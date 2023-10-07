// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart ' hide Response;
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:libraryautomation/Screens/bookEditPage.dart';
import 'package:libraryautomation/Screens/borrowPage.dart';

import 'package:libraryautomation/Screens/loginScreen.dart';
import 'package:libraryautomation/Screens/splashPage.dart';
import 'package:libraryautomation/Utils/AuthService.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../Utils/AuthorProvider.dart';
import '../Utils/BookProvider.dart';
import 'deliverPopUp.dart';

class dataSourceMyBooks extends DataTableSource {
  BookProvider bookProvider = BookProvider();

  String selectedBookName = "@abc";

  late String userName;

  dataSourceMyBooks({required this.userName}) {
    loadDataTable();
  }

  late var currentResponse;

  late var currentResponse1;
  late var currentResponse2;
  late String coverPhotoLink;

  AuthSevice authSevice = AuthSevice();

  var remainingTimeList = [];
  var penaltyList = [];

  Future<void> loadDataTable() async {
    // GET ALL BOOKS INFO
    Response response = await authSevice.getUserInfo(userName);
    String responseData = response.body;
    currentResponse = jsonDecode(responseData);
    // GET ALL BOOKS INFO

    for (int i = 0; i < currentResponse["bookList"].length; ++i) {
      Response response1 = await bookProvider
          .getRemainingTime(currentResponse["bookList"][i]["id"]);
      String responseData1 = response1.body;
      currentResponse1 = jsonDecode(responseData1);
      remainingTimeList.add(currentResponse1.toString());

      Response response2 = await bookProvider
          .checkCurrenPenalty(currentResponse["bookList"][i]["id"]);
      String responseData2 = response2.body;
      currentResponse2 = jsonDecode(responseData2);
      penaltyList.add(currentResponse2.toString());
    }
  }

  @override
  DataRow? getRow(int index) {
    coverPhotoLink = currentResponse["bookList"][index]["coverPhoto"];

    return DataRow2.byIndex(
      index: index,
      cells: [
        DataCell(Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(coverPhotoLink), fit: BoxFit.contain)),
        )),
        DataCell(
          Text(currentResponse["bookList"][index]["name"]),
        ),
        DataCell(Text(currentResponse["bookList"][index]["author"]["name"] +
            " " +
            currentResponse["bookList"][index]["author"]["surname"])),
        DataCell(
          Text(currentResponse["bookList"][index]["genre"]["name"]),
        ),
        DataCell(Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: SfLinearGauge(
                orientation: LinearGaugeOrientation.horizontal,
                maximum: 15,
                interval: 3,
                ranges: [
                  LinearGaugeRange(
                    startValue: 0,
                    endValue: 5,
                    color: Colors.green,
                  ),
                  LinearGaugeRange(
                    startValue: 5,
                    endValue: 10,
                    color: Colors.yellow,
                  ),
                  LinearGaugeRange(
                    startValue: 10,
                    endValue: 25,
                    color: Colors.red,
                  )
                ],
                barPointers: [
                  LinearBarPointer(
                    value: double.parse(remainingTimeList[index]),
                    color: Colors.purple,
                    thickness: 9,
                    animationDuration: 2550,
                  )
                ],
              ),
            ),
            SizedBox(width: 25),
            Text("(" + remainingTimeList[index] + " days)"),
          ],
        )),
        DataCell(Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: SfLinearGauge(
                orientation: LinearGaugeOrientation.horizontal,
                maximum: 500,
                interval: 100,
                barPointers: [
                  LinearBarPointer(
                    value: double.parse(penaltyList[index]),
                    color: Colors.orange,
                    thickness: 11,
                    animationDuration: 1625,
                  )
                ],
              ),
            ),
            SizedBox(width: 25),
            Text("(" + penaltyList[index] + " ₺)"),
          ],
        )),
        DataCell(Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(width: 15),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
              ),
              onPressed: () => {
                Get.dialog(deliverPopUp(
                    bookID: currentResponse["bookList"][index]["id"],
                    username: userName)),
              },
              // ignore: prefer_const_constructors
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Icon(FontAwesomeIcons.moneyCheck),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Deliver"),
                ],
              ),
            )
          ],
        )),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => currentResponse["bookList"].length;
  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
