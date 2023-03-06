import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sema/features/auth/screens/register_screen.dart';
import 'package:sema/features/auth/services/auth_service.dart';
import 'package:sema/model/user_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import '../../../common//custom_textfield.dart';
import '../../../common//custom_button.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void loginUser() {
    authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void loginAsGuest() {
    userProvider.setGuestUser();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration:  BoxDecoration(
                color:  Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(30),
                   Center(
                     child: Column(
                       children: [
                        Container(
                          width: 100,
                          height: 100,
                          
                          child: CircleAvatar(
                            radius: 100.0,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage(
                              'assets/Icon.png',
                              
                 
                              
                            ),
                          ),
                        ),
                        Gap(10),
                         Text(
                          'Welcome',
                          style: Styles.bigHeadline
                                     ),
                       ],
                     ),
                   ),
                  Gap(30),
                  
                 
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                     
                      child: Form(
                        key: _signInFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                            const SizedBox(height: 10),
                            TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration:  BoxDecoration(
                                color:  Styles.blueColor, 
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                      if (_signInFormKey.currentState!.validate()) {
                                        loginUser();
                                      }
                                    },
                                  child: Text(
                                     'Sign In',
                                     style: Styles.cardTitle.copyWith(color: Colors.white)
                                   
                                  ),
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
                                  onTap: () =>
                            Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => RegisterScreen(),
                        )),
                                  child: Text(
                                     'Sign Up',
                                     style: Styles.cardTitle.copyWith(color: Colors.white)
                                   
                                  ),
                                ),
                              ),
                            ),
                            Gap(10),
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration:  BoxDecoration(
                                color:  Styles.blueColor, 
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                      loginAsGuest();
                                    },
                                  child: Text(
                                     'Continue as Guest',
                                     style: Styles.cardTitle.copyWith(color: Colors.white)
                                   
                                  ),
                                ),
                              ),
                            ),
                            Gap(10),
                           
                           
                          ],
                        ),
                      ),
                    ),
                  // ListTile(
                  //   tileColor: Styles.cardColor,
                  //   title: Text(
                  //     'Continue as Guest',
                  //     style: Styles.headline,
                  //   ),
                  //   leading: Radio(
                  //     activeColor: Colors.orange,
                  //     value: Auth.signin,
                  //     groupValue: _auth,
                  //     onChanged: (Auth? val) {
                  //       setState(() {
                  //         _auth = val!;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // if (_auth == Auth.signin)
                  //   Container(
                  //     padding: const EdgeInsets.all(8),
                  //     color: Colors.white,
                  //     child: Center(
                  //       child: CustomButton(
                  //         text: 'Continue as Guest',
                  //         onTap: () {
                  //           loginAsGuest();
                  //         },
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
