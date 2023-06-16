$FileName = "accountWithDescription.csv"
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

# Obtenir tous les comptes utilisateurs avec une description
$comptesInactifs = Get-ADUser -Filter {Enabled -eq $true} -Properties mail, SamAccountName, LastLogonDate, lastLogonTimestamp, description

Add-Content $FilePath "SamAccountName;LastLogonDate;mail;lastLogonTimestamp;description"
# Convertir le champ lastLogonTimestamp en une date et heure lisible
# Parcourir chaque compte et écrire les informations dans le fichier
foreach ($compte in $comptesInactifs) {
    if ($null -ne $compte.description){
        if ($compte.description -ne " ") {
            $lastLogonTimestampFormatted = [DateTime]::FromFileTime($compte.lastLogonTimestamp).ToString("dd/MM/yyyy HH:mm:ss")
            Add-Content $FilePath "$($compte.SamAccountName);$($compte.LastLogonDate);$($compte.mail);$($lastLogonTimestampFormatted);$($compte.description)" 
        }
    }
}
