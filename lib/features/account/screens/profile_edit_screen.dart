import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sema/model/user_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfileEditScreen({super.key, required this.profile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileController;
  late TextEditingController _countryController;


  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current user data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _firstNameController =
        TextEditingController(text: userProvider.user?.first_name);
    _lastNameController =
        TextEditingController(text: userProvider.user?.last_name);
    _mobileController =
        TextEditingController(text: userProvider.user?.mobile);
    _countryController =
        TextEditingController(text: userProvider.user?.country);
  }
  Future<void> _updateUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final url = Uri.parse('http://10.0.2.2:8000/api/users/profile/update/');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    };
    final body = jsonEncode({
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'mobile': _mobileController.text,
      'country': _countryController.text,
      'email':  userProvider.user!.email,
      'password': userProvider.user!.password
    });


     final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then update the user data in the provider
      userProvider.updateUser(User(
        first_name: _firstNameController.text,
        last_name: _lastNameController.text,
        mobile: _mobileController.text,
        country: _countryController.text,
        token: userProvider.user!.token,
        email: userProvider.user!.email,
        password: userProvider.user!.password,
        id: userProvider.user!.id,
        is_active: userProvider.user!.is_active,
        is_staff: userProvider.user!.is_staff,
        isAdmin: userProvider.user!.isAdmin,
        profile_photo: userProvider.user!.profile_photo,
      ));

       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated'),
            backgroundColor: Colors.green,
          ),);
        Navigator.of(context).pop();
    } else {
      // If the server did not return a 200 OK response,
      // then show an error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update user'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Edit Profile",
            style: Styles.headlineStyle4.copyWith(color: Colors.black),
          ),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              Container(),
              Gap(20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Firstname",
                      style: Styles.headlineStyle3
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      maxLength: 20,
                    )
                  ],
                ),
              ),
              Gap(15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lastname",
                      style: Styles.headlineStyle3
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      maxLength: 20,
                    )
                  ],
                ),
              ),
              Gap(15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mobile",
                      style: Styles.headlineStyle3
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      maxLength: 20,
                    )
                  ],
                ),
              ),
              Gap(15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Country",
                      style: Styles.headlineStyle3
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      maxLength: 20,
                    )
                  ],
                ),
              ),
              Gap(40),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _updateUser,
                      child: Text(
                        "Save",
                        style: Styles.headlineStyle3.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
