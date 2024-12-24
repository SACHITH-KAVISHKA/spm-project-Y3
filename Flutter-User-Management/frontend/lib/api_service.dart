import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class ApiService {
  static const String baseUrl = "http://172.20.10.4:6000/user";

  static Future<String?> signIn(String email, String password) async {
    final url = Uri.parse('$baseUrl/signin');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print("Debug: API Response Code: ${response.statusCode}");
    print("Debug: API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data.containsKey('_id')) {
        print("Debug: Login successful. User ID: ${data['_id']}");
        return data['_id'];
      } else {
        print("Debug: '_id' not found in response.");
        return null;
      }
    } else {
      print("Debug: Login failed with status code: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> signUp(
      String name, String phone, String email, String password) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<User?> getUserData(String userId) async {
    final url = Uri.parse('$baseUrl/get/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      print(
          "Error: Unable to fetch user data. Status code: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> updateUserProfile(
      String userId, String name, String phone, String email) async {
    final url = Uri.parse('$baseUrl/put/$userId');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "email": email,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteUser(String userId) async {
    final url = Uri.parse('$baseUrl/delete/$userId');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }
}
