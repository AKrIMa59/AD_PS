#CONFIGURATION DU SCRIPT

#Scope de recherche
# OneLevel : Recherche étendue à l'unité organisationnelle spécifiée
# Subtree : Recherche étendue à toute l'unité organisationnelle spécifiée, y compris toutes les sous-unités.
$Scope = "OneLevel"

#Nombre de mois d'inactivité (Valeur négatif)
$numberMonths = 3



# Spécifie le chemin de l'OU que tu souhaites vérifier
$sourceOU = "OU=OU-SOURCE,DC=DOMAINE,DC=dir"
# Spécifie le chemin de l'OU où tu veux déplacer les postes inactifs
$destinationOU = "OU=OU-CIBLE,DC=DOMAINE,DC=dir"
# Obtient la date actuelle moins x mois
$MonthsAgo = (Get-Date).AddMonths($($numberMonths*-1))
# Récupère tous les objets ordinateurs de l'OU spécifiée
$computers = Get-ADComputer -Filter * -SearchBase $sourceOU -SearchScope $Scope -Properties lastLogon, lastLogonTimestamp

# Parcours tous les objets ordinateurs
foreach ($computer in $computers) {
    # Vérifie si la propriété lastLogon existe et n'est pas vide
    #Write-Host "$computer"
    if ($computer.lastLogon) {
        # Convertit la date de lastLogon en format DateTime
        $lastLogonDate = [DateTime]::FromFileTime($computer.LastLogon)
        # Vérifie si la date de lastLogon est inférieure à MonthsAgo
        if ($lastLogonDate -lt $MonthsAgo) {
            # Déplace l'objet ordinateur vers la nouvelle OU
            Move-ADObject -Identity $computer -TargetPath $destinationOU
            Write-Host "L'ordinateur $($computer.Name) a ete deplace vers $destinationOU."
        }
    }
    elseif ($computer.lastLogonTimestamp) {
        $lastLogonTimestampDate = [DateTime]::FromFileTime($computer.LastLogon)
        # Vérifie si la date de lastLogon est inférieure à MonthsAgo
        if ($lastLogonTimestampDate -lt $MonthsAgo) {
            # Déplace l'objet ordinateur vers la nouvelle OU
            Move-ADObject -Identity $computer -TargetPath $destinationOU
            Write-Host "L'ordinateur $($computer.Name) a ete deplace vers $destinationOU."
        }
    }
}

