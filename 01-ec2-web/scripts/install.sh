#!/bin/bash
set -eu
dnf -y install httpd
echo '<h1>Project 01: EC2 web server</h1>' > /var/www/html/index.html
systemctl enable --now httpd
