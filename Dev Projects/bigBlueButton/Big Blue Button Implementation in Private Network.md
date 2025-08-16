<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Big Blue Button Video Conference Server Deployment](#big-blue-button-video-conference-server-deployment)
  - [1\. Using Web Deployed Domain Name](#1%5C-using-web-deployed-domain-name)
    - [1\. Install Ngrok (Quick & Free Alternative)](#1%5C-install-ngrok-quick--free-alternative)
    - [2\. Change Host-name (machine name)](#2%5C-change-host-name-machine-name)
      - [a\. Change Hostname Temporarily (Until Reboot)](#a%5C-change-hostname-temporarily-until-reboot)
      - [b\. Change Hostname Permanently](#b%5C-change-hostname-permanently)
        - [Step 1: Use hostnamectl Command](#step-1-use-hostnamectl-command)
        - [Step 2: Edit /etc/hostname](#step-2-edit-etchostname)
        - [Step 3: Update /etc/hosts](#step-3-update-etchosts)
    - [3\. Apply Changes Without Reboot](#3%5C-apply-changes-without-reboot)
    - [4\. Verify the Change](#4%5C-verify-the-change)
    - [5\. (Optional) Reboot to Ensure Changes Persist](#5%5C-optional-reboot-to-ensure-changes-persist)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Big Blue Button Video Conference Server Deployment
## 1\. Using Web Deployed Domain Name

Make this entry in dns with the associated IP address

[7082-39-43-142-181.ngrok-free.app](https://7082-39-43-142-181.ngrok-free.app)

add a cname

[bbb2.lte.paf.mil](bbb2.lte.paf.mil)  
 

### 1\. Install Ngrok (Quick & Free Alternative)

Install Ngrok:

```plaintext
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok
```

Authenticate & Start a Tunnel:

```plaintext
ngrok authtoken YOUR_NGROK_AUTH_TOKEN
ngrok http 443 (or 80)
```

Ngrok gives you a temporary public URL (https://xyz.ngrok.io).

Use This URL to Access Your VM Globally!

### 2\. Change Host-name (machine name)

To change the hostname (machine name) of your Ubuntu machine, follow these steps:

#### a\. Change Hostname Temporarily (Until Reboot)

You can change the hostname for the current session using:

`sudo hostname 7082-39-43-142-181`

This change is temporary and will revert after a reboot.  
 

#### b\. Change Hostname Permanently

To make the change permanent, update the necessary configuration files.

##### Step 1: Use hostnamectl Command

`sudo hostnamectl set-hostname 7082-39-43-142-181`

##### Step 2: Edit /etc/hostname

`sudo nano /etc/hostname`

Replace the old name with new-hostname.

Save and exit (CTRL + X, then Y, then ENTER).

##### Step 3: Update /etc/hosts

Edit the hosts file:

`sudo nano /etc/hosts`

Find the line:

`127.0.1.1    old-hostname`

Change it to:

`127.0.1.1    7082-39-43-142-181`

Save and exit.

### 3\. Apply Changes Without Reboot

`sudo systemctl restart systemd-hostnamed`

### 4\. Verify the Change

`hostnamectl`

It should now show the updated hostname.

### 5\. (Optional) Reboot to Ensure Changes Persist

`sudo reboot`

Your Ubuntu machine now has a new hostname! 🚀