#!/usr/bin/env python3
"""
BIND9 Dynamic DNS Service Discovery for Docker Swarm

This script monitors Docker Swarm events and automatically updates BIND9 DNS records
when services are deployed, updated, or removed. It uses DNS UPDATE (RFC 2136) to
dynamically add/remove records from the BIND9 zone.

Usage:
    python3 dns-sync.py --bind-server 127.0.0.1 --zone itslit --domain itslit

Requirements:
    pip install docker dnspython pyyaml
"""

import docker
import argparse
import logging
import sys
import json
from datetime import datetime
from dns.resolver import query as dns_query
from dns.rdataclass import RdataClass
from dns.rdatatype import RdataType
from dns.update import Update
from dns.query import tcp
import socket

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('/var/log/dns-sync.log')
    ]
)
logger = logging.getLogger(__name__)


class DockerDNSSync:
    def __init__(self, bind_server='127.0.0.1', zone='itslit', domain='itslit', ttl=300):
        """
        Initialize Docker DNS Sync

        Args:
            bind_server: IP address of BIND9 server
            zone: DNS zone name (e.g., 'itslit')
            domain: Domain suffix for services (e.g., 'itslit')
            ttl: Time To Live for DNS records
        """
        self.bind_server = bind_server
        self.zone = zone
        self.domain = domain
        self.ttl = ttl
        
        try:
            self.docker_client = docker.from_env()
            logger.info("Connected to Docker daemon")
        except Exception as e:
            logger.error(f"Failed to connect to Docker daemon: {e}")
            sys.exit(1)

    def get_service_vip(self, service_name):
        """
        Get the Virtual IP (VIP) of a service from Docker Swarm

        Args:
            service_name: Name of the Docker service

        Returns:
            VIP address or None
        """
        try:
            services = self.docker_client.services.list()
            for service in services:
                if service.name == service_name or service_name in service.name:
                    # Get endpoint info
                    service_attrs = service.attrs
                    endpoint_vip = service_attrs.get('Endpoint', {}).get('VirtualIPs', [])
                    if endpoint_vip:
                        return endpoint_vip[0]['Addr'].split('/')[0]
        except Exception as e:
            logger.error(f"Error getting service VIP for {service_name}: {e}")
        return None

    def get_all_services(self):
        """
        Get all active Docker services with their VIPs

        Returns:
            Dictionary of {service_name: vip_address}
        """
        services = {}
        try:
            for service in self.docker_client.services.list():
                endpoint_vip = service.attrs.get('Endpoint', {}).get('VirtualIPs', [])
                if endpoint_vip:
                    vip = endpoint_vip[0]['Addr'].split('/')[0]
                    services[service.name] = vip
                    logger.debug(f"Found service: {service.name} -> {vip}")
        except Exception as e:
            logger.error(f"Error fetching services: {e}")
        return services

    def update_dns_record(self, hostname, ip_address, action='add'):
        """
        Update DNS record in BIND9 using DNS UPDATE (RFC 2136)

        Args:
            hostname: Hostname to add/remove (without domain suffix)
            ip_address: IP address to associate (for add action)
            action: 'add' or 'delete'

        Returns:
            True if successful, False otherwise
        """
        try:
            fqdn = f"{hostname}.{self.domain}"
            
            # Create DNS UPDATE query
            update = Update(self.zone)
            
            if action == 'add':
                # Add A record
                update.replace(hostname, self.ttl, RdataType.A, ip_address)
                logger.info(f"DNS UPDATE: Adding {fqdn} -> {ip_address}")
            elif action == 'delete':
                # Delete A record
                update.delete(hostname, RdataType.A)
                logger.info(f"DNS UPDATE: Removing {fqdn}")
            
            # Send update to BIND9
            response = tcp(update, self.bind_server)
            
            if response.rcode() == 0:
                logger.info(f"✓ Successfully {action}ed DNS record for {fqdn}")
                return True
            else:
                logger.error(f"✗ BIND9 returned error code {response.rcode()} for {fqdn}")
                return False
                
        except Exception as e:
            logger.error(f"Error updating DNS record for {hostname}: {e}")
            return False

    def verify_dns_record(self, hostname):
        """
        Verify that a DNS record exists in BIND9

        Args:
            hostname: Hostname to verify (without domain suffix)

        Returns:
            IP address if found, None otherwise
        """
        try:
            fqdn = f"{hostname}.{self.domain}"
            answer = dns_query(fqdn, RdataType.A, rdclass=RdataClass.IN, nameserver=self.bind_server)
            
            if answer:
                for rdata in answer:
                    return str(rdata)
        except Exception as e:
            logger.debug(f"DNS verification failed for {hostname}: {e}")
        return None

    def sync_all_services(self):
        """
        Sync all current Docker services to BIND9
        """
        logger.info("Syncing all Docker services to BIND9...")
        services = self.get_all_services()
        
        for service_name, vip in services.items():
            # Clean service name for DNS (remove spaces, special chars)
            dns_name = service_name.replace('_', '-').replace('.', '-').lower()
            
            if self.update_dns_record(dns_name, vip, action='add'):
                logger.info(f"Synced service: {service_name} ({dns_name}) -> {vip}")
            else:
                logger.warning(f"Failed to sync service: {service_name}")

    def monitor_events(self):
        """
        Monitor Docker events and update DNS records accordingly
        """
        logger.info("Starting Docker event monitor...")
        
        try:
            for event in self.docker_client.events(
                decode=True,
                filters={'type': 'service', 'scope': 'swarm'}
            ):
                self.handle_event(event)
        except KeyboardInterrupt:
            logger.info("Shutting down...")
            sys.exit(0)
        except Exception as e:
            logger.error(f"Error monitoring events: {e}")
            logger.info("Reconnecting in 10 seconds...")
            import time
            time.sleep(10)
            self.monitor_events()

    def handle_event(self, event):
        """
        Handle individual Docker event

        Args:
            event: Docker event dictionary
        """
        event_type = event.get('Type')
        event_action = event.get('Action')
        service_name = event.get('Actor', {}).get('Attributes', {}).get('name', '')

        logger.debug(f"Docker Event: {event_type} - {event_action} - {service_name}")

        if not service_name:
            return

        # Clean service name for DNS
        dns_name = service_name.replace('_', '-').replace('.', '-').lower()

        try:
            if event_action == 'create':
                # New service created
                vip = self.get_service_vip(service_name)
                if vip:
                    logger.info(f"✓ Service created: {service_name} ({vip})")
                    self.update_dns_record(dns_name, vip, action='add')
                else:
                    logger.warning(f"Could not get VIP for new service: {service_name}")

            elif event_action == 'update':
                # Service updated, re-sync VIP
                vip = self.get_service_vip(service_name)
                if vip:
                    logger.info(f"✓ Service updated: {service_name} ({vip})")
                    self.update_dns_record(dns_name, vip, action='add')

            elif event_action == 'remove':
                # Service removed
                logger.info(f"✓ Service removed: {service_name}")
                self.update_dns_record(dns_name, None, action='delete')

        except Exception as e:
            logger.error(f"Error handling event for {service_name}: {e}")


def main():
    parser = argparse.ArgumentParser(
        description='Automatically sync Docker Swarm services to BIND9 DNS'
    )
    parser.add_argument(
        '--bind-server',
        default='127.0.0.1',
        help='IP address of BIND9 server (default: 127.0.0.1)'
    )
    parser.add_argument(
        '--zone',
        default='itslit',
        help='DNS zone name (default: itslit)'
    )
    parser.add_argument(
        '--domain',
        default='itslit',
        help='Domain suffix for services (default: itslit)'
    )
    parser.add_argument(
        '--ttl',
        type=int,
        default=300,
        help='TTL for DNS records in seconds (default: 300)'
    )
    parser.add_argument(
        '--sync-on-start',
        action='store_true',
        help='Sync all existing services on startup'
    )
    parser.add_argument(
        '--log-level',
        default='INFO',
        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
        help='Logging level (default: INFO)'
    )

    args = parser.parse_args()

    # Set logging level
    logger.setLevel(getattr(logging, args.log_level))

    logger.info("=" * 60)
    logger.info("Docker Swarm to BIND9 DNS Sync")
    logger.info("=" * 60)
    logger.info(f"BIND9 Server: {args.bind_server}")
    logger.info(f"Zone: {args.zone}")
    logger.info(f"Domain: {args.domain}")
    logger.info(f"TTL: {args.ttl}")
    logger.info("=" * 60)

    dns_sync = DockerDNSSync(
        bind_server=args.bind_server,
        zone=args.zone,
        domain=args.domain,
        ttl=args.ttl
    )

    # Initial sync if requested
    if args.sync_on_start:
        logger.info("Initial sync requested...")
        dns_sync.sync_all_services()

    # Start monitoring
    dns_sync.monitor_events()


if __name__ == '__main__':
    main()
