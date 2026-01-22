# Guide pas-à-pas 

Ce guide est écrit pour être suivi comme en classe : chaque étape indique ce qu'il faut faire, pourquoi, et fournit une commande exemple.

1) Préparez votre dossier de travail
- But : placer le projet et ouvrir l'éditeur.
- Action : clonez ou copiez le dépôt sur votre machine, puis ouvrez-le dans votre éditeur (ex. VS Code).
- Exemple :
```powershell
# Remplacez <PATH_TO_PROJECT> par le chemin où vous avez placé le dépôt
cd "<PATH_TO_PROJECT>/MyLaboAccess-main"
code .
```

2) Installer les dépendances Flutter
- But : récupérer toutes les bibliothèques nécessaires.
- Commande :
```powershell
flutter pub get
```

3) Préparer le backend PHP local
- But : fournir des endpoints que l'app va appeler.
- Action : copiez le dossier `server-samples/mylabo_api` du dépôt vers le dossier web de votre serveur local (par ex. Laragon).
- Chemin générique Laragon : `%LARAGON_ROOT%\www\mylabo_api` (par défaut `C:\laragon\www\mylabo_api`).

4) Créer la base de données
- But : stocker les utilisateurs et signalements.
- Action : importer le schéma SQL fourni (voir `docs/SQL_SCHEMA.md`) via phpMyAdmin ou la CLI MySQL.

5) Configurer l'URL de l'API dans l'app
- But : l'application doit savoir où envoyer les requêtes.
- Où : ouvrez `lib/config.dart` et définissez `apiBaseUrl`.
- Valeurs recommandées :
  - Desktop / Web : `http://127.0.0.1/mylabo_api`
  - Émulateur Android : `http://10.0.2.2/mylabo_api`

6) Démarrer le serveur web et la base de données
- But : rendre les scripts PHP accessibles.
- Action : démarrez Laragon (ou Apache + MySQL) et assurez-vous que `http://<host>/mylabo_api` sert les fichiers.

7) Lancer l'application Flutter
- But : tester l'interface et les appels réseau.
- Commande :
```powershell
flutter run -d chrome
```

8) Tester un endpoint (exemple simple)
- But : vérifier que le backend répond.
- Exemple PowerShell (générique) :
```powershell
$base = '<BASE_URL>' # ex: 'http://127.0.0.1/mylabo_api'
$body = @{ nom = '<NIVEAU_NOM.Prenom>'; email = '<email@example.com>'; password = '<password>' }
Invoke-RestMethod -Uri "$($base)/register.php" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```

9) Dépannage rapide
- "Failed to fetch" : vérifiez que le serveur local est démarré et que `apiBaseUrl` est correct.
- "Utilisateur non trouvé" : vérifiez le format du nom dans la base (espaces, underscore, point) et adaptez l'`identifier` envoyé.
- Erreurs Flutter : lancez `flutter analyze` puis corrigez les fichiers signalés.

10) Vérifications finales
- Emplacement des fichiers importants :
  - Guide pédagogique : `docs/GUIDE.md`
  - Setup : `docs/SETUP.md`
  - API : `docs/API.md`
  - Schéma SQL : `docs/SQL_SCHEMA.md`
  - Exemples PHP : `server-samples/mylabo_api/` (à copier dans le web root)

Suivez chaque étape lentement et testez après chaque action. Si vous voulez, je peux lancer `flutter analyze` et `flutter test` maintenant et vous partager les résultats.
