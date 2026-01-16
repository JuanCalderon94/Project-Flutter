import 'package:flutter_application_1/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 71, 68, 75),
        ),
        fontFamily: "Arial",
      ),
      routes: routes,
      initialRoute: "splash",
    );
  }
}
