import 'package:flutter/material.dart';
import 'package:groundsecurity/data/model/weather.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(
            fontSize: 80,
            color: Colors.white,
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
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
