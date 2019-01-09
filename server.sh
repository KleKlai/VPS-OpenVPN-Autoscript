MYIP=$(wget -qO- ipv4.icanhazip.com);
: '
# check registered ip
wget -q -O daftarip http://188.166.215.119:85/ocs/ip.txt
if ! grep -w -q $MYIP daftarip; then
	echo "Sorry, only registered IPs can use this script!"
	if [[ $vps = "vps" ]]; then
		echo "Modified by Klai"
	else
		echo "Modified by Klai"
	fi
	rm -f /root/daftarip
	exit
fi
'
# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#detail nama perusahaan
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

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# update
apt-get update

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar
apt-get install htop
apt-get install iftop

echo "clear" >> .bashrc
echo 'echo -e ":::    ::: :::            :::     ::::::::::: " | lolcat' >> .bashrc
echo 'echo -e ":+:   :+:  :+:          :+: :+:       :+:     " | lolcat' >> .bashrc
echo 'echo -e "+:+  +:+   +:+         +:+   +:+      +:+     " | lolcat' >> .bashrc
echo 'echo -e "+#++:++    +#+        +#++:++#++:     +#+     " | lolcat' >> .bashrc
echo 'echo -e "+#+  +#+   +#+        +#+     +#+     +#+     " | lolcat' >> .bashrc
echo 'echo -e "#+#   #+#  #+#        #+#     #+#     #+#     " | lolcat' >> .bashrc
echo 'echo -e "###    ### ########## ###     ### ########### " | lolcat' >> .bashrc
echo 'echo -e ""' >> .bashrc
echo 'echo -e "+ -- --=[ Klai ]=-- -- +" | lolcat'  >> .bashrc
echo 'echo -e ""' >> .bashrc
# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Powered By: University of Immaculate Conception</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# Configure openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/badvpn-udpgw64"
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
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget "http://script.hostingtermurah.net/repo/webmin_1.801_all.deb"
dpkg --install webmin_1.801_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.801_all.deb
service webmin restart
#service vnstat restart
a#pt-get -y --force-yes -f install libxml-parser-perl

# install stunnel4 From Premium Script
apt-get -y install stunnel4
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/stunnel.conf"
sed -i $MYIP2 /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# Install Ruby & lolcat
apt-get -y install ruby
gem install lolcat

# install
fail2banapt-get -y install fail2ban;
service fail2ban restart

# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/ddos-deflate-master.zip

# bannerrm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/issues.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

#xml parser
cd
apt-get -y --force-yes -f install libxml-parser-perl

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/trial.sh"
wget -O delete "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/hapus.sh"
wget -O check "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/user-login.sh"
wget -O member "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/user-list.sh"
wget -O restart "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/resvis.sh"
wget -O speedtest "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/info.sh"
wget -O about "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

# converting to executable
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
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# Install neofetch
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
echo 'echo -e "+ -- --=[ Your Virtual Private Server is now up and running"' >> .bashrc
echo ""
echo "--------------Server Configuration Details---------------"
echo "Application & Ports"  | tee -a log-install.txt
echo ""
echo "  OpenSSH  : 22, 444"  | tee -a log-install.txt
echo "  Dropbear : 143, 3128"  | tee -a log-install.txt
echo "  SSL      : 443"  | tee -a log-install.txt
echo "  Squid3   : 8000, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "  OpenVpn	: TCP (1194)"  | tee -a log-install.txt
echo "  Badvpn   : badvpn-udpgw port (7300)"  | tee -a log-install.txt
echo "  Nginx    : 81"  | tee -a log-install.txt
echo ""
echo "Application & Ports"  | tee -a log-install.txt
echo ""
echo "Linux Utility"  | tee -a log-install.txt
echo ""
echo " htop"  | tee -a log-install.txt
echo " iftop"  | tee -a log-install.txt
echo ""
echo "Extended Information"  | tee -a log-install.txt
echo "  Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "  Timezone : Asia/Manila (GMT +7)"  | tee -a log-install.txt
echo "  IPv6     : OFF"  | tee -a log-install.txt
echo "  DDOS Protection     : Enable"  | tee -a log-install.txt
echo "  Payload Ready       : Enable"  | tee -a log-install.txt
echo "  SSH Protection      : Enable"  | tee -a log-install.txt
echo "  Installation log	:	/root/log-install.txt"  | tee -a log-install.txt
echo ""
echo "Thank You"
echo "---------------------------------------------------------"
cd
rm -f /root/debian7.sh
