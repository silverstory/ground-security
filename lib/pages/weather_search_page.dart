import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:avatar_glow/avatar_glow.dart';

class WeatherSearchPage extends StatefulWidget {
  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: StateBuilder<WeatherStore>(
        models: [Injector.getAsReactive<WeatherStore>()],
        builder: (_, reactiveModel) {
          return reactiveModel.whenConnectionState(
            onIdle: () => buildInitialInput(),
            onWaiting: () => buildLoading(),
            onData: (store) => buildColumnWithData(store.weather),
            onError: (_) => buildInitialInput(),
          );
        },
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return SpinKitFadingCube(
      color: Colors.white,
      size: 80.0,
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.amber[900],
          child: AvatarGlow(
            startDelay: Duration(milliseconds: 1000),
            glowColor: Colors.white,
            endRadius: 170.0,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Material(
              elevation: 8.0,
              shape: CircleBorder(),
              color: Colors.transparent,
              child: CircleAvatar(
                radius: 100.0,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(100),
                  child: FadeInImage(
                    fadeInDuration: const Duration(seconds: 1),
                    fadeInCurve: Curves.easeInOutCirc,
                    placeholder: AssetImage(
                      'assets/placeholder/${weather.placeholder}',
                    ),
                    image: NetworkImage(
                      "${weather.facepic}",
                    ),
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
              ),
            ),
            shape: BoxShape.circle,
            animate: true,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 90.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/images/flutter.png',
                    height: 60,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.red,
              endRadius: 90.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/images/love.png',
                    height: 60,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
          ],
        ),
        AvatarGlow(
          glowColor: Colors.cyan,
          endRadius: 60.0,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: Material(
            elevation: 8.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Image.asset(
                'assets/images/dart.png',
                height: 50,
              ),
              radius: 30.0,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(
            fontSize: 80,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        CityInputField(),
      ],
    );



    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: <Widget>[
    //     CircleAvatar(
    //       radius: 108,
    //       backgroundColor: Color(0xffFDCF09),
    //       child: CircleAvatar(
    //         radius: 100,
    //         child: ClipRRect(
    //           borderRadius: new BorderRadius.circular(100),
    //           child: FadeInImage(
    //             fadeInDuration: const Duration(seconds: 1),
    //             fadeInCurve: Curves.easeInOutCirc,
    //             placeholder: AssetImage(
    //               'assets/placeholder/${weather.placeholder}',
    //             ),
    //             image: NetworkImage(
    //               "${weather.facepic}",
    //             ),
    //             fit: BoxFit.cover,
    //             height: 300.0,
    //             width: 300.0,
    //           ),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 10.0,
    //     ),
    //     Text(
    //       weather.cityName,
    //       style: TextStyle(
    //         fontSize: 40,
    //         fontWeight: FontWeight.w700,
    //         color: Colors.white,
    //       ),
    //     ),
    //     SizedBox(
    //       height: 10.0,
    //     ),
    //     Text(
    //       // Display the temperature with 1 decimal place
    //       "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
    //       style: TextStyle(
    //         fontSize: 80,
    //         color: Colors.white,
    //       ),
    //     ),
    //     SizedBox(
    //       height: 20.0,
    //     ),
    //     CityInputField(),
    //   ],
    // );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    final reactiveModel = Injector.getAsReactive<WeatherStore>();
    reactiveModel.setState(
      (store) => store.getWeather(cityName),
      onError: (context, error) {
        if (error is NetworkError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Couldn't fetch weather. Is the device online?"),
            ),
          );
        } else {
          throw error;
        }
      },
    );
  }
}
