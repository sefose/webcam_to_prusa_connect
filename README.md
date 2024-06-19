# webcam_to_prusa_connect
This script for linux with systemd uses fswebcam and curl to send pictures from webcams to prusa connect

## usage

### create webcams at prusa connect
Go to the camera section of your printer in prusa connect and click "Add new another camera"
This generates a token we need in the next step.

### configure script
The following section of the "webcam_to_prusa_connect.sh" script needs to be edited according to your setup. Each entry in each line corrosponds to one camera at the position in the entry. You can use one ore multiple cameras.

    CAMERA_NAMES=("cam1" "cam2")
    CAMERA_DEVICES=("/dev/video0" "/dev/video2")
    CAMERA_RESOLUTIONS=("1920x1080" "1920x1080")
    TOKENS=("XXXXX" "XXXXX")

How to check which devices are available: https://askubuntu.com/questions/348838/how-to-check-available-webcams-from-the-command-line

### install service
For the script to start with the machine, we use an systemd service.
The script "create_systemd_service.sh" creates a service.

    sudo ./create_systemd_service.sh

more information: https://tecadmin.net/run-shell-script-as-systemd-service/

Now the script should send pictures to prusa connect