import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:groundsecurity/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupWorldTime() async {
    fakeFetchWeather();
    // WorldTime instance =
    //     WorldTime(location: 'Manila', flag: 'ph.png', url: 'Asia/Manila');
    // await instance.getTimeByIp();
    // Navigator.pushReplacementNamed(context, '/home', arguments: {
    //   'location': instance.location,
    //   'flag': instance.flag,
    //   'time': instance.time,
    //   'isDaytime': instance.isDaytime
    // });
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
      backgroundColor: Color.fromARGB(255, 102, 18, 222),
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 80.0,
        ),
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
