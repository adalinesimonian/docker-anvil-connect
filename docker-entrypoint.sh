#!/bin/sh
set -e

if [ "$1" = "anvil-connect" ]; then
	chown -R connect .
	exec gosu connect "$@"
elif echo "$1" | egrep -q '^--'; then
	chown -R connect .
	exec gosu connect "anvil-connect" "$@"
fi

exec "$@"
