// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:flutter_animated_icons/lottieflow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libraryautomation/Screens/dashboard.dart';
import 'package:libraryautomation/Screens/mainScaffold.dart';

import 'browsePage.dart';
import 'dataPage.dart';

class constantDrawer extends StatefulWidget {
  constantDrawer({required this.userName}) {}
  late String userName;

  @override
  State<constantDrawer> createState() => _constantDrawerState();
}

class _constantDrawerState extends State<constantDrawer> {
  Route navigateDataPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          dataPage(userName: widget.userName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Route navigateBrowsePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          browsePage(userName: widget.userName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  //dashboard _dashboard = dashboard(userName: "ggultekin");

  //mainScaffold scaffold = mainScaffold(body: dashboard(userName: "ggultekin"));

  //final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Flex(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              Container(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    Icon(
                      FontAwesomeIcons.database,
                      color: Colors.blueAccent,
                      opticalSize: 50,
                      size: 35,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 100),
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                dataPage(userName: widget.userName))),
                      },
                      child: Text(
                        "Database",
                        style: TextStyle(color: Colors.blue, fontSize: 17.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Icon(
                    FontAwesomeIcons.book,
                    color: Colors.redAccent,
                    opticalSize: 50,
                    size: 35,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 100),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => browsePage(
                                userName: widget.userName,
                              ))),
                    },
                    child: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.redAccent, fontSize: 17.5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.menu_book_sharp,
                    color: Color.fromARGB(255, 255, 149, 0),
                    opticalSize: 50,
                    size: 35,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 100),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => browsePage(
                                userName: widget.userName,
                              ))),
                    },
                    child: Text(
                      "Authors",
                      style: TextStyle(color: Colors.grey, fontSize: 17.5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.dashboard,
                    color: Colors.purple,
                    opticalSize: 50,
                    size: 35,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 100),
                  TextButton(
                    onPressed: () => {},
                    child: Text(
                      "Dashboard",
                      style: TextStyle(color: Colors.purple, fontSize: 17.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
