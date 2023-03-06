// _id(pin): 5
// type(pin): null
// title(pin): "Genius Is Misunderstood as a Bolt of Lightning"
// content(pin): "Genius is actually the eventual public recognition of dozens (or hundreds) of failed attempts at solving a problem. Sometimes we fail in public, often we fail in private, but people who are doing creative work are constantly failing. When the lizard brain kicks in and the Resistance slows you down, the only correct response is to push back again and again and again with one failure after another. Sooner or later, the lizard will get bored and give up."
// link(pin): "https://bernard.vercel.app/"
// is_poll(pin): true
// has_photo(pin): false
// updated(pin): "02/23/2023 05:17"
// timestamp(pin): "02/20/2023 11:09"
// postImage(pin): "/media/cover.jpg"
// user(pin): 1

import 'dart:convert';
import 'dart:ffi';

class Post {
  int? id;
  String title;
  String content;
  String link;
  bool is_poll;
  String postImage;
  String timestamp;
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.is_poll,
    required this.postImage,
    required this.timestamp,
  });

  Post copyWith({
    int? id,
    String? title,
    String? content,
    bool? is_poll,
    String? link,
    String? postImage,
    String? timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      link: link ?? this.link,
      is_poll: is_poll ?? this.is_poll,
      postImage: postImage ?? this.postImage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'content': content,
      'is_poll': is_poll,
      'link': link,
      'timestamp': timestamp,
      'postImage': postImage,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['_id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      is_poll: map['is_poll'] as bool,
      link: map['link'] as String,
      timestamp: map['timestamp'] as String,
      postImage: map['postImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Post(id: $id, title: $title,content: $content, is_poll: $is_poll, link: $link,timestamp: $timestamp,postImage: $postImage)';

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
