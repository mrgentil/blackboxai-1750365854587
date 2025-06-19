import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/user_service.dart';

class EventService extends ChangeNotifier {
  // Singleton pattern
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final UserService _userService = UserService();
  List<Event> _events = [];
  bool _isLoading = false;

  // Getters
  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  List<Event> get upcomingEvents =>
      _events.where((event) => event.isUpcoming).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  List<Event> get pastEvents =>
      _events.where((event) => event.isPast).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<Event> get todayEvents =>
      _events.where((event) => event.isToday).toList()
        ..sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

  List<Event> getEventsByType(EventType type) =>
      _events.where((event) => event.type == type).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  List<Event> getEventsByOrganizer(String organizerId) =>
      _events.where((event) => event.organizerId == organizerId).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  List<Event> getRegisteredEvents(String userId) =>
      _events.where((event) => event.participantIds.contains(userId)).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  // Initialize with sample data for development
  void initializeWithSampleData() {
    _events = Event.sampleEvents();
    notifyListeners();
  }

  // CRUD Operations
  Future<void> fetchEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      _events = Event.sampleEvents();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching events: $e');
      rethrow;
    }
  }

  Future<Event?> getNextEvent() async {
    try {
      if (_events.isEmpty) {
        await fetchEvents();
      }

      final upcomingEvents = _events
          .where((event) => event.date.isAfter(DateTime.now()))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      return upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
    } catch (e) {
      debugPrint('Error getting next event: $e');
      return null;
    }
  }

  Future<bool> createEvent(Event event) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _events.add(event);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error creating event: $e');
      return false;
    }
  }

  Future<bool> updateEvent(Event event) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating event: $e');
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _events.removeWhere((event) => event.id == eventId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting event: $e');
      return false;
    }
  }

  // Registration Operations
  Future<bool> registerForEvent(String eventId) async {
    try {
      if (_userService.currentUser == null) return false;

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        final event = _events[index];
        if (event.isFull || !event.isRegistrationOpen) {
          return false;
        }

        final updatedEvent = Event(
          id: event.id,
          title: event.title,
          description: event.description,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          type: event.type,
          organizerId: event.organizerId,
          participantIds: [
            ...(event.participantIds),
            _userService.currentUser!.id,
          ],
          maxParticipants: event.maxParticipants,
          requiresRegistration: event.requiresRegistration,
          registrationDeadline: event.registrationDeadline,
          imageUrl: event.imageUrl,
          isRecurring: event.isRecurring,
          recurrenceRule: event.recurrenceRule,
        );

        _events[index] = updatedEvent;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error registering for event: $e');
      return false;
    }
  }

  Future<bool> unregisterFromEvent(String eventId) async {
    try {
      if (_userService.currentUser == null) return false;

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        final event = _events[index];
        final updatedEvent = Event(
          id: event.id,
          title: event.title,
          description: event.description,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          type: event.type,
          organizerId: event.organizerId,
          participantIds: event.participantIds
              .where((id) => id != _userService.currentUser!.id)
              .toList(),
          maxParticipants: event.maxParticipants,
          requiresRegistration: event.requiresRegistration,
          registrationDeadline: event.registrationDeadline,
          imageUrl: event.imageUrl,
          isRecurring: event.isRecurring,
          recurrenceRule: event.recurrenceRule,
        );

        _events[index] = updatedEvent;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error unregistering from event: $e');
      return false;
    }
  }

  bool isRegistered(String eventId) {
    if (_userService.currentUser == null) return false;
    final event = _events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => Event(
        id: '',
        title: '',
        description: '',
        date: DateTime.now(),
        startTime: const TimeOfDay(hour: 0, minute: 0),
        location: '',
        type: EventType.other,
        organizerId: '',
        participantIds: [],
        maxParticipants: 0,
        requiresRegistration: false,
      ),
    );
    return event.participantIds.contains(_userService.currentUser!.id);
  }
}
