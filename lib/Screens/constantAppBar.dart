import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart%20';
import 'package:get/get_core/src/get_main.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
import 'package:libraryautomation/Screens/dashboard.dart';

import '../Utils/AuthService.dart';

class constantAppBar extends StatefulWidget implements PreferredSizeWidget {
  late String username;
  constantAppBar({required this.username});

  @override
  State<constantAppBar> createState() => _constantAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(100, 40);
}

class _constantAppBarState extends State<constantAppBar> {
  AuthSevice authSevice = AuthSevice();

  late String name;
  late String surname;
  late Response response;
  late String responseData;
  late var currentResponse;
  late List<dynamic> myBooks;
  late String userName = widget.username;

  Future<void> displayInfo() async {
    var response = await authSevice.getUserInfo(userName);
    responseData = response.body;
    currentResponse = jsonDecode(responseData);
    try {
      name = currentResponse["name"];
      surname = currentResponse["surname"];
      myBooks = currentResponse["bookList"];
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = displayInfo();
  }

  String providePhotoLink() {
    try {
      return currentResponse["profilePhoto"];
    } catch (e) {
      return "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/120px-User-avatar.svg.png?20201213175635";
    }
  }

  late Future _future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AppBar(
              actions: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      "${name} ${surname}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(providePhotoLink())),
                        )),
                    IconButton(
                      onPressed: () =>
                          {Get.dialog(profilePopUp(username: widget.username))},
                      icon: Icon(FontAwesomeIcons.anglesDown),
                    ),
                  ],
                )
              ],
              backgroundColor: Color.fromARGB(210, 33, 46, 166),
              title: Flex(
                direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.window_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 125),
                  Text(
                    "Library Automation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SpinKitDualRing(color: Colors.black);
          }
        });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(40);
}
