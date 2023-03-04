// _id(pin): 3
// attendees(pin): 0
// name(pin): "The Paralysis of Unlimited Opportunity"
// description(pin): "You can spend your marketing money in more ways than ever, live in more places while still working electronically, contact different people, launch different initiatives, hire different freelancers. You can post your ideas in dozens of ways, interact with millions of people, launch any sort of product or service without a permit or a factory"
// start_date(pin): "12th March 2023"
// end_date(pin): "18th March 2023"
// venue(pin): "JK Nyerere Hall"
// location(pin): "Dar Es Saalam"
// event_cover(pin): "/media/event_photos/pexels-pixabay-50675.jpg"

import 'dart:convert';
import 'dart:ffi';

class Event {
  int id;
  String name;
  String description;
  String start_date;
  String end_date;
  String location;
  String venue;
  String event_cover;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.start_date,
    required this.end_date,
    required this.location,
    required this.venue,
    required this.event_cover,
  });

  Event copyWith({
    int? id,
    String? name,
    String? description,
    String? start_date,
    String? end_date,
    String? location,
    String? venue,
    String? event_cover,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      venue: venue ?? this.venue,
      location: location ?? this.location,
      event_cover: event_cover ?? this.event_cover,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'description': description,
      'start_date': start_date,
      'end_date': end_date,
      'venue': venue,
      'location': location,
      'event_cover': event_cover,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      start_date: map['start_date'] as String,
      end_date: map['end_date'] as String,
      venue: map['venue'] as String,
      location: map['location'] as String,
      event_cover: map['event_cover'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Event(id: $id, name: $name,description: $description, start_date: $start_date, end_date: $end_date,venue: $venue,location: $location, event_cover: $event_cover)';

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
