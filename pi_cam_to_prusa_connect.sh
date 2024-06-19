#!/bin/bash

PRUSA_URL=https://webcam.connect.prusa3d.com/c/snapshot
CAMERA_NAMES=("cam1" "cam2")
CAMERA_DEVICES=("/dev/video0" "/dev/video2")
CAMERA_RESOLUTIONS=("1920x1080" "1920x1080")
TOKENS=("XXXXX" "XXXXX")
FRAME_CAPTURE_DELAY=${FRAME_CAPTURE_DELAY:-1}
CAMERA_CYCLE_DELAY=${CAMERA_CYCLE_DELAY:-10}
CONNECTION_TIMEOUT_DELAY=${CONNECTION_TIMEOUT_DELAY:-5}

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
            --resolution ${CAMERA_RESOLUTIONS[$i]} - | \
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