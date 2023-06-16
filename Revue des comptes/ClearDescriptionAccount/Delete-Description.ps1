$FileName = "accountWithDescriptionSave.csv"
$FilePath = "$PSScriptRoot\$FileName"
$PropertieName = "description"
$PropertieValue = " "

if (Test-Path $FilePath) {
    # Utilise la cmdlet Import-Csv pour importer les données du fichier CSV dans une variable
    $csvData = Import-Csv -Path $FilePath -Delimiter ";"
    foreach ($row in $csvData) {
        try {
            Set-ADUser -Identity $($row.'SamAccountName') -Replace @{$PropertieName=$PropertieValue}
        }
        catch {
            Write-Host "$($row.'SamAccountName')"
            Write-Host "Une erreur s'est produite : $($error[0].Exception.Message)"
            exit
        }
        Write-Host "$($row.'SamAccountName') : $PropertieName = NULL"
    }
} else {
    Write-Host "Le fichier $FileName n'existe pas."
}