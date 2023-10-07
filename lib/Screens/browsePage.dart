import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
//import 'package:get/get_connect/http/src/response/response.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../Utils/BookProvider.dart';
import 'constantAppBar.dart';

class browsePage extends StatefulWidget {
  late String userName;
  browsePage({required this.userName});
  @override
  State<browsePage> createState() => _browsePageState(userName: userName);
}

class _browsePageState extends State<browsePage> {
  late String userName;
  _browsePageState({required this.userName});

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

  late Future future;
  double totalBorrows = 10;
  int dataRowKey = 1;
  int pageViewKey = 1;

  List<Widget> allBooks = <Widget>[];

  void addToAllBooks() {
    allBooks.add(
      Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(coverPhotoLink))),
          )),
    );
  }

  CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = displayAllBooks();
  }

  late int dbSize;

  Future<void> displayAllBooks() async {
    Response response = await bookProvider.getAllBooks();
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);

    Response dbSize_r = await bookProvider.getDbSize();
    String dbSize_rd = dbSize_r.body;
    var dbSize_cr = jsonDecode(dbSize_rd);
    dbSize = dbSize_cr;

    try {
      for (int i = 0; i < dbSize; ++i) {
        coverPhotoLink = currentResponse[i]["coverPhoto"];
        addToAllBooks();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Container(
              color: Colors.black87,
              child: GridView.count(
                children: allBooks,
                crossAxisCount: 8,
              ),
            ),
          );
        } else {
          return SpinKitWave(
            color: Colors.blue,
            size: 150,
          );
        }
      },
    );
  }
}
