#!/bin/bash

### SET SCRIPT VARIABLES
ip=`hostname --ip-address`
network=`ip route | grep  `hostname -I` | cut -d " " -f 1`


### FIREWALL ###
###### CONDITIONAL:  Firewall Status
if ufw status | grep -q 'inactive'; 
then
    echo "UFW Inactive"
else
    echo "UFW Active"
fi

### FIREWALL RULES
ufw allow from $network to any port 22 proto tcp


### UPDATE
apt update && apt update
apt dist-upgrade
apt autoremove




### SETUP UNATTENDED UPGRADES
apt-get -y install unattended-upgrades && \
cat > /etc/apt/apt.conf.d/10periodic <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
sed -i 's#//Unattended-Upgrade::Remove-Unused-Dependencies "false"#Unattended-Upgrade::Remove-Unused-Dependencies "true"#' /etc/apt/apt.conf.d/50unattended-upgrades && \
sed -i 's#//Unattended-Upgrade::Automatic-Reboot "false"#Unattended-Upgrade::Automatic-Reboot "true"#' /etc/apt/apt.conf.d/50unattended-upgrades && \
sed -i 's#//Unattended-Upgrade::Automatic-Reboot-Time "02:00"#Unattended-Upgrade::Automatic-Reboot-Time "04:00"#' /etc/apt/apt.conf.d/50unattended-upgrades





### INSTALL NOMACHINE
wget http://download.nomachine.com/download/6.4/Linux/nomachine_6.4.6_1_amd64.deb
dpkg -i nomachine_6.4.6_1_amd64.deb

### Allow NoMachine through UFW
# ufw allow 4000/tcp
# fw allow 4011:4999/udp

### Allow NoMachine through iptables
# iptables -A INPUT -p tcp --dport 4000 -j ACCEPT
# iptables -A INPUT -p udp --match multiport --dports 4011:4999 -j ACCEPT



###### CONDITIONAL:  Am I running in a VirtualBox VM
if dmidecode -s system-product-name | grep -q 'VirtualBox'; 
then
    echo "I'm a VirtualBox VM"
else
    echo "I'm not a VirtualBox VM"
fi


### VIRTUAL HOST
install virtualbox
virtualbox

apt install vagrant
