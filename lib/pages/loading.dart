import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/services/world_time.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _location;

  final asset = AssetFlare(
    bundle: rootBundle,
    name: "assets/flare/perfect_loading_eprel.flr",
  );
  void setupWorldTime(String location) async {
    // fakeFetchWeather();
    WorldTime instance =
        WorldTime(location: location, flag: 'ph.png', url: 'Asia/Manila');
    // instance.initDio();
    await instance.getTimeByIp();
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDaytime': instance.isDaytime
    });
  }

  @override
  void initState() {
    super.initState();
    /*
    * read location from storage
    */
    _location = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('location') ?? 'GATE 7');
    });
    /*
    * setup location
    */
    _location.then((value) => setupWorldTime(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color.fromARGB(255, 3, 54, 255),
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 250.0,
            maxWidth: 250.0,
          ),
          child: FlareCacheBuilder(
            [asset],
            builder: (BuildContext context, bool _) {
              return FlareActor.asset(
                asset,
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: 'active',
              );
            },
          ),
        ),
        // SpinKitFadingCube(
        //   color: Colors.white,
        //   size: 80.0,
        // ),
      ),
    );
  }

  Future<void> fakeFetchWeather() {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }
}
