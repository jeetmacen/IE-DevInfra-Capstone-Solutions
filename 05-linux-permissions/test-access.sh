#!/usr/bin/env bash
set -euo pipefail
(( EUID == 0 )) || { echo "Run with sudo" >&2; exit 1; }
id p05writer; id p05guest
ls -ld /srv/p05-private /srv/p05-private/notes
runuser -u p05writer -- sh -c 'echo "team write succeeded" >> /srv/p05-private/notes && cat /srv/p05-private/notes'
if runuser -u p05guest -- cat /srv/p05-private/notes; then
  echo "FAIL: guest read the file" >&2; exit 1
fi
if runuser -u p05guest -- sh -c 'echo unexpected >> /srv/p05-private/notes'; then
  echo "FAIL: guest wrote to the file" >&2; exit 1
fi
echo "PASS: team read/write; guest denied both."
