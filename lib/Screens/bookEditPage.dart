import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart%20' hide Response;
import 'package:http/src/response.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:libraryautomation/Screens/constantAppBar.dart';
import 'package:libraryautomation/Screens/constantDrawer.dart';
import 'package:libraryautomation/Screens/profilePopUp.dart';
import 'package:libraryautomation/Utils/AuthorProvider.dart';
import 'package:libraryautomation/Utils/BookProvider.dart';
import 'package:libraryautomation/Utils/GenreProvider.dart';
import 'package:list_picker/list_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import 'dataPage.dart';

class bookEditPage extends StatefulWidget {
  late String userName;
  bookEditPage({required this.bookName, required this.userName});
  String bookName;

  @override
  State<bookEditPage> createState() => bookEditPageState();
}

class bookEditPageState extends State<bookEditPage> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _coverPhotoController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  ScrollController _scrollController = ScrollController();
  int authoridValue = 1;
  int genreidValue = 1;
  DateTime releaseDate = DateTime.now();
  DateTime createTime = DateTime.now();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    _controller.dispose();
  }

  TextEditingController changeAuthorController = TextEditingController();

  TextEditingController changeGenreController = TextEditingController();

  late Future future;
  late Future future1;
  late Future future2;

  @override
  void initState() {
    super.initState();
    future = getBookFromName(widget.bookName);
    future1 = getAuthors();
    future2 = getGenres();
  }

  late VideoPlayerController _controller;

  BookProvider bookProvider = BookProvider();
  AuthorProvider authorProvider = AuthorProvider();
  GenreProvider genreProvider = GenreProvider();

  late var currentResponse;
  late var currentResponse1;
  late var currentResponse2;
  late String coverPhoto;

  Future<void> getBookFromName(String bookName) async {
    Response response = await bookProvider.findBookFromName(bookName);
    String responseData = response.body;
    currentResponse = jsonDecode(responseData);
    coverPhoto = currentResponse["coverPhoto"];
  }

  late List<String> authorsList = [];
  late List<String> genresList = [];
  late List<String> splitted = changeAuthorController.text.split(",");

  Future<void> getAuthors() async {
    Response response = await authorProvider.getAllAuthorInfo();
    String responseData = response.body;
    currentResponse1 = jsonDecode(responseData);
    for (int i = 0; i < currentResponse1.length; ++i) {
      authorsList.add(
          currentResponse1[i]["name"] + "," + currentResponse1[i]["surname"]);
    }
  }

  Future<void> getGenres() async {
    Response response = await genreProvider.getAll();
    String responseData = response.body;
    currentResponse2 = jsonDecode(responseData);
    for (int i = 0; i < currentResponse2.length; ++i) {
      genresList.add(currentResponse2[i]["name"]);
    }
  }

  Future<void> editBook(String findBook, String name, DateTime releaseDate,
      DateTime createTime, int authorID, int genreID, String coverPhoto) async {
    Response response = await bookProvider.editBook(
        findBook, name, releaseDate, createTime, authorID, genreID, coverPhoto);
  }

  Future<int> getAuthorID(String name, String surname) async {
    Response response = await authorProvider.findFromName(name, surname);
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    return currentResponse["id"];
  }

  Future<int> getGenreID(String name) async {
    Response response = await genreProvider.findFromName(name);
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    return currentResponse["id"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([future, future1, future2]),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(200),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.blueAccent])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 1.15,
                            color: Colors.white24,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10),
                                      Icon(
                                        FontAwesomeIcons.edit,
                                        size: 60,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              30),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        child: TextField(
                                          controller: _bookNameController,
                                          decoration: InputDecoration(
                                            hintText: "Edit book name",
                                            hintStyle: TextStyle(
                                              color: Colors.white54,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.drive_file_rename_outline,
                                              color: Colors.blue,
                                            ),
                                            fillColor: Colors.white,
                                            helperText: "Book name",
                                            helperStyle: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey2,
                                              fontSize: 10,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              12),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        child: TextField(
                                          controller: _coverPhotoController,
                                          decoration: InputDecoration(
                                            hintText: "Edit Cover Photo",
                                            hintStyle: TextStyle(
                                              color: Colors.white54,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.image,
                                              color: Colors.orange,
                                            ),
                                            helperText: "Cover photo link",
                                            helperStyle: TextStyle(
                                              color:
                                                  CupertinoColors.systemGrey2,
                                              fontSize: 10,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              30),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            animationDuration:
                                                Duration(seconds: 1),
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        Colors.blueGrey),
                                            overlayColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.blue)),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.calendarXmark,
                                              size: 16,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    300),
                                            Text(
                                              "Change Release Date\n\n${releaseDate}",
                                              style: TextStyle(
                                                fontSize: 16.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          await showDatePicker(
                                                  context: context,
                                                  initialDate: releaseDate,
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime.now())
                                              .then((pickedDate) {
                                            if (pickedDate != null) {
                                              setState(() {
                                                releaseDate = pickedDate;
                                              });
                                            }
                                          });
                                        },
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            animationDuration:
                                                Duration(seconds: 1),
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        Colors.blueGrey),
                                            overlayColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) => Colors.blue)),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.date_range_outlined,
                                              size: 17,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    200),
                                            Text(
                                              "Change Create Time\n\n${createTime}",
                                              style: TextStyle(
                                                fontSize: 16.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          await showDatePicker(
                                            context: context,
                                            initialDate: createTime,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                          ).then((pickedDate) {
                                            if (pickedDate != null) {
                                              setState(() {
                                                createTime = pickedDate;
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10),
                                      ListPickerField(
                                        label: "Change Author",
                                        items: authorsList,
                                        controller: changeAuthorController,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10),
                                      ListPickerField(
                                          label: "Change Genre",
                                          items: genresList,
                                          controller: changeGenreController),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10),
                                      TextButton(
                                        onPressed: () async => {
                                          editBook(
                                              widget.bookName,
                                              _bookNameController.text,
                                              releaseDate,
                                              createTime,
                                              await getAuthorID(
                                                  splitted[0], splitted[1]),
                                              await getGenreID(
                                                  changeGenreController.text),
                                              _coverPhotoController.text),
                                          setState(() {
                                            Get.dialog(AlertDialog(
                                              title: Text("Saved"),
                                            ));
                                          })
                                        },
                                        child: Text("Save Changes"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 1.3,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          image: NetworkImage(coverPhoto),
                          fit: BoxFit.contain,
                        )),
                      ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SpinKitFadingFour(
              color: Colors.blue,
            );
          }
        });
  }
}
