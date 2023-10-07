// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libraryautomation/Screens/browseAuthors.dart';
import 'package:libraryautomation/Screens/constantAppBar.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/dashboard.dart';
import 'package:libraryautomation/Screens/mobileMainScaffold.dart';
import 'package:libraryautomation/Screens/splashPage.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'browsePage.dart';
import 'profilePopUp.dart';
import 'dataPage.dart';

class mainScaffold extends StatefulWidget {
  String username;
  late Widget? body;
  mainScaffold({required this.body, required this.username});

  static GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  State<mainScaffold> createState() => _mainScaffoldState();
}

class _mainScaffoldState extends State<mainScaffold> {
  late StreamController<int> stream_controller;

  Stream<int> generateNumbers = (() async* {
    Random random = Random();
    while (true) {
      yield random.nextInt(6000);
      await Future<void>.delayed(Duration(seconds: 60));
    }
  })();

  late Scaffold scaffold;

  late String userName;

  late Future future;

  Future<void> loadDashboard() async {
    scaffold = Scaffold(body: widget.body);
  }

  var myStreamController = StreamController<bool>.broadcast();

  @override
  void dispose() {
    // TODO: implement dispose
    stream_controller.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream_controller = StreamController<int>.broadcast();
    future = loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (MediaQuery.of(context).size.width > 900) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 9,
                      child: Drawer(
                        child: Container(
                          color: Color.fromARGB(210, 2, 16, 142),
                          child: Flex(
                            direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white24)),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.database,
                                        color: CupertinoColors.activeBlue,
                                        size: 18,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100),
                                      Expanded(child: Text("Database")),
                                    ],
                                  ),
                                  onPressed: () => {
                                    scaffold = Scaffold(
                                      body: dataPage(userName: widget.username),
                                    ),
                                    setState(() {}),
                                  },
                                ),
                              )),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 80),
                              Container(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white24)),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.dashboard,
                                        color: Colors.purple[500],
                                        size: 18,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100),
                                      Expanded(child: Text("Dashboard")),
                                    ],
                                  ),
                                  onPressed: () => {
                                    scaffold = Scaffold(
                                        body: dashboard(
                                            userName: widget.username)),
                                    setState(() {}),
                                  },
                                ),
                              )),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 80),
                              Container(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white24)),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.bookAtlas,
                                        color: CupertinoColors.activeGreen,
                                        size: 18,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100),
                                      Expanded(child: Text("Gallery")),
                                    ],
                                  ),
                                  onPressed: () => {
                                    scaffold = Scaffold(
                                      body:
                                          browsePage(userName: widget.username),
                                    ),
                                    setState(() {}),
                                  },
                                ),
                              )),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 80),
                              Container(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white24)),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        color: Color.fromARGB(255, 255, 153, 0),
                                        size: 18,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100),
                                      Expanded(child: Text("Authors")),
                                    ],
                                  ),
                                  onPressed: () => {
                                    scaffold = Scaffold(
                                      body: browseAuthorsPage(),
                                    ),
                                    setState(() {}),
                                  },
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Expanded(
                      flex: 2,
                      child: scaffold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          endDrawer: profilePopUp(username: widget.username),
          appBar: constantAppBar(username: widget.username),
          bottomNavigationBar: StreamBuilder<int>(
              stream: generateNumbers,
              initialData: 0,
              builder: (
                BuildContext context,
                AsyncSnapshot<int> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(color: Colors.blue);
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return SpinKitFadingCircle(color: Colors.blue);
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Container(
                        color: Color.fromARGB(255, 12, 56, 144),
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.assessment_outlined,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 150,
                            ),
                            Text(
                              "Active Users",
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 60,
                            ),
                            SfLinearGauge(
                              orientation: LinearGaugeOrientation.horizontal,
                              showAxisTrack: false,
                              axisTrackStyle: LinearAxisTrackStyle(
                                  gradient: LinearGradient(
                                      colors: [Colors.purple, Colors.red]),
                                  borderColor: Colors.purple,
                                  color: Colors.white24),
                              axisLabelStyle: TextStyle(color: Colors.white54),
                              minimum: 0,
                              maximum: 5000,
                              animateAxis: true,
                              animateRange: true,
                              barPointers: [
                                LinearBarPointer(
                                  enableAnimation: true,
                                  animationType: LinearAnimationType.linear,
                                  borderColor: Colors.deepPurple,
                                  animationDuration: 1250,
                                  borderWidth: 7.5,
                                  value: double.parse(snapshot.data.toString()),
                                ),
                                LinearBarPointer(
                                  enableAnimation: true,
                                  animationType: LinearAnimationType.linear,
                                  borderColor: Colors.red,
                                  animationDuration: 1250,
                                  borderWidth: 7.5,
                                  value: double.parse(snapshot.data.toString()),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 150,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SpinKitFadingCircle(color: Colors.blue);
                  }
                } else {
                  return SpinKitFadingCircle(color: Colors.blue);
                }
              }),
        );
      } else {
        return mobileMainScaffold();
      }
    });
  }
}
