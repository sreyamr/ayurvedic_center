import 'dart:convert';
import 'package:ayurvedic_center/models/patientlist_model.dart'; // Ensure this model exists and matches the expected structure
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';

class PatientProvider with ChangeNotifier {
  List<PatientModel> _patient = [];
  bool _isLoading = false;

  List<PatientModel> get patient => _patient;
  bool get isLoading => _isLoading;

  Future<void> getPatientList() async {
    final url = Uri.parse(Urls.patientList);
    print(url);
    String? token = await AppController.getToken();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        _patient = (data['patient'] as List)
            .map((item) => PatientModel.fromJson(item))
            .toList();
      } else {
        print('getPatient failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
