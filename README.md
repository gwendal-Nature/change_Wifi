# **Automatic WiFi management script**

This PowerShell script allows you to measure the bandwidth of a WiFi connection and automatically switch to another WiFi connection if the speed is too low.

# **Configuration**

To configure the script, you need to modify the $ssid and $securityKey variables with the information of your primary WiFi connection. You can also modify the $Debit_max variable to set the speed limit in Mbps. If the speed is higher than this limit, the script will automatically switch to another WiFi connection.

# **Usage**

To use the script, open PowerShell and execute the script by typing:

``Powershell
.\auto-wifi.ps1``

The script will start measuring the bandwidth of your primary WiFi connection. If the speed is below the defined limit, the script will automatically switch to another WiFi connection.

# **Warnings**

This script has been tested on Windows 10 and may not work on other operating systems. Additionally, this script may not work correctly if you are using WiFi connections with different names.

# **Author**

This script was developed by Gwendal . If you have any questions or comments, please feel free to contact me.
