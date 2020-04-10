import 'package:flutter/material.dart';
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
  Color accessFont = Colors.white;
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
          color: Colors.amber[50],
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            overflow: Overflow.visible,
            children: <Widget>[
              AvatarGlow(
                startDelay: Duration(milliseconds: 1000),
                glowColor: Colors.brown[900],
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
                      child: ProgressiveImage(
                        placeholder:
                            AssetImage('assets/placeholder/placeholder.gif'),
                        thumbnail: AssetImage(
                            'assets/placeholder/${weather.placeholder}'), // 64x43 recommended
                        image: NetworkImage('${weather.facepic}'),
                        height: 200.0,
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                      // below is the recent image holder
                      // child: FadeInImage(
                      //   fadeInDuration: const Duration(seconds: 1),
                      //   fadeInCurve: Curves.easeInOutCirc,
                      //   placeholder: AssetImage(
                      //     'assets/placeholder/${weather.placeholder}',
                      //   ),
                      //   image: NetworkImage(
                      //     '${weather.facepic}',
                      //   ),
                      //   fit: BoxFit.cover,
                      //   height: 200.0,
                      //   width: 200.0,
                      // ),
                    ),
                  ),
                ),
                shape: BoxShape.circle,
                animate: true,
                curve: Curves.fastOutSlowIn,
              ),
              Positioned(
                top: -22.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black,
                      ],
                      // colors: [
                      //   Colors.blue[900],
                      //   Colors.blue[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.white,
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.blue[50],
                      //   Colors.blue[900],
                      // ],
                      begin: Alignment.centerRight,
                      end: Alignment(-1.0, -1.0),
                    ),
                    border: Border.all(
                      color: Colors.cyan[200],
                      width: 3.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(40.0, 10.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    // boxShadow: [
                    //   // BoxShadow(
                    //   //   color: Colors.blue[50],
                    //   //   offset: Offset(4.0, 2.0),
                    //   //   blurRadius: 20.0,
                    //   //   spreadRadius: 3.0,
                    //   // ),
                    //   // BoxShadow(
                    //   //   color: Colors.blue[300],
                    //   //   offset: Offset(4.0, 2.0),
                    //   //   blurRadius: 20.0,
                    //   //   spreadRadius: 2.0,
                    //   // ),
                    //   BoxShadow(
                    //     color: Colors.blue[300],
                    //     offset: Offset(2.0, 1.0),
                    //     blurRadius: 15,
                    //     spreadRadius: 3,
                    //   )
                    // ],
                  ),
                  // decoration: new BoxDecoration(
                  //   color: Colors.purple,
                  //   gradient: new LinearGradient(
                  //     colors: [Colors.red, Colors.cyan],
                  //     begin: Alignment.centerRight,
                  //     end: Alignment.centerLeft,
                  //   ),
                  // ),
                  height: 45.0,
                  width: MediaQuery.of(context).size.width * 0.80,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Text(
                      'OP OFFICIAL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        wordSpacing: 6.0,
                        letterSpacing: 6.0,
                        fontSize: 30,
                        color: Colors.cyan[100],
                        // shadows: [
                        //   Shadow(
                        //       // bottomLeft
                        //       offset: Offset(-1.0, -1.0),
                        //       color: Colors.black),
                        //   Shadow(
                        //       // bottomRight
                        //       offset: Offset(1.0, -1.0),
                        //       color: Colors.black),
                        //   Shadow(
                        //       // topRight
                        //       offset: Offset(1.0, 1.0),
                        //       color: Colors.black),
                        //   Shadow(
                        //       // topLeft
                        //       offset: Offset(-1.0, 1.0),
                        //       color: Colors.black),
                        // ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -23.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black,
                      ],
                      // colors: [
                      //   Colors.red[900],
                      //   Colors.red[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.white,
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.grey[50],
                      //   Colors.red[50],
                      //   Colors.red[900],
                      // ],
                      begin: Alignment.centerRight,
                      end: Alignment(-1.0, -1.0),
                    ),
                    border: Border.all(
                      color: Colors.cyan[200],
                      width: 3.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.elliptical(40.0, 10.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    // boxShadow: [
                    //   // BoxShadow(
                    //   //   color: Colors.red[50],
                    //   //   offset: Offset(4.0, 2.0),
                    //   //   blurRadius: 20.0,
                    //   //   spreadRadius: 3.0,
                    //   // ),
                    //   // BoxShadow(
                    //   //   color: Colors.red[300],
                    //   //   offset: Offset(4.0, 2.0),
                    //   //   blurRadius: 20.0,
                    //   //   spreadRadius: 2.0,
                    //   // ),
                    //   BoxShadow(
                    //     color: Colors.red[300],
                    //     offset: Offset(2.0, 1.0),
                    //     blurRadius: 15.0,
                    //     spreadRadius: 3.0,
                    //   )
                    // ],
                  ),
                  // decoration: new BoxDecoration(
                  //   color: Colors.purple,
                  //   gradient: new LinearGradient(
                  //     colors: [Colors.red, Colors.cyan],
                  //     begin: Alignment.centerRight,
                  //     end: Alignment.centerLeft,
                  //   ),
                  // ),
                  height: 45.0,
                  width: MediaQuery.of(context).size.width * 0.80,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: Text(
                      weather.cityName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        wordSpacing: 6.0,
                        letterSpacing: 6.0,
                        fontSize: 30,
                        color: Colors.cyan[100],
                        // shadows: [
                        //   Shadow(
                        //       // bottomLeft
                        //       offset: Offset(-1.0, -1.0),
                        //       color: Colors.black),
                        //   Shadow(
                        //       // bottomRight
                        //       offset: Offset(1.0, -1.0),
                        //       color: Colors.black),
                        //   Shadow(
                        //       // topRight
                        //       offset: Offset(1.0, 1.0),
                        //       color: Colors.black),
                        //   Shadow(
                        //       // topLeft
                        //       offset: Offset(-1.0, 1.0),
                        //       color: Colors.black),
                        // ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
            AvatarGlow(
              glowColor: Colors.white,
              endRadius: 70.0,
              duration: Duration(milliseconds: 4000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.greenAccent[400],
                  child: Icon(
                    Icons.filter_1,
                    color: accessFont,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.white,
              endRadius: 70.0,
              duration: Duration(milliseconds: 4000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent[100],
                  child: Icon(
                    Icons.filter_2,
                    color: accessFont,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.white,
              endRadius: 70.0,
              duration: Duration(milliseconds: 4000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Icon(
                    Icons.filter_3,
                    color: Colors.black,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            AvatarGlow(
              glowColor: Colors.white,
              endRadius: 70.0,
              duration: Duration(milliseconds: 4000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.blue[400],
                  child: Icon(
                    Icons.filter_4,
                    color: accessFont,
                    size: 36.0,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: 10.0,
        // ),
        // Text(
        //   weather.cityName,
        //   style: TextStyle(
        //     fontSize: 40,
        //     fontWeight: FontWeight.w700,
        //     color: Colors.white,
        //   ),
        // ),
        // SizedBox(
        //   height: 10.0,
        // ),
        // Text(
        //   // Display the temperature with 1 decimal place
        //   "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
        //   style: TextStyle(
        //     fontSize: 80,
        //     color: Colors.white,
        //   ),
        // ),
        SizedBox(
          height: 30.0,
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
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Enter a name",
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
