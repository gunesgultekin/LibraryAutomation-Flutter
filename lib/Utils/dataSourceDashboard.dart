import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Utils/AuthService.dart';

import 'AuthorProvider.dart';
import 'BookProvider.dart';

class dataSourceDashboard extends DataTableSource {
  List<DataRow2> dataRows = <DataRow2>[];

  BookProvider bookProvider = BookProvider();
  AuthorProvider authorProvider = AuthorProvider();
  String selectedBookName = "-";

  dataSourceDashboard() {
    loadDataTable();
  }

  late int db_size;

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

  late Response response;
  late String responseData;
  late var currentResponse;

  List<String> authorNames = <String>[];

  AuthSevice authSevice = AuthSevice();

  Future<void> loadDataTable() async {
    Response response = await bookProvider.getTopScore();
    String responseData = response.body;
    currentResponse = jsonDecode(responseData);
  }

  @override
  DataRow? getRow(int index) {
    bool isDeleted = currentResponse[index]["isDeleted"];
    coverPhotoLink = currentResponse[index]["coverPhoto"];

    return DataRow2.byIndex(
      index: index,
      cells: [
        DataCell(Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(coverPhotoLink), fit: BoxFit.cover)),
        )),
        DataCell(
          Text(currentResponse[index]["name"]),
        ),
        DataCell(Text(currentResponse[index]["author"]["name"] +
            " " +
            currentResponse[index]["author"]["surname"])),
        DataCell(
          Text(currentResponse[index]["genre"]["name"]),
        ),
        DataCell(
          Text(currentResponse[index]["score"].toString()),
        ),
        DataCell(
          Text(currentResponse[index]["popularity"].toString()),
        ),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => currentResponse.length;
  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
