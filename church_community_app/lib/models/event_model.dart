import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum EventType {
  worship,
  prayer,
  youth,
  children,
  women,
  men,
  bible,
  other,
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final String location;
  final EventType type;
  final String organizerId;
  final List<String> participantIds;
  final int maxParticipants;
  final bool requiresRegistration;
  final DateTime? registrationDeadline;
  final String? imageUrl;
  final bool isRecurring;
  final String? recurrenceRule;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.type,
    required this.organizerId,
    required this.participantIds,
    required this.maxParticipants,
    required this.requiresRegistration,
    this.registrationDeadline,
    this.imageUrl,
    this.isRecurring = false,
    this.recurrenceRule,
  });

  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isPast => date.isBefore(DateTime.now());
  bool get isToday => date.day == DateTime.now().day &&
      date.month == DateTime.now().month &&
      date.year == DateTime.now().year;

  bool get isFull => participantIds.length >= maxParticipants;
  bool get isRegistrationOpen => !requiresRegistration ||
      (registrationDeadline?.isAfter(DateTime.now()) ?? true);

  String get formattedDate {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return "Aujourd'hui";
    }
    if (date.day == now.day + 1 &&
        date.month == now.month &&
        date.year == now.year) {
      return "Demain";
    }

    final weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];

    if (date.difference(now).inDays < 7) {
      return weekdays[date.weekday - 1];
    }

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get formattedTime {
    String formatTimeOfDay(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    if (endTime != null) {
      return '${formatTimeOfDay(startTime)} - ${formatTimeOfDay(endTime!)}';
    }
    return formatTimeOfDay(startTime);
  }

  Color get typeColor {
    switch (type) {
      case EventType.worship:
        return Colors.purple;
      case EventType.prayer:
        return Colors.blue;
      case EventType.youth:
        return Colors.orange;
      case EventType.children:
        return Colors.green;
      case EventType.women:
        return Colors.pink;
      case EventType.men:
        return Colors.brown;
      case EventType.bible:
        return Colors.teal;
      case EventType.other:
        return Colors.grey;
    }
  }

  String get typeLabel {
    switch (type) {
      case EventType.worship:
        return 'Culte';
      case EventType.prayer:
        return 'Prière';
      case EventType.youth:
        return 'Jeunesse';
      case EventType.children:
        return 'Enfants';
      case EventType.women:
        return 'Femmes';
      case EventType.men:
        return 'Hommes';
      case EventType.bible:
        return 'Étude biblique';
      case EventType.other:
        return 'Autre';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case EventType.worship:
        return Icons.church;
      case EventType.prayer:
        return Icons.emoji_people;
      case EventType.youth:
        return Icons.groups;
      case EventType.children:
        return Icons.child_care;
      case EventType.women:
        return Icons.female;
      case EventType.men:
        return Icons.male;
      case EventType.bible:
        return Icons.menu_book;
      case EventType.other:
        return Icons.event;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': {
        'hour': startTime.hour,
        'minute': startTime.minute,
      },
      'endTime': endTime != null
          ? {
              'hour': endTime!.hour,
              'minute': endTime!.minute,
            }
          : null,
      'location': location,
      'type': type.toString(),
      'organizerId': organizerId,
      'participantIds': participantIds,
      'maxParticipants': maxParticipants,
      'requiresRegistration': requiresRegistration,
      'registrationDeadline': registrationDeadline?.toIso8601String(),
      'imageUrl': imageUrl,
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(
        hour: json['startTime']['hour'],
        minute: json['startTime']['minute'],
      ),
      endTime: json['endTime'] != null
          ? TimeOfDay(
              hour: json['endTime']['hour'],
              minute: json['endTime']['minute'],
            )
          : null,
      location: json['location'],
      type: EventType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => EventType.other,
      ),
      organizerId: json['organizerId'],
      participantIds: List<String>.from(json['participantIds']),
      maxParticipants: json['maxParticipants'],
      requiresRegistration: json['requiresRegistration'],
      registrationDeadline: json['registrationDeadline'] != null
          ? DateTime.parse(json['registrationDeadline'])
          : null,
      imageUrl: json['imageUrl'],
      isRecurring: json['isRecurring'] ?? false,
      recurrenceRule: json['recurrenceRule'],
    );
  }

  // Sample events for development
  static List<Event> sampleEvents() {
    return [
      Event(
        id: '1',
        title: 'Culte dominical',
        description: 'Culte hebdomadaire du dimanche matin',
        date: DateTime.now().add(const Duration(days: 2)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
        location: 'Grande salle',
        type: EventType.worship,
        organizerId: '1',
        participantIds: [],
        maxParticipants: 200,
        requiresRegistration: false,
        isRecurring: true,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=SU',
      ),
      Event(
        id: '2',
        title: 'Réunion de prière',
        description: 'Réunion de prière hebdomadaire',
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 19, minute: 0),
        endTime: const TimeOfDay(hour: 20, minute: 30),
        location: 'Salle de prière',
        type: EventType.prayer,
        organizerId: '1',
        participantIds: [],
        maxParticipants: 50,
        requiresRegistration: false,
        isRecurring: true,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
      ),
    ];
  }
}
