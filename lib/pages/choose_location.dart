import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundsecurity/data/location.dart';
import 'package:groundsecurity/services/world_time.dart';
import 'package:flare_flutter/flare_actor.dart';
import "package:flare_flutter/flare_cache_builder.dart";
import 'package:flare_flutter/provider/asset_flare.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final asset = AssetFlare(
    bundle: rootBundle,
    name: "assets/flare/perfect_loading_eprel.flr",
  );
  List<WorldTime> locations = Location().supported;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void updateTime(index) async {
    setState(() {
      isLoading = true;
    });
    var instance = locations[index];
    // instance.initDio();
    await instance.getTimeByCity();
    setState(() {
      // navigate to home screen
      Navigator.pop(context, {
        'location': instance.location,
        'time': instance.time,
        'isDaytime': instance.isDaytime,
      });
      isLoading = false;
    });

    // var instance = locations[index];
    // instance.initDio();
    // await instance.getTimeByCity();
    // // navigate to home screen
    // Navigator.pop(context, {
    //   'location': instance.location,
    //   'time': instance.time,
    //   'isDaytime': instance.isDaytime,
    // });
  }

  Widget buildContent() {
    if (isLoading)
      return Center(
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
      );
    else
      return buildList();
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 1.0,
            horizontal: 4.0,
          ),
          child: Card(
            child: ListTile(
              onTap: () async {
                dynamic result = await Navigator.pushNamed(
                  context,
                  '/verify',
                );
                if (result != null && result['success'] == true) {
                  updateTime(index);
                  // setState(() {
                  //   data = {
                  //     'time': result['time'],
                  //     'location': result['location'],
                  //     'isDaytime': result['isDaytime'],
                  //   };
                  // });
                }
              },
              title: Text(
                locations[index].location,
              ),
              leading: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/flags/${locations[index].flag}'),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    locations.sort((a, b) => a.location.compareTo(b.location));

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(255, 255, 255, 40.0),
        title: Text('Choose a Location'),
        elevation: 8.0,
        titleSpacing: 2.0,
        // centerTitle: true,
      ),
      body: buildContent(),
    );
  }
}
