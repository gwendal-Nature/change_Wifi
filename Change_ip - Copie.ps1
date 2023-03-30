# Initialise les variables pour le réseau et la date
$compteur = 1
$IP_arriver = "10.101.7"
$gateway = "10.101.7.254"
$Debit_max = 10000000
$dateOld = Get-Date


# Désactive DHCP sur l'interface réseau


# Boucle infinie pour surveiller l'état de la carte réseau WiFi
while ($true) {
    # Récupère la première interface réseau WiFi connectée
    $interface_wifi = 19
    Write-Host "hello world"

    # Si une carte réseau WiFi est trouvée
    if ($null -ne $interface_wifi) {
        # Récupère l'ID de l'interface, les statistiques réseau et la date actuelle
        $interface_recupe = $interface_wifi.id
        $ipstat_New = $interface_wifi.GetIPStatistics()
        $date = Get-Date
        Write-Host "tu vas bien ?"

        # Vérifie si le débit peut être calculé entre la dernière mesure et la nouvelle :
        # même carte réseau, données disponibles
        if ($null -ne $ipstat_Old -and $null -ne $ipstat_New -and $interface_wifiIdOld -eq $interface_recupe) 
        {
            # Vérifie que $date et $dateOld ont une valeur avant de les utiliser dans l'opération de soustraction
            Write-Host " mois non"
            if ($null -ne $date -and $null -ne $dateOld) {
                Write-Host "je veux réglé ce problème"
                # Calcul du ratio pour les octets/seconde
                $ratio = 1000 / ($date - $dateOld).TotalMilliseconds
            }

            # Récupère et calcule les données à afficher
            $Nom_interface = $interface_wifi.Name
            $DateShow = $date.ToString()
            [int64]$sent = ($ipstat_New.BytesSent - $ipstat_Old.BytesSent) * $ratio
            [int64]$received = ($ipstat_New.BytesReceived - $ipstat_Old.BytesReceived) * $ratio

            # Affiche les résultats : nom
            if ($null -ne $ipstat_Old -and $null -ne $ipstat_New -and $interface_wifiIdOld -eq $interface_recupe) 
            {
                Write-Host "j'èspère que jusque là j'ai eu tout les messages"
                # Calcul du ratio pour les octets/seconde
                if ($dateOld -is [DateTime]) {
                    $ratio = 1000 / ($date - $dateOld).TotalMilliseconds
                }
                else {
                    $ratio = 0
                }
            
                # Récupère et calcule les données à afficher
                $Nom_interface = $interface_wifi.Name
                $DateShow = $date.ToString()
                [int64]$sent = ($ipstat_New.BytesSent - $ipstat_Old.BytesSent) * $ratio
                [int64]$received = ($ipstat_New.BytesReceived - $ipstat_Old.BytesReceived) * $ratio
            
                # Affiche les résultats : nom de l'interface, date, débit d'envoi et de réception
                Write-Host "$Nom_interface`n , Date : `t$DateShow`n , Envoyés : `t$sent Octets/seconde`n , Reçus : `t$received Octets/seconde`n"
            }
        
            # Si le débit demandé pour le réseau WiFi est supérieur à 10 Mb/s, change l'adresse IP de l'ordinateur vers un réseau WiFi plus performant
            if ($sent -gt $Debit_max -and $received -gt $Debit_max) {    
                New-NetIPAddress –InterfaceIndex 12 –IPAddress ($IP_arriver + $compteur) –PrefixLength 24 -DefaultGateway $gateway
                $compteur += 1
                
            }
        }
        # Si aucune carte réseau WiFi n'est trouvée, force les informations à null
        else {
            $interface_recupe = $null
            $ipstat_New = $null
            $date = $null
        }
    
        # Stocke les nouvelles données en tant que données précédentes
        $interface_wifiIdOld = $interface_recupe
        $ipstat_Old = $ipstat_New
        $dateOld = $date
    }
    Start-Sleep -Seconds 5
}