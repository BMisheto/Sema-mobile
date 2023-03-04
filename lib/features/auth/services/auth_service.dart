import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sema/common/bottom_bar.dart';
import 'package:sema/features/feed/screens/feed_screen.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign up user

// sign in user
void loginUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  try {
    http.Response res = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/users/login/'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    
    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
      
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => BottomBar()),
        (route) => false,
      );
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/users/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/users/login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
