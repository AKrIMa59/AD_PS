$ou = "OU=OU-CIBLE,DC=DOMAINE,DC=dir"
$count = (Get-ADUser -Filter {ObjectClass -eq "user" -and Enabled -eq $false} -SearchBase $ou | Measure-Object).Count
Write-Host "Le nombre d'utilisateurs dans l'OU $ou est : $count"
