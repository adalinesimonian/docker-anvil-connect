#!/bin/sh
set -e

if [ "$1" = "anvil-connect" ]; then
	[ -f secrets/secrets.json ] && cp secrets/secrets.json .
	chown -R connect $(ls | awk '{if($1 != "secrets"){ print $1 }}')
	exec gosu connect "$@"
elif echo "$1" | egrep -q '^--'; then
	[ -f secrets/secrets.json ] && cp secrets/secrets.json .
	chown -R connect $(ls | awk '{if($1 != "secrets"){ print $1 }}')
	exec gosu connect "anvil-connect" "$@"
fi

exec "$@"
