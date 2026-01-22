import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

/// ApiService centralise les appels réseau vers le backend PHP.
///
/// - Utiliser `ApiService.login(identifier, password)` pour la connexion.
/// - Utiliser `ApiService.register(...)` pour l'inscription.
/// - Utiliser `ApiService.sendReport(...)` pour poster un signalement.
class ApiService {
  /// Essaye plusieurs variantes d'URL (127.0.0.1 / localhost / 10.0.2.2)
  /// afin de réduire les erreurs lors du développement local.
  static Future<Map<String, dynamic>> _postWithFallback(String path, Map<String, dynamic> payload) async {
    final variants = <String>[apiBaseUrl];
    if (apiBaseUrl.contains('127.0.0.1')) {
      variants.add(apiBaseUrl.replaceFirst('127.0.0.1', 'localhost'));
      variants.add(apiBaseUrl.replaceFirst('127.0.0.1', '10.0.2.2'));
    } else if (apiBaseUrl.contains('localhost')) {
      variants.add(apiBaseUrl.replaceFirst('localhost', '127.0.0.1'));
      variants.add(apiBaseUrl.replaceFirst('localhost', '10.0.2.2'));
    } else {
      variants.add(apiBaseUrl.replaceAll(RegExp(r'https?://'), 'http://127.0.0.1'));
      variants.add(apiBaseUrl.replaceAll(RegExp(r'https?://'), 'http://localhost'));
    }

    Exception? lastEx;
    for (final base in variants) {
      final url = Uri.parse('$base$path');
      try {
        final response = await http
            .post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload))
            .timeout(const Duration(seconds: 8));
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body;
      } catch (e) {
        lastEx = e as Exception?;
        // essayer la variante suivante
      }
    }
    return {
      'success': false,
      'message': 'Impossible de joindre le serveur. Vérifiez Laragon/Apache et l’URL ${apiBaseUrl + path}. Détail: ${lastEx ?? 'erreur inconnue'}'
    };
  }

  /// Appel pour l'inscription
  static Future<Map<String, dynamic>> register(String email, String nom, String role, String password) async {
    return await _postWithFallback('/register.php', {
      'email': email,
      'nom': nom,
      'role': role,
      'password': password,
    });
  }

  /// Appel pour la connexion (identifiant = email ou nom)
  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    return await _postWithFallback('/login.php', {'identifier': identifier, 'password': password});
  }

  /// Envoie un signalement au backend.
  static Future<Map<String, dynamic>> sendReport(String userEmail, String equipment, int quantity, String description) async {
    return await _postWithFallback('/report.php', {
      'user_email': userEmail,
      'equipment_name': equipment,
      'quantity': quantity,
      'description': description,
    });
  }

  /// Supprime le compte utilisateur après vérification du mot de passe.
  /// L'identifiant peut être l'email ou le nom (format Niveau_NOM.Prenom).
  static Future<Map<String, dynamic>> deleteAccount(String identifier, String password) async {
    return await _postWithFallback('/delete.php', {'identifier': identifier, 'password': password});
  }
}
