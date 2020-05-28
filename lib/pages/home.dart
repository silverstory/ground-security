import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/pages/scanner.dart';
import 'package:groundsecurity/pages/weather_search_page.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:groundsecurity/services/world_time.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// https://api.flutter.dev/flutter/material/Colors-class.html

class _HomeState extends State<Home> {
  Map data = {};
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Future<String> _location;
  final asset =
      AssetFlare(bundle: rootBundle, name: "assets/flare/qrcode_eprel.flr");

  // void setupWorldTimeDio() {
  //   // fakeFetchWeather();
  //   WorldTime instance =
  //       WorldTime(location: 'Manila', flag: 'ph.png', url: 'Asia/Manila');
  //   instance.initDio();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   setupWorldTimeDio();
  // }

  Future<void> _changeLocation(String location) async {
    final SharedPreferences prefs = await _prefs;
    // final String location = (prefs.getString('location') ?? 'GATE 7');
    await prefs.setString("location", location).then(
          (bool success) => success,
        );
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    // for background image - old design
    // String bgImage = data['isDaytime'] ? 'day.png' : 'night.png';
    // Color bgColor = data['isDaytime'] ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      // Color.fromARGB(255, 3, 54, 255),
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      // Color.fromARGB(255, 20, 20, 20),
      // floatingActionButton: Material(
      //   color: Colors.transparent,
      //   child: Ink(
      //     decoration: BoxDecoration(
      //       border: Border.all(
      //         // Color.fromARGB(255, 255, 2, 102),
      //         color: Color.fromARGB(255, 3, 218, 197),
      //         width: 2.0,
      //       ),
      //       // Color.fromARGB(255, 255, 2, 102),
      //       color: Color.fromARGB(255, 3, 218, 197),
      //       shape: BoxShape.circle,
      //     ),
      //     child: InkWell(
      //       //This keeps the splash effect within the circle
      //       borderRadius: BorderRadius.circular(
      //           1000.0), //Something large to ensure a circle
      //       onTap: () {},
      //       child: Padding(
      //         padding: EdgeInsets.all(15.0),
      //         child: ConstrainedBox(
      //           constraints: BoxConstraints(
      //             maxHeight: 50.0,
      //             maxWidth: 50.0,
      //           ),
      //           child: FlareCacheBuilder(
      //             [asset],
      //             builder: (BuildContext context, bool _) {
      //               return FlareActor.asset(
      //                 asset,
      //                 alignment: Alignment.center,
      //                 fit: BoxFit.contain,
      //                 animation: 'show',
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                child: Column(
                  children: <Widget>[
                    ScannerWidget(context: context),
                    // FractionallySizedBox(
                    //   widthFactor: 0.7,
                    //   child: Divider(
                    //     height: 20.0, // 40.0,
                    //     thickness: 5.0, // 10.0,
                    //     // Color.fromARGB(255, 255, 222, 3),
                    //     // Color.fromARGB(255, 255, 2, 102),
                    //     // Color.fromARGB(255, 187, 134, 252),
                    //     color: Color.fromRGBO(255, 255, 255, 0.07),
                    //     // indent: 60.0,
                    //     // endIndent: 60.0,
                    //   ),
                    // ),
                    Injector(
                      inject: [
                        Inject<WeatherStore>(
                            () => WeatherStore(FakeWeatherRepository())),
                      ],
                      builder: (_) => WeatherSearchPage(),
                    ),
                    SizedBox(height: 30.0),
                    FlatButton.icon(
                      onPressed: () async {
                        dynamic result =
                            await Navigator.pushNamed(context, '/location');
                        if (result != null) {
                          await _changeLocation(result['location']);
                          setState(() {
                            data = {
                              'time': result['time'],
                              'location': result['location'],
                              'isDaytime': result['isDaytime'],
                            };
                          });
                        }
                      },
                      icon: Icon(
                        Icons.edit_location,
                        color: Color.fromARGB(255, 234, 128, 252),
                      ),
                      label: Text(
                        'Edit Location',
                        style: TextStyle(
                          color: Color.fromARGB(255, 234, 128, 252),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          // data['location'],
                          data['time'],
                          style: TextStyle(
                            fontSize: 28.0,
                            letterSpacing: 2.0,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      // data['time'],
                      data['location'],
                      style: TextStyle(
                        fontSize: 66.0,
                        color: Color.fromRGBO(255, 255, 255, 0.87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
