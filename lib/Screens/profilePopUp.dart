// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Screens/dataSourceMyBooks.dart';
import 'package:libraryautomation/Screens/loginScreen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../Utils/AuthService.dart';
import '../Utils/dataSourceDashboard.dart';
import 'dataPage.dart';

class profilePopUp extends StatefulWidget {
  late String username;
  profilePopUp({required this.username});

  @override
  State<profilePopUp> createState() => _profilePopUpState();
}

class _profilePopUpState extends State<profilePopUp> {
  late String name;
  late String surname;
  late Response response;
  late String responseData;
  late var currentResponse;
  late List<dynamic> myBooks;
  late String userName = widget.username;
  AuthSevice authSevice = new AuthSevice();

  late Future _future1;
  late Future _future2;

  Future<void> displayInfo() async {
    response = await authSevice.getUserInfo(userName);
    responseData = response.body;
    currentResponse = jsonDecode(responseData);
    try {
      name = currentResponse["name"];
      surname = currentResponse["surname"];
      myBooks = currentResponse["bookList"];
    } catch (e) {}
  }

  late DataTableSource dataSource;

  //final DataTableSource dataTableSource = dataSourceMyBooks();

  @override
  void initState() {
    super.initState();
    dataSource = dataSourceMyBooks(userName: widget.username);
    _future1 = displayInfo();
  }

  String providePhotoLink() {
    try {
      return currentResponse["profilePhoto"];
    } catch (e) {
      return "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/120px-User-avatar.svg.png?20201213175635";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future1,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.all(190),
              child: Container(
                width: 180,
                height: 300,
                color: Colors.black87,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Flex(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.vertical,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 15),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 8,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(
                              providePhotoLink(),
                            ),
                            fit: BoxFit.contain,
                          )),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 25),
                        Text(
                          "${name} ${surname}",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 25),
                        Flex(
                          mainAxisAlignment: MainAxisAlignment.center,
                          direction: Axis.horizontal,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidWindowRestore,
                              color: Colors.purple,
                              opticalSize: 40,
                              size: 35,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 100),
                            TextButton(
                              onPressed: () => {
                                Get.dialog(
                                  transitionDuration:
                                      Duration(milliseconds: 575),
                                  Padding(
                                      padding: EdgeInsets.all(80),
                                      child: PreferredSize(
                                        preferredSize: Size(100, 100),
                                        child: Container(
                                          color: Colors.black87,
                                          child: PaginatedDataTable2(
                                            autoRowsToHeight: true,
                                            columnSpacing: 1,
                                            dividerThickness: 1,
                                            source: dataSource,
                                            header: Flex(
                                              direction: Axis.horizontal,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.star_half_sharp,
                                                  color: CupertinoColors
                                                      .systemIndigo,
                                                  size: 25,
                                                ),
                                                Text(
                                                  "Borrowed Books",
                                                  style: TextStyle(
                                                    color: CupertinoColors
                                                        .systemIndigo,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            fixedCornerColor:
                                                CupertinoColors.systemGrey,
                                            border: TableBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                verticalInside:
                                                    BorderSide.none),
                                            //columnSpacing: 12.5,
                                            //autoRowsToHeight: true,
                                            dataRowHeight: 50,
                                            rowsPerPage: 5,
                                            showCheckboxColumn: false,
                                            fit: FlexFit.tight,
                                            columns: [
                                              DataColumn2(
                                                fixedWidth: 80,
                                                label: Text(""),
                                              ),
                                              DataColumn2(
                                                  label: Text('Name'),
                                                  fixedWidth: 125,
                                                  onSort: (columnIndex,
                                                      ascending) {}),
                                              DataColumn2(
                                                label: Text('Author'),
                                                fixedWidth: 150,
                                              ),
                                              DataColumn2(
                                                fixedWidth: 100,
                                                label: Text('Genre'),
                                              ),
                                              DataColumn2(
                                                fixedWidth: 450,
                                                label: Text('Remaining Time'),
                                              ),
                                              DataColumn2(
                                                fixedWidth: 250,
                                                label: Text('Penalty'),
                                              ),
                                              DataColumn2(
                                                label: Text(''),
                                              ),
                                            ],
                                            //dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
                                            //rows: dataRows,
                                          ),
                                        ),
                                      )),
                                )
                              },
                              child: Text(
                                "My Books",
                                style: TextStyle(
                                    color: Colors.purple, fontSize: 17.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                          opticalSize: 40,
                          size: 35,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 100),
                        TextButton(
                          onPressed: () => {
                            Get.to(loginScreen()),
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red, fontSize: 17.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SpinKitRipple(
              color: Colors.blue,
              size: 250,
            );
          }
        });
  }
}
