$FileName = "disableAccount.csv"
$FilePath = "$PSScriptRoot\$FileName"
$destinationOU = "OU=OU-CIBLE,DC=DOMAINE,DC=dir"

if (Test-Path $FilePath) {
    # Utilise la cmdlet Import-Csv pour importer les données du fichier CSV dans une variable
    $csvData = Import-Csv -Path $FilePath -Delimiter ";"
    foreach ($row in $csvData) {
        #Write-Host "SamAccountName : $($row.'SamAccountName')"
        try {
            $UserDN = (Get-ADUser -Identity $row.SamAccountName).distinguishedName
            Move-ADObject -Identity $UserDN -TargetPath $destinationOU
        }
        catch {
            Write-Host "Une erreur s'est produite pour $($row.'SamAccountName') : $($error[0].Exception.Message)"
        }
    }
} else {
    Write-Host "Le fichier $FileName n'existe pas."
}