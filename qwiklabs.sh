#!/bin/bash

# The username is always the same, but .pem files and external ip address
# change every time you start a lab session.
# That's why username is declared as a variable in script and ip address
# is prompted.
# Temporary .pem files are deleted to ensure only the newest is available
# for use.

## Set current working directory
cd ~/Downloads

FILENAME="qwiklabs*.pem"
USERNAME="student-02-2a88fc37774b"

## Gets data from arguments
NODEL=false
IP_ADDRESS=""
REGEX_IP=^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$
for var in $@; do
  # Sets value for NODEL attribute
  if [[ $var = "--nodel" ]]; then NODEL=true; fi
  # Sets value for IP_ADDRESS attribute
  if [[ $var =~ $REGEX_IP ]]; then IP_ADDRESS=$var; fi
done

## Asks for IP_ADDRESS if not passed as an argument
if [[ $IP_ADDRESS = "" ]]; then
  read -p "Please input Qwiklabs IP address... " IP_ADDRESS
fi

## If argument --nodel is passed, uses previous downloaded file, otherwise
## deletes all existing pem files and waits for new download
if $NODEL; then
  echo -n "Starting previous .pem file... "
  sleep 1
else
  echo -n "Deleting previous files... "
  rm -f $FILENAME
  sleep 1
  echo "OK"
  echo -n "Waiting for new *.pem file download"
  while [ ! -f $FILENAME ]; do
    sleep 2
    echo -n "."
  done
fi

## If a pem file is found, starts the ssh session
if [ -f $FILENAME ]; then
  echo "OK"
  echo -n "Setting ssh environment up... "
  chmod 600 $FILENAME
  sleep 1
  echo "OK"
  echo
  ssh -i $FILENAME $USERNAME@$IP_ADDRESS
else
  echo "ERROR: No qwiklabs .pem file found!"
fi
