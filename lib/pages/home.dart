import 'package:flutter/material.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/pages/weather_search_page.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// https://api.flutter.dev/flutter/material/Colors-class.html
class _HomeState extends State<Home> {
  // Map data = {};

  @override
  Widget build(BuildContext context) {
    // Scaffold(
    //   body: SafeArea(
    //           child: Container(
    //       child: SingleChildScrollView(
    //         child: Injector(
    //           inject: [
    //             Inject<WeatherStore>(() => WeatherStore(FakeWeatherRepository())),
    //           ],
    //           builder: (_) => WeatherSearchPage(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey[900],
      // Colors.grey[900]
      body: SafeArea(
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                child: Column(
                  children: <Widget>[
                    Injector(
                      inject: [
                        Inject<WeatherStore>(
                            () => WeatherStore(FakeWeatherRepository())),
                      ],
                      builder: (_) => WeatherSearchPage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    // // set background
    // String bgImage = data['isDaytime'] ? 'day.png' : 'night.png';
    // Color bgColor = data['isDaytime'] ? Colors.blue : Colors.indigo[700];
    // // Color fontColor = data['isDaytime'] ? Colors.grey[900] : Colors.white;

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   backgroundColor: bgColor,
    //   body: SafeArea(
    //     child: Container(
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/$bgImage'),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //       child: Center(
    //         child: SingleChildScrollView(
    //           child: Padding(
    //             padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
    //             child: Column(
    //               children: <Widget>[
    //                 Injector(
    //                   inject: [
    //                     Inject<WeatherStore>(
    //                         () => WeatherStore(FakeWeatherRepository())),
    //                   ],
    //                   builder: (_) => WeatherSearchPage(),
    //                 ),
    //                 SizedBox(height: 20.0),
    //                 FlatButton.icon(
    //                   onPressed: () async {
    //                     dynamic result =
    //                         await Navigator.pushNamed(context, '/location');
    //                     setState(() {
    //                       data = {
    //                         'time': result['time'],
    //                         'location': result['location'],
    //                         'isDaytime': result['isDaytime'],
    //                       };
    //                     });
    //                   },
    //                   icon: Icon(
    //                     Icons.edit_location,
    //                     color: Colors.grey[300],
    //                   ),
    //                   label: Text(
    //                     'Edit Location',
    //                     style: TextStyle(
    //                       color: Colors.grey[300],
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(height: 20.0),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Text(
    //                       data['location'],
    //                       style: TextStyle(
    //                         fontSize: 28.0,
    //                         letterSpacing: 2.0,
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(height: 20.0),
    //                 Text(
    //                   data['time'],
    //                   style: TextStyle(
    //                     fontSize: 66.0,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
