import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/app_controller.dart';
import '../data/urls.dart';
import '../models/treatmentlist_model.dart';

class TreatmentList with ChangeNotifier {
  List<Treatment> _treatments = [];
  bool _isLoading = false;

  List<Treatment> get treatments => _treatments;
  bool get isTreatmentLoading => _isLoading;

  Future<void> getTreatmentList() async {
    final url = Uri.parse(Urls.treatmentList);
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
        _treatments = (data['treatments'] as List)
            .map((treatmentJson) => Treatment.fromJson(treatmentJson))
            .toList();
        notifyListeners();
      } else {
        print('getTreatmentList failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
