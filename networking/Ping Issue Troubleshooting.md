<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Device Inaccessible Outside Local Subnet](#device-inaccessible-outside-local-subnet)
    - [1\. ****Check IP Configuration****](#1%5C-check-ip-configuration)
    - [2\. ****Verify Route Table****](#2%5C-verify-route-table)
    - [3\. ****Check for Firewall Issues****](#3%5C-check-for-firewall-issues)
    - [4\. ****Verify ARP Cache****](#4%5C-verify-arp-cache)
    - [5\. ****Check for Duplicate IP Addresses****](#5%5C-check-for-duplicate-ip-addresses)
    - [6\. ****Test Connectivity with Tracert****](#6%5C-test-connectivity-with-tracert)
    - [7\. ****Network Interface Check****](#7%5C-network-interface-check)
    - [8\. ****Verify VLAN and Network Configuration****](#8%5C-verify-vlan-and-network-configuration)
  - [Clear Previous Routes](#clear-previous-routes)
    - [1\. ****Open Command Prompt as Administrator****](#1%5C-open-command-prompt-as-administrator)
    - [2\. ****Clear All Routes****](#2%5C-clear-all-routes)
    - [3\. ****Verify Route Table****](#3%5C-verify-route-table)
    - [4\. ****Re-add Necessary Routes****](#4%5C-re-add-necessary-routes)
  - [Restriction by Gateway](#restriction-by-gateway)
    - [1\. ****MAC Address Filtering****](#1%5C-mac-address-filtering)
    - [2\. ****Dynamic ARP Inspection (DAI)****](#2%5C-dynamic-arp-inspection-dai)
    - [3\. ****Port Security on Switches****](#3%5C-port-security-on-switches)
    - [4\. ****Stale ARP Entries****](#4%5C-stale-arp-entries)
    - [5\. ****VLAN Configuration Issues****](#5%5C-vlan-configuration-issues)
    - [****Steps to Resolve the Issue:****](#steps-to-resolve-the-issue)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Device Inaccessible Outside Local Subnet

My windows can ping the devices in the subnet. But cannot ping gateway and other networks. Other device on the subnet can ping the gateway and other networks.

If your Windows machine can ping devices on the same subnet but not the gateway or devices on other networks, it indicates a possible network configuration issue on the Windows machine itself. Here's how you can troubleshoot and resolve the problem:

### 1\. ****Check IP Configuration****

- Open a Command Prompt and type ``ipconfig /all``. Ensure that:
  - **IP Address** is correctly assigned.
  - **Subnet Mask** is the same as other devices on the subnet.
  - **Default Gateway** is set to the correct IP address of the gateway.
  - **DNS Server** addresses are correctly configured.

### 2\. ****Verify Route Table****

- Type ``route print`` in the Command Prompt to display the routing table.
- Ensure there is a route to the gateway. You should see something like:

Network Destination Netmask Gateway Interface Metric

0.0.0.0 0.0.0.0 &lt;Gateway IP&gt; &lt;Your IP&gt; &lt;Metric&gt;

- If the route to the gateway is missing or incorrect, you can add it manually:

```
route add 0.0.0.0 mask 0.0.0.0 <Gateway IP>;
```

### 3\. ****Check for Firewall Issues****

- Ensure that the Windows Firewall is not blocking ICMP traffic (ping).
- Temporarily disable the Windows Firewall to see if that resolves the issue:
  - Open the Control Panel, go to **System and Security > Windows Defender Firewall**.
  - Click on **Turn Windows Defender Firewall on or off**.
  - Turn off the firewall and try pinging the gateway again.

### 4\. ****Verify ARP Cache****

- Type arp -a in the Command Prompt to view the ARP cache.
- Ensure that the MAC address of the gateway is correctly listed. If not, try clearing the ARP cache with:
```
arp -d \*
```
### 5\. ****Check for Duplicate IP Addresses****

- Ensure there are no IP address conflicts on the network.
- Use ping -a &lt;Your IP&gt; from another device to ensure no other device is using the same IP.

### 6\. ****Test Connectivity with Tracert****

- Use the tracert &lt;Gateway IP&gt; command to trace the route to the gateway. This will help identify where the connection is failing.

### 7\. ****Network Interface Check****

- If you are using Wi-Fi, try switching to a wired connection to see if the issue persists.
- Update the network adapter drivers via **Device Manager**.

### 8\. ****Verify VLAN and Network Configuration****

- If your network uses VLANs, ensure that your Windows machine is in the correct VLAN.
- Check if there are any specific routes or network configurations applied to this Windows machine that might affect connectivity.

If after these steps the issue persists, there could be a more complex network configuration problem at the gateway or a specific restriction applied to the Windows machine.

## Clear Previous Routes
To clear all routes from your Windows machine's routing table, you can use the following steps:

### 1\. ****Open Command Prompt as Administrator****

- Press Windows + X and select **Command Prompt (Admin)** or **Windows PowerShell (Admin)**.

### 2\. ****Clear All Routes****

- To delete all non-persistent routes (routes that are not stored in the registry), use the following command:
```
route -f
```
- This will clear all routes except for the ones associated with the loopback interface (127.0.0.0) and your own network interfaces.

### 3\. ****Verify Route Table****

- After clearing the routes, you can verify the current routing table by typing:
```
route print
```
- This will display the remaining routes, which should now only include default and necessary system routes.

### 4\. ****Re-add Necessary Routes****

- If you need to re-add specific routes, you can do so using the route add command. For example:
```
route add 0.0.0.0 mask 0.0.0.0 <Gateway IP>;
```
This should help you reset the routing configuration and troubleshoot any networking issues.

It is also possible that the gateway has blacklisted the mac of the computer because i shifted its VLANS. The gateway is defined in the router

Yes, it is possible that the gateway or router has blacklisted or otherwise restricted the MAC address of your computer, especially if you moved it between VLANs. Here’s how this might occur:

## Restriction by Gateway
### 1\. ****MAC Address Filtering****

- Some routers and gateways have MAC address filtering or security features that can block or restrict devices based on their MAC address. If your device was moved to a different VLAN, the router might have detected it as a new or unauthorized device and restricted its access.

### 2\. ****Dynamic ARP Inspection (DAI)****

- In networks with strict security, Dynamic ARP Inspection can block a device if the MAC and IP pair does not match the expected VLAN configuration. Moving between VLANs might cause the router to flag the device as suspicious.

### 3\. ****Port Security on Switches****

- If your network switch has port security enabled, it may limit the number of MAC addresses allowed on a port or restrict which MAC addresses are allowed. Moving the device between VLANs might have triggered a security response, leading to the MAC being blocked.

### 4\. ****Stale ARP Entries****

- When moving between VLANs, the gateway might have an old ARP entry that associates your MAC address with the previous VLAN’s IP address. This mismatch can cause the gateway to block traffic.

### 5\. ****VLAN Configuration Issues****

- If the VLAN configuration was not updated correctly when you moved the device, the router might reject traffic from your device because it’s not recognized in the new VLAN.

### ****Steps to Resolve the Issue:****

1. **Check MAC Filtering:**
    - Access your router’s configuration interface and check if there are any MAC filtering rules. If your device’s MAC address is listed, remove it from the blacklist or whitelist it.
2. **Clear ARP Cache on the Router:**
    - If possible, clear the ARP cache on the router to remove any stale ARP entries that might be causing conflicts.
3. **Verify VLAN Configuration:**
    - Ensure that your device is correctly configured for the new VLAN, including the correct IP address, subnet mask, and gateway.
4. **Reboot the Router and Switches:**
    - Sometimes a simple reboot of the networking equipment can resolve issues related to MAC address restrictions or stale configurations.
5. **Check Port Security:**
    - If port security is enabled on your switch, ensure that the MAC address is allowed on the specific port and that the port is configured for the correct VLAN.

If these steps don’t resolve the issue, you may need to check the router's logs for any specific security events related to your device’s MAC address, or further investigate the VLAN and network settings to ensure everything is configured correctly.