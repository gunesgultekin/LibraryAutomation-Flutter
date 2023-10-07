import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart%20';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:libraryautomation/Screens/dashboard.dart';
import 'package:libraryautomation/Screens/mainScaffold.dart';

import 'package:libraryautomation/Screens/registerScreen.dart';
import 'package:libraryautomation/Utils/AuthService.dart';
import 'package:video_player/video_player.dart';

class loginScreen extends StatefulWidget {
  //const mobileLoginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  late String jwtToken;

  late VideoPlayerController _controller;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String username;
  late String password;
  String loginMessage = "";
  Color loginMessageColor = Colors.white;
  late bool showWarning;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    showWarning = false;
  }

  void navigateDashboard() {}

  Future<void> updateScreen() async {
    AuthSevice authSevice = new AuthSevice();
    username = usernameController.text;
    password = passwordController.text;
    try {
      jwtToken = await authSevice.validateAuth(username, password);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      String authLevel = decodedToken.values.elementAt(2);
      Get.to(mainScaffold(
          body: dashboard(userName: username), username: username));
    } catch (e) {
      setState(() {
        showWarning = true;
        loginMessage = "Invalid username or password";
        loginMessageColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("Assets/backgroundImage.jpg"),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              )),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.25,
                color: Colors.black87,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                      Icon(
                        Icons.account_balance_sharp,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 20),
                      Text(
                        "Library Automation",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            shadows: [
                              Shadow(color: Colors.blue, blurRadius: 30)
                            ]),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      Text(
                        "Welcome ! Please login to continue",
                        style: TextStyle(color: Colors.white, fontSize: 14.5),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 45),
                      Flex(
                        mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Visibility(
                            visible: showWarning,
                            child: Icon(
                              Icons.warning_amber_outlined,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 70),
                          Text(
                            loginMessage,
                            style: TextStyle(
                              color: loginMessageColor,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 32.5),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                        width: MediaQuery.of(context).size.width / 5,
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            helperText: "Enter your username",
                            helperStyle: TextStyle(
                              color: CupertinoColors.systemGrey2,
                              fontSize: 10,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 80),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 5,
                          child: TextField(
                            decoration: InputDecoration(
                              helperText: "Enter your password",
                              helperStyle: TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 10,
                              ),
                            ),
                            controller: passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )),
                      SizedBox(height: MediaQuery.of(context).size.height / 15),
                      TextButton(
                        onPressed: updateScreen,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 80),
                          TextButton(
                            onPressed: () => {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          registerScreen()))
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
