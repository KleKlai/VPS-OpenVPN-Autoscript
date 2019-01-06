# getting requirements
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi

# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";
apt-get -y remove apt-listchanges

#Certicate Details
country=Philippines
state=DavaoDelSur
locality=Davao
organization=UniversityofImmaculateConception
organizationalunit=ITDeparment
commonname=KlaiHere
email=klaiklai@nbi.gov.ph

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#Add DNS Server ipv4
echo "nameserver 4.2.2.2" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 4.2.2.2" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.8.8" >> /etc/resolv.conf' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
apt-get -y purge sendmail*
apt-get -y remove sendmail*

# update
apt-get update; apt-get -y upgrade

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# setting vnstat
vnstat -u -i eth0
service vnstat restart

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cat > /etc/nginx/nginx.conf <<END3
user www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
  worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;

  include /etc/nginx/conf.d/*.conf;
}
END3
mkdir -p /home/vps/public_html
wget -O /home/vps/public_html/index.html "http://script.hostingtermurah.net/repo/index.html"
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
cat > /etc/nginx/conf.d/vps.conf <<END4
server {
  listen       85;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/vps-access.log;
  error_log /var/log/nginx/vps-error.log error;
  root   /home/vps/public_html;

  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}

END4
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar htop iftop mtr nano
apt-get -y install build-essential

echo "clear" >> .bashrc
echo 'echo -e ":::    ::: :::            :::     ::::::::::: " | lolcat' >> .bashrc
echo 'echo -e ":+:   :+:  :+:          :+: :+:       :+:     " | lolcat' >> .bashrc
echo 'echo -e "+:+  +:+   +:+         +:+   +:+      +:+     " | lolcat' >> .bashrc
echo 'echo -e "+#++:++    +#+        +#++:++#++:     +#+     " | lolcat' >> .bashrc
echo 'echo -e "+#+  +#+   +#+        +#+     +#+     +#+     " | lolcat' >> .bashrc
echo 'echo -e "#+#   #+#  #+#        #+#     #+#     #+#     " | lolcat' >> .bashrc
echo 'echo -e "###    ### ########## ###     ### ########### " | lolcat' >> .bashrc
echo 'echo -e ""' >> .bashrc
echo 'echo -e "+ -- --=[ OpenVPN v2.0"' >> .bashrc
echo 'echo -e "+ -- --=[ DDOS Protection ENABLED"' >> .bashrc
echo 'echo -e "+ -- --=[ BBR Technology DISABLED"' >> .bashrc
echo 'echo -e "+ -- --=[ Maynard Magallen"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
#rm /etc/nginx/sites-enabled/default
#rm /etc/nginx/sites-available/default
#wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/nginx.conf"
#mkdir -p /home/vps/public_html
#echo "<pre>Powered By: University of Immaculate Conception</pre>" > /home/vps/public_html/index.html
#wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/vps.conf"
#service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# Configure openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 444' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=3128/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 143"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# install squid3
#cd
#apt-get -y install squid3
#wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/squid3.conf"
#sed -i $MYIP2 /etc/squid3/squid.conf;
#service squid3 restart

# install webmin
cd
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[dropbear]
accept = 443
connect = 127.0.0.1:3128

END

#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

#configure stunnel4
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# teks berwarna
apt-get -y install ruby
gem install lolcat

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install vnstat gui
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/daybreakersx/premscript/master/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install webmin
cd
wget "http://script.hostingtermurah.net/repo/webmin_1.801_all.deb"
dpkg --install webmin_1.801_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.801_all.deb
service webmin restart
service vnstat restart
apt-get -y --force-yes -f install libxml-parser-perl

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*filter
:FORWARD ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -i eth0 -o ppp0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i ppp0 -o eth0 -j ACCEPT
-A OUTPUT -d 23.66.241.170 -j DROP
-A OUTPUT -d 23.66.255.37 -j DROP
-A OUTPUT -d 23.66.255.232 -j DROP
-A OUTPUT -d 23.66.240.200 -j DROP
-A OUTPUT -d 128.199.213.5 -j DROP
-A OUTPUT -d 128.199.149.194 -j DROP
-A OUTPUT -d 128.199.196.170 -j DROP
-A OUTPUT -d 103.52.146.66 -j DROP
-A OUTPUT -d 5.189.172.204 -j DROP
COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules

# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/ddos-deflate-master.zip

# bannerrm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/issues.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

#xml parser
cd
apt-get -y --force-yes -f install libxml-parser-perl

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/trial.sh"
wget -O delete "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/hapus.sh"
wget -O check "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/user-login.sh"
wget -O member "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/user-list.sh"
wget -O restart "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/resvis.sh"
wget -O speedtest "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/info.sh"
wget -O about "https://raw.githubusercontent.com/MMagallen/Debian7-OpenVpn-Autoscript/master/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x delete
chmod +x check
chmod +x member
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about

# Finalizing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php5-fpm start
service openvpn restart
service cron restart
service ssh restart
service fail2ban restart
service dropbear restart
#service squid3 restart
service webmin restart
service vnstat restart

#Clearing History
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

# info
clear
echo ""
echo 'echo -e "You Virtual Private Server is now up and running." | lolcat' >> .bashrc
echo "---------------------Server-Details-----------------------"
echo "																													"
echo ""
echo "Application & Ports" | tee -a log-install.txt
echo ""
echo "		OpenSSH					:		22,444" | tee -a log-install.txt
echo "		Dropbear				:		143, 3128" | tee -a log-install.txt
echo "		Stunnel4				:		443" | tee -a log-install.txt
echo "		OpenVPN					:		TCP(1194)" | tee -a log-install.txt
echo "		Badvpn					:		badvpn-udpgw (7300)" | tee -a log-install.txt
echo "		Nginx						:		81" | tee -a log-install.txt
echo "		Webmin					:		http://$MYIP:10000/"  | tee -a log-install.txt
echo "		Vnstat					:		http://$MYIP:85/vnstat/"  | tee -a log-install.txt
#echo "Squid3   : 8000, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo ""
echo "Additional Informations" | tee -a log-install.txt
echo ""
echo "		Timezone 				: Asia/Manila (GMT +7)"  | tee -a log-install.txt
echo "		BBR Technology	: OFF"  | tee -a log-install.txt
echo "		Ipv6						: OFF"  | tee -a log-install.txt
echo "		DDOS Protection	: ON"  | tee -a log-install.txt
echo "		SSH Protection	: ON"  | tee -a log-install.txt
echo "		Installation Log:	/root/log-install.txt"	| tee -a log-install.txt
echo ""
echo "		Tools" | tee -a log-install.txt
echo ""
echo "		htop" | tee -a log-install.txt
echo "		iftop" | tee -a log-install.txt
echo "		nethogs" | tee -a log-install.txt
echo ""
echo "	Special Thanks to Fornesia, Rzengineer, Clrkz & Fawzya	"
echo "							Modified by: Magallen, Maynard							"
echo "----------------------------------------------------------"
echo "To begin type 'menu' to show all available commands"  | tee -a log-install.txt
cd
rm -f /root/debian7.sh
