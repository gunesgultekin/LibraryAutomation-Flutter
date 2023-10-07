import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Utils/BookProvider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class mobileMainScaffold extends StatefulWidget {
  const mobileMainScaffold({super.key});

  @override
  State<mobileMainScaffold> createState() => _mobileMainScaffoldState();
}

class _mobileMainScaffoldState extends State<mobileMainScaffold> {
  late StreamController<int> stream_controller;

  List<Widget> allBooks = <Widget>[];
  late Response response;
  late String responseData;
  late var currentResponse;
  late Future future;
  double totalBorrows = 10;
  int dataRowKey = 1;
  int pageViewKey = 1;

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

  final __scrollController = ScrollController();

  CarouselController _carouselController = CarouselController();

  int carouselIndex = 0;

  Future<int> addToAllBooks() async {
    allBooks.add(
      FlipCard(
        key: ValueKey(pageViewKey),
        direction: FlipDirection.VERTICAL,
        side: CardSide.FRONT,
        front: Container(
          height: 500,
          width: 500,
          child: Image.network(
            coverPhotoLink,
            fit: BoxFit.contain,
          ),
        ),
        back: Container(
          //key: ,
          height: 500,
          width: 500,
          color: Colors.black54,
          child: SingleChildScrollView(
            controller: __scrollController,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(30),
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                SfRadialGauge(
                  enableLoadingAnimation: true,
                  animationDuration: 800,
                  title: const GaugeTitle(
                      text: "Popularity",
                      textStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                      )),
                  axes: <RadialAxis>[
                    RadialAxis(
                      ranges: [
                        GaugeRange(
                            startValue: 0, endValue: 10000, color: Colors.red),
                        GaugeRange(
                            startValue: 10000,
                            endValue: 25000,
                            color: Colors.orange),
                        GaugeRange(
                            startValue: 25000,
                            endValue: 37500,
                            color: Colors.yellow),
                        GaugeRange(
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
                          color: Colors.black,
                          value: currentResponse[carouselIndex]["popularity"],
                          borderColor: Colors.blue,
                          enableAnimation: true,
                        ),
                      ],
                    ),
                  ],
                ),
                SfRadialGauge(
                  animationDuration: 2500,
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
          ),
        ),
      ),
    );
    return 1;
  }

  BookProvider bookProvider = BookProvider();

  Future<void> displayAllBooks() async {
    Response response = await bookProvider.getAllBooks();
    String responseData = response.body;
    currentResponse = jsonDecode(responseData);

    Response dbSize_r = await bookProvider.getDbSize();
    String dbSize_rd = dbSize_r.body;
    var dbSize_cr = jsonDecode(dbSize_rd);
    int dbSize = dbSize_cr;

    try {
      for (int i = 0; i < dbSize; ++i) {
        coverPhotoLink = currentResponse[i]["coverPhoto"];
        addToAllBooks();
        carouselIndex++;
      }
    } catch (e) {}
  }

  late Widget? body;

  @override
  void dispose() {
    // TODO: implement dispose
    stream_controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    stream_controller = StreamController<int>.broadcast();
    future = displayAllBooks();

    body = FutureBuilder(
        future: Future.wait([future]),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.blueAccent])),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    SizedBox(height: MediaQuery.of(context).size.width / 200),
                    CarouselSlider(
                      items: allBooks,
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          carouselIndex = index;
                        },
                        height: MediaQuery.of(context).size.height / 1,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        enlargeCenterPage: true,
                        enlargeFactor: 350,
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
