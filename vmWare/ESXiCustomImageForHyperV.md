# Making a Custom VMware ESXi image for HyperV 

## Installing Python 3.7.9
1. Install Python 3.7.9 from the link [text](https://www.python.org/downloads/release/python-379/).

2. Also add Python to $PATH while installing.

3. Open PowerShell.

3. Install Required dependencies.
> pip install six lxml psutil pyopenssl

4. Set Python path in PowerCLI config
> Set-PowerCLIConfiguration -PythonPath "C:\Users\<username>\AppData\Local\Programs\Python\Python37\python.exe" -Scope User

## Modififcation of ESXi VMimage
1. Navigate to the directory containing the image file and tulip drivers.
> cd D:\vmedit\

2. Load ESXi image.
```bash
# Command
PS D:\vmedit>Add-EsxSoftwareDepot .\VMware-ESXi-8.0U3g-24859861-depot.zip
# Output
Depot Url
---------
zip:D:\vmedit\VMware-ESXi-8.0U3g-24859861-depot.zip?index.xml
```

3. Load Tulip Drivers
```bash
# Command
PS D:\vmedit>Add-EsxSoftwareDepot .\net-tulip-1.1.15-1-offline_bundle.zip
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


> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.