$FileName = "UserNoPasswordExpire.csv"
$FilePath = "$PSScriptRoot\$FileName"

if (Test-Path $FilePath) {
    # Utilise la cmdlet Import-Csv pour importer les données du fichier CSV dans une variable
    $csvData = Import-Csv -Path $FilePath -Delimiter ";"
    foreach ($row in $csvData) {
        Write-Host "SamAccountName : $($row.'SamAccountName')"
        try {
            Set-ADUser -Identity $($row.'SamAccountName') -PasswordNeverExpires:$false
        }
        catch {
            Write-Host "Une erreur s'est produite : $($error[0].Exception.Message)"
        }
    }
} else {
    Write-Host "Le fichier $FileName n'existe pas."
}