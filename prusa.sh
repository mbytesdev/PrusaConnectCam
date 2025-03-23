#!/bin/bash

SNAPSHOT_PATH="/tmp/snapshot.jpg"
PRINTER_UUID="${PRINTER_UUID}"
CAMERA_TOKEN="${CAMERA_TOKEN}"
CAMERA_FP="${CAMERA_FP}"
SNAP_DELAY="${SNAP_DELAY}"
PRUSA_HOST="${PRUSA_HOST}"

API_URL="https://connect.prusa3d.com/c/snapshot"

is_prusa_online() {
    ping -c 1 -W 1 "$PRUSA_HOST" > /dev/null
    return $?
}
capture_snapshot() {
    ffmpeg -f video4linux2 -i /dev/video0 -video_size 1920x1080 \
        -vf "hflip,vflip" -frames:v 1 -q:v 2 "$SNAPSHOT_PATH" -y -loglevel quiet
}
upload_snapshot() {
    echo "Uploading snapshot to Prusa Connect..."
    curl -s -X PUT "$API_URL" \
        -H "accept: */*" \
        -H "Content-Type: image/jpg" \
        -H "fingerprint: ${CAMERA_FP}" \
        -H "token: ${CAMERA_TOKEN}" \
        --data-binary "@${SNAPSHOT_PATH}" \
    && echo "Done." || echo "Upload failed"
}
main() {
    while true; do
        if [ -z "$PRUSA_HOST" ]; then
            capture_snapshot
            upload_snapshot
        elif is_prusa_online; then
            capture_snapshot
            upload_snapshot
        fi
        sleep ${SNAP_DELAY}
    done
}
# Execution
main