$FileName = "Properties.csv"
$FilePath = "$PSScriptRoot\$FileName"
$PropertieName = "Propertie"
$PropertieValue = "Value"

if (Test-Path $FilePath) {
    # Utilise la cmdlet Import-Csv pour importer les données du fichier CSV dans une variable
    $csvData = Import-Csv -Path $FilePath -Delimiter ";"
    foreach ($row in $csvData) {
        Write-Host "$($row.'SamAccountName') : $PropertieName = $PropertieValue"
        try {
            Set-ADUser -Identity $($row.'SamAccountName') -Replace @{$PropertieName=$PropertieValue}
        }
        catch {
            Write-Host "Une erreur s'est produite : $($error[0].Exception.Message)"
        }
    }
} else {
    Write-Host "Le fichier $FileName n'existe pas."
}