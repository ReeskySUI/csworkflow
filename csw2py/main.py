import bf
from services.dhcp import start_dhcp_service
from services.dns import start_dns_service
from services.ssh import start_ssh_service
from services.ftp import start_ftp_service
from services.nfs import start_nfs_service
from services.rsync import start_rsync_service
from services.apache import start_apache_service
from services.nginx import start_nginx_service
from services.tomcat import start_tomcat_service
from services.mysql import start_mysql_service
from services.redis import start_redis_service
from services.extmail import start_extmail_service
from services.lvs import start_lvs_service
from services.zabbix import start_zabbix_service

def main():
    services = [
        start_dhcp_service,
        start_dns_service,
        start_ssh_service,
        start_ftp_service,
        start_nfs_service,
        start_rsync_service,
        start_apache_service,
        start_nginx_service,
        start_tomcat_service,
        start_mysql_service,
        start_redis_service,
        start_extmail_service,
        start_lvs_service,
        start_zabbix_service
    ]

    for service in services:
        service()

if __name__ == "__main__":
    main()
