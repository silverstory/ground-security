import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/model/weather.dart';
import 'package:groundsecurity/pages/city_input_field.dart';
import 'package:groundsecurity/pages/infos/access_badge.dart';
import 'package:groundsecurity/pages/infos/basic_info.dart';
import 'package:groundsecurity/pages/infos/class_info.dart';
import 'package:groundsecurity/pages/infos/face_image.dart';
import 'package:groundsecurity/state/weather_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';

class WeatherSearchPage extends StatefulWidget {
  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  Color accessFont = Colors.black;
  final asset = AssetFlare(
      bundle: rootBundle, name: "assets/flare/meteor_loading_eprel.flr");
  final pin_asset = AssetFlare(
      bundle: rootBundle, name: "assets/flare/pin_location_eprel.flr");
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 350.0,
        maxWidth: 350.0,
      ),
      child: FlareCacheBuilder(
        [asset],
        builder: (BuildContext context, bool _) {
          return FlareActor.asset(
            asset,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'Idle',
          );
        },
      ),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          type: MaterialType.card,
          color: Color.fromRGBO(255, 255, 255, 0.07),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.90, // double.infinity,
            height: 650.0, // 530.0,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              fit: StackFit.loose,
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  top: 0.0,
                  height: 290.0, //170.0,
                  child: ClassInfo(context: context, weather: weather),
                ),
                Positioned(
                  bottom: 0.0,
                  height: 360.0,
                  child: BasicInfo(context: context, weather: weather),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 120.0,
                  ),
                  child: FaceImage(weather: weather),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 70.0,
          thickness: 12.0,
          // Color.fromARGB(255, 255, 222, 3),
          // Color.fromARGB(255, 255, 2, 102),
          // Color.fromARGB(255, 187, 134, 252),
          color: Color.fromRGBO(255, 255, 255, 0.38),
          indent: 60.0,
          endIndent: 60.0,
        ),
        AccessBadge(accessFont: accessFont, weather: weather),
        SizedBox(
          height: 10.0,
        ),
        CityInputField(),
      ],
    );
  }
}
