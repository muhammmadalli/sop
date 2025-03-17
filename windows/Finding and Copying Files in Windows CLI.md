# Access Share Folder via CMD in Win Server 22

To access a shared folder via the command line on Windows Server 2022, you can use the net use command. Here is the general syntax and an example:

### Syntax

```
net use \[drive letter\]: \\\\\[server name\]\\\[shared folder\] \[password\] /user:\[username\]
````

### Example

Suppose you want to access a shared folder named SharedFolder on a server named ServerName using the username UserName and the password Password. You want to map this shared folder to drive letter Z:. Here is how you can do it:

1. Open Command Prompt with administrative privileges.
2. Enter the following command:

```bash
net use Z: \\\\ServerName\\SharedFolder Password /user:UserName
```

## Additional Options

- **Persistent connection**: To make the connection persistent (reconnect at login), add /persistent:yes:

```bash
net use Z: \\\\ServerName\\SharedFolder Password /user:UserName /persistent:yes
```

- **Without specifying password**: If you prefer to enter the password manually or not specify it in the command, you can omit the password:

```bash

net use Z: \\\\ServerName\\SharedFolder /user:UserName
```

After running the command, you should have access to the shared folder as a mapped drive in Windows Explorer and can use it from the command line.


# Copy a Folder Into Downloads

To copy a folder into your Downloads folder on Windows Server 2022 using the command line, you can use the xcopy or robocopy command. Here are the steps and examples for both methods:

## Using xcopy

1. Open Command Prompt.
2. Use the xcopy command to copy the folder. Here's the syntax and an example:

### Syntax

```cmd

xcopy \[source\] \[destination\] /E /I
```
### Example

Suppose you want to copy a folder named MyFolder located at C:\\SourcePath to your Downloads folder located at C:\\Users\\\[YourUsername\]\\Downloads. The command would be:

```cmd
xcopy C:\\SourcePath\\MyFolder C:\\Users\\\[YourUsername\]\\Downloads\\MyFolder /E /I
```
- /E copies all subdirectories, including empty ones.
- /I treats the destination as a directory if it's ambiguous.

## Using robocopy

robocopy (Robust File Copy) is more advanced and reliable for copying large sets of files and folders.

1. Open Command Prompt.
2. Use the robocopy command to copy the folder. Here's the syntax and an example:

### Syntax

```cmd

robocopy \[source\] \[destination\] /E
```
### Example

Using the same example as above, the command would be:

```cmd
robocopy C:\\SourcePath\\MyFolder C:\\Users\\\[YourUsername\]\\Downloads\\MyFolder /E
```
- /E copies all subdirectories, including empty ones.

## Steps

1. Open Command Prompt by pressing Win + R, typing cmd, and hitting Enter.
2. Execute one of the above commands based on your preference.

## Note

Replace \[YourUsername\] with your actual username.

Using either xcopy or robocopy, you should be able to copy the folder into your Downloads folder efficiently.