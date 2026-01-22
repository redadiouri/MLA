# Installation et configuration (simple)

1) Installer Laragon (https://laragon.org) — utiliser l'installation par défaut.

2) Copier les scripts PHP dans le dossier web de Laragon :

   - Emplacement par défaut : `C:\laragon\www\mylabo_api` (ou `%LARAGON_ROOT%\www\mylabo_api` si vous avez changé le dossier d'installation).
   - Si le dossier `server-samples/mylabo_api` existe dans le projet, copier tout le contenu dans ce dossier.

3) Créer la base de données MySQL :

   - Ouvrir `http://localhost/phpmyadmin` (Laragon) ou utiliser MySQL en ligne de commande.
   - Créer une base `mylaboipi` (ou importer le fichier SQL fourni dans `docs/SQL_SCHEMA.md`).

4) Vérifier les identifiants MySQL dans les scripts PHP (par défaut Laragon utilise `root` sans mot de passe). Si vous changez ces paramètres, mettez à jour les fichiers PHP.

5) Vérifier `lib/config.dart` dans Flutter :

   - Pour exécuter l'app dans le navigateur ou desktop, mettre `apiBaseUrl = 'http://127.0.0.1/mylabo_api'`.
   - Pour émulateur Android (Android Studio), mettre `apiBaseUrl = 'http://10.0.2.2/mylabo_api'`.

6) Démarrer Laragon (Start All) puis lancer l'application Flutter :

```powershell
# Assurez-vous d'être dans le dossier racine du projet
cd "<PATH_TO_PROJECT>/MyLaboAccess-main"
flutter pub get
flutter run -d chrome
```

7) Tester rapidement un endpoint (PowerShell exemple générique) :

```powershell
# Remplacez <BASE_URL> par l'URL de votre API locale, ex: 'http://127.0.0.1/mylabo_api'
$base = '<BASE_URL>'
$body = @{ nom = '<NIVEAU_NOM.Prenom>'; email = '<email@example.com>'; password = '<password>' }
Invoke-RestMethod -Uri "$($base)/register.php" -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'
```
