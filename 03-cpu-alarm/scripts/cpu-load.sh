#!/bin/bash
set -eu
# Delay the one-off test so the alarm first records an idle baseline.
systemd-run --unit=p03-load --on-active=6min /bin/bash -c \
  'for ((i=0;i<$(nproc);i++)); do timeout 300 yes >/dev/null & done; wait'
