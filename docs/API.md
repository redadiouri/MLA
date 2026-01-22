# API (exemples simples)

Base URL locale : `<BASE_URL>` (ex. `http://127.0.0.1/mylabo_api` ou `http://10.0.2.2/mylabo_api` pour émulateur Android)

Endpoints principaux (POST, JSON) — exemples génériques :

1) `register.php` - inscription

Requête (PowerShell) :
```powershell
# Remplacez <BASE_URL>, <NIVEAU_NOM.Prenom>, <email@example.com> et <password>
$base = '<BASE_URL>'
$body = @{ nom = '<NIVEAU_NOM.Prenom>'; email = '<email@example.com>'; password = '<password>' }
Invoke-RestMethod -Uri "$($base)/register.php" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

Réponse attendue :
```json
{ "success": true, "message": "Inscription réussie" }
```

2) `login.php` - connexion

Requête (PowerShell) :
```powershell
# identifier peut être un email ou le nom normalisé (ex: '<NIVEAU_NOM.Prenom>')
$base = '<BASE_URL>'
$body = @{ identifier = '<email@example.com_or_NIVEAU_NOM.Prenom>'; password = '<password>' }
Invoke-RestMethod -Uri "$($base)/login.php" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

Réponse :
- Succès : `{ "success": true, "message": "Connecté", "user": { /* infos */ } }`
- Échec : `{ "success": false, "message": "Utilisateur non trouvé" }`

3) `report.php` - envoyer un signalement

Requête (PowerShell) :
```powershell
$base = '<BASE_URL>'
$body = @{ user_id = <USER_ID>; contenu = '<Texte du signalement>' }
Invoke-RestMethod -Uri "$($base)/report.php" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

Réponse : `{ "success": true, "message": "Signalement enregistré" }`

4) `delete.php` - supprimer un compte (vérifie mot de passe)

Requête (PowerShell) :
```powershell
$base = '<BASE_URL>'
$body = @{ identifier = '<email@example.com_or_NIVEAU_NOM.Prenom>'; password = '<password>' }
Invoke-RestMethod -Uri "$($base)/delete.php" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

Réponse : `{ "success": true, "message": "Compte supprimé" }` ou une erreur correspondante.

Remarques :
- Les scripts attendent du JSON dans le corps de la requête.
- Utilisez des placeholders génériques dans les exemples pour éviter d'exposer des données réelles.
