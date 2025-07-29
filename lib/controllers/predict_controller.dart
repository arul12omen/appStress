import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class PredictController {
  final String baseUrl = 'https://apistres-production.up.railway.app/predict';

  Future<PredictionResult?> sendPrediction(PredictionInput input) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(input.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PredictionResult.fromJson(json);
      } else {
        print("Error response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
