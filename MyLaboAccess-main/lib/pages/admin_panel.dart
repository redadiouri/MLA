import 'package:flutter/material.dart';
import '../models/user.dart';

/// Page de contrôle administrateur
///
/// Cette page permet à l'administrateur de gérer :
/// - Les utilisateurs (liste, ajout, suppression, modification de rôles)
/// - Le matériel (inventaire, ajout, modification, suppression)
/// - Les signalements (consultation, traitement, archivage)
/// - Les statistiques (emprunts, retours, utilisateurs actifs)
/// - Les paramètres système
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  // Données mockées pour le frontend (seront remplacées par des appels API)
  final List<Map<String, dynamic>> _users = [
    {'id': 1, 'nom': 'B2ipi_ADMIN.System', 'email': 'admin@mylabo.com', 'role': 'admin', 'actif': true, 'dateInscription': '2025-01-15'},
    {'id': 2, 'nom': 'B2ipi_DIOURI.Reda', 'email': 'reda@example.com', 'role': 'utilisateur', 'actif': true, 'dateInscription': '2025-02-20'},
    {'id': 3, 'nom': 'B2ipi_MARTIN.Sophie', 'email': 'sophie@example.com', 'role': 'utilisateur', 'actif': true, 'dateInscription': '2025-03-10'},
    {'id': 4, 'nom': 'B2ipi_BERNARD.Luc', 'email': 'luc@example.com', 'role': 'utilisateur', 'actif': false, 'dateInscription': '2025-01-25'},
  ];

  final List<Map<String, dynamic>> _equipment = [
    {'id': 1, 'nom': 'Écrans', 'quantiteTotal': 15, 'quantiteDispo': 8, 'quantiteEmprunte': 7, 'etat': 'Bon'},
    {'id': 2, 'nom': 'Routeurs', 'quantiteTotal': 8, 'quantiteDispo': 5, 'quantiteEmprunte': 3, 'etat': 'Bon'},
    {'id': 3, 'nom': 'Switches', 'quantiteTotal': 12, 'quantiteDispo': 9, 'quantiteEmprunte': 3, 'etat': 'Moyen'},
    {'id': 4, 'nom': 'Serveurs', 'quantiteTotal': 4, 'quantiteDispo': 2, 'quantiteEmprunte': 2, 'etat': 'Bon'},
    {'id': 5, 'nom': 'Câbles réseau', 'quantiteTotal': 150, 'quantiteDispo': 120, 'quantiteEmprunte': 30, 'etat': 'Bon'},
    {'id': 6, 'nom': 'Points d\'accès WiFi', 'quantiteTotal': 6, 'quantiteDispo': 4, 'quantiteEmprunte': 2, 'etat': 'Bon'},
  ];

  final List<Map<String, dynamic>> _reports = [
    {'id': 1, 'utilisateur': 'reda@example.com', 'materiel': 'Écrans', 'quantite': 2, 'description': 'Écran cassé coin inférieur droit', 'date': '2025-11-20', 'statut': 'En attente', 'priorite': 'Haute'},
    {'id': 2, 'utilisateur': 'sophie@example.com', 'materiel': 'Switches', 'quantite': 1, 'description': 'Port Ethernet ne fonctionne plus', 'date': '2025-11-22', 'statut': 'En cours', 'priorite': 'Moyenne'},
    {'id': 3, 'utilisateur': 'luc@example.com', 'materiel': 'Routeurs', 'quantite': 1, 'description': 'LED ne s\'allume plus', 'date': '2025-11-18', 'statut': 'Résolu', 'priorite': 'Basse'},
    {'id': 4, 'utilisateur': 'reda@example.com', 'materiel': 'Câbles réseau', 'quantite': 5, 'description': 'Câbles abîmés, connecteurs cassés', 'date': '2025-11-23', 'statut': 'En attente', 'priorite': 'Haute'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments;
    String userEmail = '';
    UserRole? role;
    if (user != null && user is User) {
      userEmail = user.email;
      role = user.role;
    }

    // Vérification des droits admin
    if (role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Accès refusé'),
          backgroundColor: Colors.redAccent.shade700,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: 80, color: Colors.redAccent.shade700),
              const SizedBox(height: 24),
              const Text(
                'Accès réservé aux administrateurs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Panneau Administrateur', style: TextStyle(fontFamily: 'Roboto', fontSize: 22, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.redAccent.shade700,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Actualiser',
            onPressed: () {
              setState(() {
                // Rafraîchir les données (appel API futur)
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Données actualisées'), duration: Duration(seconds: 2)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Déconnexion',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Tableau de bord'),
            Tab(icon: Icon(Icons.people), text: 'Utilisateurs'),
            Tab(icon: Icon(Icons.inventory), text: 'Matériel'),
            Tab(icon: Icon(Icons.report_problem), text: 'Signalements'),
            Tab(icon: Icon(Icons.settings), text: 'Paramètres'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboard(),
          _buildUsersManagement(),
          _buildEquipmentManagement(),
          _buildReportsManagement(),
          _buildSettings(),
        ],
      ),
    );
  }

  // ==================== TABLEAU DE BORD ====================
  Widget _buildDashboard() {
    // Calculs de statistiques
    final totalUsers = _users.length;
    final activeUsers = _users.where((u) => u['actif'] == true).length;
    final totalEquipment = _equipment.fold<int>(0, (sum, eq) => sum + (eq['quantiteTotal'] as int));
    final borrowedEquipment = _equipment.fold<int>(0, (sum, eq) => sum + (eq['quantiteEmprunte'] as int));
    final pendingReports = _reports.where((r) => r['statut'] == 'En attente').length;
    final highPriorityReports = _reports.where((r) => r['priorite'] == 'Haute' && r['statut'] != 'Résolu').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vue d\'ensemble',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Cartes statistiques
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Utilisateurs actifs', '$activeUsers / $totalUsers', Icons.people, Colors.blue),
              _buildStatCard('Matériel emprunté', '$borrowedEquipment / $totalEquipment', Icons.shopping_cart, Colors.orange),
              _buildStatCard('Signalements en attente', '$pendingReports', Icons.warning_amber, Colors.red),
              _buildStatCard('Priorité haute', '$highPriorityReports', Icons.priority_high, Colors.purple),
            ],
          ),
          const SizedBox(height: 32),
          // Graphiques et activités récentes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Matériel le plus emprunté', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ..._equipment.map((eq) {
                          final borrowed = eq['quantiteEmprunte'] as int;
                          final total = eq['quantiteTotal'] as int;
                          final percent = (borrowed / total * 100).toStringAsFixed(0);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(eq['nom'], style: const TextStyle(fontWeight: FontWeight.w500)),
                                    Text('$borrowed / $total ($percent%)', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: borrowed / total,
                                  backgroundColor: Colors.grey[300],
                                  color: borrowed / total > 0.7 ? Colors.red : Colors.green,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Activités récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildActivityItem(Icons.person_add, 'Nouvel utilisateur', 'B2ipi_MARTIN.Sophie', '10/03/2025'),
                        _buildActivityItem(Icons.report_problem, 'Signalement', 'Câbles abîmés', '23/11/2025'),
                        _buildActivityItem(Icons.check_circle, 'Signalement résolu', 'Routeur LED', '18/11/2025'),
                        _buildActivityItem(Icons.add_box, 'Matériel ajouté', '+10 Câbles réseau', '15/11/2025'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.redAccent.shade100,
            child: Icon(icon, size: 20, color: Colors.redAccent.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // ==================== GESTION UTILISATEURS ====================
  Widget _buildUsersManagement() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un utilisateur...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    // Filtrer les utilisateurs (à implémenter)
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _showAddUserDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Ajouter utilisateur'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Rôle', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Inscription', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _users.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${user['id']}')),
                      DataCell(Text(user['nom'])),
                      DataCell(Text(user['email'])),
                      DataCell(_buildRoleBadge(user['role'])),
                      DataCell(_buildStatusBadge(user['actif'])),
                      DataCell(Text(user['dateInscription'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Modifier',
                            onPressed: () => _showEditUserDialog(user),
                          ),
                          IconButton(
                            icon: Icon(user['actif'] ? Icons.block : Icons.check_circle, color: user['actif'] ? Colors.orange : Colors.green),
                            tooltip: user['actif'] ? 'Désactiver' : 'Activer',
                            onPressed: () => _toggleUserStatus(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Supprimer',
                            onPressed: () => _deleteUser(user),
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    switch (role) {
      case 'admin':
        color = Colors.red;
        break;
      case 'utilisateur':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(role, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildStatusBadge(bool actif) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: actif ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: actif ? Colors.green : Colors.red),
      ),
      child: Text(
        actif ? 'Actif' : 'Inactif',
        style: TextStyle(color: actif ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  void _showAddUserDialog() {
    final nomController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'utilisateur';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ajouter un utilisateur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Niveau_NOM.Prenom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'utilisateur', child: Text('Utilisateur')),
                    DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                    DropdownMenuItem(value: 'invite', child: Text('Invité')),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Appel API pour ajouter l'utilisateur
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Utilisateur ajouté avec succès')),
                );
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    final nomController = TextEditingController(text: user['nom']);
    final emailController = TextEditingController(text: user['email']);
    String selectedRole = user['role'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Modifier l\'utilisateur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'utilisateur', child: Text('Utilisateur')),
                    DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                    DropdownMenuItem(value: 'invite', child: Text('Invité')),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Appel API pour modifier l'utilisateur
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Utilisateur modifié avec succès')),
                );
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['actif'] = !user['actif'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utilisateur ${user['actif'] ? 'activé' : 'désactivé'}')),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer l\'utilisateur ${user['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.remove(user);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utilisateur supprimé')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  // ==================== GESTION MATÉRIEL ====================
  Widget _buildEquipmentManagement() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher du matériel...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _showAddEquipmentDialog,
                icon: const Icon(Icons.add_box),
                label: const Text('Ajouter matériel'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Disponible', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Emprunté', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('État', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _equipment.map((eq) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${eq['id']}')),
                      DataCell(Text(eq['nom'])),
                      DataCell(Text('${eq['quantiteTotal']}')),
                      DataCell(Text('${eq['quantiteDispo']}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                      DataCell(Text('${eq['quantiteEmprunte']}', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                      DataCell(_buildEquipmentStateBadge(eq['etat'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Modifier',
                            onPressed: () => _showEditEquipmentDialog(eq),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            tooltip: 'Ajouter stock',
                            onPressed: () => _showAdjustStockDialog(eq, true),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.orange),
                            tooltip: 'Retirer stock',
                            onPressed: () => _showAdjustStockDialog(eq, false),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Supprimer',
                            onPressed: () => _deleteEquipment(eq),
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentStateBadge(String etat) {
    Color color;
    switch (etat) {
      case 'Bon':
        color = Colors.green;
        break;
      case 'Moyen':
        color = Colors.orange;
        break;
      case 'Mauvais':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(etat, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  void _showAddEquipmentDialog() {
    final nomController = TextEditingController();
    final quantiteController = TextEditingController();
    String selectedEtat = 'Bon';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Ajouter du matériel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du matériel',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantiteController,
                  decoration: const InputDecoration(
                    labelText: 'Quantité',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedEtat,
                  decoration: const InputDecoration(
                    labelText: 'État',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Bon', child: Text('Bon')),
                    DropdownMenuItem(value: 'Moyen', child: Text('Moyen')),
                    DropdownMenuItem(value: 'Mauvais', child: Text('Mauvais')),
                  ],
                  onChanged: (value) => setState(() => selectedEtat = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Appel API pour ajouter le matériel
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Matériel ajouté avec succès')),
                );
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEquipmentDialog(Map<String, dynamic> eq) {
    final nomController = TextEditingController(text: eq['nom']);
    String selectedEtat = eq['etat'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Modifier le matériel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du matériel',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedEtat,
                  decoration: const InputDecoration(
                    labelText: 'État',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Bon', child: Text('Bon')),
                    DropdownMenuItem(value: 'Moyen', child: Text('Moyen')),
                    DropdownMenuItem(value: 'Mauvais', child: Text('Mauvais')),
                  ],
                  onChanged: (value) => setState(() => selectedEtat = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Appel API pour modifier le matériel
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Matériel modifié avec succès')),
                );
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdjustStockDialog(Map<String, dynamic> eq, bool isAdding) {
    final quantiteController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAdding ? 'Ajouter au stock' : 'Retirer du stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${eq['nom']} - Quantité actuelle: ${eq['quantiteTotal']}'),
            const SizedBox(height: 16),
            TextField(
              controller: quantiteController,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(quantiteController.text) ?? 0;
              setState(() {
                if (isAdding) {
                  eq['quantiteTotal'] += qty;
                  eq['quantiteDispo'] += qty;
                } else {
                  eq['quantiteTotal'] -= qty;
                  eq['quantiteDispo'] -= qty;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stock ${isAdding ? 'ajouté' : 'retiré'} avec succès')),
              );
            },
            child: Text(isAdding ? 'Ajouter' : 'Retirer'),
          ),
        ],
      ),
    );
  }

  void _deleteEquipment(Map<String, dynamic> eq) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer ${eq['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _equipment.remove(eq);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Matériel supprimé')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  // ==================== GESTION SIGNALEMENTS ====================
  Widget _buildReportsManagement() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un signalement...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Tous', label: Text('Tous')),
                  ButtonSegment(value: 'En attente', label: Text('En attente')),
                  ButtonSegment(value: 'En cours', label: Text('En cours')),
                  ButtonSegment(value: 'Résolu', label: Text('Résolus')),
                ],
                selected: {'Tous'},
                onSelectionChanged: (Set<String> selection) {
                  // Filtrer les signalements
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Utilisateur', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Matériel', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Quantité', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Priorité', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _reports.map((report) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${report['id']}')),
                      DataCell(Text(report['utilisateur'])),
                      DataCell(Text(report['materiel'])),
                      DataCell(Text('${report['quantite']}')),
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(
                            report['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(report['date'])),
                      DataCell(_buildPriorityBadge(report['priorite'])),
                      DataCell(_buildReportStatusBadge(report['statut'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, color: Colors.blue),
                            tooltip: 'Voir détails',
                            onPressed: () => _showReportDetails(report),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Marquer résolu',
                            onPressed: () => _markReportResolved(report),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Supprimer',
                            onPressed: () => _deleteReport(report),
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(String priorite) {
    Color color;
    switch (priorite) {
      case 'Haute':
        color = Colors.red;
        break;
      case 'Moyenne':
        color = Colors.orange;
        break;
      case 'Basse':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(priorite, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildReportStatusBadge(String statut) {
    Color color;
    switch (statut) {
      case 'En attente':
        color = Colors.orange;
        break;
      case 'En cours':
        color = Colors.blue;
        break;
      case 'Résolu':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(statut, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Signalement #${report['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Utilisateur', report['utilisateur']),
              _buildDetailRow('Matériel', report['materiel']),
              _buildDetailRow('Quantité', '${report['quantite']}'),
              _buildDetailRow('Date', report['date']),
              _buildDetailRow('Priorité', report['priorite']),
              _buildDetailRow('Statut', report['statut']),
              const SizedBox(height: 12),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(report['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (report['statut'] != 'Résolu')
            ElevatedButton(
              onPressed: () {
                _markReportResolved(report);
                Navigator.pop(context);
              },
              child: const Text('Marquer résolu'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _markReportResolved(Map<String, dynamic> report) {
    setState(() {
      report['statut'] = 'Résolu';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signalement marqué comme résolu')),
    );
  }

  void _deleteReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer le signalement #${report['id']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _reports.remove(report);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signalement supprimé')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  // ==================== PARAMÈTRES ====================
  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paramètres système',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildSettingsCard(
            'Notifications',
            Icons.notifications,
            [
              _buildSettingsSwitch('Activer les notifications par email', true),
              _buildSettingsSwitch('Notifications pour nouveaux signalements', true),
              _buildSettingsSwitch('Notifications pour stock faible', true),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'Sécurité',
            Icons.security,
            [
              _buildSettingsSwitch('Authentification à deux facteurs', false),
              _buildSettingsSwitch('Déconnexion automatique (30 min)', true),
              ListTile(
                title: const Text('Changer le mot de passe admin'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Dialog pour changer le mot de passe
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'Base de données',
            Icons.storage,
            [
              ListTile(
                title: const Text('Sauvegarder la base de données'),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sauvegarde en cours...')),
                    );
                  },
                  icon: const Icon(Icons.backup),
                  label: const Text('Sauvegarder'),
                ),
              ),
              ListTile(
                title: const Text('Restaurer depuis une sauvegarde'),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    // Dialog pour restaurer
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Restaurer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'Maintenance',
            Icons.build,
            [
              ListTile(
                title: const Text('Nettoyer les logs anciens'),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logs nettoyés')),
                    );
                  },
                  child: const Text('Nettoyer'),
                ),
              ),
              ListTile(
                title: const Text('Réinitialiser les statistiques'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Confirmation dialog
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Réinitialiser'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            'À propos',
            Icons.info,
            [
              const ListTile(
                title: Text('Version de l\'application'),
                trailing: Text('1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const ListTile(
                title: Text('Développé par'),
                trailing: Text('Équipe B2 IPI', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Voir les logs système'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Afficher les logs
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.redAccent.shade700),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSwitch(String title, bool initialValue) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool value = initialValue;
        return SwitchListTile(
          title: Text(title),
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
        );
      },
    );
  }
}
