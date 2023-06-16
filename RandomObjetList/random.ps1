# Spécifiez le chemin d'accès du fichier CSV dans lequel vous souhaitez enregistrer les informations
$csvPath = ".\random.csv"

# Spécifiez le chemin d'accès de l'unité organisationnelle (OU) Active Directory dans laquelle vous souhaitez sélectionner les ordinateurs au hasard
$ouPath = "OU=OU-CIBLE,DC=DOMAINE,DC=dir"

# Obtenez une liste de tous les ordinateurs dans l'unité organisationnelle spécifiée
$computers = Get-ADComputer -Filter {operatingSystem -eq "Windows 10 Professionnel"} -SearchBase $ouPath | Select-Object -ExpandProperty Name

# Sélectionnez x ordinateurs au hasard dans la liste
$selectedComputers = $computers | Get-Random -Count 70

# Pour chaque ordinateur sélectionné, récupérez ses informations et stockez-les dans une variable
$computerDetails = foreach ($computer in $selectedComputers) {
    Get-ADComputer $computer -Properties * | Select-Object Name, LastLogonDate
}

# Exportez les informations des ordinateurs sélectionnés dans un fichier CSV
$computerDetails | Export-Csv -Path $csvPath -NoTypeInformation
