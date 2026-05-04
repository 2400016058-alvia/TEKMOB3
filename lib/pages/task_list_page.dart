import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  // Dummy data
  final List<Map<String, String>> tasks = const [
    {
      "judul": "Belajar Flutter",
      "deskripsi": "Mengerjakan praktikum layouting"
    },
    {
      "judul": "Mengerjakan Tugas",
      "deskripsi": "Menyelesaikan laporan mobile"
    },
    {
      "judul": "Membaca Buku",
      "deskripsi": "Mempelajari UI/UX design"
    },
    {
      "judul": "Ngoding",
      "deskripsi": "Membuat aplikasi Pomodoro"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 Daftar Tugas"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final item = tasks[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black12,
                  offset: Offset(2, 3),
                )
              ],
            ),

            // 🔥 WAJIB: Row + Expanded
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: Text(
                    item["judul"]![0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 16),

                // Text (pakai Expanded biar responsive)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["judul"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item["deskripsi"]!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer / icon kanan
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}