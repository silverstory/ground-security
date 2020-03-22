import 'package:flutter/material.dart';

import 'package:groundsecurity/pages/home.dart';
import 'package:groundsecurity/pages/choose_location.dart';
import 'package:groundsecurity/pages/loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/location': (context) => ChooseLocation()
      },
      title: 'Ground Security',
    );
  }
}
