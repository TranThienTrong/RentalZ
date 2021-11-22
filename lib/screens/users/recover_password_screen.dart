import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

class RecoverPasswordScreen extends StatefulWidget {
  RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  GlobalKey<FormState> _recoverPasswordFormKey = new GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isLoading == true
          ? CircularProgress()
          : Container(
              width: _deviceWidth,
              height: _deviceHeight,
              padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.yellowAccent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Form(
                      onChanged: () {
                        _recoverPasswordFormKey.currentState!.save();
                      },
                      key: _recoverPasswordFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: buildTextFormField("email"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: _deviceWidth,
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
                    child: MaterialButton(
                      onPressed: () async {
                        var connectivity =
                            await Connectivity().checkConnectivity();
                        if (connectivity == ConnectivityResult.none) {
                          return;
                        }
                        if (_recoverPasswordFormKey.currentState!.validate()) {
                          _recoverPasswordFormKey.currentState!.save();
                          setState(
                            () => isLoading = true,
                          );

                          await _firebaseAuth.sendPasswordResetEmail(
                              email: email!);

                          setState(
                            () {
                              isLoading = false;
                              Fluttertoast.showToast(
                                  msg: "Check your email to reset password",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.lightGreenAccent,
                                  textColor: Colors.white,
                                  fontSize: 20.0);
                            },
                          );
                        }
                      },
                      color: Colors.lightBlue,
                      child: Text(
                        "RESET PASSWORD",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /* ___________________________ Widget Builder ___________________________ */
  Widget? buildTextFormField(String fieldType) {
    if (fieldType == "email") {
      return TextFormField(
        style: TextStyle(color: Colors.indigo),
        decoration: new InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Email',
          contentPadding: const EdgeInsets.only(left: 10.0),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.lightBlueAccent),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: new BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter Email';
          } else if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'Email not valid';
          }
          return null;
        },
        onSaved: (value) {
          setState(
            () {
              email = value;
            },
          );
        },
        cursorColor: Colors.indigo,
      );
    }
  }
}
