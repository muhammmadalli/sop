<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Change Win RDP Port](#change-win-rdp-port)
- [Port Ranges](#port-ranges)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Change Win RDP Port

To change the Remote Desktop Protocol (RDP) port on a Windows machine, follow these steps:

1. **Open the Registry Editor**:
    - Press Win + R, type regedit, and press Enter.
2. **Navigate to the RDP Port Key**:
    - Go to:  
        ```
        HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp
        ```
3. **Edit the Port Number**:
    - In the right-hand pane, find the PortNumber key.
    - Right-click it and select **Modify**.
    - Select **Decimal** and enter the new port number (default is 3389).
4. **Restart the Computer**:
    - For the changes to take effect, restart your computer.
5. **Update Your Firewall**:
    - Ensure the new port is allowed through the firewall.
    - Open Windows Firewall > **Advanced Settings**.
    - Find any existing RDP rules and modify them to allow traffic on the new port.
6. **Update Your Router (If Necessary)**:
    - If you're accessing the RDP from outside your local network, you'll need to forward the new port on your router.

Make sure to test the new port by connecting with the format:  
``remote_computer_ip:new_port``

# Port Ranges

The valid port range in TCP/UDP networks is between 0 and 65535. Here’s a breakdown:

1. **Well-Known Ports (0–1023)**:
    - These are reserved for system services and well-known applications like HTTP (port 80), HTTPS (port 443), and SSH (port 22).
    - It’s recommended **not to use** ports in this range for custom services, like RDP.
2. **Registered Ports (1024–49151)**:
    - These are typically used by applications and services that register with IANA.
    - For custom RDP ports, choosing something in this range (e.g., 5000–6000) is often ideal.
3. **Dynamic/Private Ports (49152–65535)**:
    - These are generally used for dynamic or temporary connections and are less ideal for services requiring static ports.

For RDP, avoid ports commonly used by other services to minimize conflicts, and ensure the port isn't blocked by security software or firewalls. Common choices for RDP are ports like 5000, 6000, or 49152.