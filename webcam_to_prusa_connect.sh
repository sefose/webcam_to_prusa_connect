#!/bin/bash

PRUSA_URL=https://webcam.connect.prusa3d.com/c/snapshot
FRAME_CAPTURE_DELAY=${FRAME_CAPTURE_DELAY:-0.5}
CAMERA_CYCLE_DELAY=${CAMERA_CYCLE_DELAY:-9}
CONNECTION_TIMEOUT_DELAY=${CONNECTION_TIMEOUT_DELAY:-5}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source ${SCRIPT_DIR}/settings.conf || exit 1

FINGERPRINTS=()
for i in $(seq 1 ${#CAMERA_NAMES[@]}); do
    FINGERPRINTS+=($(printf "camera%010d" $i))
done

echo "Input variables:"
for i in "${!CAMERA_NAMES[@]}"; do
    echo "Camera $((i + 1)), Name: ${CAMERA_NAMES[$i]}, ${TOKENS[$i]}"
done

while true; do
    for i in "${!CAMERA_NAMES[@]}"; do
        echo "Processing camera: $((i + 1))"
        echo "Name: ${CAMERA_NAMES[$i]}"
        echo "Token: ${TOKENS[$i]}"
        echo "Fingerprint: ${FINGERPRINTS[$i]}"
        echo "------"
        fswebcam --device ${CAMERA_DEVICES[$i]} \
            --resolution ${CAMERA_RESOLUTIONS[$i]} \
            ${CAMERA_OPTIONS[$i]} - | \
        curl -X PUT "$PRUSA_URL" \
            -H "accept: */*" \
            -H "content-type: image/jpg" \
            -H "fingerprint: ${FINGERPRINTS[$i]}" \
            -H "token: ${TOKENS[$i]}" \
            --data-binary "@-" \
            --no-progress-meter \
            --compressed \
            --max-time "$CONNECTION_TIMEOUT_DELAY"
        echo " "
        echo "#######"
        sleep "$FRAME_CAPTURE_DELAY"
    done

    sleep "$CAMERA_CYCLE_DELAY"
done
