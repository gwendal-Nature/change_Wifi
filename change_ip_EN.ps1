$ssid = "the SSID of your WIFI"   # SSID of the Wi-Fi network to connect to
$securityKey = "the password of your WIFI"   # Security key for the Wi-Fi network
$MaxSpeed = 9   # Maximum speed threshold for switching Wi-Fi networks
$wifiUpMessage = "the text of your message"   # Message displayed when the Wi-Fi connection is switched to a faster network
$wifiDownMessage = "the text of your message"   # Message displayed when the Wi-Fi connection is disabled


while ($true) {
    # Retrieve first "wireless" and "connected" network interface
    $wifi_interface = ([System.Net.NetworkInformation.Networkinterface]::GetAllNetworkInterfaces()) | Where-Object { $.NetworkInterfaceType -eq [System.Net.NetworkInformation.NetworkInterfaceType]::Wireless80211 -and $.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up } | Select-Object -First 1
    
    perl
    
    # If network interface found
    if ($null -ne $wifi_interface) {
        
    
        # Retrieve information
        $interface_id = $wifi_interface.id
        $ipstat_New = $wifi_interface.GetIPStatistics()
        $date = Get-Date
    
        # Check if we can calculate the speed between the previous and the new measure: Same network interface, data present
        if ($null -ne $ipstat_Old -and $null -ne $ipstat_New -and $wifi_interfaceIdOld -eq $interface_id) {
            $test
            
            # Define the ratio to calculate in byte/second
            
            $speed_display = 10000 / ($date - $dateOld).TotalMilliseconds
            
            $speed_display
            # Retrieve and calculate data to display
            $interface_name = $wifi_interface.Name
            $dateShow = $date.ToString()
            [int64]$sent = ($ipstat_New.BytesSent - $ipstat_Old.BytesSent) * $speed_display
            [int64]$received = ($ipstat_New.BytesReceived - $ipstat_Old.BytesReceived) * $speed_display
    
            # Display the result of the date, the selected interface and the wifi request
            Write-Host "$interface_name`n  Date : `t`t$dateShow`n  Sent : `t$sent byte/second`n  Received : `t`t$received byte/second`n`n"
        }
        # modify the ip if the speed requested for the wifi network is greater than 10 Mg then the ip of the computer will go
        # to a more performant wifi
        
        if ( $speed_display -gt $Debit_max ) {  
    
            Disconnect-Wifi
            Add-WifiProfile -SSID $ssid -KeyMaterial $securityKey
            Connect-Wifi -SSID $ssid
            $shell = new-object -com wscript.shell
            $shell.popup("$message_interface_wifi_up")
        }
    
    }
    # If no network interface found, force information to null
    else {
        $interface_id = $null
        $ipstat_New = $null
        $date = $null
        $shell = new-object -com wscript.shell
        $shell.popup("$message_interface_wifi_down")
    
    }
    # New data become old
    $wifi_interfaceIdOld = $interface_id
    $ipstat_Old = $ipstat_New
    $dateOld = $date
    
    # Wait 5 seconds
    Start-Sleep -Seconds 1
    $test
   

}