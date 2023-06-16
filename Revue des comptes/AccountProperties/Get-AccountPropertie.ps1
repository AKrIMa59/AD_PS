$FileName = "Properties.csv"
$FilePath = "$PSScriptRoot\$FileName"
$PropertieName = "Propertie"
$PropertieValue = "Value"

# Vérifie si le fichier csv existe déjà
if (Test-Path $FilePath) {
    # Si le fichier existe, demande à l'utilisateur s'il souhaite continuer
    $response = Read-Host "Le fichier $FileName existe deja. Voulez-vous continuer ? (O/N)"
    if ($response -ne "O") {
        Write-Host "Operation annulee par l'utilisateur."
        exit
    }
    Remove-Item -Path $FilePath
}

# Obtenir tous les comptes utilisateurs désactiver
$comptesInactifs = Get-ADUser -Filter {Enabled -eq $true -and $PropertieName -eq $PropertieValue} -Properties SamAccountName, LastLogonDate, lastLogonTimestamp, $PropertieName

Add-Content $FilePath "SamAccountName;adminCount;LastLogonDate;lastLogonTimestamp"
# Convertir le champ lastLogonTimestamp en une date et heure lisible
# Parcourir chaque compte inactif et écrire les informations dans le fichier
foreach ($compte in $comptesInactifs) {
    $lastLogonTimestampFormatted = [DateTime]::FromFileTime($compte.lastLogonTimestamp).ToString("dd/MM/yyyy HH:mm:ss")
    Add-Content $FilePath "$($compte.SamAccountName);$($compte.$($PropertieName));$($compte.LastLogonDate);$($lastLogonTimestampFormatted)" 
}
