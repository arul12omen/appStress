import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String baseUrl =
      "https://apistres-production.up.railway.app/auth"; // pakai ini untuk Android emulator

  Future<bool> login(UserModel user) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userId = data['user_id'];
      final username = data['username'];
      final nama = data['nama'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('username', username);
      await prefs.setString('nama', nama);

      print("Login berhasil: $username ($nama)");
      return true;
    } else {
      print("Login gagal: ${response.body}");
      return false;
    }
  }

  Future<bool> register(UserModel user) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': user.nama,
        'username': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      print("Pendaftaran berhasil");
      return true;
    } else {
      print("Pendaftaran gagal: ${response.body}");
      return false;
    }
  }
}
