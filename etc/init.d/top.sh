#!/bin/bash
#
# chkconfig: - 10 90
# description: blah 

# Add to runtime with chkconfig --add top.sh
# run with bash /etc/init.d/top.sh
# turn the script on now with chkconfig top.sh on

screen -dmS name watch -n1 /usr/local/bin/ruby /home/anthony/Documents/Ruby/top.rb 60 8
