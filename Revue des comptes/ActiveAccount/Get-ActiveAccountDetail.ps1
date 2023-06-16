$FileName = "ActiveAccount2Years.csv"
$FilePath = "$PSScriptRoot\$FileName"
$dateLimite = (Get-Date).AddYears(-2)

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

# Obtenir tous les comptes utilisateurs actif depuis la date limite
$comptesInactifs = Get-ADUser -Filter {Enabled -eq $true -and LastLogonDate -gt $dateLimite} -Properties mail, SamAccountName, LastLogonDate, lastLogonTimestamp, whenCreated 

Add-Content $FilePath "SamAccountName;LastLogonDate;mail;lastLogonTimestamp;whenCreated"
# Convertir le champ lastLogonTimestamp en une date et heure lisible
# Parcourir chaque compte actif et écrire les informations dans le fichier
foreach ($compte in $comptesInactifs) {
    $lastLogonTimestampFormatted = [DateTime]::FromFileTime($compte.lastLogonTimestamp).ToString("dd/MM/yyyy HH:mm:ss")
    Add-Content $FilePath "$($compte.SamAccountName);$($compte.LastLogonDate);$($compte.mail);$($lastLogonTimestampFormatted);$($compte.whenCreated)" 
}

Write-Host "$($(Get-Content -Path $FilePath | Measure-Object -Line).Lines) compte(s) trouve(s)"

