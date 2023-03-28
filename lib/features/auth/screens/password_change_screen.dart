import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:sema/utils/url.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current user data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }
  
  Future<void> _updatePassword() async {

    if(_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords Do not mach'),
          backgroundColor: Colors.red,
        ),
      );

    } else {

      
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse(
        '${ApiUrl}api/users/change-password/${userProvider.user!.id}/');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    };
    final body = jsonEncode({
      'new': _passwordController.text,
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then update the user data in the provider

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Change'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      // If the server did not return a 200 OK response,
      // then show an error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Something Went Wrong'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    }





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: Styles.cardTitle,
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle:
                    TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                filled: true,
                fillColor: Styles.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please enter an Password';
                }
                return null;
              },
            ),
            Gap(10),
            TextFormField(
              controller: _confirmPasswordController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                labelStyle:
                    TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                filled: true,
                fillColor: Styles.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please confirm new password';
                }
                return null;
              },
            ),
            Gap(10),
           
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Styles.blueColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _updatePassword,
                  child: Text('Change Password',
                      style: Styles.cardTitle.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
