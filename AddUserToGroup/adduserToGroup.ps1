# Spécifiez le chemin d'accès au fichier CSV contenant les noms et prénoms des utilisateurs
$csvFilePath = ".\utilisateurs.csv"

# Spécifiez le nom du groupe AD auquel les utilisateurs doivent être ajoutés
$groupName = "GROUPE"

# Importer les données du fichier CSV
$users = Import-Csv $csvFilePath

# Parcourir chaque utilisateur dans la liste et les ajouter au groupe AD spécifié
foreach ($user in $users) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    
    # Recherchez l'utilisateur dans Active Directory en utilisant le nom complet
    $adUser = Get-ADUser -Filter {GivenName -eq $firstName -and Surname -eq $lastName}
    
    # Si l'utilisateur est trouvé, ajoutez-le au groupe spécifié
    if ($adUser) {
        Add-ADGroupMember -Identity $groupName -Members $adUser
        Write-Host "L'utilisateur $($adUser.SamAccountName) a été ajouté au groupe $($groupName)"
    }
    else {
        Write-Warning "Impossible de trouver l'utilisateur $firstName $lastName dans Active Directory."
    }
}
