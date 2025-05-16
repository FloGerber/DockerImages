#!/bin/bash

set -e

# service rpcbind start
# service nfs-common start
# mount -t nfs istr400139pri001.file.core.windows.net:/istr400139pri001/userdata /home -o nolock,vers=4,minorversion=1,sec=sys

for script in /etc/init.d/custom/* ; do
  if [ -r $script ] && [ -x $script ]; then
    echo "Initializing $(basename ${script})"
    $script
    if [ $? -ne 0 ]; then
      echo "FATAL: Failed to initialize"
      exit 1
    fi
  fi
done

# echo "Starting SSH ..."
# exec /usr/sbin/sshd -D -e

## Use if you need to run an listener

echo "Starting SSH ..."
service ssh start

# echo "Running Init"

# /etc/init.d/custom/usercreation

# echo "Starting Web Listener" 
# nc -l 8080

tail -f /dev/null