#!/bin/sh
SCRIPT=$0

# SCRIPT may be an arbitrarily deep series of symlinks. Loop until we have the concrete path.
while [ -h "$SCRIPT" ] ; do
  ls=$(ls -ld "$SCRIPT")
  # Drop everything prior to ->
  link=$(expr "$ls" : '.*-> \(.*\)$')
  if expr "$link" : '/.*' > /dev/null; then
    SCRIPT="$link"
  else
    SCRIPT=$(dirname "$SCRIPT")/"$link"
  fi
done

DIR="$(dirname "${SCRIPT}")/.."
NODE="/root/node-v10.15.2-linux-armv6l/bin/node"
test -x "$NODE"
if [ ! -x "$NODE" ]; then
  echo "unable to find usable node.js executable."
  exit 1
fi

NODE_ENV=production exec "${NODE}" --no-warnings --max-http-header-size=65536 $NODE_OPTIONS "${DIR}/src/cli" ${@}