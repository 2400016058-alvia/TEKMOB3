import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StatefulPage(),
    );
  }
}

// =====================
// HALAMAN UTAMA (POMODORO)
// =====================
enum SesiMode { fokus, istirahatPendek, istirahatPanjang }

class StatefulPage extends StatefulWidget {
  const StatefulPage({super.key});

  @override
  State<StatefulPage> createState() => _StatefulPageState();
}

class _StatefulPageState extends State<StatefulPage> {
  SesiMode _mode = SesiMode.fokus;
  bool _isRunning = false;
  int _detikTersisa = 25 * 60;

  Timer? _timer;

  static const Map<SesiMode, int> _durasi = {
    SesiMode.fokus: 25 * 60,
    SesiMode.istirahatPendek: 5 * 60,
    SesiMode.istirahatPanjang: 15 * 60,
  };

  Color get _warnaTema {
    switch (_mode) {
      case SesiMode.fokus:
        return Colors.green;
      case SesiMode.istirahatPendek:
        return Colors.blue;
      case SesiMode.istirahatPanjang:
        return Colors.purple;
    }
  }

  String get _waktu {
    final m = _detikTersisa ~/ 60;
    final s = _detikTersisa % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _start() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_detikTersisa > 0) {
        setState(() => _detikTersisa--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🦫 Pomodoro"),
        backgroundColor: _warnaTema,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TIMER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    _waktu,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: _warnaTema,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isRunning ? _pause : _start,
                    child: Text(_isRunning ? "Pause" : "Start"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 TOMBOL KE LIST (INI YANG PENTING)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TaskListPage()),
                );
              },
              child: const Text("📋 Lihat Daftar Tugas"),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// HALAMAN LISTVIEW (TUGAS PRAKTIKUM 3)
// =====================
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  final List<Map<String, String>> data = const [
    {
      "judul": "Belajar Flutter",
      "deskripsi": "Mengerjakan praktikum layout"
    },
    {
      "judul": "Ngoding",
      "deskripsi": "Membuat aplikasi mobile"
    },
    {
      "judul": "Membaca",
      "deskripsi": "Belajar UI/UX"
    },
    {
      "judul": "Tugas Kampus",
      "deskripsi": "Menyelesaikan laporan"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📋 Daftar Tugas")),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black12,
                )
              ],
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  child: Text(item["judul"]![0]),
                ),

                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["judul"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item["deskripsi"]!),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}