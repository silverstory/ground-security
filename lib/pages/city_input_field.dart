import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/weather_repository.dart';
import 'package:groundsecurity/main.dart';
// import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.singleLineFormatter,
          // WhitelistingTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          letterSpacing: 3.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 20, 20, 20),
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) async {
    await _changeTime(cityName);
  }

  Future<void> _changeTime(String time) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("time", time).then(
          (bool success) => success,
    );
  }

  void oldsubmitCityName(BuildContext context, String cityName) {
    weatherStore.setState(
      (store) => store.getWeather(cityName),
      onError: (error) {
        if (error is NetworkError) {
          ScaffoldMessenger.of(RM.context).showSnackBar(
            SnackBar(
              content: Text("Couldn't fetch weather. Is the device online?"),
            ),
          );
        } else {
          print(error.toString());
          weatherStore.setState(
            (store) => store.getEmptyWeather(),
          );
          // throw error;
        }
      },
    );

    // final reactiveModel = RM.get<WeatherStore>();
    // reactiveModel.setState(
    //   (store) => store.getWeather(cityName),
    //   onError: (error) {
    //     if (error is NetworkError) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text("Couldn't fetch weather. Is the device online?"),
    //         ),
    //       );
    //     } else {
    //       print(error.toString());
    //       reactiveModel.setState(
    //         (store) => store.getEmptyWeather(),
    //       );
    //       // throw error;
    //     }
    //   },
    // );
  }
}
