import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sema/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    if (_user != null) {
      _user = _user!.copyWith(
        first_name: updatedUser.first_name,
        last_name: updatedUser.last_name,
        mobile: updatedUser.mobile,
        country: updatedUser.country,
        profile_photo: updatedUser.profile_photo,
      );
      notifyListeners();
    }
  }
}
