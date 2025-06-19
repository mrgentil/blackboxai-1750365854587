import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({Key? key}) : super(key: key);

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> with SingleTickerProviderStateMixin {
  final EventService _eventService = EventService();
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      await _eventService.fetchEvents();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, bool success) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Constants.successColor : Constants.errorColor,
      ),
    );
  }

  Future<void> _handleRegister(Event event) async {
    setState(() => _isLoading = true);
    try {
      final success = await _eventService.registerForEvent(event.id);
      _showSnackBar(
        success ? 'Inscription réussie' : 'Erreur lors de l\'inscription',
        success,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleUnregister(Event event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler l\'inscription'),
        content: const Text('Êtes-vous sûr de vouloir annuler votre inscription ?'),
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

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final success = await _eventService.unregisterFromEvent(event.id);
      _showSnackBar(
        success ? 'Désinscription réussie' : 'Erreur lors de la désinscription',
        success,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildEventCard(Event event) {
    final isRegistered = _eventService.isRegistered(event.id);

    return Card(
      margin: const EdgeInsets.only(bottom: Constants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Event Banner
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: event.typeColor.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Constants.defaultBorderRadius),
              ),
              image: event.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(event.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: event.imageUrl == null
                ? Center(
                    child: Icon(
                      event.typeIcon,
                      size: 48,
                      color: event.typeColor,
                    ),
                  )
                : null,
          ),
          // Event Details
          Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Type and Capacity
                Row(
                  children: [
                    _buildTypeChip(event),
                    const Spacer(),
                    if (event.requiresRegistration)
                      _buildCapacityChip(event),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.title,
                  style: Constants.subheadingStyle,
                ),
                const SizedBox(height: 8),
                _buildEventInfo(event),
                const SizedBox(height: 16),
                if (event.isUpcoming || event.isToday)
                  _buildActionButtons(event, isRegistered),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(Event event) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: event.typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        event.typeLabel,
        style: TextStyle(
          color: event.typeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCapacityChip(Event event) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: event.isFull
            ? Constants.errorColor.withOpacity(0.1)
            : Constants.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${event.participantIds.length}/${event.maxParticipants}',
        style: TextStyle(
          color: event.isFull
              ? Constants.errorColor
              : Constants.successColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEventInfo(Event event) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Constants.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              event.formattedDate,
              style: Constants.subtitleStyle,
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.access_time,
              size: 16,
              color: Constants.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              event.formattedTime,
              style: Constants.subtitleStyle,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: Constants.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              event.location,
              style: Constants.subtitleStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(Event event, bool isRegistered) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: isRegistered ? 'Se désinscrire' : 'S\'inscrire',
            onPressed: event.isRegistrationOpen && !_isLoading
                ? () => isRegistered
                    ? _handleUnregister(event)
                    : _handleRegister(event)
                : null,
            backgroundColor: isRegistered
                ? Constants.errorColor
                : Constants.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        CustomButton.secondary(
          text: 'Détails',
          onPressed: () {
            // TODO: Navigate to event details
          },
        ),
      ],
    );
  }

  Widget _buildEventList(List<Event> events) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Constants.subtitleColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun événement',
              style: Constants.subtitleStyle,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        itemCount: events.length,
        itemBuilder: (context, index) => _buildEventCard(events[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Événements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'À venir'),
            Tab(text: "Aujourd'hui"),
            Tab(text: 'Passés'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildEventList(_eventService.upcomingEvents),
                _buildEventList(_eventService.todayEvents),
                _buildEventList(_eventService.pastEvents),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create event screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
