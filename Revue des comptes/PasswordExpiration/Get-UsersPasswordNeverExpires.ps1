$FileName = "UserNoPasswordExpire.csv"
$FilePath = "$PSScriptRoot\$FileName"

$groupName = "Administrateurs"

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

Add-Content $FilePath "SamAccountName;PasswordNeverExpires"

Get-ADGroupMember -Identity $groupName | Where-Object {$_.ObjectClass -eq "user"} | ForEach-Object {
    $user = Get-ADUser -Identity $_.SamAccountName -Properties PasswordNeverExpires
    if ($user.PasswordNeverExpires) {
        Write-Host "$($user.Name) ($($user.SamAccountName)) a le mot de passe qui n'expire jamais."
        Add-Content $FilePath "$($user.SamAccountName);$($user.PasswordNeverExpires)"
    }
}