import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final UserService _userService = UserService();
  late UserPreferences _preferences;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _preferences = _userService.currentUser!.preferences;
  }

  Future<void> _updatePreferences(UserPreferences newPreferences) async {
    setState(() => _isLoading = true);
    try {
      final success = await _userService.updatePreferences(newPreferences);
      if (mounted) {
        if (success) {
          setState(() => _preferences = newPreferences);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Préférences mises à jour'),
              backgroundColor: Constants.successColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la mise à jour des préférences'),
              backgroundColor: Constants.errorColor,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Constants.textColor.withOpacity(0.6),
        ),
      ),
      value: value,
      onChanged: _isLoading ? null : onChanged,
      activeColor: Constants.primaryColor,
    );
  }

  Widget _buildTimePickerTile({
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Constants.textColor.withOpacity(0.6),
        ),
      ),
      trailing: TextButton(
        onPressed: _isLoading
            ? null
            : () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (newTime != null) {
                  onChanged(newTime);
                }
              },
        child: Text(
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildSection(
                    title: 'Notifications générales',
                    children: [
                      _buildSwitchTile(
                        title: 'Notifications push',
                        subtitle: 'Recevoir des notifications sur votre appareil',
                        value: _preferences.notificationsEnabled,
                        onChanged: (value) {
                          _updatePreferences(
                            _preferences.copyWith(notificationsEnabled: value),
                          );
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Notifications par email',
                        subtitle: 'Recevoir des notifications par email',
                        value: _preferences.emailNotificationsEnabled,
                        onChanged: (value) {
                          _updatePreferences(
                            _preferences.copyWith(
                              emailNotificationsEnabled: value,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Mode silencieux',
                    children: [
                      _buildSwitchTile(
                        title: 'Heures silencieuses',
                        subtitle:
                            'Ne pas recevoir de notifications pendant certaines heures',
                        value: _preferences.quietHoursEnabled,
                        onChanged: (value) {
                          _updatePreferences(
                            _preferences.copyWith(quietHoursEnabled: value),
                          );
                        },
                      ),
                      if (_preferences.quietHoursEnabled) ...[
                        _buildTimePickerTile(
                          title: 'Début',
                          subtitle: 'Heure de début du mode silencieux',
                          time: _preferences.quietHoursStart,
                          onChanged: (time) {
                            _updatePreferences(
                              _preferences.copyWith(quietHoursStart: time),
                            );
                          },
                        ),
                        _buildTimePickerTile(
                          title: 'Fin',
                          subtitle: 'Heure de fin du mode silencieux',
                          time: _preferences.quietHoursEnd,
                          onChanged: (time) {
                            _updatePreferences(
                              _preferences.copyWith(quietHoursEnd: time),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(Constants.defaultPadding),
                    child: Text(
                      'Les notifications importantes peuvent toujours être envoyées pendant les heures silencieuses.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
