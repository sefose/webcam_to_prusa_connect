# webcam_to_prusa_connect
This script for linux with systemd uses fswebcam and curl to send pictures from webcams to prusa connect. To preserve the sd card when running this on a raspberry pi, it doesn't save the image to the file system but sends it directly to prusa connect.
It is tested for Raspberry Pi OS Lite (Bookworm).

## Usage

### Install needed tools
If not present install git for cloning this repository, fswebcam for getting the pictures from the webcams

    sudo apt install fswebcam git

### Clone the repository

    git clone https://github.com/sefose/webcam_to_prusa_connect.git


### Configure script
To edit the script you can use nano and close with ctrl + x and save your changes

    cd webcam_to_prusa_connect/
    nano webcam_to_prusa_connect.sh

The following section of the "webcam_to_prusa_connect.sh" script needs to be edited according to your setup. Each entry in each line corrosponds to one camera at the position in the entry. You can use one or multiple cameras.

    CAMERA_NAMES=("cam1" "cam2")
    CAMERA_DEVICES=("/dev/video0" "/dev/video2")
    CAMERA_RESOLUTIONS=("1920x1080" "1920x1080")
    TOKENS=("XXXXX" "XXXXX")

#### CAMERA_NAMES
You can choose the names freely - they appear in the log of the script.
#### CAMERA_DEVICES
In short:

    v4l2-ctl --list-devices

Th output should be something like this:

    Full HD webcam: Full HD webcam (usb-0000:01:00.0-1.1):
        /dev/video0
        /dev/video1
        /dev/media4

Take the first "/dev/*" entry for each camera.

Source: https://askubuntu.com/questions/348838/how-to-check-available-webcams-from-the-command-line
#### CAMERA_RESOLUTIONS
Enter resolutions appropriate for your cameras.
#### TOKENS
Go to the camera section of your printer in prusa connect and click "Add new another camera"
This generates the needed Token.
### Install service
For the script to start with the machine, we use an systemd service.
The script "create_systemd_service.sh" creates a service.

    sudo ./create_systemd_service.sh

more information: https://tecadmin.net/run-shell-script-as-systemd-service/

Now the script should send pictures to prusa connect


## Sources
Thanks Djaesthetic for this solution to start with: https://www.reddit.com/r/prusa3d/comments/1971673/streaming_a_webcam_via_rtsp_to_prusa_connect/

To save ressources on the pi and make things less complicated I replaced the rtsp stream to get the picture from the cam directly.

Thanks jtee3d for sharing his work using multiple devices with one script! https://github.com/jtee3d/prusa_connect_rtsp
