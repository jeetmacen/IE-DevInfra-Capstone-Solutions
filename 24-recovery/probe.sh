#!/usr/bin/env bash
set -u
while true; do
  stamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  if code=$(curl -s -o /dev/null --max-time 2 -w '%{http_code}' http://127.0.0.1:8024/) && [[ $code == 200 ]]; then
    printf '%s UP   http=%s\n' "$stamp" "$code"
  else
    printf '%s DOWN http=%s\n' "$stamp" "$code"
  fi
  sleep 2
done
