import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sema/common/bottom_bar.dart';
import 'package:sema/features/auth/screens/login_screen.dart';
import 'package:sema/providers/user_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sema'),
      routes: {
        '/login': (context) => AuthScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false; // assuming user is not logged in initially

  @override
  Widget build(BuildContext context) {
    
    if (!isLoggedIn) {
      // if user is not logged in, navigate to login screen
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => AuthScreen()));
      return const SizedBox.shrink(); // return an empty widget while navigating
    }

    // if user is logged in, show the home page
    return Scaffold(
      body: Center(
        child: BottomBar(),
      ),
    );
  }
}
