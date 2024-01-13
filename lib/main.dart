import 'package:flutter/material.dart';
import 'package:hotel_apps/bookingDetails.dart';
import 'package:hotel_apps/login.dart';
import 'package:hotel_apps/room.dart';
import 'package:hotel_apps/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF755f56),
        primarySwatch: Colors.brown,
        canvasColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => welcome(),
        '/home': (context) => Room(),
        '/favorite': (context) => Login(),
        '/profile': (context) => bookingDetails(),
      },
    );
  }
}
