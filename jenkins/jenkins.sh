#!/bin/bash -x


#Script to setup Jenkins on centOS/RHEL 6.x and 7.x

#Author Serge  Aug 2017
#Modify: sept 2019
#Modified: Jun 2020
#Modified: sept 2021


OS_VERSION=`cat /etc/*release |grep VERSION_ID |awk -F\" '{print $2}'`
OS_TYPE=`cat /etc/*release|head -1|awk '{print $1}'`


sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
# Add required dependencies for the jenkins package
sudo yum install java-11-openjdk
sudo yum install jenkins
sudo systemctl daemon-reload

echo "configuring the port 8080 on the firewall for jenkins server"
sleep 3
systemctl restart firewalld 
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
#sed -i '/:OUTPUT ACCEPT/a \-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
#echo 
#echo "Restart iptables services "
#service iptables restart
sleep 2

echo "done"

echo
echo " Use this link to access your jenkins server. http://$(ifconfig eth1|head -2|tail -1|awk '{print $2}'):8080"
echo
exit 0

else

echo -e "\nDetected that you are running Centos 6\n"



echo "configuring the port 8080 on the firewall for jenkins server"
sleep 3
sed -i '/:OUTPUT ACCEPT/a \-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
echo 
echo "Restart iptables services "
service iptables restart
sleep 2

echo "done"

echo
echo " Use this link to access your jenkins server. http://$(ifconfig eth1|head -2|tail -1|awk '{print $2}'):8080"
echo

fi

exit 0 
