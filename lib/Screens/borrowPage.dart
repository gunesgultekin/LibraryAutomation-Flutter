// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart%20';
import 'package:get/get_core/src/get_main.dart';
import 'package:libraryautomation/Screens/constantAppBar.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
import 'package:libraryautomation/Utils/AuthService.dart';
import 'package:libraryautomation/Utils/BookProvider.dart';
import 'package:video_player/video_player.dart';

class borrowPage extends StatefulWidget {
  late String userName;
  borrowPage({required this.bookID, required this.userName});
  late int bookID;

  @override
  State<borrowPage> createState() => _borrowPageState();
}

class _borrowPageState extends State<borrowPage> {
  _borrowPageState();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    _controller.dispose();
  }

  BookProvider bookProvider = BookProvider();
  late String coverPhotoLink;
  late String bookName;

  AuthSevice authSevice = AuthSevice();

  Future<void> borrow(int bookID) async {
    var response = await authSevice.getUserInfo(widget.userName);
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);

    int userID = currentResponse["id"];
    bookProvider.borrow(bookID, userID);
    await getBook(bookID);
  }

  Future<void> getBook(int bookID) async {
    var response = await bookProvider.getBook(bookID);
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);

    try {
      coverPhotoLink = currentResponse["coverPhoto"];
      bookName = currentResponse["name"];
    } catch (e) {}
  }

  late Future future;
  @override
  void initState() {
    super.initState();
    future = borrow(widget.bookID);
  }

  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(username: widget.userName),
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: Container(
                  color: Colors.black,
                  child: Center(
                    child: Container(
                      color: Colors.black87,
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 10),
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      coverPhotoLink,
                                    ),
                                    fit: BoxFit.fitHeight)),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 150),
                          Text(
                            "Succesfully borrowed ${bookName}.",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 30),
                          Text(
                            "Borrow Date: ${DateTime.now()}/",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 17.5,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 30),
                          Text(
                            "Borrower: ${widget.userName}",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 30),
                          Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.warning,
                                color: const Color.fromARGB(255, 255, 17, 0),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 90),
                              Text(
                                "(!) Remainder: You have 10 workdays to deliver",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 17, 0),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 30),
                          Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.warning,
                                color: Color.fromARGB(255, 172, 30, 20),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 90),
                              Text(
                                "Late fee is determined as 10 ₺ (TL) starting from the deadline date.",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 172, 30, 20),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Checking the availability of book",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      SpinKitRing(
                        color: Colors.blue,
                        size: 100,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
