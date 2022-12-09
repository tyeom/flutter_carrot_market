import 'package:app/pages/intro.dart';
import 'package:app/provider/service_provider.dart';
import 'package:app/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<NavigationProvider>(
        create: (context) => NavigationProvider()),
    ChangeNotifierProvider<ServiceProvider>(
        create: (context) => ServiceProvider()),
  ], child: const MyApp()));
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '당근마켓',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Colors.white,
            onPrimary: Colors.black,
            background: Colors.white,
            onBackground: Colors.black,
            secondary: Colors.white,
            onSecondary: Colors.white,
            error: Colors.black,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        home: Intro());
  }
}
