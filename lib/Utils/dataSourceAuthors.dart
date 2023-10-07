import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:libraryautomation/Utils/AuthorProvider.dart';

class dataSourceAuthors extends DataTableSource {
  AuthorProvider authorProvider = AuthorProvider();

  var currentResponse;
  dataSourceAuthors({required this.currentResponse});

  @override
  DataRow? getRow(int index) {
    return DataRow2.byIndex(index: index, cells: [
      DataCell(Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(currentResponse[index]["photo"]),
          fit: BoxFit.cover,
        )),
      )),
      DataCell(
        Text(currentResponse[index]["name"] +
            " " +
            currentResponse[index]["surname"]),
      ),
      DataCell(SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(height: 25),
            Text(currentResponse[index]["about"]),
          ],
        ),
      )),
    ]);
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
