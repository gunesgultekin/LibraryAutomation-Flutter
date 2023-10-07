import 'package:http/http.dart' as http;

class GenreProvider {
  Future<http.Response> getAll() async {
    var url = Uri.parse("http://localhost:5243/api/Genres/getGenres");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }

  Future<http.Response> findFromName(String name) async {
    var url =
        Uri.parse("http://localhost:5243/api/Genres/findFromName?name=${name}");
    var response = await http.get(url);
    return response;
  }
}
