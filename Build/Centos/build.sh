#!/bin/bash

dir='../../';
user=`users | awk '{print $1}'`;

sudo cp ${dir}etc/init.d/top.sh /etc/init.d/top.sh;
sudo cp ${dir}usr/lib/systemd/system/top.service /usr/lib/systemd/system/top.service; 
sudo cp ${dir}top.rb /home/$user/top.rb;
sudo chmod a+rx /etc/init.d/top.sh /usr/lib/systemd/system/top.service /home/$user/top.rb;
sudo chkconfig --add top.sh;
sudo chkconfig top.sh on;
sudo systemctl start top;
