#!/bin/sh

URL="http://localhost:3000/.well-known/openid-configuration"
STATUS_CODE=$(curl --silent --output /dev/stderr --write-out "%{http_code}" $URL)

echo
echo

if test $STATUS_CODE -ne 200; then
    printf '[\033[1;31merror\033[m]\t%s\n' "Unable to connect to Anvil Connect discovery endpoint"
    exit 1
else
    printf '[\033[1;32mpass\033[m]\t%s\n' "Successfully connected to Anvil Connect discovery endpoint"
    exit 0
fi
