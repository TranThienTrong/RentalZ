import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rental_apartments_finder/models/users/my_user.dart';
import 'package:rental_apartments_finder/models/users/singned_account.dart';
import 'package:rental_apartments_finder/services/user_service.dart';
import 'package:rental_apartments_finder/providers/auth_provider.dart';
import 'package:rental_apartments_finder/widgets/progress.dart';

import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /* Responsive Design */
  double _deviceWidth = 0;
  double _deviceHeight = 0;

  /* Login helper */
  FirebaseUserService _firebaseHelper = new FirebaseUserService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late AuthProvider authProvider;

  /* User */
  GoogleSignInAccount? _currentUser;
  MyUser? signedUser;
  SignedAccount signedAccount = SignedAccount.instance;

  /* Other attributes */
  GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  String? email;
  String? password;
  bool isAuthenticating = false;

  @override
  void initState() {
    authProvider = AuthProvider(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isAuthenticating == true
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
                    ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Form(
                      onChanged: () {
                        _loginFormKey.currentState!.save();
                      },
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: buildTextFormField("email"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: buildTextFormField("password"),
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

                        if (_loginFormKey.currentState!.validate()) {
                          _loginFormKey.currentState!.save();
                          setState(() {
                            isAuthenticating = true;
                          });
                          await authProvider.loginWithEmailAndPassword(
                              email: email!, password: password!);
                          isAuthenticating = false;
                        }
                      },
                      color: Colors.lightBlue,
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: _deviceWidth,
                    padding: EdgeInsets.all(5.0),
                    child: SignInButton(
                      Buttons.Google,
                      elevation: 0.0,
                      text: "Sign in with Google",
                      onPressed: () async {
                        setState(() {
                          isAuthenticating = true;
                        });
                        await authProvider.loginWithGoogle();
                        isAuthenticating = false;
                      },
                    ),
                  ),
                  Container(
                    width: _deviceWidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/recover_password_screen');
                            },
                            child: Text(
                              "FORGOT PASSWORD",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
    );
  }

  /* ___________________________ Widget Builder ___________________________ */
  Widget buildTextFormField(String fieldType) {
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
          setState(() {
            email = value;
          });
        },
        cursorColor: Colors.indigo,
      );
    } else {
      return TextFormField(
        style: TextStyle(color: Colors.indigo),
        obscureText: true,
        decoration: new InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password',
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
            return 'Please enter Password';
          } else if (value.length < 6) {
            return 'Password too short';
          }
          return null;
        },
        onSaved: (value) {
          setState(
            () {
              password = value;
            },
          );
        },
        cursorColor: Colors.indigo,
      );
    }
  }

/* ___________________________ Login Helper Function ___________________________ */

}
