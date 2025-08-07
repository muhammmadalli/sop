# Making a Custom VMware ESXi image for HyperV 

## Installing Python 3.7.9
1. Install Python 3.7.9 from the link: [Python 3.7.9](https://www.python.org/downloads/release/python-379/).

2. Also add Python to $PATH while installing.

3. Open PowerShell.

3. Install Required dependencies.
> pip install six lxml psutil pyopenssl

4. Set Python path in PowerCLI config
> Set-PowerCLIConfiguration -PythonPath "C:\Users\<username>\AppData\Local\Programs\Python\Python37\python.exe" -Scope User

## Downloading Tulip-Net Depot
Download tulip-net VIB/drivers files from the following link: - <br>
[Tulip-Net offline bundle 1.1.15](http://vibsdepot.v-front.de/depot/bundles/net-tulip-1.1.15-1-offline_bundle.zip)

## Modififcation of ESXi VMimage
1. Navigate to the directory containing the image file and tulip drivers.
> cd D:\vmedit\

2. Load ESXi image.
```bash
# Command
PS D:\vmedit> Add-EsxSoftwareDepot .\VMware-ESXi-8.0U3g-24859861-depot.zip
# Output
Depot Url
---------
zip:D:\vmedit\VMware-ESXi-8.0U3g-24859861-depot.zip?index.xml
```

3. Load Tulip Drivers
```bash
# Command
PS D:\vmedit> Add-EsxSoftwareDepot .\net-tulip-1.1.15-1-offline_bundle.zip
# Output
Depot Url
---------
zip:D:\vmedit\net-tulip-1.1.15-1-offline_bundle.zip?index.xml
```

4. List the ESXi image profiles
```bash
# Command
PS D:\vmedit> Get-EsxImageProfile|ft Name
# Output
Name
----
ESXi-8.0U3g-24859861-no-tools
ESXi-8.0U3g-24859861-standard
ESXi-8.0U3sg-24853260-standard
ESXi-8.0U3sg-24853260-no-tools
```

5. Clone the standard ESXi image with a custom name such as 'ESXi8.0U3-HyperV'
```bash
# Command
PS D:\vmedit> New-EsxImageProfile -CloneProfile ESXi-8.0U3g-24859861-standard -Name ESXi8.0U3-HyperV -Vendor muhammmadali
# Output
Name                Vendor          Last Modified       Acceptance Level
----                ------          -------------       ----------------
ESXi8.0U3-HyperV    muhammmadali    29/07/2025 12:…     PartnerSupported
```

6. Add the tulip packages to the ESXi image
```bash
# Command
PS D:\vmedit> New-EsxImageProfile -CloneProfile ESXi-8.0U3g-24859861-standard -Name ESXi8.0U3-HyperV -Vendor muhammmadali
# Output
Name                           Vendor          Last Modified   Acceptance Level
----                           ------          -------------   ----------------
ESXi8.0U3-HyperV               muhammmadali    29/07/2025 12:… PartnerSupported

PS D:\vmedit> Add-EsxSoftwarePackage -ImageProfile ESXi8.0U3-HyperV -SoftwarePackage net-tulip -Force
Add-EsxSoftwarePackage: In ImageProfile ESXi8.0U3-HyperV, the payload(s) in VIB DEC_bootbank_net-tulip_1.1.15-1 does not have sha-256 gunzip checksum. This will prevent VIB security verification and secure boot from functioning properly. Please remove this VIB or please check with your vendor for a replacement of this VIB
```
> [!NOTE]  
> the net-tulip VIB:<br>
    - Lacks a SHA-256 checksum, which is required for Secure Boot validation in ESXi 8.x. <br>
    - Without this checksum, Secure Boot will fail, and the image will be considered untrusted

7. Secure Boot will be disabled by adding the **net-tulip** VIB (Not Recommended for Production)
> [!WARNING]  
> ⚠️ This compromises host integrity and is not recommended for production environments.

8. Set the VMimage Acceptance Level to Community Supported
```bash
# Command
PS D:\vmedit> Set-EsxImageProfile -AcceptanceLevel CommunitySupported -ImageProfile ESXi8.0U3-HyperV
# Output
Name                           Vendor          Last Modified        Acceptance Level
----                           ------          -------------        ----------------
ESXi8.0U3-HyperV               muhammmadali    07/08/2025 11:…      CommunitySupported
```

9. Now you are ready to create the ESXi installation ISO file that includes net-tulip drivers. Run the following command to create the ISO image: -

```bash
PS D:\vmedit> Export-EsxImageProfile -ImageProfile ESXi8.0U3-HyperV -FilePath d:vmedit\esxi80_hyperv.iso -ExportToIso -NoSignatureCheck -Force
```

> ✅ **Success!**
> This creates our ESXi image ISO bootable inside Microsoft Windows Hyper-V Virtual Machine.


# Configuring the Hyper-V VM
## Enabling Nested Virtualization for the Hyper-V VM with ESXi

Nested virtualization is a feature that allows you to run virtual machines inside a virtual machine. In this case a nested VM should run on a Hyper-V VM that has ESXi hypervisor installed. Enable nested virtualization for this VM in PowerShell.

> PS C:\Windows\System32> Set-VMProcessor -VMName \<vm-name> -ExposeVirtualizationExtensions $true

## ESXi Installation on the Hyper-V VM
Now you are ready to install ESXi on a Hyper-V VM. Start your VM (right-click the VM name, select connect and click the Start button). Press TAB when you see the boot screen with a blue background to modify boot options, and prevent hanging the VM

Install the ESXi as normal.

## Enable ESXi to run headless (inside a VM)

1. While ESXi is rebootin, press **Shift+O** before the boot begins.

2. Enter ignoreHeadless=TRUE at the end of the string and press **Enter**.

## Enable permanent headless for ESXi
Below you can learn how to set this option permanently
