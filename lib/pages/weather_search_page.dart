import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/model/weather.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:progressive_image/progressive_image.dart';

class WeatherSearchPage extends StatefulWidget {
  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  Color accessFont = Colors.black;
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
          width: MediaQuery.of(context).size.width * 0.90, // double.infinity,
          height: 650.0, // 530.0,
          color: Colors.white,
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                top: 0.0,
                height: 290.0, //170.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/placeholder/male.jpg'),
                      fit: BoxFit.cover,
                    ),
                    color: Color.fromARGB(255, 3, 54, 255),
                  ),
                  height: 45.0,
                  width: MediaQuery.of(context).size.width * 0.90,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(
                          'OP OFFICIAL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            wordSpacing: 6.0,
                            letterSpacing: 6.0,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                height: 360.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 45.0,
                  width: MediaQuery.of(context).size.width * 0.90,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 54.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'DIRECTOR XCVIII',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                wordSpacing: 6.0,
                                letterSpacing: 6.0,
                                fontSize: 21.0,
                                color: Color.fromARGB(255, 3, 54, 255),
                              ),
                            ),
                            SizedBox(
                              height: 22.0,
                            ),
                            Text(
                              weather.cityName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                wordSpacing: 6.0,
                                letterSpacing: 3.0,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 30, 30, 30),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.pin_drop,
                                  size: 37.0,
                                  color: Color.fromARGB(255, 2, 53, 255),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'ODESFA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    wordSpacing: 6.0,
                                    letterSpacing: 6.0,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 2, 53, 255),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 120.0,
                ),
                child: AvatarGlow(
                  startDelay: Duration(milliseconds: 1000),
                  glowColor: Color.fromARGB(255, 102, 18, 222),
                  endRadius: 170.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    color: Color.fromARGB(255, 3, 54, 255),
                    child: CircleAvatar(
                      radius: 108,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 100.0,
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(100),
                          child: ProgressiveImage(
                            placeholder: AssetImage(
                                'assets/placeholder/placeholder.gif'),
                            thumbnail: AssetImage(
                                'assets/placeholder/${weather.placeholder}'), // 64x43 recommended
                            image: NetworkImage('${weather.facepic}'),
                            height: 200.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  shape: BoxShape.circle,
                  animate: true,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 70.0,
          thickness: 12.0,
          color: Color.fromARGB(255, 255, 222, 3),
          indent: 60.0,
          endIndent: 60.0,
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
            AvatarGlow(
              glowColor: Colors.green[200],
              endRadius: 55.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              curve: Curves.fastLinearToSlowEaseIn,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.filter_1,
                    color: Colors.green,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.blue[400],
              endRadius: 55.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              curve: Curves.fastLinearToSlowEaseIn,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.filter_2,
                    color: Colors.blue,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.white,
              endRadius: 55.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              curve: Curves.fastLinearToSlowEaseIn,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.filter_3,
                    color: accessFont,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.red,
              endRadius: 55.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              curve: Curves.fastLinearToSlowEaseIn,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.filter_4,
                    color: Colors.red,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "8-digit token",
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
