$ssid = "WIFI_ETUDIANTS" # SSID du wifi que vous voulez rejoindre
$name = "WIFI_ETUDIANTS" # nom du profile wifi
$Debit_max = 8
$message_interface_wifi_up = "Votre wifi à changé pour avoir un meilleur débit si vous avez lancé un téléchargement sur internet il faut le relancé Bonne journée.          L'admin sys"
$message_interface_wifi_down = "votre wifi est désactivé pour que le script fonction il faut activé le wifi. Admin sys "

# Boucle infinie
while ($true) {
    # Récupère la première interface réseau "wirless" et "connecté"
    $interface_wifi = ([System.Net.NetworkInformation.Networkinterface]::GetAllNetworkInterfaces()) | Where-Object { $_.NetworkInterfaceType -eq [System.Net.NetworkInformation.NetworkInterfaceType]::Wireless80211 -and $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up } | Select-Object -First 1

    # Si carte réseau trouvé
    if ($null -ne $interface_wifi) {
        

        # Récupère les informations
        $interface_recupe = $interface_wifi.id
        $ipstat_New = $interface_wifi.GetIPStatistics()
        $date = Get-Date

        # Vérifie si on peux calculer le débit entre la précédente mesure et la nouvelle : Même carte réseau, données présentent
        if ($null -ne $ipstat_Old -and $null -ne $ipstat_New -and $interface_wifiIdOld -eq $interface_recupe) {
            $test
            
            # Définit le ratio pour calculer en octet/seconde
            
            $Affichage_debit = 10000 / ($date - $dateOld).TotalMilliseconds
            
            $Affichage_debit
            # Récupère et calcul les données à afficher
            $Nom_interface = $interface_wifi.Name
            $DateShow = $date.ToString()
            [int64]$sent = ($ipstat_New.BytesSent - $ipstat_Old.BytesSent) * $Affichage_debit
            [int64]$received = ($ipstat_New.BytesReceived - $ipstat_Old.BytesReceived) * $Affichage_debit

            # affiche le résultat de la date l'interface sélectionné et la demande de wifi
            Write-Host "$Nom_interface`n  Date : `t`t$DateShow`n  Envoyés : `t$sent octet/seconde`n  Reçus : `t`t$received octet/seconde`n`n"
        }
        # modification de l'ip si le débit demander pour le réseaux wifi est supérieur à 10 Mg alors l'ip de l'ordianteur iras 
        # vers un wifi plus performant
        
        if ( $Affichage_debit -gt $Debit_max ) {  

            Disconnect-Wifi
            netsh wlan connect name=$name ssid=$ssid
            $shell = new-object -com wscript.shell
            $shell.popup("$message_interface_wifi_up")
            exit
        }

    }
    # Si pas de carte réseau trouvé on force les informations à null
    else {
        $interface_recupe = $null
        $ipstat_New = $null
        $date = $null
        $shell = new-object -com wscript.shell
        $shell.popup("$message_interface_wifi_down")

    }
    # Les nouvelles données deviennent les anciennes
    $interface_wifiIdOld = $interface_recupe
    $ipstat_Old = $ipstat_New
    $dateOld = $date

    # Attend 5 secondes
    Start-Sleep -Seconds 1
    $test
}