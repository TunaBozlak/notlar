import 'package:flutter/material.dart';
import 'package:notlar/components/themenotifier.dart';
import 'package:provider/provider.dart';
import 'package:notlar/pages/homepage/homepage.dart';
import 'package:notlar/pages/loginpage/loginpage.dart';
import 'package:notlar/pages/registerpage/registerpage.dart';
import 'package:notlar/models/User.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme, // Dinamik tema
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginPage(
              Uyeol: () { // Login'deki üyeol ile register'a geçiş
                Navigator.pushNamed(context, '/register');
              },
              Oturumac: (user) {
                // Navigator.push ile HomePage'e User objesini geçirin
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: user),
                  ),
                );
              },
            ),
            '/register': (context) => RegisterPage(
              Girisyap: () { // Register'daki Girisyap ile Login'e geçiş
                Navigator.pushNamed(context, '/login');
              },
              Kayitol: (user) { // Register'daki Kayıtol ile home'a geçiş
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: user),
                  ),
                );
              },
            ),
          },
        );
      },
    );
  }
}
