#!/bin/bash

# username and password
# for security, the password here means the hash value saved in /etc/shadow, not raw password
username=
password=

# .bashrc: done
cat ./bashrc >> /etc/bash.bashrc
source /etc/bash.bashrc
echo -e "\e[31;1m =============== Load bash setting successfully ===============\e[0m"

# locale: done
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
echo -e "\e[31;1m =============== Set locale successfully ===============\e[0m"

# v2ray: done
bash <(curl -fsSL https://install.direct/go.sh)
cp ./config.json /etc/v2ray/config.json
systemctl start v2ray
systemctl enable v2ray
echo -e "\e[31;1m =============== Install V2ray successfully ===============\e[0m"

# docker: done
bash <(curl -fsSL https://get.docker.com)
echo -e "\e[31;1m =============== Install Docker successfully ===============\e[0m"

# ttrss: done
ip_address=`ifconfig|grep -G 'inet .* netmask 255.255.254.0 .*'|awk '{print $2}'`
docker run -d --name ttrssdb nornagon/postgres
docker run -d --link ttrssdb:db -p 80:80 -e SELF_URL_PATH=http://${ip_address}/ fischerman/docker-ttrss
echo -e "\e[31;1m =============== Install Tiny-TIny-RSS successfully ===============\e[0m"

# pip3: done
apt -y install python3-pip
echo -e "\e[31;1m =============== Install pip3 successfully ===============\e[0m"

# youtube-dl: done
pip3 install youtube-dl
echo -e "\e[31;1m =============== Install youtube-dl successfully ===============\e[0m"

# lrzsz: done
apt -y install lrzsz
echo -e "\e[31;1m =============== Install lrzsz successfully ===============\e[0m"

# add new user: done
useradd ${username}
sed -i '/'${username}':*/s/!/'$password'/' /etc/shadow
mkdir /home/${username}
chown ${username} /home/${username}
chgrp ${username} /home/${username}
chsh -s /bin/bash ${username}
# need further test here !!!
chmod u+w /etc/sudoers
echo 'sweatran ALL=(ALL:ALL) ALL'>>/etc/sudoers
chmod u-w /etc/sudoers
echo -e "\e[31;1m =============== Add new user successfully ===============\e[0m"

# vsftpd: done
apt -y install vsftpd
cp ./vsftpd.conf /etc/vsftpd.conf
systemctl start vsftpd
systemctl enable vsftpd
systemctl restart vsftpd
echo -e "\e[31;1m =============== Install vsftpd successfully ===============\e[0m"

# frp: need test
# mkdir /etc/frp
# mkdir /etc/frp/temp
# wget -O /etc/frp/temp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.32.1/frp_0.32.1_linux_arm64.tar.gz
# tar -xzf /etc/frp/temp/frp.tar.gz -C /etc/frp/temp/
# mv /etc/frp/temp/frp_0.32.1_linux_arm64/frps*.ini /etc/frp
# mv /etc/frp/temp/frp_0.32.1_linux_arm64/frps /usr/bin
# mv /etc/frp/temp/frp_0.32.1_linux_arm64/systemd/frps.service /etc/systemd/system
# rm -r /etc/frp/temp
# systemctl enable frps
# systemctl start frps
# echo -e "\e[31;1m =============== Install frps successfully ===============\e[0m"

# chfs: done
mkdir /home/sweatran/shared
cp ./chfs /usr/sbin/chfs
chmod 744 /usr/sbin/chfs
cp ./chfs.service /etc/systemd/system/chfs.service
chmod 644 /etc/systemd/system/chfs.service
systemctl enable chfs
systemctl start chfs
echo -e "\e[31;1m =============== Install chfs successfully ===============\e[0m"





