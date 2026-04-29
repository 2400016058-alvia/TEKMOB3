import 'package:flutter/material.dart';
import 'stateful_page.dart';

class StatelessPage extends StatelessWidget {
  const StatelessPage({super.key});

  // Data tips belajar
  static const List<Map<String, dynamic>> _tips = [
    {
      'emoji': '📵',
      'judul': 'Matikan HP',
      'isi': 'Notifikasi adalah musuh fokus. Silent mode, letakkan HP terbalik.',
    },
    {
      'emoji': '💧',
      'judul': 'Sediain Air Minum',
      'isi': 'Otak butuh hidrasi buat berpikir. Capybara juga suka berendam!',
    },
    {
      'emoji': '✏️',
      'judul': 'Tulis Tangan Dulu',
      'isi': 'Menulis tangan membantu otak mengingat 40% lebih baik.',
    },
    {
      'emoji': '🌿',
      'judul': 'Tempat yang Nyaman',
      'isi': 'Meja rapi, pencahayaan cukup, suhu sejuk = belajar produktif.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. WIDGET: Scaffold
      backgroundColor: const Color(0xFFF4F7EE),
      appBar: AppBar(
        // 2. WIDGET: AppBar
        backgroundColor: const Color(0xFF5C7A45),
        title: const Text(
          '🦫 Belajar Bareng Capybara',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // 3. WIDGET: SingleChildScrollView
        padding: const EdgeInsets.all(20),
        child: Column(
          // 4. WIDGET: Column
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            // Hero Card
            Container(
              // 5. WIDGET: Container
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF5C7A45),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  // 6. WIDGET: Text
                  const Text(
                    '🦫',
                    style: TextStyle(fontSize: 72),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '"Capybara tidak terburu-buru.\nTapi ia selalu sampai tepat waktu."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      '— Filosofi Capybara 🧘',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Apa itu Pomodoro?
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '📖 Apa itu Teknik Pomodoro?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3A5228),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 7. WIDGET: Card
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFB8D4A0), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StepRow(
                      step: '1',
                      color: const Color(0xFF5C7A45),
                      text: 'Pilih 1 tugas yang ingin dikerjakan',
                    ),
                    _StepRow(
                      step: '2',
                      color: const Color(0xFF5C7A45),
                      text: 'Set timer 25 menit — fokus penuh!',
                    ),
                    _StepRow(
                      step: '3',
                      color: const Color(0xFF5C7A45),
                      text: 'Istirahat 5 menit saat timer bunyi',
                    ),
                    _StepRow(
                      step: '4',
                      color: const Color(0xFF5C7A45),
                      text: 'Setelah 4 sesi → istirahat panjang 15-30 menit',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '💡 Tips Belajar dari Capybara:',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3A5228),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 8. WIDGET: ListView (tips)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tip = _tips[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFD4E8C0), width: 1),
                  ),
                  child: Row(
                    // 9. WIDGET: Row
                    children: [
                      Text(tip['emoji'],
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['judul'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF3A5228),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              tip['isi'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7C5A),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // 10. WIDGET: ElevatedButton navigasi
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StatefulPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C7A45),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🦫  Mulai Belajar Sekarang!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final Color color;
  final String text;
  final bool isLast;

  const _StepRow({
    required this.step,
    required this.color,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3A5228),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}