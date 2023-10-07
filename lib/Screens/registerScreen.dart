import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libraryautomation/Screens/loginScreen.dart';
import 'package:video_player/video_player.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  late bool hidePassword;
  String passwordState = "Show Password";
  TextEditingController _passwordController = TextEditingController();

  late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: _controller.value.size?.width ?? 0,
              height: _controller.value.size?.height ?? 0,
              child: VideoPlayer(_controller),
            ),
          )),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.15,
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 5),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_box_rounded,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 80),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 5,
                          child: TextField(
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              helperText: "Enter your first name",
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
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 80),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 5,
                          child: TextField(
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              helperText: "Enter your last name",
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
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.app_registration_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 80),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 5,
                          child: TextField(
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              helperText: "Enter a username",
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
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.password,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 80),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 5,
                          child: TextField(
                            controller: _passwordController,
                            enableSuggestions: false,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              helperText: "Create a password",
                              helperStyle: TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 10,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    TextButton(
                      onPressed: () => {},
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 17.5),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account ?",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 80),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        loginScreen())),
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 14.5,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("Assets/backgroundVideo.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    hidePassword = true;
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}
