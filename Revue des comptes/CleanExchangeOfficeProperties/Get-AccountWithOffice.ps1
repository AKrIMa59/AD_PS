$FileName = "AccountWithOffice.csv"
$FilePath = "$PSScriptRoot\$FileName"

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
$mailboxList = Get-ADUser -Filter * -Properties SamAccountName, LastLogonDate, lastLogonTimestamp, physicalDeliveryOfficeName

Add-Content $FilePath "SamAccountName;LastLogonDate;physicalDeliveryOfficeName;lastLogonTimestamp"
# Convertir le champ lastLogonTimestamp en une date et heure lisible
# Parcourir chaque compte inactif et écrire les informations dans le fichier
foreach ($mail in $mailboxList) {
    if ($null -ne $($mail.physicalDeliveryOfficeName)) {
        $lastLogonTimestampFormatted = [DateTime]::FromFileTime($mail.lastLogonTimestamp).ToString("dd/MM/yyyy HH:mm:ss")
        Add-Content $FilePath "$($mail.SamAccountName);$($mail.LastLogonDate);$($mail.physicalDeliveryOfficeName);$($lastLogonTimestampFormatted)" 
    }
}
