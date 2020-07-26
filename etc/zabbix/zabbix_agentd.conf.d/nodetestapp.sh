#!/bin/bash

# Connection validation
timeout 3 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/3000"
check=$?
echo "Connection status to 127.0.0.1:3000 is $check" > /var/tmp/.testnodejsapp.log
if [ $check -eq 0 ]
then
connstat=1
else
connstat=0
fi

# Service validation
pstat=`ps -ef|grep server.js|grep -v grep`
if [[ "$pstat" != "" ]]
then
psstat=1
echo "test nodejs app is running" >> /var/tmp/.testnodejsapp.log
else
psstat=0
echo "test nodejs app is NOT running" >> /var/tmp/.testnodejsapp.log
fi

# User validation
ustat=`ps -ef|grep server.js|grep -v grep|awk '{print $1}'
if [[ "$ustat" == "root" || "$ustat" == "" ]]
then
usstat=0
echo "test nodejs app is NOT running or running as root" >> /var/tmp/.testnodejsapp.log
else
usstat=1
echo "test nodejs app is running as $ustat" >> /var/tmp/.testnodejsapp.log
fi

## Final validation
if [[ $connstat -eq 0 || $psstat -eq 0 || $usstat -eq 0 ]]
then
echo 0
else
echo 1
fi
