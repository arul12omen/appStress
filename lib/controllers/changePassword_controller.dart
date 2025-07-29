import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prediksi_stress/models/ChangePasswordModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController {
  final TextEditingController oldPassCtrl = TextEditingController();
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String> changePassword() async {
    final username = await getUsername();
    if (username == null) return 'User tidak ditemukan';

    final body = ChangePasswordModel(
      username: username,
      oldPassword: oldPassCtrl.text,
      newPassword: newPassCtrl.text,
      confirmPassword: confirmPassCtrl.text,
    ).toJson();

    final response = await http.post(
      Uri.parse(
          'https://apistres-production.up.railway.app/auth/change-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return 'Berhasil ganti password';
    } else {
      final error = jsonDecode(response.body);
      return error['error'] ?? 'Terjadi kesalahan';
    }
  }

  void dispose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
  }
}
