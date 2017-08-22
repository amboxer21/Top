#!/bin/bash
#
# chkconfig: - 10 90
# description: blah 

user=`users | awk '{print $1}'`;

screen -dmS name watch -n1 /usr/local/bin/ruby /home/$user/top.rb 60 8
