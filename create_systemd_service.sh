#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat >/lib/systemd/system/camtoprusaconnect.service  <<EOL
[Unit]
Description=Uploads screenshots from cameras to prusa connect 

[Service]
ExecStart=${SCRIPT_DIR}/script.sh

[Install]
WantedBy=multi-user.target
EOL