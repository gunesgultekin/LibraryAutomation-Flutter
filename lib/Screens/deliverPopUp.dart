import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Screens/constantAppBar.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/dashboard.dart';
import 'package:libraryautomation/Screens/mainScaffold.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
import 'package:libraryautomation/Utils/BookProvider.dart';
import 'package:video_player/video_player.dart';

class deliverPopUp extends StatefulWidget {
  deliverPopUp({required this.bookID, required this.username});
  int bookID;
  String username;
  @override
  State<deliverPopUp> createState() => _deliverPopUpState();
}

class _deliverPopUpState extends State<deliverPopUp> {
  late Future future;

  @override
  void initState() {
    super.initState();
    future = deliver(widget.bookID);
  }

  BookProvider bookProvider = BookProvider();
  late var currrentResponse;
  late String currentPenalty = "-";

  Future<void> deliver(int bookID) async {
    Response response = await bookProvider.deliver(bookID);
    String responseData = response.body;
    currrentResponse = jsonDecode(responseData);
    currentPenalty = currrentResponse.toString();
    penaltyCheck();
  }

  late String penaltyText;
  late Icon penaltyIcon;

  void penaltyCheck() {
    if (currentPenalty == "0") {
      penaltyText = "Thanks! You don't have a late penalty";
      penaltyIcon = Icon(Icons.assignment_turned_in_rounded,
          color: const Color.fromARGB(255, 8, 243, 16), size: 45);
    } else {
      penaltyText =
          "${currentPenalty} ₺ penalty withdrawn on your registered credit card !";
      penaltyIcon = Icon(Icons.credit_card,
          color: const Color.fromARGB(255, 234, 25, 10), size: 45);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.all(300),
              child: Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          penaltyIcon,
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 75),
                          Text(penaltyText,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17.5,
                                  decoration: TextDecoration.none)),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 75),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Get.dialog(mainScaffold(
                                body: dashboard(userName: widget.username),
                                username: widget.username));
                          });
                        },
                        child: Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SpinKitCubeGrid();
          }
        });
  }
}
