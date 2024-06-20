#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat >/lib/systemd/system/camtoprusaconnect.service  <<EOL
[Unit]
Description=Uploads screenshots from cameras to prusa connect 

[Service]
ExecStart=${SCRIPT_DIR}/webcam_to_prusa_connect.sh

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload

sudo systemctl enable camtoprusaconnect.service 
sudo systemctl start camtoprusaconnect.service 