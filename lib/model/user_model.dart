// "id": 2,
// "_id": 2,
// "isAdmin": true,
// "password": "pbkdf2_sha256$320000$zAIP8agjGQzELTaGiCNYzJ$GkM/5R3dMtBRxr3nx4HM4q9N7DMoqvba3cb5PqWOoSc=",
// "last_login": "02/10/2023 22:46",
// "email": "bernadmisheto@gmail.com",
// "first_name": "Bernad",
// "last_name": "Misheto",
// "mobile": "0764120975",
// "country": "Tanzania",
// "profile_photo": "/media/profile_photos/final_xbVv9vL.jpg",
// "created_at": "02/10/2023 22:45",
// "is_staff": true,
// "is_active": true,
// "is_superuser": true,
// "groups": [],
// "user_permissions": [

import 'dart:convert';
import 'dart:ffi';

class User {
  int id;
  String email;
  String first_name;
  String last_name;
  String mobile;
  String country;
  String password;
  String token;
  String profile_photo;
  bool isAdmin;
  bool is_staff;
  bool is_active;
  User({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.mobile,
    required this.country,
    required this.password,
    required this.token,
    required this.profile_photo,
    required this.is_active,
    required this.is_staff,
    required this.isAdmin,
  });

  User copyWith({
    int? id,
    String? email,
    String? first_name,
    String? last_name,
    String? mobile,
    String? country,
    String? password,
    String? token,
    String? profile_photo,
    bool? isAdmin,
    bool? is_active,
    bool? is_staff,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      mobile: mobile ?? this.mobile,
      country: country ?? this.country,
      password: password ?? this.password,
      token: token?? this.token,
      profile_photo: profile_photo ?? this.profile_photo,
      is_active: is_active ?? this.is_active,
      is_staff: is_staff ?? this.is_staff,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'mobile': mobile,
      'country': country,
      'password': password,
      'token': token,
      'profile_photo': profile_photo,
      'is_active': is_active,
      'is_staff': is_staff,
      'isAdmin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as int,
      email: map['email'] as String,
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      mobile: map['mobile'] as String,
      country: map['country'] as String,
      password: map['password'] as String,
      token: map['token'] as String,
      profile_photo: map['profile_photo'] as String,
      is_active: map['is_active'] as bool,
      is_staff: map['is_staff'] as bool,
      isAdmin: map['isAdmin'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'User(id: $id, email: $email,first_name: $first_name,last_name: $last_name,mobile: $mobile, country: $country, password: $password, token: $token, profile_photo: $profile_photo, is_active: $is_active, isAdmin: $isAdmin,is_staff: $is_staff )';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
