import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiUrl}api/users/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'mobile': _mobileController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful, navigate to login screen
        Navigator.of(context).pop();
      } else {
        // Registration failed, show error message
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      // Request failed, show error message
      setState(() {
        _errorMessage = 'Registration failed. Please check your network connection and try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Register', style: Styles.headline),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
                Gap(20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                      labelText: 'First Name',
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
                Gap(20),
              TextField(
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
              ),
                Gap(20),
              TextField(
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
              ),
                Gap(20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                      labelText: 'Email',
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
                Gap(20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                      labelText: 'Password',
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
                                  onTap: _register,
                                  child: Text(
                                     'Create Account',
                                     style: Styles.cardTitle.copyWith(color: Colors.white)
                                   
                                  ),
                                ),
                              ),
                            ),
            ],
          ),
        ),
      ),
    );
  }
}