# Check Linux Distribution

To check which Linux distribution you are using, you can use one of the following commands in your terminal:

1. **Check the distribution name and version:**
```
lsb_release -a
```
This command will output detailed information about your Linux distribution, including the distributor ID, description, release, and codename.

2. **Check the contents of the /etc/os-release file:**
```
cat /etc/os-release
```
This file contains various details about the distribution, such as its name, version, and other relevant information.

3. **For a quick summary:**
```
hostnamectl
```
This command will provide a summary that includes the Operating System, its version, and other relevant system information.
Any of these commands will help you identify the Linux distribution and version you are currently using.

## Other Ways

If those commands didn't work, it could be due to a few different reasons, such as the commands not being available or the distribution not having those specific files. Here are alternative ways to check which Linux distribution you're using:

1. **Check /etc/\*release Files:**

If the lsb_release command or /etc/os-release file isn't available, you can try:

```
cat /etc/\*release
```
This command searches for any release files, which typically contain information about the distribution.

2. **Check /etc/issue:**

Another file that often contains distribution information is /etc/issue:
```
cat /etc/issue
```
This will usually display the distribution name and version.

3. **Check Kernel Information:**

Although this doesn't directly tell you the distribution, it can provide information about the kernel and sometimes the distribution:
```
uname -a
```
For more detailed kernel and OS information:
```
uname -r
```
4. **Try dmesg | head:**

The dmesg command might show some information about the distribution during the boot process:
```
dmesg | head
```
These methods should help you determine which Linux distribution you're running.