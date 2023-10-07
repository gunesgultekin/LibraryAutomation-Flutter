import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthorProvider {
  Future<Response> getAuthorInfo(int authorID) async {
    var url = Uri.parse(
        "http://localhost:5243/api/AuthorsContoller/getAuthorInfo?authorID=${authorID}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }

  Future<Response> getAllAuthorInfo() async {
    var url = Uri.parse("http://localhost:5243/api/AuthorsContoller/getAll");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }

  Future<Response> findFromName(String name, String surname) async {
    var url = Uri.parse(
        "http://localhost:5243/api/AuthorsContoller/findFromName?name=${name}&surname=${surname}");

    var response = await http.get(url);
    return response;
  }
}
