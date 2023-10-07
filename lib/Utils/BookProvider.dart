
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BookProvider {
  late int id;
  late String name;
  late DateTime releaseDate;
  late DateTime createTime;
  late DateTime updateTime;
  late String updater;
  late bool isDeleted;
  late int authorID;
  late int genreID;
  late int userID;
  late bool isBorrowed;
  late DateTime borrowDate;

  late Future<List<Widget?>> allBooks;

  Future<void> randScore() async {
    var url = Uri.parse("http://localhost:5243/api/Book/assingRandomScores");
    await http.get(url);
  }

  Future<http.Response> findBookFromName(String bookName) async {
    var url = Uri.parse(
        "http://localhost:5243/api/Book/findBookFromName?name=${bookName}");
    var response = await http.get(url);
    return response;
  }

  Future<void> randPopularity() async {
    var url =
        Uri.parse("http://localhost:5243/api/Book/assingRandomPopularity");
    await http.get(url);
  }

  Future<http.Response> getAllBooks() async {
    var url = Uri.parse("http://localhost:5243/api/Book/GetAll");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    }
    return response;
  }

  Future<http.Response> getTopScore() async {
    var url = Uri.parse("http://localhost:5243/api/Book/sortScores");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    }
    return response;
  }

  Future<http.Response> getGenre(int id) async {
    var url = Uri.parse("http://localhost:5243/api/Genres/getGenre?id=${id}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    }
    return response;
  }

  Future<http.Response> getDbSize() async {
    var url = Uri.parse("http://localhost:5243/api/Book/getDbSize");
    var response = await http.get(url);
    return response;
  }

  Future<http.Response> checkCurrenPenalty(int bookID) async {
    var url = Uri.parse(
        "http://localhost:5243/api/Book/checkCurrentPenalty?bookID=${bookID}");
    var response = await http.get(url);
    return response;
  }

  Future<http.Response> deleteSelected(int bookID) async {
    var url =
        Uri.parse("http://localhost:5243/api/Book/deleteSelected?id=${bookID}");
    var response = await http.get(url);
    return response;
  }

  Future<http.Response> getRemainingTime(int bookID) async {
    var url = Uri.parse(
        "http://localhost:5243/api/Book/remainingTime?bookID=${bookID}");
    var response = await http.get(url);
    return response;
  }

  Future<void> borrow(int bookID, int userID) async {
    var url = Uri.parse(
        "http://localhost:5243/api/Book/Borrow?bookID=${bookID}&userID=${userID}");
    await http.get(url);
  }

  Future<http.Response> getBook(int bookID) async {
    var url = Uri.parse("http://localhost:5243/api/Book/getBook?id=${bookID}");
    var response = await http.get(url);
    return response;
  }

  Future<http.Response> deliver(int bookID) async {
    var url =
        Uri.parse("http://localhost:5243/api/Book/Deliver?bookID=${bookID}");
    var response = await http.get(url);
    return response;
  }

  Future<http.Response> editBook(
      String findBook,
      String name,
      DateTime releaseDate,
      DateTime createTime,
      int authorID,
      int genreID,
      String coverPhoto) async {
    var url = Uri.parse(
        "http://localhost:5243/api/Book/edit?findBook=${findBook}&name=${name}&releaseDate=${releaseDate}&createTime=${createTime}&authorID=${authorID}&genreID=${genreID}&coverPhoto=${coverPhoto}");
    var response = await http.get(url);
    return response;
  }
}
