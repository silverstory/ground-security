import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/services/world_time.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _location;
  Future<String> _token;

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
    _createToken();
    _location.then((value) => setupWorldTime(value));
  }

  // create user token
  Future<void> _createToken() async {
    final SharedPreferences prefs = await _prefs;
    // fetch token here
    String token;

    var url = 'http://210.213.193.149/users/authenticate';
    var response =
        await http.post(url, body: {'userName': 'h', 'password': 'h'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var _res = json.decode(response.body);
    print(_res['token']);
    // return _res['token'];
    token = _res['token'];

    // end fetch token
    await prefs.setString("token", token).then(
          (bool success) => success,
        );

    // read token from storage just to make sure
    _token = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('token') ?? 'invalid string');
    });
    // end read token froms storage
  }
  // end create user token

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
