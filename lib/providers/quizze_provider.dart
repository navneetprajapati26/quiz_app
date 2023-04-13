import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quiz_model.dart';

class QuizzesProvider with ChangeNotifier {
  int? responseCode;
  List<Results>? results;

  QuizzesProvider({this.responseCode, this.results});

  Future<void> fetchQuizzesData() async {
    print("API call");
    final response = await http.get(Uri.parse('https://opentdb.com/api.php?amount=10&type=multiple'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      responseCode = jsonData['response_code'];
      if (jsonData['results'] != null) {
        results = <Results>[];
        jsonData['results'].forEach((v) {
          results!.add(new Results.fromJson(v));
        });
      }
      print("successful  ");
      notifyListeners();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
