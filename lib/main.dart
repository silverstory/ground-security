import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:groundsecurity/app_initializer.dart';

import 'package:groundsecurity/pages/home.dart';
import 'package:groundsecurity/pages/choose_location.dart';
import 'package:groundsecurity/pages/loading.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:groundsecurity/pages/verify.dart';
import 'package:groundsecurity/services/dependency_injection.dart';

Injector injector;

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  _enablePlatformOverrideForDesktop();
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/location': (context) => ChooseLocation(),
        '/verify': (context) => PinCodeVerificationScreen(),
      },
      title: 'Ground Security',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.blue,
      //   primaryColor: Colors.red,
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primarySwatch: Colors.orange,
      //   primaryColor: Colors.yellow,
      // ),
      // themeMode: ThemeMode.dark,
    );
  }
}
