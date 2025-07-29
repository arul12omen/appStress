import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prediksi_stress/views/hasil_prediksi_page.dart';

class PrediksiPage extends StatefulWidget {
  const PrediksiPage({super.key});

  @override
  State<PrediksiPage> createState() => _PrediksiPageState();
}

class _PrediksiPageState extends State<PrediksiPage> {
  final TextEditingController npmCtrl = TextEditingController();
  final TextEditingController belajarCtrl = TextEditingController();
  final TextEditingController organisasiCtrl = TextEditingController();
  final TextEditingController tidurCtrl = TextEditingController();
  final TextEditingController sosialCtrl = TextEditingController();
  final TextEditingController fisikCtrl = TextEditingController();
  final TextEditingController ipkCtrl = TextEditingController();

  int _selectedIndex = 1; // index halaman Prediksi
  String hasilPrediksi = '';

  Future<void> kirimPrediksi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        setState(() {
          hasilPrediksi = "User belum login!";
        });
        return;
      }

      final url =
          Uri.parse('https://apistres-production.up.railway.app/predict');

      final body = jsonEncode({
        "study": double.tryParse(belajarCtrl.text) ?? 0,
        "extracurricular": double.tryParse(organisasiCtrl.text) ?? 0,
        "sleep": double.tryParse(tidurCtrl.text) ?? 0,
        "social": double.tryParse(sosialCtrl.text) ?? 0,
        "physical": double.tryParse(fisikCtrl.text) ?? 0,
        "gpa": double.tryParse(ipkCtrl.text) ?? 0,
        "user_id": userId,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final hasil = json['prediction'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HasilPrediksiPage(hasil: hasil),
          ),
        );
      } else {
        setState(() {
          hasilPrediksi = "Gagal memprediksi!";
        });
      }
    } catch (e) {
      setState(() {
        hasilPrediksi = "Terjadi error: $e";
      });
    }
  }

  Widget field(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            hintText: 'Masukkan angka',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.analytics;
      case 2:
        return Icons.history; // icon prediksi
      case 3:
        return Icons.person;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false, // jika tidak ingin tombol kembali
        title: const Text(
          'Prediksi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  field("Jam belajar per hari:", belajarCtrl),
                  field(
                      "Jam kegiatan organisasi/UKM per hari:", organisasiCtrl),
                  field("Jam tidur per hari:", tidurCtrl),
                  field("Jam interaksi sosial per hari:", sosialCtrl),
                  field("Jam aktivitas fisik per hari:", fisikCtrl),
                  field("Nilai IPK:", ipkCtrl),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: kirimPrediksi,
                      child: const Text("Prediksi Sekarang"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (hasilPrediksi.isNotEmpty)
                    Center(
                      child: Text(
                        hasilPrediksi,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        alignment:
                            Alignment(0, _selectedIndex == index ? -0.6 : 0.8),
                        child: GestureDetector(
                          onTap: () => _onNavTapped(index),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              boxShadow: _selectedIndex == index
                                  ? [
                                      BoxShadow(
                                        color:
                                            Colors.blueAccent.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              _getIconForIndex(index),
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
