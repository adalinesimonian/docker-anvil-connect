#!/bin/sh
set -e

if [ "$1" = "anvil-connect" ]; then
	chown -R connect $(ls | awk '{if($1 != "secrets"){ print $1 }}')
	exec gosu connect "$@"
elif echo "$1" | egrep -q '^--'; then
	chown -R connect $(ls | awk '{if($1 != "secrets"){ print $1 }}')
	exec gosu connect "anvil-connect" "$@"
fi

exec "$@"
