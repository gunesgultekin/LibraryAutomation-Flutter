import 'package:carousel_slider/carousel_controller.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart ' hide Response;

import 'package:libraryautomation/Screens/bookEditPage.dart';
import 'package:libraryautomation/Screens/dataPage.dart';
import 'package:libraryautomation/Screens/mainScaffold.dart';

import '../Screens/borrowPage.dart';
import '../Screens/deliverPopUp.dart';
import 'AuthorProvider.dart';
import 'BookProvider.dart';

class dataSourceAdmin extends DataTableSource {
  late String userName;
  late var currentResponse;

  dataSourceAdmin({required this.userName, required this.currentResponse});

  List<DataRow> dataRows = <DataRow>[];

  BookProvider bookProvider = BookProvider();
  AuthorProvider authorProvider = AuthorProvider();
  late String selectedBookName;

  late int db_size;

  double totalBorrows = 10;
  int dataRowKey = 1;
  int pageViewKey = 1;

  CarouselController _carouselController = CarouselController();
  int carouselIndex = 0;

  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();

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

  @override
  DataRow? getRow(int index) {
    return DataRow2.byIndex(
      index: index,
      cells: [
        DataCell(Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(currentResponse[index]["coverPhoto"]),
            fit: BoxFit.fitWidth,
          )),
        )),
        DataCell(
          Text(currentResponse[index]["name"]),
        ),
        DataCell(
          Text("${DateTime.parse(currentResponse[index]["releaseDate"]).year}"),
        ),
        DataCell(
          Text("${DateTime.parse(currentResponse[index]["createTime"]).year}"
              "/${DateTime.parse(currentResponse[index]["createTime"]).month}"
              "/${DateTime.parse(currentResponse[index]["createTime"]).day}"),
        ),
        DataCell(
          Text("${DateTime.parse(currentResponse[index]["updateTime"]).year}"
              "/${DateTime.parse(currentResponse[index]["updateTime"]).month}"
              "/${DateTime.parse(currentResponse[index]["updateTime"]).day}"),
        ),
        DataCell(Text(currentResponse[index]["author"]["name"] +
            " " +
            currentResponse[index]["author"]["surname"])),
        DataCell(
          Text(currentResponse[index]["genre"]["name"]),
        ),
        DataCell(Row(children: [
          IconButton(
              icon: Icon(Icons.add_box_rounded),
              onPressed: () => {
                    selectedBookName = currentResponse[index]["name"],
                    Get.dialog(AlertDialog(
                      contentPadding: EdgeInsets.all(25),
                      backgroundColor: Colors.black87,
                      icon: Icon(
                        Icons.warning_amber_outlined,
                        color: CupertinoColors.systemBlue,
                        size: 50,
                        opticalSize: 25,
                      ),
                      elevation: 500,
                      title: Text(
                        "Do you want to borrow ${selectedBookName} ?",
                        style: TextStyle(
                          color: CupertinoColors.systemBlue,
                          fontSize: 17.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Yes",
                          ),
                          onPressed: () => {
                            Get.to(borrowPage(
                              bookID: currentResponse[index]["id"],
                              userName: userName,
                            ))
                          },
                        )
                      ],
                    ))
                  }),
          IconButton(
              icon: Icon(Icons.refresh_outlined),
              onPressed: () => {
                    selectedBookName = currentResponse[index]["name"],
                    Get.dialog(AlertDialog(
                      contentPadding: EdgeInsets.all(25),
                      backgroundColor: Colors.black87,
                      icon: Icon(
                        Icons.warning_amber_outlined,
                        color: CupertinoColors.systemBlue,
                        size: 50,
                        opticalSize: 25,
                      ),
                      elevation: 500,
                      title: Text(
                        "Do you want to Deliver ${selectedBookName} ?",
                        style: TextStyle(
                          color: CupertinoColors.systemBlue,
                          fontSize: 17.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Yes",
                          ),
                          onPressed: () => {
                            Get.dialog(deliverPopUp(
                                bookID: bookID, username: userName))
                          },
                        )
                      ],
                    ))
                  }),
        ])),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit_note),
                onPressed: () => {
                      selectedBookName = currentResponse[index]["name"],
                      Get.dialog(AlertDialog(
                        contentPadding: EdgeInsets.all(25),
                        backgroundColor: Colors.black87,
                        icon: Icon(
                          Icons.warning_amber_outlined,
                          color: CupertinoColors.systemBlue,
                          size: 50,
                          opticalSize: 25,
                        ),
                        elevation: 500,
                        title: Text(
                          "Do you want to edit ${selectedBookName} ?",
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontSize: 17.5,
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              "Yes",
                            ),
                            onPressed: () => {
                              Get.dialog(bookEditPage(
                                bookName: currentResponse[index]["name"],
                                userName: userName,
                              )),
                            },
                          )
                        ],
                      ))
                    }),
            IconButton(
                icon: Icon(Icons.delete_forever_outlined),
                onPressed: () => {
                      selectedBookName = currentResponse[index]["name"],
                      Get.dialog(
                        AlertDialog(
                          contentPadding: EdgeInsets.all(25),
                          backgroundColor: Colors.black87,
                          icon: Icon(
                            Icons.warning_amber_outlined,
                            color: CupertinoColors.systemBlue,
                            size: 50,
                            opticalSize: 25,
                          ),
                          elevation: 500,
                          title: Text(
                            "Do you want to delete ${selectedBookName} ?",
                            style: TextStyle(
                              color: CupertinoColors.systemBlue,
                              fontSize: 17.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                "Yes",
                              ),
                              onPressed: () => {
                                bookProvider.deleteSelected(
                                    currentResponse[index]["id"]),
                                Get.to(
                                    mainScaffold(
                                        body: dataPage(userName: userName),
                                        username: userName),
                                    preventDuplicates: false),
                              },
                            )
                          ],
                        ),
                      ),
                    }),
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
  int get rowCount => currentResponse.length;
  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
