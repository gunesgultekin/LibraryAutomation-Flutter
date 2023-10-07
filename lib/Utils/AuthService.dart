import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthSevice {
  Future<String> validateAuth(String username, String password) async {
    var url = Uri.parse(
        'http://localhost:5243/api/Users/LoginAuth?username=${username}&password=${password}');
    var response = await http.get(url);
    return response.body;
  }

  Future<Response> getUserInfo(String userName) async {
    var url = Uri.parse(
        "http://localhost:5243/api/Users/GetUserInfo?userName=${userName}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }
}
