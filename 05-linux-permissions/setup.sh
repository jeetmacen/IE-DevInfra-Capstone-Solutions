#!/usr/bin/env bash
set -euo pipefail
(( EUID == 0 )) || { echo "Run with sudo" >&2; exit 1; }
# Refuse to repurpose any existing user, group or directory.
if getent passwd p05writer || getent passwd p05guest || getent group p05team || [[ -e /srv/p05-private || -L /srv/p05-private ]]; then
  echo "Lab names already in use; start with a clean VM." >&2; exit 1
fi
groupadd p05team
useradd -M -s /usr/sbin/nologin -G p05team p05writer
useradd -M -s /usr/sbin/nologin p05guest
install -d -o root -g p05team -m 2770 /srv/p05-private
install -o root -g p05team -m 0660 /dev/null /srv/p05-private/notes
