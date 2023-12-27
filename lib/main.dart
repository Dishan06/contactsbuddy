import 'package:contactsbuddy/screen/contactScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts Buddy',
      theme: ThemeData(
        primaryColor: Color(0XFF06BAD9),
        hintColor: Color(0XFFFFFFFF),
        textTheme: GoogleFonts.poppinsTextTheme(),

        scaffoldBackgroundColor: Color(0XFF0A1123),
        errorColor: Colors.redAccent,
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Color(0XFF4B92FF),

        ),
        pageTransitionsTheme: PageTransitionsTheme(builders: const {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      home: MyContacts(),
    );
  }
}
