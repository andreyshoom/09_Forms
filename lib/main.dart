import 'package:flutter/material.dart';
import 'package:hotels/class_hotels.dart';
import 'package:hotels/hotels.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ClassHotels.routeName:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return ClassHotels();
              },
            );
          case DetailPage.routeName:
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailPage();
              },
            );
        }
      },
    );
  }
}
