// _id(pin): 3
// total(pin): 0
// name(pin): "Finding Inspiration Instead of It Finding You"
// description(pin): "The second method challenges the fear and announces that you’ve abandoned the Resistance and instead prepared to ship. Your first idea might not be good, or even your second or your tenth, but once you dedicate yourself to this cycle, yes, in fact, you will ship and make a difference."
// date(pin): "02/20/2023 11:16"
// target(pin): "3000000.00"
// donation_cover(pin): "/media/donation_photos/pexels-rodnae-productions-6646914.jpg"

import 'dart:convert';
import 'dart:ffi';

class Donation {
  int id;
  String name;
  String description;
  String date;
  String target;
  String donation_cover;

  Donation({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.target,
    required this.donation_cover,
  });

  Donation copyWith({
    int? id,
    String? name,
    String? description,
    String? date,
    String? target,
    String? donation_cover,
  }) {
    return Donation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      target: target ?? this.target,
      donation_cover: donation_cover ?? this.donation_cover,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'description': description,
      'date': date,
      'target': target,
      'donation_cover': donation_cover,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      target: map['target'] as String,
      donation_cover: map['donation_cover'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Donation.fromJson(String source) =>
      Donation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Event(id: $id, name: $name,description: $description, date: $date,target: $target, donation_cover: $donation_cover)';

  @override
  bool operator ==(covariant Donation other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
