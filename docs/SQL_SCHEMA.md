# Schéma SQL minimal

Utilisez ce fichier pour créer les tables `users` et `reports` dans la base `mylaboipi`.

```sql
CREATE DATABASE IF NOT EXISTS `mylaboipi` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `mylaboipi`;

CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `nom` VARCHAR(200) NOT NULL,
  `email` VARCHAR(200),
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `reports` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `contenu` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Exemple d'import : sauvegarder ce fichier et l'importer via phpMyAdmin ou mysql CLI
```
