//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_child_properties_last

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Screens/browsePage.dart';
import 'package:libraryautomation/Screens/constantAppBar.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
import 'package:libraryautomation/Screens/dataPage.dart';
import 'package:libraryautomation/Screens/splashPage.dart';
import 'package:libraryautomation/Utils/AuthService.dart';
import 'package:libraryautomation/Utils/AuthorProvider.dart';
import 'package:libraryautomation/Utils/BookProvider.dart';
import 'package:libraryautomation/Utils/dataSourceDashboard.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../Utils/dataSourceUser.dart';
import 'loginScreen.dart';
import 'mainScaffold.dart';

class dashboard extends StatefulWidget {
  PageController pageController = PageController();
  late String userName;

  dashboard({required this.userName});

  @override
  State<dashboard> createState() => _dashboardState(userName: userName);
}

class _dashboardState extends State<dashboard> {
  bool sort = true;

  late List<int?> popularityList;

  final DataTableSource dataTableSource = dataSourceDashboard();

  late Future future;
  double totalBorrows = 10;
  int dataRowKey = 1;
  int pageViewKey = 1;

  CarouselController _carouselController = CarouselController();
  int carouselIndex = 0;

  double value = 0;
  _dashboardState({required this.userName}) {
    popularityList = <int>[];
  }

  late double currentScreenWidth;
  BookProvider bookProvider = BookProvider();

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

  List<int?> scoreList = <int>[];
  List<Widget> allBooks = <Widget>[];

  late Response response;
  late String responseData;
  late var currentResponse;

  double rand() {
    Random random = Random();
    return double.parse(random.nextInt(40000).toString());
  }

  double res = 0;

  void loop() {
    Timer.periodic(new Duration(seconds: 3), (timer) {
      res = rand();
    });
  }

  String reviewProvider(String review) {
    if (review == null) {
      return "review Unavailable";
    } else {
      return review;
    }
  }

  String? review = "!!";
  String? authorPhoto;
  String? aboutAuthor;

  void addToAllBooks() {
    allBooks.add(
      FlipCard(
        key: ValueKey(pageViewKey),
        direction: FlipDirection.VERTICAL,
        side: CardSide.FRONT,
        front: Container(
            height: 500,
            width: 500,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(coverPhotoLink),
                    fit: BoxFit.contain,
                  )),
                ),
              ),
            )),
        back: Container(
          height: 400,
          width: 400,
          color: Colors.black54,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(30),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 1250,
                      title: const GaugeTitle(
                          text: "Popularity",
                          textStyle: TextStyle(
                            color: Colors.green,
                            fontSize: 12.5,
                          )),
                      axes: <RadialAxis>[
                        RadialAxis(
                          interval: 10000,
                          ranges: [
                            GaugeRange(
                                labelStyle: GaugeTextStyle(
                                    fontSize: 12, color: Colors.red),
                                startWidth: 3,
                                endWidth: 3,
                                startValue: 0,
                                endValue: 12500,
                                color: Colors.red),
                            GaugeRange(
                                startWidth: 3,
                                endWidth: 3,
                                startValue: 12500,
                                endValue: 25000,
                                color: Colors.orange),
                            GaugeRange(
                                startWidth: 3,
                                endWidth: 3,
                                startValue: 25000,
                                endValue: 37500,
                                color: Colors.yellow),
                            GaugeRange(
                                startWidth: 3,
                                endWidth: 3,
                                startValue: 37500,
                                endValue: 50000,
                                color: Colors.green),
                          ],
                          axisLabelStyle: const GaugeTextStyle(
                            color: Colors.green,
                          ),
                          endAngle: 100,
                          minimum: 0,
                          maximum: 50000,
                          pointers: <GaugePointer>[
                            MarkerPointer(
                              markerWidth: 17.5,
                              markerOffset: 7.5,
                              enableAnimation: true,
                              animationDuration: 1250,
                              color: Color.fromARGB(255, 83, 214, 103),
                              animationType: AnimationType.linear,
                              value: currentResponse[carouselIndex]
                                  ["popularity"],
                            )
                          ],
                        ),
                      ],
                    ),
                    SfRadialGauge(
                      animationDuration: 700,
                      title: const GaugeTitle(
                          text: "Score",
                          textStyle: TextStyle(
                            color: Colors.orange,
                            fontSize: 15,
                          )),
                      axes: <RadialAxis>[
                        RadialAxis(
                          axisLabelStyle: const GaugeTextStyle(
                            color: Colors.orange,
                          ),
                          endAngle: 25,
                          interval: 1,
                          minimum: 0,
                          maximum: 10,
                          pointers: <GaugePointer>[
                            RangePointer(
                              color: Colors.purple,
                              value: currentResponse[carouselIndex]["score"],
                              enableAnimation: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Icon(
                      Icons.reviews,
                      color: Colors.blue,
                      size: 17.5,
                    ),
                    Text("Review",
                        style: TextStyle(color: Colors.blue, fontSize: 15)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 90),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    review == null ? "Review unavailable" : "${review}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 25),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Icon(
                      FontAwesomeIcons.award,
                      color: Colors.blue,
                      size: 17.5,
                    ),
                    Text("Author",
                        style: TextStyle(color: Colors.blue, fontSize: 15)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 25),
                Flex(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 15,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(authorPhoto == null
                            ? "https://st2.depositphotos.com/2586633/46477/v/600/depositphotos_464771766-stock-illustration-no-photo-or-blank-image.jpg"
                            : "${authorPhoto}"),
                      )),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 50),
                    Expanded(
                      child: Text(
                          aboutAuthor == null
                              ? "About Author Unavailable"
                              : "${aboutAuthor}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Icon(
                      FontAwesomeIcons.chartBar,
                      color: Colors.blue,
                      size: 17.5,
                    ),
                    Text("Statistics",
                        style: TextStyle(color: Colors.blue, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> displayAllBooks() async {
    Response response = await bookProvider.getAllBooks();
    String responseData = response.body;
    currentResponse = jsonDecode(responseData);
    int dbSize = currentResponse.length;

    try {
      for (int i = 0; i < dbSize; i++) {
        coverPhotoLink = currentResponse[i]["coverPhoto"];
        review = currentResponse[i]["review"];
        authorPhoto = currentResponse[i]["author"]["photo"];
        aboutAuthor = currentResponse[i]["author"]["about"];
        popularityList.add(currentResponse[i]["popularity"]);
        scoreList.add(currentResponse[i]["score"]);
        addToAllBooks();
        carouselIndex++;
      }
      carouselIndex = 0;
    } catch (e) {}
  }

  Future<void> displayInfo() async {
    Response response = await authSevice.getUserInfo(userName);
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    try {
      name = currentResponse["name"];
      surname = currentResponse["surname"];
    } catch (e) {}
  }

  late String userName;
  AuthSevice authSevice = new AuthSevice();

  late Future _future1;
  late Future _future2;

  static late Widget body;

  late StreamController<int> stream_controller;

  GlobalKey _scaffoldKey = GlobalKey();

  late Scaffold scaffold = Scaffold(body: body);

  @override
  void dispose() {
    // TODO: implement dispose
    stream_controller.close();
    super.dispose();
  }

  late double gaugeVal = 5000;

  int i = 1;

  @override
  void initState() {
    super.initState();
    stream_controller = StreamController<int>.broadcast();
    _future1 = displayAllBooks();
    _future2 = displayInfo();

    body = FutureBuilder(
        future: Future.wait([_future1, _future2]),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.blueAccent])),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 100),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width / 200),
                            CarouselSlider(
                              items: allBooks,
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                onPageChanged: (index, reason) {
                                  carouselIndex = index;
                                },
                                height: 500,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                enlargeCenterPage: true,
                                enlargeFactor: 50,
                                autoPlay: false,
                                autoPlayInterval: const Duration(seconds: 15),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1250),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PaginatedDataTable2(
                        source: dataTableSource,
                        autoRowsToHeight: true,
                        header: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_half_sharp,
                              color: CupertinoColors.systemIndigo,
                              size: 25,
                            ),
                            Text(
                              "Books of the week",
                              style: TextStyle(
                                color: CupertinoColors.systemIndigo,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        fixedCornerColor: CupertinoColors.systemGrey,
                        border: TableBorder(
                            borderRadius: BorderRadius.circular(20),
                            verticalInside: BorderSide.none),
                        rowsPerPage: 10,
                        showCheckboxColumn: false,
                        fit: FlexFit.tight,
                        columns: [
                          DataColumn2(
                            label: Text(""),
                          ),
                          DataColumn2(
                              label: Text('Name'),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  sort = !sort;
                                });
                              }),
                          DataColumn2(
                            label: Text('Author'),
                          ),
                          DataColumn2(
                            label: Text('Genre'),
                          ),
                          DataColumn2(
                            label: Text('Score'),
                          ),
                          DataColumn2(
                            label: Text('Total Reads'),
                          ),
                        ],
                        //dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
                        //rows: dataRows,
                        key: ValueKey(pageViewKey)),
                  ),
                ],
              ),
            );
          } else {
            return Center(
                child: SpinKitRipple(
              color: Colors.lightBlue,
              size: 250,
            ));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}
