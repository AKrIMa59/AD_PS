# Spécifier le nom du groupe
$nomGroupe = "GROUPE"

# Obtenir les membres du groupe
$utilisateurs = Get-ADGroupMember -Identity $nomGroupe

# Afficher les utilisateurs
foreach ($utilisateur in $utilisateurs) {
    if ($utilisateur.objectClass -eq "user") {
        Write-Output $utilisateur.Name
    }
}