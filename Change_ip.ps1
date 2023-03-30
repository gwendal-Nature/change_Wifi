$compteur = 1
$IP_arriver = 10.101.7
$gateway = 10.101.7.254
$Debit_max = 10000000


# Boucle infinie
while($true) /////
{
    # Récupère la première interface réseau "Ethernet" et "connecté"
    $interface_wifi = ([System.Net.NetworkInformation.Networkinterface]::GetAllNetworkInterfaces()) | Where-Object {$_.NetworkInterfaceType -eq [System.Net.NetworkInformation.NetworkInterfaceType]::Wireless80211 -and $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up} | Select-Object -First 1

    # Si carte réseau trouvé
    if($interface_wifi -ne $null)
    {
        # Récupère les informations
        $interface_recupe = $interface_wifi.id
        $ipstat_New = $interface_wifi.GetIPStatistics()
        $date = Get-Date

        # Vérifie si on peux calculer le débit entre la précédente mesure et la nouvelle : Même carte réseau, données présentent
        if ($ipstat_Old -ne $null -and $ipstat_New -ne $null -and $interface_wifiIdOld -eq $interface_recupe)
        {
            # Définit le ratio pour calculer en Octets/seconde
            $Debit = 1000 / ($date - $dateOld).TotalMilliseconds

            # Récupère et calcul les données à afficher
            $Nom_interface = $interface_wifi.Name
            $DateShow = $date.ToString()
            [int64]$sent = ($ipstat_New.BytesSent - $ipstat_Old.BytesSent) * $ratio
            [int64]$received = ($ipstat_New.BytesReceived - $ipstat_Old.BytesReceived) * $ratio

            # affiche le résultat de la date l'interface sélectionné et la demande de wifi
            Write-Host "$Nom_interface`n  Date : `t`t$DateShow`n  Envoyés : `t$sent Octets/seconde`n  Reçus : `t`t$received Octets/seconde`n`n"
        }
        # modification de l'ip si le débit demander pour le réseaux wifi est supérieur à 10 Mg alors l'ip de l'ordianteur iras 
        # vers un wifi plus performant
        if ( $debit -gt $Debit_max )
        {    
            New-NetIPAddress –InterfaceIndex 12 –IPAddress $IP_arriver + $compteur –PrefixLength 24 -deflautgateway $gateway
            $compteur =+ 1
        }
        

    }
    # Si pas de carte réseau trouvé on force les informations à null
    else
    {
        $interface_recupe = $null
        $ipstat_New = $null
        $date = $null
    }
    # Les nouvelles données deviennes les anciennes
    $interface_wifiIdOld = $interface_recupe
    $ipstat_Old = $ipstat_New
    $dateOld = $date

    # Attend 5 secondes
    Start-Sleep -Seconds 5
}