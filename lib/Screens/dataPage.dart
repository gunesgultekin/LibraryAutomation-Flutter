// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Screens/constantAppBar.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
import 'package:libraryautomation/Screens/dashboard.dart';
import 'package:libraryautomation/Utils/AuthService.dart';
import 'package:libraryautomation/Utils/dataSourceUser.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../Utils/AuthorProvider.dart';
import '../Utils/BookProvider.dart';
import '../Utils/dataSourceAdmin.dart';

class dataPage extends StatefulWidget {
  late String userName;
  late List<DataRow> dataRows = <DataRow>[];
  dataPage({required this.userName});

  @override
  State<dataPage> createState() => _dataPageState(userName: userName);
}

class _dataPageState extends State<dataPage> {
  //late StreamController<int> stream_controller;

  AuthSevice authSevice = AuthSevice();
  late String role;

  late Future _future1;

  Future<String> dataResponse() async {
    Response response = await bookProvider.getAllBooks();
    String responseData = response.body;
    var currentResponse = await jsonDecode(responseData);
    return currentResponse;
  }

  Future<int> checkDbSizeChanges() async {
    Response response = await bookProvider.getDbSize();
    String responseData = response.body;
    var currentResponse = await jsonDecode(responseData);
    int initialDbSize = int.parse(currentResponse);
    while (true) {
      Response response1 = await bookProvider.getDbSize();
      String responseData1 = response1.body;
      var currentResponse1 = await jsonDecode(responseData1);
      int currentDbSize = int.parse(currentResponse1);
      if (currentDbSize != initialDbSize) {
        return 1;
      } else if (currentDbSize == initialDbSize) {
        exit(0);
      }
    }
  }

  Stream<dynamic> generateNumbers = (() async* {
    Random random = Random();

    for (int i = 1; i <= 0x10; i++) {
      yield random.nextInt(0X100);
      //await Future<void>.delayed(Duration(seconds: 2));
    }
  })();

  Stream<dynamic> checkDbChanges = (() async* {
    Random random = Random();
    for (int i = 1; i <= 0xFFFFF; i++) {
      yield random.nextInt(6000);
      await Future<void>.delayed(Duration(seconds: 1));
    }
  })();

  late DataTableSource _dataAdmin;
  late DataTableSource _dataUser;

  Future<void> authorizeTable(String role) async {
    Response response = await bookProvider.getAllBooks();
    String responseData = response.body;
    var currentResponse = await jsonDecode(responseData);
    if (role == "Admin") {
      datasource = dataSourceAdmin(
          userName: widget.userName, currentResponse: currentResponse);
    } else if (role == "User") {
      datasource = dataSourceUser(
          userName: widget.userName, currentResponse: currentResponse);
    }
  }

  double totalBorrows = 10;
  int dataRowKey = 1;
  int pageViewKey = 1;

  CarouselController _carouselController = CarouselController();
  int carouselIndex = 0;

  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();

  late String userName;

  late String name;
  late String surname;
  late String bookName;
  late int bookID;
  late String releaseDate;
  late DateTime createTime;
  late DateTime updateTime;
  late String updater;
  late bool isDeleted;
  late int authorID;
  late int genreID;
  late int userID;
  late bool isBorrowed;
  late DateTime borrowDate;
  late String authorName;
  late String authorSurname;
  late String coverPhotoLink;
  late String genreName;

  List<Widget> allBooks = <Widget>[];

  _dataPageState({required this.userName});
  late double currentScreenWidth;
  BookProvider bookProvider = BookProvider();
  AuthorProvider authorProvider = AuthorProvider();

  Color _getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    //return Colors.green; // Use the default value.
    return Colors.transparent;
  }

  static late Future futureData;
  late DataTableSource datasource;

  Future<int> displayInfo() async {
    Response response = await authSevice.getUserInfo(widget.userName);
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    try {
      name = currentResponse["name"];
      surname = currentResponse["surname"];
      role = currentResponse["role"]["name"];
      await authorizeTable(role);
    } catch (e) {}
    return 1;
  }

  bool selected = true;

  @override
  void dispose() {
    // TODO: implement dispose
    //stream_controller.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //stream_controller = StreamController<int>.broadcast();
    futureData = displayInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Future.wait([futureData]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return StreamBuilder(
                    stream: generateNumbers,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitFadingCircle(color: Colors.blue),
                          ],
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return SpinKitFadingCircle(color: Colors.blue);
                        } else if (snapshot.hasData) {
                          return PaginatedDataTable2(
                              autoRowsToHeight: true,
                              dividerThickness: 1,
                              header: Center(
                                child: Text(
                                  "All Books",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              rowsPerPage: 15,
                              source: datasource,
                              showCheckboxColumn: false,
                              columns: [
                                DataColumn2(
                                  label: Text(''),
                                ),
                                DataColumn2(
                                  label: Text('Name'),
                                ),
                                DataColumn2(
                                  label: Text('Release Date'),
                                ),
                                DataColumn2(
                                  label: Text('Create Time'),
                                ),
                                DataColumn2(
                                  label: Text('Update Time'),
                                ),
                                DataColumn2(
                                  label: Text('Author'),
                                ),
                                DataColumn2(
                                  label: Text('Genre'),
                                ),
                                DataColumn2(
                                  label: Text(''),
                                ),
                                DataColumn2(
                                  label: Text(''),
                                ),
                              ],
                              //dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
                              //rows: dataRows,
                              key: ValueKey(pageViewKey));
                        } else {
                          return SpinKitChasingDots(color: Colors.red);
                        }
                      } else {
                        return SpinKitChasingDots(color: Colors.red);
                      }
                    });
              } else {
                return SpinKitChasingDots(
                  color: Colors.red,
                );
              }
            }));
  }
}
