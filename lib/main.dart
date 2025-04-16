import 'package:flutter/material.dart';
import 'package:home_management/pages/bills.dart';
import 'package:home_management/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "home",
      routes: {
        "home": (context) => HomePage(),
        "bills": (context) => const Bills(),
        "object'sLocation": (context) => const Bills(),
        "documents": (context) => const Bills(),
        "addresses": (context) => const Bills(),
      },
    );
  }
}
