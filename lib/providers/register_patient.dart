import 'dart:convert';
import 'package:ayurvedic_center/models/patientlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';
import '../models/user_model.dart';

class AddPatient with ChangeNotifier {
  PatientModel? _patientModel;
  bool _addSuccess = false;
  String? _errorMessage;

  PatientModel? get patientModel => _patientModel;
  bool get addSuccess => _addSuccess;
  String? get errorMessage => _errorMessage;

  Future<void> addPatient(PatientModel patient) async {
    final url = Uri.parse(Urls.addPatient);
    print(url);
    String? token = await AppController.getToken();
    try {
      var jsonData = patient.toJson();
      print(jsonData);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
        body: jsonData,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        String token = data['token'];
        await AppController.saveToken(token);
        _addSuccess = true;
      } else {
        print('Login failed: ${response.body}');
        _addSuccess = false;
      }
      notifyListeners();
    } catch (e) {
      print('An error occurred: $e');
      _addSuccess = false;
      notifyListeners();
    }
  }
}

