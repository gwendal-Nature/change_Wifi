$message = "Votre wifi à changé pour avoir un meuilleur débit si vous avez lancé un téléchargement sur internet il faut le relancé Bonne journée. L'admin sys()"

Write-Host "hello world"
$newIP = $IP_arriver + $compteur
New-NetIPAddress –InterfaceIndex $interface_wifi.ifIndex –IPAddress $newIP –PrefixLength 24 -DefaultGateway $gateway
$compteur++
$shell = new-object -com wscript.shell
$shell.popup("$message")
