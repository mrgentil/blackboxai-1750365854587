import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Text(
            title,
            style: Constants.subheadingStyle,
          ),
        ),
        ...children,
        const SizedBox(height: Constants.defaultPadding),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.smallPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Constants.textColor.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
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
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Constants.textColor.withOpacity(0.6),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constants.largePadding),
              color: Constants.primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.church,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Constants.appName,
                    style: Constants.headingStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version ${Constants.appVersion}',
                    style: TextStyle(
                      color: Constants.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Church Information
            _buildSection(
              title: 'Notre église',
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding,
                  ),
                  child: Text(
                    'L\'Assemblée Chrétienne est une communauté vivante et accueillante, '
                    'dédiée à partager l\'amour de Dieu et à faire des disciples de Jésus-Christ.',
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  label: 'Fondée en',
                  value: '1990',
                ),
                _buildInfoRow(
                  label: 'Membres',
                  value: '500+',
                ),
                _buildInfoRow(
                  label: 'Pasteur principal',
                  value: 'Pr. David Martin',
                ),
              ],
            ),

            // Contact Information
            _buildSection(
              title: 'Nous contacter',
              children: [
                _buildContactItem(
                  icon: Icons.location_on,
                  title: 'Adresse',
                  subtitle: '123 Rue de l\'Église\n75000 Paris, France',
                  onTap: () {
                    // TODO: Open maps
                  },
                ),
                _buildContactItem(
                  icon: Icons.phone,
                  title: 'Téléphone',
                  subtitle: '+33 1 23 45 67 89',
                  onTap: () {
                    // TODO: Make phone call
                  },
                ),
                _buildContactItem(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'contact@assemblee-chretienne.org',
                  onTap: () {
                    // TODO: Send email
                  },
                ),
                _buildContactItem(
                  icon: Icons.web,
                  title: 'Site web',
                  subtitle: 'www.assemblee-chretienne.org',
                  onTap: () {
                    // TODO: Open website
                  },
                ),
              ],
            ),

            // Social Media
            _buildSection(
              title: 'Réseaux sociaux',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook),
                      onPressed: () {
                        // TODO: Open Facebook
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.youtube_searched_for),
                      onPressed: () {
                        // TODO: Open YouTube
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        // TODO: Open Instagram
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.music_note),
                      onPressed: () {
                        // TODO: Open TikTok
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Legal Information
            _buildSection(
              title: 'Informations légales',
              children: [
                CustomButton.secondary(
                  text: 'Conditions d\'utilisation',
                  onPressed: () {
                    // TODO: Show terms of service
                  },
                ),
                const SizedBox(height: 8),
                CustomButton.secondary(
                  text: 'Politique de confidentialité',
                  onPressed: () {
                    // TODO: Show privacy policy
                  },
                ),
                const SizedBox(height: 8),
                CustomButton.secondary(
                  text: 'Licences',
                  onPressed: () {
                    // TODO: Show licenses
                  },
                ),
              ],
            ),

            // Copyright
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Text(
                '© ${DateTime.now().year} Assemblée Chrétienne. Tous droits réservés.',
                style: TextStyle(
                  color: Constants.textColor.withOpacity(0.6),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
