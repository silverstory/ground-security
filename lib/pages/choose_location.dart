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

  String citiName = '';

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

    // await instance.getTimeByCity(); // removed dec 21 2022

    // get person name from SharedPrefs

    setState(() {
      // navigate to home screen
      Navigator.pop(context, {
        'location': instance.location,
        // 'time': instance.time, // removed dec 21 2022
        'time': citiName, // added dec 21 2022
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
      // return buildList();

      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            citiInput(),
            buildList(),
          ],
        ),
      );


      // return Column(
      //   children: [
      //     buildList(),
      //     citiInput(),
      //   ],
      // );
  }

  Widget citiInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onSubmitted: (value) => submitCitiName(value),
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.singleLineFormatter
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
          hintText: "officer name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  void submitCitiName(String _citiName) {
    citiName = _citiName;
  }





  Widget buildList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
