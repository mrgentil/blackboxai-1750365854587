import 'package:flutter/material.dart';
import '../screens/tabs/events_tab.dart';
import '../screens/tabs/home_tab.dart';
import '../screens/tabs/messages_tab.dart';
import '../screens/tabs/notifications_tab.dart';
import '../screens/tabs/profile_tab.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final NotificationService _notificationService = NotificationService();

  final List<_TabItem> _tabs = [
    const _TabItem(
      icon: Icons.home,
      label: 'Accueil',
      screen: HomeTab(),
    ),
    const _TabItem(
      icon: Icons.event,
      label: 'Événements',
      screen: EventsTab(),
    ),
    const _TabItem(
      icon: Icons.message,
      label: 'Messages',
      screen: MessagesTab(),
    ),
    const _TabItem(
      icon: Icons.notifications,
      label: 'Notifications',
      screen: NotificationsTab(),
    ),
    const _TabItem(
      icon: Icons.person,
      label: 'Profil',
      screen: ProfileTab(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _notificationService.addListener(_handleNotificationsChange);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_handleNotificationsChange);
    super.dispose();
  }

  void _handleNotificationsChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs.map((tab) => tab.screen).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Constants.primaryColor,
          unselectedItemColor: Constants.subtitleColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: _tabs.map((tab) {
            final isNotifications = tab.label == 'Notifications';
            final hasUnread = isNotifications &&
                _notificationService.notifications.any((n) => !n.isRead);

            return BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(tab.icon),
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Constants.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                children: [
                  Icon(
                    tab.icon,
                    color: Constants.primaryColor,
                  ),
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Constants.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  final Widget screen;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
