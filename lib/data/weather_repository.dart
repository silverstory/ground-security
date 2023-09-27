// import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:groundsecurity/main.dart';
// import 'package:groundsecurity/services/socket_service.dart';

import 'model/weather.dart';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:groundsecurity/interceptor/dio_connectivity_request_retrier.dart';
import 'package:groundsecurity/interceptor/retry_interceptor.dart';

import 'package:faker/faker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'dart:io';

import 'dart:async';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Future<String> _token;

  // final SocketService socketService = injector.get<SocketService>();
  Dio dio;
  double cachedTempCelsius;
  Map<String, String> placeholderMap = {
    'male': 'male.jpg',
    'female': 'female.jpg'
  };
  Map<int, String> genderMap = {1: 'male', 2: 'female'};
  Map<int, String> maleMap = {
    1: 'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    2: 'https://images.pexels.com/photos/2473581/pexels-photo-2473581.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    3: 'https://images.pexels.com/photos/938642/pexels-photo-938642.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    4: 'https://images.pexels.com/photos/2589650/pexels-photo-2589650.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  };
  Map<int, String> femaleMap = {
    1: 'https://images.pexels.com/photos/3891820/pexels-photo-3891820.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    2: 'https://images.pexels.com/photos/2135135/pexels-photo-2135135.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    3: 'https://images.pexels.com/photos/1727273/pexels-photo-1727273.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    4: 'https://images.pexels.com/photos/247120/pexels-photo-247120.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  };

  // for vms picture
  String thefilename;

  @override
  Future<Weather> fetchWeather(String sCode) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () async {
        /*
        * read token from storage
        */
        // _token = _prefs.then((SharedPreferences prefs) {
        //   return (prefs.getString('token') ?? 'an invalid token');
        // });
        String _token = await _tokenRetriever();
        String _gate = await _gateRetriever();
        String _time = await _timeRetriever();
        List<String> urlArr = sCode.split('/');
        String hmac = urlArr.last;
        /*
        * start to get data from api
        */
        String fullName;
        String position;
        String office;
        String classGroup;
        String facePic;
        String placeHolder;
        String gender;
        /*
        * use enum to transform colorN
        * to a color object below
        */
        String color1;
        String color2; // data coming from api
        String color3; // as hex color value
        String color4;

        Color one = Colors.green;
        Color two = Colors.blue;
        Color three = Color.fromRGBO(255, 255, 255, 0.87);
        Color four = Colors.red;

        String gate;

        // for socket
        String id;
        String profileid;
        String qrcode;

        // for display photo in app
        String thePhoto =
            "https://images.pexels.com/photos/6912822/pexels-photo-6912822.jpeg?auto=compress&cs=tinysrgb&w=960&h=640&dpr=1";

        // uncomment lines below for ciss API

        dio = Dio();

        // if statement here for visitors

        if (sCode.contains('op-proper.gov.ph')) {
          thePhoto =
              "https://images.pexels.com/photos/6912822/pexels-photo-6912822.jpeg?auto=compress&cs=tinysrgb&w=960&h=640&dpr=1";

          // employee section

          // String url = "http://192.168.23.8/verifyemployee";

          // if (hmac.contains('VEHICLE')) {
          //   url = "http://192.168.23.8/api/vehicle/${hmac}";
          // }

          // dio.options.headers["Authorization"] = "Bearer ${_token}";

          // FormData formData = new FormData.fromMap({
          //   "hmac": hmac,
          //   "bearer": _token
          // });

          dio.interceptors.add(
            RetryOnConnectionChangeInterceptor(
              requestRetrier: DioConnectivityRequestRetrier(
                dio: Dio(),
                connectivity: Connectivity(),
              ),
            ),
          );

          dio.options.headers["Accept"] = "application/json";

          Response response = await dio
              .post("https://events.op-vms.gov.ph/verifyemployee", data: {
            "hmac": hmac,
            "bearer": _token,
          });

          // handle not found
          if (response.data == null) {
            return Weather.notFound();
          }

          Map data = response.data;

          // end uncomment lines below for ciss API
          // if (hmac.contains('VEHICLE')) {
          //   // use vehicle profile
          //   fullName = data['platenumber'];
          //   position =
          //       data['make'] + ' ' + data['series'] + ' [' + data['color'] + ']';
          //   office = data['vehicleowner'];
          //   classGroup = data['parkingslot'];
          //   String _facePic = data['vehiclephoto'];
          //   // facePic = _facePic.replaceAll(
          //   //     'http://192.168.23.60/', 'http://58.69.10.203/');
          //   facePic = _facePic;
          //   placeHolder = 'female.jpg';
          //   gender = 'female';
          //   // for socket
          //   id = data['_id'].toString();
          //   profileid = data['controlnumber'];
          //   qrcode = data['qrcode'];
          // } else {

          // use human profile
          fullName = data['name']['first'] + ' ' + data['name']['last'];
          // if clause here on what field to
          // display depending on distinction
          position = data['employee']['position'];
          office = data['employee']['office'] +
              ' [' +
              data['recordstatus'].toString().toUpperCase() +
              ']';
          // end if clause
          classGroup = data['distinction'];
          String _facePic = data['photothumbnailurl'];
          // String _facePic = "https://images.pexels.com/photos/6912822/pexels-photo-6912822.jpeg?auto=compress&cs=tinysrgb&w=960&h=640&dpr=1";
          facePic = _facePic;
          // facePic = _facePic.replaceAll(
          //     'http://192.168.23.60/', 'http://58.69.10.203/');
          placeHolder = 'male.jpg';
          print(data['gender'].toString().trim());
          if (data['gender'].toString().trim() == 'male') {
            placeHolder = 'male.jpg';
          } else {
            placeHolder = 'female.jpg';
          }
          gender = data['gender'].toString().trim();
          // for socket
          id = data['_id'].toString();
          profileid = data['profileid'];
          qrcode = data['cissinqtext'];
          // }

          var datetime = new DateTime.now();

          /*
          * colors values should come from
          * colorN's equivalent enum value
          */
          /*
          * create a function to convert colors
          */
          one = Colors.green;
          two = Colors.blue;
          three = Color.fromRGBO(255, 255, 255, 0.87);
          four = Colors.red;

          dio.interceptors.removeLast(); // kinomment jan 19 2023 11.48 am
          dio = null; // kinomment jan 19 2023 11.10 am

          gate = _gate;

          String time;
          time = _time;

          dynamic personA = {
            "id": id,
            "profileid": profileid,
            "name": fullName,
            "gender": gender,
            "imagepath": facePic,
            "distinction": "OPEMPLOYEE",
            "gate": gate + " - " + time,
            "qrcode": qrcode,
            "datetime": datetime.toIso8601String(),
            "completed": false,
          };

          // post verifications

          dynamic verifyPersonA = {
            "idnumber": id,
            "fullName": fullName,
            "gender": gender,
            "facePic": facePic,
            "classGroup": "EMPLOYEE",
            "gate": gate + " - " + time,
            "qrcode": qrcode,
            "datetime": datetime.toIso8601String().toString().substring(0, 10),
            "affiliation": office,
            "appointment": position
          };

          dynamic _res = await _sendNotification(personA);

          dynamic _resp = await _sendVerification(verifyPersonA);

          // end post verifications

          // end employee section

        } else if (sCode.contains(':22211')) {
          // qrcode from email / from cellphone

          dio.interceptors.add(
            RetryOnConnectionChangeInterceptor(
              requestRetrier: DioConnectivityRequestRetrier(
                dio: Dio(),
                connectivity: Connectivity(),
              ),
            ),
          );

          dio.options.headers["Accept"] = "application/json";

          Response response = await dio.post(
              "https://events.op-vms.gov.ph/verifyvisitorv2",
              data: {"qrcode": sCode});

          // handle not found
          if (response.data == null) {
            return Weather.notFound();
          }

          Map data = response.data;

          if (data['success'] == false) {
            return Weather.notFound();
          }

          // bool isVIP = false;
          String _theTime = _time.toUpperCase();
          final containsVIP = _theTime.contains('VIP');

          if (containsVIP && data['doc']['profile']['type'] != 'VIP') {
            return Weather.notFound();
          }

          if (!containsVIP && data['doc']['profile']['type'] == 'VIP') {
            return Weather.notFound();
          }

          // use visitor profile
          // fullName = data['doc']['dept_to_visit'] +
          //     ' : ' + data['doc']['time_start'] + ' - ' + data['doc']['time_end'];
          fullName = data['doc']['dept_to_visit'] +
              ' : ' +
              data['doc']['visit_date'].toString().substring(0, 10);
          position = data['doc']['profile']['fullname'] +
              ' - ' +
              data['doc']['purpose'];
          // office = data['doc']['visit_date'].toString().substring(0, 10) +
          //     ' - ' + data['doc']['person_to_visit'] + ' - ' + data['doc']['profile']['company'];
          office = 'From: ' +
              data['doc']['profile']['company'] +
              ' - Visiting: ' +
              data['doc']['person_to_visit'];
          // end if clause
          classGroup = 'GUEST';
          placeHolder = 'male.jpg';
          if (data['gender'].toString().trim() == 'male') {
            placeHolder = 'male.jpg';
          } else {
            placeHolder = 'female.jpg';
          }
          gender = 'male';
          // for socket
          id = data['doc']['_id'].toString();
          profileid = data['doc']['profile']['_id'];
          qrcode = data['doc']['qrcode'];
          // String _facePic = 'http://192.168.23.145/vmsphoto.jpg'; // data['photothumbnailurl'];
          String _facePic =
              "http://192.168.64.150:364/api/v1/ciss/getPhoto?id=${profileid}"; //'http://192.168.64.150:3100/' + profileid + '.jpg';
          // String _facePic = "https://images.pexels.com/photos/6912822/pexels-photo-6912822.jpeg?auto=compress&cs=tinysrgb&w=960&h=640&dpr=1";
          facePic = _facePic;
          // facePic = _facePic.replaceAll(
          //     'http://192.168.23.60/', 'http://58.69.10.203/');

          // thePhoto = "http://58.69.10.194/api/v1/ciss/getPhoto?id=${profileid}";

          thePhoto =
              "https://events.op-vms.gov.ph/api/visitorphoto?id=${profileid}";

          var feedFullname = data['doc']['profile']['fullname'] +
              ' - ' +
              data['doc']['dept_to_visit'];

          var verifyFullname = data['doc']['profile']['fullname'] +
              ' - ' +
              data['doc']['profile']['company'];
          var verifyAffiliation = 'Visiting: ' +
              data['doc']['dept_to_visit'] +
              ' - ' +
              data['doc']['person_to_visit'];
          var verifyAppointment = 'Visit Date: ' +
              data['doc']['visit_date'].toString().substring(0, 10) +
              ' - Purpose: ' +
              data['doc']['purpose'];

          var datetime = new DateTime.now();

          /*
        * colors values should come from
        * colorN's equivalent enum value
        */
          /*
        * create a function to convert colors
        */
          one = Colors.green;
          two = Colors.blue;
          three = Color.fromRGBO(255, 255, 255, 0.87);
          four = Colors.red;

          dio.interceptors.removeLast(); // kinomment jan 19 2023 11.48 am
          dio = null; // kinomment jan 19 2023 11.09 am

          gate = _gate;

          String time;
          time = _time;

          dynamic personFlop = {
            "id": id,
            "username": time
          };

          dynamic personS = {
            "id": id,
            "profileid": profileid,
            "name": feedFullname,
            "gender": gender,
            "imagepath": facePic,
            "distinction": "GUEST",
            "gate": gate + " - " + time,
            "qrcode": qrcode,
            "datetime": datetime.toIso8601String(),
            "completed": false
          };

          // post verifications

          dynamic verifyPersonS = {
            "idnumber": id,
            "fullName": verifyFullname,
            "gender": "male",
            "facePic": facePic,
            "classGroup": "VISITOR",
            "gate": gate + " - " + time,
            "qrcode": qrcode,
            "datetime": datetime.toIso8601String().toString().substring(0, 10),
            "affiliation": verifyAffiliation,
            "appointment": verifyAppointment
          };

          dynamic _flop = await _sendToFlop(personFlop);

          dynamic _res = await _sendNotification(personS);

          dynamic _resp = await _sendVerification(verifyPersonS);

          // end post verifications

          // end internet visitor section

        } else {
          // qrcode from visitor tag issued by psg

          // FormData formData = new FormData.fromMap({
          //   "code": sCode // hmac
          // });

          dio.interceptors.add(
            RetryOnConnectionChangeInterceptor(
              requestRetrier: DioConnectivityRequestRetrier(
                dio: Dio(),
                connectivity: Connectivity(),
              ),
            ),
          );

          dio.options.headers["Accept"] = "application/json";

          // Response response = await dio
          //     .post("http://58.69.10.194/verifyvisitor", data: {"code": hmac});

          Response response = await dio.post(
              "https://events.op-vms.gov.ph/verifyvisitor",
              data: {"code": hmac});

          // handle not found
          if (response.data == null) {
            return Weather.notFound();
          }

          Map data = response.data;

          if (data['success'] == false) {
            return Weather.notFound();
          }

          // use visitor profile
          // fullName = data['doc']['dept_to_visit'] +
          //     ' : ' + data['doc']['time_start'] + ' - ' + data['doc']['time_end'];
          fullName = data['doc']['dept_to_visit'] +
              ' : ' +
              data['doc']['visit_date'].toString().substring(0, 10);
          position = data['doc']['profile']['fullname'] +
              ' - ' +
              data['doc']['purpose'];
          // office = data['doc']['visit_date'].toString().substring(0, 10) +
          //     ' - ' + data['doc']['person_to_visit'] + ' - ' + data['doc']['profile']['company'];
          office = 'From: ' +
              data['doc']['profile']['company'] +
              ' - Visiting: ' +
              data['doc']['person_to_visit'];
          // end if clause
          classGroup = 'GUEST';
          placeHolder = 'male.jpg';
          if (data['gender'].toString().trim() == 'male') {
            placeHolder = 'male.jpg';
          } else {
            placeHolder = 'female.jpg';
          }
          gender = 'male';
          // for socket
          id = data['doc']['_id'].toString();
          profileid = data['doc']['profile']['_id'];
          qrcode = data['doc']['qrcode'];
          // String _facePic = 'http://192.168.23.145/vmsphoto.jpg'; // data['photothumbnailurl'];
          String _facePic =
              "http://192.168.64.150:364/api/v1/ciss/getPhoto?id=${profileid}"; //'http://192.168.64.150:3100/' + profileid + '.jpg';
          // String _facePic = "https://images.pexels.com/photos/6912822/pexels-photo-6912822.jpeg?auto=compress&cs=tinysrgb&w=960&h=640&dpr=1";
          facePic = _facePic;
          // facePic = _facePic.replaceAll(
          //     'http://192.168.23.60/', 'http://58.69.10.203/');

          // thePhoto = "http://58.69.10.194/api/v1/ciss/getPhoto?id=${profileid}";

          thePhoto =
              "https://events.op-vms.gov.ph/api/visitorphoto?id=${profileid}";

          var feedFullname = data['doc']['profile']['fullname'] +
              ' - ' +
              data['doc']['dept_to_visit'];

          var verifyFullname = data['doc']['profile']['fullname'] +
              ' - ' +
              data['doc']['profile']['company'];
          var verifyAffiliation = 'Visiting: ' +
              data['doc']['dept_to_visit'] +
              ' - ' +
              data['doc']['person_to_visit'];
          var verifyAppointment = 'Visit Date: ' +
              data['doc']['visit_date'].toString().substring(0, 10) +
              ' - Purpose: ' +
              data['doc']['purpose'];

          var datetime = new DateTime.now();

          /*
        * colors values should come from
        * colorN's equivalent enum value
        */
          /*
        * create a function to convert colors
        */
          one = Colors.green;
          two = Colors.blue;
          three = Color.fromRGBO(255, 255, 255, 0.87);
          four = Colors.red;

          dio.interceptors.removeLast(); // kinomment jan 19 2023 11.48 am
          dio = null; // kinomment jan 19 2023 11.09 am

          gate = _gate;

          String time;
          time = _time;

          // upload picture of visitor to 23.145
          // String thePic = 'http://192.168.64.150:3100/' + profileid + '.jpg';

          // get picture from api
          // dio.interceptors.add(
          //   RetryOnConnectionChangeInterceptor(
          //     requestRetrier: DioConnectivityRequestRetrier(
          //       dio: Dio(),
          //       connectivity: Connectivity(),
          //     ),
          //   ),
          // );
          // Response<List<int>> rs = await Dio().get<List<int>>("http://192.168.64.150:364/api/v1/ciss/getPhoto", queryParameters: {'id': profileid},
          //   options: Options(responseType: ResponseType.bytes), // set responseType to `bytes`
          // );

          // write to local storage
          // await writeContent(rs.data);
          // dio.interceptors.removeLast();
          // dio = null;

          // then upload the mother father
          // final file = await _localFile;
          // String thePic = await uploadImage(file);

          dynamic personS = {
            "id": id,
            "profileid": profileid,
            "name": feedFullname,
            "gender": gender,
            "imagepath": facePic,
            "distinction": "GUEST",
            "gate": gate + " - " + time,
            "qrcode": qrcode,
            "datetime": datetime.toIso8601String(),
            "completed": false
          };

          // format to use
          // verifyPerson = {
          //   "idnumber": id,
          //   "fullName": verifyFullname,
          //   "gender": "male",
          //   "facePic": facePic,
          //   "classGroup": "GUEST",
          //   "gate": gate + ' - ' + time,
          //   "qrcode": qrcode,
          //   "datetime": datetime.toIso8601String().toString().substring(0, 10),
          //   "affiliation": verifyAffiliation,
          //   "appointment": verifyAppointment
          // };

          // post verifications

          dynamic verifyPersonS = {
            "idnumber": id,
            "fullName": verifyFullname,
            "gender": "male",
            "facePic": facePic,
            "classGroup": "VISITOR",
            "gate": gate + " - " + time,
            "qrcode": qrcode,
            "datetime": datetime.toIso8601String().toString().substring(0, 10),
            "affiliation": verifyAffiliation,
            "appointment": verifyAppointment
          };

          dynamic _res = await _sendNotification(personS);

          dynamic _resp = await _sendVerification(verifyPersonS);

          // end post verifications

          // end visitor section

        }

        // VISITOR BS
        // dynamic person = {
        //   idnumber, // empno or other id number | string | not unique
        //   fullName, string | not unique
        //   gender, string | not unique
        //   facePic, string | not unique
        //   classGroup, // OP EMPLOYEE or VISITOR | string not unique
        //   gate, string | not unique
        //   qrcode, string | not unique
        //   datetime, // date and time of reading | datetime
        //   affiliation, // office if employee. Affiliation and destination office if visitor | string | not unique
        //   appointment, // position if employee. Time range of visit and purpose if visitor | string | not unique
        // };

        // VISITOR BS POST
        // FormData formData = new FormData.fromMap({
        //   "name": "wendux",
        //   "age": 25,
        // });

        // Response response = await dio.post(url, data: formData);

        // response = await dio.post(
        //   "http://www.dtworkroom.com/doris/1/2.0.0/test",
        //   data: {"aa": "bb" * 22},
        //   onSendProgress: (int sent, int total) {
        //     print("$sent $total");
        //   },
        // );

        return Weather(
            sCode: sCode,
            fullName: fullName,
            position: position,
            office: office,
            classGroup: classGroup,
            facePic: thePhoto,
            placeHolder: placeHolder,
            gender: gender,
            one: one,
            two: two,
            three: three,
            four: four,
            id: id,
            profileid: profileid,
            qrcode: qrcode,
            gate: gate);
      },
    );
  }

  Future<String> uploadImage(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
      "filename": thefilename,
    });

    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );

    Response response =
        await dio.post("https://events.op-vms.gov.ph/upload", data: formData);

    String path = response.data['path'];

    dio.interceptors.removeLast();
    dio = null;

    return path;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$thefilename');
  }

  Future<File> writeContent(bytes) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsBytes(bytes);
  }

  Future<Uint8List> readcontent() async {
    try {
      final file = await _localFile;
      // Read the file
      Uint8List contents = await file.readAsBytes();
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return null;
    }
  }

  // send to flop
  Future<dynamic> _sendToFlop(dynamic person) async {
    var uri = Uri(scheme: 'https', host: 'events.op-vms.gov.ph', path: '/sendtoflop');

    var body = json.encode(person);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(uri, headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var _res = json.decode(response.body);

    return _res;
  }
  // end send to flop

  // send verification
  Future<dynamic> _sendVerification(dynamic person) async {
    var uri = Uri(scheme: 'https', host: 'events.op-vms.gov.ph', path: '/log');

    var body = json.encode(person);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(uri, headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var _res = json.decode(response.body);

    return _res;
  }
  // end send verification

  // send notification
  Future<dynamic> _sendNotification(dynamic person) async {
    var uri =
        Uri(scheme: 'https', host: 'events.op-vms.gov.ph', path: '/cissnotify');

    var body = json.encode(person);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(uri, headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var _res = json.decode(response.body);

    return _res;
  }
  // end send notification

  Future<String> _tokenRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 'an invalid token';
    print(token);
    return token;
  }

  Future<String> _gateRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('location') ?? 'OP';
    print(location);
    return location;
  }

  Future<String> _timeRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final time = prefs.getString('time') ?? 'Juan';
    print(time);
    return time;
  }

  // @override
  Future<Weather> oldFetchWeather(String sCode) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 2),
      () async {
        /*
        * start to get data from api
        */

        String fullName;
        String position;
        String office;
        String classGroup;
        String facePic;
        String placeHolder;
        String gender;

        /*
        * use enum to transform colorN
        * to a color object below
        */
        String color1;
        String color2; // data coming from api
        String color3; // as hex color value
        String color4;

        // final random = Random();

        // Simulate some network error
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }

        /*
        * Since we're inside a fake repository, we need to cache the temperature
        * in order to have the same one returned in for the detailed weather
        * cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();
        */

        final _random = new Random();

        /*
        * Generates a positive random integer uniformly distributed on the range
        * from [min], inclusive, to [max], exclusive.
        */

        int next(int min, int max) => min + _random.nextInt(max - min);

        int intNow = next(1, 3);
        String genderNow = genderMap[intNow];
        int picRand = next(1, 5);
        String picNow =
            genderNow == 'male' ? maleMap[picRand] : femaleMap[picRand];
        String placeholderNow = placeholderMap[genderNow];

        const faker = Faker();

        // uncomment lines below for ciss API

        // dio = Dio();

        // dio.interceptors.add(
        //   RetryOnConnectionChangeInterceptor(
        //     requestRetrier: DioConnectivityRequestRetrier(
        //       dio: Dio(),
        //       connectivity: Connectivity(),
        //     ),
        //   ),
        // );

        // Response response = await dio.get('http://worldtimeapi.org/api/ip');

        // handle not found
        // if (response.data == null) {
        //   return Weather.notFound();
        // }

        // end uncomment lines below for ciss API

        fullName = faker.person.name();
        position = faker.job.title();
        office = faker.company.name();
        classGroup = faker.sport.name();
        facePic = picNow;
        placeHolder = placeholderNow;
        gender = genderNow;

        // additional fields for socket io
        // to add to Weather class
        //
        // id
        // profileid
        // gate
        // qrcode
        // datetime
        var datetime = new DateTime.now();

        /*
          * colors values should come from
          * colorN's equivalent enum value
          */
        Color one = Colors.green;
        Color two = Colors.blue;
        Color three = Color.fromRGBO(255, 255, 255, 0.87);
        Color four = Colors.red;

        // uncomment lines below for ciss API

        // dio.interceptors.removeLast();
        // dio = null;

        // end uncomment lines below for ciss API

        // dynamic person = {
        //   'id': sCode,
        //   'profileid': 'replace-this-value' + sCode,
        //   'name': fullName,
        //   'gender': gender,
        //   'imagepath': facePic,
        //   'distinction': classGroup,
        //   'gate': 'GATE-7',
        //   'qrcode': 'replace-this-value',
        //   'datetime': datetime,
        //   'completed': false,
        // };

        // socketService.deliverSocketMessage('list:feed', person);

        // // Return "fetched" weather
        return Weather(
          sCode: sCode,
          fullName: fullName,
          position: position,
          office: office,
          classGroup: classGroup,
          facePic: facePic,
          placeHolder: placeHolder,
          gender: gender,
          one: one,
          two: two,
          three: three,
          four: four,
          id: 'id',
          profileid: 'profileid',
          qrcode: 'qrcode',
          gate: 'gate',
        );
      },
    );
  }
}

class NetworkError extends Error {}
