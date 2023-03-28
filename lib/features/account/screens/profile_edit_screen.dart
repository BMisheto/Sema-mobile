import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sema/features/auth/screens/password_change_screen.dart';
import 'package:sema/model/user_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  late TextEditingController _companyController;
  late TextEditingController _bioController;
  File? _imageFile;


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
    _companyController =
        TextEditingController(text: userProvider.user?.company);
    _bioController =
        TextEditingController(text: userProvider.user?.bio);
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
      'company': _companyController.text,
      'bio': _bioController.text,
      'email':  userProvider.user!.email,
     
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
        company: userProvider.user!.company,
        bio: userProvider.user!.bio,
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
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Edit Profile",
            style: Styles.headline
          ),
        ),
        body: Center(
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
             
             
              
              Gap(15),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                    labelText: 'Firstname',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your First name';
                  }
                  return null;
                },
              ),
              Gap(15),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                    labelText: 'Lastname',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your First name';
                  }
                  return null;
                },
              ),
              Gap(15),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                    labelText: 'Mobile',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Mobile';
                  }
                  return null;
                },
              ),
              Gap(15),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                    labelText: 'Country',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Country';
                  }
                  return null;
                },
              ),
              Gap(15),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                    labelText: 'Company',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                
              ),
              Gap(15),
              TextFormField(
                controller: _bioController,
                maxLines: null,
               decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
               
              ),
              Gap(15),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => PasswordChangeScreen(),
                      )),
                    child: Text("Change Password", style: Styles.cardDescription.copyWith(color: Colors.red),)
                  )
                  
                ],
              ),
                Gap(20),
              
             
              Container(
                            width: double.infinity,
                            height: 60,
                            decoration:  BoxDecoration(
                              color:  Styles.blueColor, 
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: _updateUser,
                                child: Text(
                                   'Save',
                                   style: Styles.cardTitle.copyWith(color: Colors.white)
                                 
                                ),
                              ),
                            ),
                          ),
            ],
          ),
        ));
  }
}
