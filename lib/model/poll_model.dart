// _id(pin): 20
// choice_text(pin): "Choice Name"
// votes(pin): 0
// post(pin): 5

import 'dart:convert';
import 'dart:ffi';

class Poll {
  int id;
  String choice_text;
  int votes;
  int post;
  Poll({
    required this.id,
    required this.choice_text,
    required this.votes,
    required this.post,
  });

  Poll copyWith({
    int? id,
    String? choice_text,
    int? votes,
    int? post,
  }) {
    return Poll(
      id: id ?? this.id,
      choice_text: choice_text ?? this.choice_text,
      votes: votes ?? this.votes,
      post: post ?? this.post,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'choice_text': choice_text,
      'votes': votes,
      'post': post,
    };
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      id: map['_id'] as int,
      choice_text: map['choice_text'] as String,
      votes: map['votes'] as int,
      post: map['post'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Poll.fromJson(String source) =>
      Poll.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Post(id: $id, choice_text: $choice_text, votes: $votes, post: $post)';

  @override
  bool operator ==(covariant Poll other) {
    if (identical(this, other)) return true;

    return other.id == id && other.choice_text == choice_text;
  }

  @override
  int get hashCode => id.hashCode ^ choice_text.hashCode;
}
