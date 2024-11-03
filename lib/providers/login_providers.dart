import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';
import '../models/user_model.dart';

class LoginProvider with ChangeNotifier {
  UserModel? _userModel;
  bool _loginSuccess = false;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  bool get loginSuccess => _loginSuccess;
  String? get errorMessage => _errorMessage;

  Future<void> loginUser(UserModel usermodel) async {
    final url = Uri.parse(Urls.login);
    print(url);
    try {
      var jsonData = usermodel.toJson();
      print(jsonData);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: jsonData,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        String token = data['token'];
        await AppController.saveToken(token);

        _userModel = UserModel.fromJson(data);
        _loginSuccess = true;
      } else {
        print('Login failed: ${response.body}');
        _loginSuccess = false;
      }
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
      _loginSuccess = false;
      notifyListeners();
    }
  }
}

