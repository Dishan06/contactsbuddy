import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/contactScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts Buddy',
      theme: ThemeData(
        primaryColor: const Color(0XFF06BAD9),
        hintColor: const Color(0XFFFFFFFF),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 26, 45, 89),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(
              primary: const Color(0XFF4B92FF),
            )
            .copyWith(error: Colors.redAccent),
      ),
      home: const MyContacts(),
    );
  }
}
