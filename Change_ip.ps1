# Définition des variables pour le réseau
$compteur = 1
$IP_arriver = "10.101.7"
$gateway = "10.101.7.254"
$Debit_max = 10000000

# Désactive DHCP sur l'interface réseau
Set-NetIPInterface -InterfaceIndex 12 -Dhcp Disabled

# Boucle infinie pour surveiller l'état de la carte réseau WiFi
while($true)
{
    # Récupère la première interface réseau WiFi connectée
    $interface_wifi = ([System.Net.NetworkInformation.Networkinterface]::GetAllNetworkInterfaces()) | Where-Object {$_.NetworkInterfaceType -eq [System.Net.NetworkInformation.NetworkInterfaceType]::Wireless80211 -and $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up} | Select-Object -First 1

    # Si une carte réseau WiFi est trouvée
    if($interface_wifi -ne $null)
    {
        # Récupère l'ID de l'interface, les statistiques réseau et la date actuelle
        $interface_recupe = $interface_wifi.id
        $ipstat_New = $interface_wifi.GetIPStatistics()
        $date = Get-Date

        # Vérifie si le débit peut être calculé entre la dernière mesure et la nouvelle :
        # même carte réseau, données disponibles
        if ($ipstat_Old -ne $null -and $ipstat_New -ne $null -and $interface_wifiIdOld -eq $interface_recupe)
        {
            # Calcul du ratio pour les octets/seconde
            $ratio = 1000 / ($date - $dateOld).TotalMilliseconds

            # Récupère et calcule les données à afficher
            $Nom_interface = $interface_wifi.Name
            $DateShow = $date.ToString()
            [int64]$sent = ($ipstat_New.BytesSent - $ipstat_Old.BytesSent) * $ratio
            [int64]$received = ($ipstat_New.BytesReceived - $ipstat_Old.BytesReceived) * $ratio

            # Affiche les résultats : nom de l'interface, date, débit d'envoi et de réception
            Write-Host "$Nom_interface`n  Date : `t`t$DateShow`n  Envoyés : `t$sent Octets/seconde`n  Reçus : `t`t$received Octets/seconde`n`n"
        }
        
        # Si le débit demandé pour le réseau WiFi est supérieur à 10 Mb/s, change l'adresse IP de l'ordinateur vers un réseau WiFi plus performant
        if ($sent -gt $Debit_max -and $received -gt $Debit_max)
        {    
            New-NetIPAddress –InterfaceIndex 12 –IPAddress ($IP_arriver + $compteur) –PrefixLength 24 -DefaultGateway $gateway
            $compteur += 1
        }
    }
    # Si aucune carte réseau WiFi n'est trouvée, force les informations à null
    else
    {
        $interface_recupe = $null
        $ipstat_New = $null
        $date = $null
    }
    
    # Stocke les nouvelles données en tant que données précédentes
    $interface_wifiIdOld = $interface_recupe
    $ipstat_Old = $ipstat_New
    $dateOld = $
}