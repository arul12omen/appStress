import 'package:flutter/material.dart';
import 'package:prediksi_stress/controllers/History_controller.dart';
import 'package:prediksi_stress/models/HistoryItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  Future<List<HistoryItem>>? futureRiwayat;
  List<HistoryItem> allItems = [];
  List<HistoryItem> filteredItems = [];
  int selectedWeek = 0;
  int? userId;
  int selectedMonth = DateTime.now().month;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (id != null) {
      setState(() {
        userId = id;
        futureRiwayat = fetchHistory(userId!);
      });
    }
  }

  void _filterRiwayat({int? month, int? week}) {
    final selectedM = month ?? selectedMonth;
    final selectedW = week ?? selectedWeek;

    setState(() {
      selectedMonth = selectedM;
      selectedWeek = selectedW;

      filteredItems = allItems.where((item) {
        final date = DateTime.parse(item.createdAt);
        if (date.month != selectedM) return false;
        if (selectedW == 0) return true;
        int itemWeek = ((date.day - 1) ~/ 7) + 1;
        return itemWeek == selectedW;
      }).toList();
    });
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/prediksi');
        break;
      case 2:
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false, // jika tidak ingin tombol kembali
        title: const Text(
          'Riwayat Prediksi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<HistoryItem>>(
              future: futureRiwayat,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Gagal: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada riwayat.'));
                }

                if (allItems.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      allItems = snapshot.data!;
                      _filterRiwayat(month: selectedMonth, week: selectedWeek);
                    });
                  });
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Bulan',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              value: selectedMonth,
                              items: List.generate(12, (i) {
                                final monthNum = i + 1;
                                return DropdownMenuItem(
                                  value: monthNum,
                                  child: Text(DateFormat.MMMM()
                                      .format(DateTime(0, monthNum))),
                                );
                              }),
                              onChanged: (val) {
                                if (val != null) _filterRiwayat(month: val);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Minggu',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              value: selectedWeek,
                              items: const [
                                DropdownMenuItem(
                                    value: 0, child: Text('Semua')),
                                DropdownMenuItem(
                                    value: 1, child: Text('Minggu ke-1')),
                                DropdownMenuItem(
                                    value: 2, child: Text('Minggu ke-2')),
                                DropdownMenuItem(
                                    value: 3, child: Text('Minggu ke-3')),
                                DropdownMenuItem(
                                    value: 4, child: Text('Minggu ke-4')),
                              ],
                              onChanged: (val) {
                                if (val != null) _filterRiwayat(week: val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final date = DateFormat('dd MMMM yyyy')
                              .format(DateTime.parse(item.createdAt));
                          return GestureDetector(
                            onTap: () => _showDetailDialog(item),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.blueAccent.shade100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.bar_chart,
                                          size: 20, color: Colors.blueAccent),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Hasil: ${item.result.toUpperCase()}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Study: ${item.study} jam | GPA: ${item.gpa}'),
                                  const SizedBox(height: 4),
                                  Text('Tanggal: $date',
                                      style: const TextStyle(
                                          color: Colors.black54)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
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

  void _showDetailDialog(HistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Riwayat'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Study: ${item.study} jam'),
              Text('Extracurricular: ${item.extracurricular} jam'),
              Text('Sleep: ${item.sleep} jam'),
              Text('Social: ${item.social} jam'),
              Text('Physical: ${item.physical} jam'),
              Text('GPA: ${item.gpa}'),
              Text('Result: ${item.result}'),
              Text('Tanggal: ${item.createdAt}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
