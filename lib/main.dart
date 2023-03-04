import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sema/common/bottom_bar.dart';
import 'package:sema/features/auth/screens/login_screen.dart';
import 'package:sema/features/auth/services/auth_service.dart';
import 'package:sema/providers/user_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sema',
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.white,
        // colorScheme: const ColorScheme.dark(
        //   primary: Colors.white,
        // ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      home: (Provider.of<UserProvider>(context).user?.token.isNotEmpty == true
          ? const BottomBar()
          : const AuthScreen()),
    );
  }
}
