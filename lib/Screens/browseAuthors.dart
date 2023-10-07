// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:js_interop';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:libraryautomation/Screens/authorInfoPopUp.dart';
import 'package:libraryautomation/Utils/AuthorProvider.dart';
import 'package:libraryautomation/Utils/dataSourceAuthors.dart';

class browseAuthorsPage extends StatefulWidget {
  const browseAuthorsPage({super.key});

  @override
  State<browseAuthorsPage> createState() => _browseAuthorsPageState();
}

class _browseAuthorsPageState extends State<browseAuthorsPage> {
  late String profilePhoto;
  late String about;
  late String name;
  late String surname;
  List<Widget> allAuthors = <Widget>[];
  AuthorProvider authorProvider = AuthorProvider();

  void addToAllAuthors() {
    allAuthors.add(
      Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            color: Colors.black,
            width: 100,
            height: 100,
            child: Flex(
              direction: Axis.vertical,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 80),
                Text(name + " " + surname,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQuery.of(context).size.height / 100),
                Expanded(
                  child: IconButton(
                    icon: Image.network(profilePhoto),
                    iconSize: MediaQuery.of(context).size.height / 4,
                    onPressed: () {
                      Get.dialog(authorInfoPopUp(about: about));
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> displayAllAuthors() async {
    Response response = await authorProvider.getAllAuthorInfo();
    String responseData = response.body;
    var currentResponse = jsonDecode(responseData);
    try {
      source = dataSourceAuthors(currentResponse: currentResponse);
    } catch (e) {}
  }

  late Future future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = displayAllAuthors();
  }

  late DataTableSource source;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: PaginatedDataTable2(
                  dataRowHeight: 300,
                  dividerThickness: 3.5,
                  rowsPerPage: 10,
                  source: source,
                  columns: [
                    DataColumn2(
                      fixedWidth: 175,
                      label: Text(""),
                    ),
                    DataColumn2(
                        fixedWidth: 200,
                        label: Flex(
                          mainAxisAlignment: MainAxisAlignment.center,
                          direction: Axis.horizontal,
                          children: [
                            Icon(Icons.person_outline_sharp, size: 15),
                            Text("Name"),
                          ],
                        )),
                    DataColumn2(
                        label: Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        Icon(Icons.reviews_outlined, size: 15),
                        Text("About"),
                      ],
                    )),
                  ],
                ),
              ),
            );
          } else {
            return SpinKitChasingDots(
              color: Colors.red,
            );
          }
        });
  }
}
