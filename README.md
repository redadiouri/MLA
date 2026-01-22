# MyLaboAccess

Application de gestion d'emprunt de matériel informatique pour laboratoire avec système d'administration complet.

## Ressources dans ce dépôt :

- `lib/` : code Flutter
- `server-samples/mylabo_api/` : exemples PHP (à copier dans le dossier WWW Laragon)
- `docs/` : guides d'installation, API et schéma SQL (fichiers simples)

Démarrage rapide (développement)

1. Ouvrir le projet dans VS Code :
   ```powershell
   # Remplacez <PATH_TO_PROJECT> par le chemin où vous avez cloné le dépôt
   cd "<PATH_TO_PROJECT>/MyLaboAccess-main"
   code .
   ```
2. Installer les dépendances Flutter :
   ```powershell
   flutter pub get
   ```
3. Démarrer l'API PHP locale avec Laragon : copier le contenue `server-samples/mylabo_api` du dépôt dans le dossier web de Laragon (par défaut `C:\laragon\www\mylabo_api`) puis démarrer Laragon (Apache + MySQL).
4. Vérifier `lib/config.dart` : mettre `apiBaseUrl` à `http://127.0.0.1/mylabo_api` (web/desktop) ou `http://10.0.2.2/mylabo_api` (émulateur Android). Vous pouvez aussi utiliser un placeholder `'<BASE_URL>'` dans vos tests.
5. Lancer l'app :
   ```powershell
   flutter run -d chrome
   ```

Docs utiles :
- `docs/SETUP.md` : configuration Laragon / base de données
- `docs/API.md` : endpoints et exemples simples (PowerShell)
- `docs/SQL_SCHEMA.md` : schéma SQL minimal à importer


---
Note : le guide pas-à-pas a été déplacé vers `docs/GUIDE.md`.

## Fonctionnalités principales

### 🔐 Système d'authentification
- **Connexion** : email/mot de passe avec validation backend
- **Inscription** : format normalisé `Niveau_NOM.Prenom` (ex: `B2ipi_DIOURI.Reda`)
- **Mode invité** : accès en lecture seule sans inscription
- **3 niveaux de rôles** : Admin, Utilisateur, Invité

### 📦 Gestion du matériel
- Inventaire en temps réel : écrans, routeurs, switches, serveurs, câbles, points d'accès WiFi
- Suivi des quantités disponibles et empruntées
- Interface visuelle avec icônes et badges colorés
- Système d'emprunt/retour (en développement)

### ⚠️ Signalement de dégradations
- Formulaire de signalement pour matériel endommagé
- Sélection du matériel, quantité et description
- Envoi vers backend via API REST

### 👨‍💼 Panneau d'administration (NOUVEAU)

**Accès réservé aux administrateurs** - `lib/pages/admin_panel.dart`

Le panneau admin offre une interface complète de gestion avec 5 sections principales :

#### 1. 📊 **Tableau de bord**
- **Statistiques en temps réel** :
  - Utilisateurs actifs / total
  - Matériel emprunté / disponible
  - Signalements en attente
  - Alertes priorité haute
- **Graphiques de suivi** : barres de progression par type de matériel
- **Fil d'activités récentes** : nouveaux utilisateurs, signalements, ajouts de matériel
- **Vue d'ensemble visuelle** avec cartes colorées et icônes

#### 2. 👥 **Gestion des utilisateurs**
- **Tableau complet** : ID, nom, email, rôle, statut (actif/inactif), date d'inscription
- **Actions CRUD** :
  - ➕ Ajouter un utilisateur (formulaire avec validation)
  - ✏️ Modifier les informations (nom, email, rôle)
  - 🔄 Activer/Désactiver un compte utilisateur
  - ❌ Supprimer un compte (avec confirmation)
- **Recherche** dynamique d'utilisateurs
- **Badges visuels** pour les rôles (admin/utilisateur/invité) et statuts

#### 3. 📦 **Gestion du matériel**
- **Inventaire détaillé** : quantité totale, disponible, empruntée, état
- **Actions** :
  - ➕ Ajouter nouveau matériel au catalogue
  - ✏️ Modifier les informations (nom, état)
  - 📈 Ajouter au stock (réapprovisionnement)
  - 📉 Retirer du stock (matériel hors service)
  - ❌ Supprimer un équipement du système
- **Badges d'état** : Bon (vert), Moyen (orange), Mauvais (rouge)
- **Recherche** de matériel

#### 4. ⚠️ **Gestion des signalements**
- **Tableau complet** : utilisateur, matériel concerné, quantité, description détaillée, date, priorité, statut
- **Filtres** : Tous / En attente / En cours / Résolus
- **Actions** :
  - 👁️ Voir les détails complets d'un signalement
  - ✅ Marquer comme résolu
  - ❌ Supprimer un signalement (archivage)
- **Badges de priorité** : Haute (rouge), Moyenne (orange), Basse (bleue)
- **Badges de statut** : En attente, En cours, Résolu

#### 5. ⚙️ **Paramètres système**
- **Notifications** :
  - Activer/désactiver les notifications par email
  - Alertes pour nouveaux signalements
  - Alertes pour stock faible
- **Sécurité** :
  - Authentification à deux facteurs (2FA)
  - Déconnexion automatique (timeout configurable)
  - Changement de mot de passe administrateur
- **Base de données** :
  - Sauvegarde complète de la BDD
  - Restauration depuis une sauvegarde
- **Maintenance** :
  - Nettoyage des logs anciens
  - Réinitialisation des statistiques
- **Informations** :
  - Version de l'application
  - Équipe de développement
  - Logs système

#### 🔐 **Accès au panneau admin**

**Méthode temporaire (développement)** :
1. S'inscrire avec un email contenant "admin" OU avec le mot de passe `admin123` 
2. Exemple : `admin@mylabo.com` / `admin123` , ensuite se connecter avec le meme mot de pase et email 
3. Une icône ⚙️ (engrenage rouge) apparaît dans l'AppBar
4. Cliquer sur l'icône pour accéder au panneau

**Sécurité** :
- Vérification automatique du rôle utilisateur
- Accès refusé avec message d'erreur si non-admin
- Toutes les actions sensibles nécessitent une confirmation

**Note** : Les données actuelles sont mockées (frontend uniquement). L'intégration backend sera ajoutée ultérieurement.

---

## Architecture technique

Arboressence : 

Flutter App (lib/)
├── main.dart (écran principal + inventaire)
├── config.dart (URL API configurable)
├── pages/
│   ├── login_page.dart (connexion/inscription)
│   ├── signup_page.dart
│   └── admin_panel.dart (🆕 panneau d'administration complet)
├── services/
│   └── api_service.dart (couche HTTP centralisée)
└── models/
    └── user.dart (modèle utilisateur avec rôles : admin, utilisateur, invité)

Backend PHP (server-samples/mylabo_api/)
├── register.php (inscription)
├── login.php (connexion)
├── report.php (signalements)
└── delete.php (suppression compte)