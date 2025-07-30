import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prediksi_stress/models/HistoryItem.dart';

Future<List<HistoryItem>> fetchHistory(int userId) async {
  final response = await http.get(
      Uri.parse('https://apistres-production.up.railway.app/history/$userId'));

  if (response.statusCode == 200) {
    List jsonData = jsonDecode(response.body);
    return jsonData.map((item) => HistoryItem.fromJson(item)).toList();
  } else {
    throw Exception('Gagal memuat riwayat');
  }
}
