# Access Share Folder On Windows Server CLI

To access a shared folder on a Windows server using the command line interface (CLI), you can use the net use command in Windows or the smbclient command in Linux. Below are the steps for both:

## On Windows

1. Open Command Prompt as Administrator.
2. Use the following command to map a network drive to the shared folder:
```
net use Z: \\\\ServerName\\SharedFolder /user:Username Password
```
Replace Z: with the drive letter you want to assign, ServerName with the name of your Windows server, SharedFolder with the name of the shared folder, Username with your username, and Password with your password.

### Example
```sh
net use Z: \\\\MyServer\\Documents /user:JohnDoe MyPassword
```
## On Linux
1. Open a terminal.
2. Install smbclient if it's not already installed:
```bash
sudo apt-get install smbclient
```
3. Use the following command to access the shared folder:
```bash
smbclient //ServerName/SharedFolder -U Username
```
Replace ServerName with the name of your Windows server, SharedFolder with the name of the shared folder, and Username with your username. You will be prompted for the password.

### Example
```bash
smbclient //MyServer/Documents -U JohnDoe
```
Once connected, you can use smbclient commands to interact with the shared folder.
## Mounting a Windows Share on Linux

Alternatively, you can mount the shared folder to a local directory:

1. Create a mount point:
```bash
sudo mkdir /mnt/sharedfolder
```
1. Mount the shared folder using cifs:
```bash
sudo mount -t cifs //ServerName/SharedFolder /mnt/sharedfolder -o username=Username,password=Password
```
### Example
```bash
sudo mount -t cifs //MyServer/Documents /mnt/sharedfolder -o username=JohnDoe,password=MyPassword
```
Now, you can access the shared folder through /mnt/sharedfolder.