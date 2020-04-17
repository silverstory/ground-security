import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/services/world_time.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final asset = AssetFlare(
      bundle: rootBundle, name: "assets/flare/perfect_loading_eprel.flr");
  void setupWorldTime() async {
    // fakeFetchWeather();
    WorldTime instance =
        WorldTime(location: 'Manila', flag: 'ph.png', url: 'Asia/Manila');
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
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[900], // dark
      backgroundColor: Color.fromARGB(255, 3, 54, 255),
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
