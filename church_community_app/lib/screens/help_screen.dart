import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Help Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Constants.primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 64,
                    color: Constants.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Comment pouvons-nous vous aider ?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trouvez des réponses à vos questions',
                    style: TextStyle(
                      color: Constants.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Contact Support Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Contacter le support',
                onPressed: () {
                  // TODO: Implement contact support functionality
                },
                icon: Icons.email_outlined,
              ),
            ),
            // FAQs
            _buildSection(
              title: 'Questions fréquentes',
              items: [
                _FAQItem(
                  question: 'Comment modifier mes informations de profil ?',
                  answer: 'Accédez à votre profil en appuyant sur l\'onglet "Profil", '
                      'puis appuyez sur "Modifier le profil". Vous pourrez alors '
                      'modifier vos informations personnelles.',
                ),
                _FAQItem(
                  question: 'Comment m\'inscrire à un événement ?',
                  answer: 'Dans l\'onglet "Événements", sélectionnez l\'événement '
                      'qui vous intéresse et appuyez sur le bouton "S\'inscrire". '
                      'Vous recevrez une confirmation par email.',
                ),
                _FAQItem(
                  question: 'Comment gérer mes notifications ?',
                  answer: 'Dans les paramètres de votre profil, appuyez sur '
                      '"Notifications" pour personnaliser vos préférences de '
                      'notification selon vos besoins.',
                ),
                _FAQItem(
                  question: 'Comment rejoindre un groupe ?',
                  answer: 'Consultez la liste des groupes disponibles dans la '
                      'section "Groupes" et appuyez sur "Rejoindre" pour le '
                      'groupe qui vous intéresse.',
                ),
                _FAQItem(
                  question: 'Comment faire un don ?',
                  answer: 'Dans la section "Mes Dons" de votre profil, appuyez '
                      'sur "Faire un don" et suivez les instructions pour '
                      'effectuer votre contribution en toute sécurité.',
                ),
              ],
            ),
            // Help Categories
            _buildSection(
              title: 'Catégories d\'aide',
              items: [
                _HelpCategoryItem(
                  icon: Icons.person,
                  title: 'Compte et profil',
                  onTap: () {
                    // TODO: Navigate to account help section
                  },
                ),
                _HelpCategoryItem(
                  icon: Icons.event,
                  title: 'Événements',
                  onTap: () {
                    // TODO: Navigate to events help section
                  },
                ),
                _HelpCategoryItem(
                  icon: Icons.group,
                  title: 'Groupes et communauté',
                  onTap: () {
                    // TODO: Navigate to groups help section
                  },
                ),
                _HelpCategoryItem(
                  icon: Icons.volunteer_activism,
                  title: 'Dons et contributions',
                  onTap: () {
                    // TODO: Navigate to donations help section
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Support Contact
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Besoin d\'aide supplémentaire ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notre équipe de support est disponible pour vous aider',
                    style: TextStyle(
                      color: Constants.textColor.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () {
                          // TODO: Launch email client
                        },
                      ),
                      _buildContactButton(
                        icon: Icons.phone,
                        label: 'Téléphone',
                        onTap: () {
                          // TODO: Launch phone dialer
                        },
                      ),
                      _buildContactButton(
                        icon: Icons.chat_bubble,
                        label: 'Chat',
                        onTap: () {
                          // TODO: Open chat support
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Constants.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: Constants.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpCategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HelpCategoryItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Constants.primaryColor,
        ),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
