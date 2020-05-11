import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController()
    ..text = "";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Verify using Pin'),
        elevation: 8.0,
        titleSpacing: 2.0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: FlareActor(
                  "assets/otp/otp.flr",
                  animation: "otp",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Pin Number Verification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 8,
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                        text: '0927XXXXXXX',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 30,
                ),
                child: PinCodeTextField(
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.box,
                  animationDuration: Duration(milliseconds: 300),
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  backgroundColor: Color.fromARGB(255, 18, 18, 18),
                  fieldWidth: 40,
                  activeFillColor: Color.fromARGB(255, 18, 18, 18),
                  activeColor: Color.fromRGBO(255, 255, 255, 0.38),
                  inactiveFillColor: Color.fromARGB(255, 18, 18, 18),
                  inactiveColor: Color.fromRGBO(255, 255, 255, 0.38),
                  selectedFillColor: Color.fromARGB(255, 18, 18, 18),
                  selectedColor: Color.fromARGB(255, 3, 218, 197),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: " RESEND",
                      recognizer: onTapRecognizer,
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 218, 197),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 30,
                ),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      // conditions for validating
                      if (currentText.length != 4 || currentText != "test") {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                          showInfoFlushbar(context);
                          // showErrorFlushbarHelper(context);
                          // showFloatingFlushbar(context);
                        });
                      } else {
                        setState(() {
                          hasError = false;
                          // scaffoldKey.currentState.showSnackBar(SnackBar(
                          //   content: Text("Aye!!"),
                          //   duration: Duration(seconds: 2),
                          // ));
                          // navigate to previous screen
                          Navigator.pop(context, {
                            'success': true,
                          });
                        });
                      }
                    },
                    child: Center(
                      child: Text(
                        "VERIFY".toUpperCase(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 18, 18, 18),
                          fontSize: 18,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 218, 197),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                  FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "1234";
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showInfoFlushbar(BuildContext context) {
    Flushbar(
      title: 'This action is prohibited',
      message: 'You entered an invalid pin',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void showErrorFlushbarHelper(BuildContext context) {
    FlushbarHelper.createError(
      title: 'Oops! Wrong PIN',
      message: 'That is an incorrect pin',
    ).show(context);
  }

  void showFloatingFlushbar(BuildContext context) {
    Flushbar(
      padding: EdgeInsets.all(10),
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.green.shade800, Colors.greenAccent.shade700],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // reverseAnimationCurve: Curves.linearToEaseOut,
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Got it!',
      message: 'You nailed it!',
    )..show(context);
  }
}
