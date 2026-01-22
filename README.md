# 🏥 MyLaboAccess - Système de Gestion d'Emprunt de Matériel

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)]()
[![Status](https://img.shields.io/badge/Status-Active%20Development-orange)]()

**MyLaboAccess** est une application complète de gestion d'emprunt et de suivi de matériel informatique pour laboratoires et établissements éducatifs. Elle offre une interface intuitive aux utilisateurs et un panneau d'administration puissant pour les gestionnaires.

## 📋 Table des matières

- [🎯 Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture](#️-architecture)
- [🚀 Installation](#-installation)
- [⚙️ Configuration](#️-configuration)
- [📱 Usage](#-usage)
- [👨‍💻 Développement](#-développement)
- [📚 Documentation](#-documentation)
- [🤝 Contribution](#-contribution)
- [📄 License](#-license)

---

## 🎯 Fonctionnalités

### 🔐 Authentification & Sécurité
- ✅ Connexion/Inscription avec validation backend
- ✅ Système de rôles : Admin, Utilisateur, Invité
- ✅ Accès en mode invité (lecture seule)
- ✅ Format d'inscription normalisé : `Niveau_NOM.Prenom` (ex: `B2ipi_DIOURI.Reda`)
- ✅ Gestion sécurisée des sessions

### 📦 Gestion du Matériel
- ✅ Inventaire en temps réel avec filtrage dynamique
- ✅ Suivi précis des quantités (total, disponible, emprunté)
- ✅ Support de multiples catégories :
  - Écrans
  - Routeurs & Switches
  - Serveurs
  - Câbles & Connectiques
  - Points d'accès WiFi
  - Et plus...
- ✅ Badges d'état colorés (Bon, Moyen, Mauvais)
- ✅ Interface visuelle avec icônes et avatars

### 📤 Emprunt & Retour de Matériel
- ✅ Système d'emprunt simplifié
- ✅ Historique des emprunts
- ✅ Traçabilité complète
- ✅ Notifications de retour

### ⚠️ Signalement de Dégradations
- ✅ Formulaire de signalement intuitif
- ✅ Sélection du matériel et quantité
- ✅ Description détaillée des problèmes
- ✅ Priorisation automatique

### 👨‍💼 Panneau d'Administration Complet

#### 📊 **Tableau de Bord**
- Statistiques en temps réel
- Graphiques de suivi du stock
- Fil d'activités récentes
- Alertes et notifications

#### 👥 **Gestion des Utilisateurs**
- Tableau CRUD complet
- Ajouter/Modifier/Supprimer des utilisateurs
- Activer/Désactiver des comptes
- Attribution des rôles
- Recherche dynamique

#### 📦 **Gestion de l'Inventaire**
- Ajouter/Modifier/Supprimer du matériel
- Gérer le stock (réapprovisionnement)
- État du matériel
- Statistiques par catégorie

#### ⚠️ **Gestion des Signalements**
- Tableau complet des signalements
- Filtres (En attente, En cours, Résolus)
- Marquer comme résolu
- Priorités (Haute, Moyenne, Basse)

#### ⚙️ **Paramètres Système**
- Configuration des notifications
- Sécurité & 2FA
- Sauvegarde/Restauration BDD
- Gestion des logs
- Informations système

---

## 🏗️ Architecture

### Structure du Projet

```
MyLaboAccess/
├── lib/                                    # Code Flutter principal
│   ├── main.dart                          # Point d'entrée application
│   ├── config.dart                        # Configuration globale
│   ├── models/                            # Modèles de données
│   │   └── user.dart                      # Modèle utilisateur
│   ├── pages/                             # Interfaces utilisateur
│   │   ├── login_page.dart                # Connexion/Inscription
│   │   ├── signup_page.dart               # Formulaire d'inscription
│   │   └── admin_panel.dart               # Panneau d'administration
│   ├── services/                          # Couches métier
│   │   └── api_service.dart               # Requêtes HTTP
│   └── [autres fichiers]
├── server-samples/                        # API Backend PHP
│   └── mylabo_api/
│       ├── login.php                      # Endpoint connexion
│       ├── register.php                   # Endpoint inscription
│       ├── report.php                     # Endpoint signalement
│       └── delete.php                     # Endpoint suppression
├── docs/                                  # Documentation
│   ├── SETUP.md                          # Configuration système
│   ├── API.md                            # Documentation API
│   ├── GUIDE.md                          # Guide utilisateur
│   └── SQL_SCHEMA.md                     # Schéma base de données
├── android/                               # Configuration Android
├── ios/                                   # Configuration iOS
├── web/                                   # Web build
├── windows/                               # Desktop Windows
├── linux/                                 # Desktop Linux
└── pubspec.yaml                          # Dépendances Flutter
```

### Stack Technologique

**Frontend:**
- Flutter 3.0+
- Dart 3.0+
- HTTP client

**Backend:**
- PHP 7.4+
- MySQL 5.7+
- REST API

**Infrastructure:**
- Laragon (développement)
- Apache
- Git & GitHub

---

## 🚀 Installation

### Prérequis

- **Flutter** 3.0+ : [Installation](https://flutter.dev/docs/get-started/install)
- **Dart** 3.0+ : Inclus avec Flutter
- **PHP** 7.4+ : [Laragon](https://laragon.org/) recommandé
- **MySQL** 5.7+ : Inclus avec Laragon
- **Git** : [Installation](https://git-scm.com/)

### Étapes d'installation

#### 1️⃣ Cloner le dépôt

```bash
git clone https://github.com/redadiouri/MLA.git
cd MyLaboAccess-main
```

#### 2️⃣ Installer les dépendances Flutter

```bash
flutter pub get
```

#### 3️⃣ Configurer le Backend

1. Ouvrir Laragon
2. Copier le contenu de `server-samples/mylabo_api/` vers `C:\laragon\www\mylabo_api`
3. Importer le schéma SQL depuis `docs/SQL_SCHEMA.md` dans phpMyAdmin
4. Démarrer Apache et MySQL

#### 4️⃣ Configurer l'URL API

Éditer `lib/config.dart` :

```dart
// Web / Desktop
const String apiBaseUrl = 'http://127.0.0.1/mylabo_api';

// Android Émulateur
const String apiBaseUrl = 'http://10.0.2.2/mylabo_api';
```

#### 5️⃣ Lancer l'application

```bash
# Web
flutter run -d chrome

# Android
flutter run -d emulator-5554

# Windows Desktop
flutter run -d windows

# Linux Desktop
flutter run -d linux
```

---

## ⚙️ Configuration

### Variables d'Environnement

```dart
// lib/config.dart
class ApiConfig {
  static const String apiBaseUrl = 'http://127.0.0.1/mylabo_api';
  static const int timeoutDuration = 30; // secondes
  static const bool enableLogging = true;
}
```

### Accès Panneau Admin (Développement)

**Méthode temporaire :**

1. S'inscrire avec email contenant "admin" :
   - Email : `admin@mylabo.com`
   - Mot de passe : `admin123`

2. Se connecter avec les mêmes identifiants

3. Une icône ⚙️ rouge apparaît dans l'AppBar

4. Cliquer pour accéder au panneau

---

## 📱 Usage

### Pour les Utilisateurs

#### Connexion
```
1. Lancer l'application
2. Entrer email et mot de passe
3. Cliquer sur "Connexion"
```

#### Consultation du Matériel
```
1. Aller à "Inventaire"
2. Consulter les catégories
3. Voir les quantités disponibles
```

#### Emprunt de Matériel
```
1. Sélectionner le matériel
2. Indiquer la quantité
3. Confirmer l'emprunt
```

#### Signalement de Dégradation
```
1. Aller à "Signaler un problème"
2. Sélectionner le matériel endommagé
3. Décrire le problème
4. Envoyer le signalement
```

### Pour les Administrateurs

#### Gestion des Utilisateurs
```
1. Panneau Admin → Utilisateurs
2. Ajouter/Modifier/Supprimer
3. Gérer les rôles
```

#### Gestion du Stock
```
1. Panneau Admin → Inventaire
2. Ajouter nouveau matériel
3. Réapprovisionner le stock
4. Mettre à jour l'état
```

#### Traiter les Signalements
```
1. Panneau Admin → Signalements
2. Consulter les détails
3. Marquer comme résolu
```

---

## 👨‍💻 Développement

### Structure des Fichiers Clés

**`lib/services/api_service.dart`** - Requêtes HTTP centralisées
**`lib/models/user.dart`** - Modèle utilisateur avec rôles
**`lib/pages/admin_panel.dart`** - Interface admin complète
**`lib/config.dart`** - Configuration globale

### Ajouter une Nouvelle Fonctionnalité

1. Créer le modèle dans `lib/models/`
2. Ajouter les endpoints dans `lib/services/api_service.dart`
3. Créer la page UI dans `lib/pages/`
4. Intégrer dans `main.dart`

### Tester Localement

```bash
# Test unitaire
flutter test

# Lancer en mode debug
flutter run -d chrome --debug

# Build release
flutter build web --release
```

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [SETUP.md](docs/SETUP.md) | Configuration Laragon & Base de données |
| [API.md](docs/API.md) | Endpoints API avec exemples |
| [GUIDE.md](docs/GUIDE.md) | Guide complet utilisateur/admin |
| [SQL_SCHEMA.md](docs/SQL_SCHEMA.md) | Schéma SQL à importer |

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Veuillez suivre ces étapes :

1. **Fork** le dépôt
2. **Créer une branche** : `git checkout -b feature/AmazingFeature`
3. **Commiter** : `git commit -m 'Add AmazingFeature'`
4. **Pusher** : `git push origin feature/AmazingFeature`
5. **Ouvrir une Pull Request**

### Guide de Style

- Utiliser Dart linting standard
- Documenter les fonctions publiques
- Ajouter des tests pour les nouvelles features
- Respecter la structure des dossiers

---

## 📄 License

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

---

## 👥 Équipe

**Développement** : Reda DIOURI  
**Encadrement** : Équipe IPI  
**Institution** : IPI - Classe B2

---

## ️ Roadmap

### Phase 1 (Actuelle) ✅
- [x] Interface utilisateur principale
- [x] Authentification
- [x] Gestion du matériel
- [x] Panneau admin

### Phase 2 (À venir) 📅
- [ ] Système d'emprunt avancé
- [ ] Notifications push
- [ ] Rapports PDF
- [ ] Codes QR/RFID

### Phase 3 (Futur) 🔮
- [ ] App mobile native
- [ ] Synchronisation cloud
- [ ] API GraphQL
- [ ] Analytics avancées

---

## 📝 Changelog

**v1.0.0** - 22 Jan 2026
- Initial release
- Authentification fonctionnelle
- Inventaire complet
- Panneau admin

---

**Merci d'utiliser MyLaboAccess ! 🙏**
