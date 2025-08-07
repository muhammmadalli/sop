# Making a Custom VMware ESXi image for HyperV 

## Installing Python 3.7.9
1. Install Python 3.7.9 from the link [text](https://www.python.org/downloads/release/python-379/).

2. Also add Python to $PATH while installing.

3. Open PowerShell.

3. Install Required dependencies.
> pip install six lxml psutil pyopenssl

4. Set Python path in PowerCLI config
> Set-PowerCLIConfiguration -PythonPath "C:\Users\<username>\AppData\Local\Programs\Python\Python37\python.exe" -Scope User