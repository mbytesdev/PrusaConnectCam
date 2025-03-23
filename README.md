A simple docker container which uploads snapshots to [Prusa Connect](https://connect.prusa3d.com).

In short:
- Debian based
- simple bash script with...
    - ffmpeg to capture snapshots
    - curl for [API](https://help.prusa3d.com/article/prusa-connect-camera-api_569012) calls

# How to...
## ...use with docker run
Docker run with environment file:
```bash
docker run -d \
  --name prusa-cam \
  --restart unless-stopped \
  --device /dev/video0:/dev/video0 \
  -e PRINTER_UUID=<uuid> \
  -e CAMERA_TOKEN=<token> \
  -e CAMERA_FP=<fingerprint> \
  -e SNAP_DELAY=10 \
  -e PRUSA_HOST=<ip for ping> \
  ghcr.io/mbytesdev/prusaconnectcam:latest
```
Docker run with environment file:
```bash
docker run -d \
  --name prusa-cam \
  --restart unless-stopped \
  --env-file .env \
  --device /dev/video0:/dev/video0 \
  ghcr.io/mbytesdev/prusaconnectcam:latest
```
## ...use with docker compose
docker compose with environment file:
```yml
services:
  prusa-cam:
    container_name: prusa-cam
    image: ghcr.io/mbytesdev/prusaconnectcam:latest
    restart: unless-stopped
    env_file: .env
    devices:
      # Your camera device path, find yours e.g. with 'v4l2-ctl --list-devices'
      - /dev/video0:/dev/video0
```
docker compose with environment variables:
```yml
services:
  prusa-cam:
    container_name: prusa-cam
    image: ghcr.io/mbytesdev/prusaconnectcam:latest
    restart: unless-stopped
    env_file: .env
    devices:
      # Your camera device path, find yours e.g. with 'v4l2-ctl --list-devices'
      - /dev/video0:/dev/video0
    environment:
      - PRINTER_UUID=
      - CAMERA_TOKEN=
      - CAMERA_FP=
      - SNAP_DELAY=10
      # optional
      # - PRUSA_HOST=
```
## ...build from source
```bash
git clone https://github.com/mbytesdev/PrusaConnectCam.git
cd prusaconnectcam
# be sure to fill out an .env file, take a look at the sample.env
docker compose build .
docker compose up -d
```
# Troubleshoot
## Find Camera Device
```bash
v4l2-ctl --list-devices
```
Outputs something like:
```bash
Logitech Webcam C270 (usb-3f980000.usb-1.3):
	/dev/video0
```