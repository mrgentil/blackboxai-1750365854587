import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/theme_service.dart';
import '../../services/user_service.dart';
import '../../utils/constants.dart';
import '../../widgets/language_selection_dialog.dart';
import '../about_screen.dart';
import '../change_password_screen.dart';
import '../edit_profile_screen.dart';
import '../help_screen.dart';
import '../notification_settings_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final UserService _userService = UserService();
  final ThemeService _themeService = ThemeService();
  late ChurchUser _user;

  @override
  void initState() {
    super.initState();
    _user = _userService.currentUser!;
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Constants.primaryColor.withOpacity(0.2),
            backgroundImage: _user.profileImageUrl != null
                ? NetworkImage(_user.profileImageUrl!)
                : null,
            child: _user.profileImageUrl == null
                ? Text(
                    '${_user.firstName[0]}${_user.lastName[0]}',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Constants.primaryColor,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            '${_user.firstName} ${_user.lastName}',
            style: Constants.headingStyle,
          ),
          const SizedBox(height: 4),
          Text(
            _user.email,
            style: TextStyle(
              color: Constants.textColor.withOpacity(0.6),
            ),
          ),
          if (_user.phoneNumber != null) ...[
            const SizedBox(height: 4),
            Text(
              _user.phoneNumber!,
              style: TextStyle(
                color: Constants.textColor.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? Constants.primaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Constants.primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Constants.textColor.withOpacity(0.6),
              ),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: Constants.subtitleColor,
          ),
      onTap: onTap,
    );
  }

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

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Oui',
              style: TextStyle(color: Constants.errorColor),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _userService.logout();
      // TODO: Navigate to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            _buildSection(
              title: 'Compte',
              children: [
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Modifier le profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.lock,
                  title: 'Changer le mot de passe',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              title: 'Préférences',
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Langue',
                  subtitle: 'Français',
                  onTap: () {
                    LanguageSelectionDialog.show(
                      context: context,
                      currentLanguage: _user.preferences.language,
                      onLanguageSelected: (language) {
                        // TODO: Implement language change
                      },
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: _themeService.getThemeModeIcon(),
                  title: 'Thème',
                  subtitle: _themeService.getThemeModeName(),
                  onTap: () {
                    _themeService.toggleTheme();
                    setState(() {});
                  },
                ),
              ],
            ),
            _buildSection(
              title: 'Support',
              children: [
                _buildSettingsTile(
                  icon: Icons.help,
                  title: 'Aide',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'À propos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              title: 'Compte',
              children: [
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Se déconnecter',
                  iconColor: Constants.errorColor,
                  onTap: _handleLogout,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Text(
                'Version ${Constants.appVersion}',
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
