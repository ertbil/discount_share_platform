import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutionchallenge/models/post%20models/discount_post.dart';
import 'package:solutionchallenge/pages/add_post.dart';
import 'package:solutionchallenge/pages/login_page.dart';
import 'package:solutionchallenge/pages/main_page.dart';
import 'package:solutionchallenge/pages/detail_page.dart';
import 'package:solutionchallenge/pages/profile_page.dart';
import 'package:solutionchallenge/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Route? onGenerate(settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/profile':
        if(arguments is String) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => ProfilePage(profileID: arguments),

          );
        }
        break;
      case '/post':
        if(arguments is DiscountPost) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => DetailPage(discountPost: arguments),

          );
        }
        break;

    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerate,

      initialRoute: '/',
      routes: {
        '/': (context) => const LogInPage(),
        '/main': (context) => const MainPage(),
        "/signup": (context) => const SignUpPage(),
        '/login': (context) => const LogInPage(),
        '/addpost': (context) => const Addpost(),

      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
