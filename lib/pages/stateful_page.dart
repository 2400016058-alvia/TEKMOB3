import 'dart:async';
import 'package:flutter/material.dart';

// Mode sesi belajar
enum SesiMode { fokus, istirahatPendek, istirahatPanjang }

class StatefulPage extends StatefulWidget {
  const StatefulPage({super.key});

  @override
  State<StatefulPage> createState() => _StatefulPageState();
}

class _StatefulPageState extends State<StatefulPage> {
  // ===== STATE =====
  SesiMode _mode = SesiMode.fokus;
  bool _isRunning = false;
  int _detikTersisa = 25 * 60; // 25 menit default
  int _sesiSelesai = 0;
  int _totalFokusDetik = 0;
  String _tugasSekarang = '';
  Timer? _timer;

  // Durasi tiap mode (dalam detik)
  static const Map<SesiMode, int> _durasi = {
    SesiMode.fokus: 25 * 60,
    SesiMode.istirahatPendek: 5 * 60,
    SesiMode.istirahatPanjang: 15 * 60,
  };

  // Label mode
  String get _labelMode {
    switch (_mode) {
      case SesiMode.fokus:
        return 'Sesi Fokus 🧠';
      case SesiMode.istirahatPendek:
        return 'Istirahat Sebentar ☕';
      case SesiMode.istirahatPanjang:
        return 'Istirahat Panjang 🛁';
    }
  }

  // Capybara emoji & pesan berdasarkan state
  String get _emojiCapy {
    if (!_isRunning && _detikTersisa == _durasi[_mode]) return '🦫';
    if (_mode == SesiMode.istirahatPendek) return '☕🦫';
    if (_mode == SesiMode.istirahatPanjang) return '🛁🦫';
    if (_isRunning) return '🦫📖';
    return '🦫💤';
  }

  String get _pesanCapy {
    if (_sesiSelesai == 0 && !_isRunning) {
      return 'Hei! Capybara siap menemanimu belajar. Yuk mulai!';
    }
    if (_mode == SesiMode.istirahatPendek && _isRunning) {
      return 'Bagus banget! Istirahat dulu ya. Capybara mau minum teh. ☕';
    }
    if (_mode == SesiMode.istirahatPanjang && _isRunning) {
      return 'Luar biasa! Kamu udah kerja keras. Capybara mau berendam dulu! 🛁';
    }
    if (_isRunning) {
      return 'Capybara nemenin kamu fokus. Jangan buka medsos ya! 🙅';
    }
    if (_sesiSelesai > 0) {
      return 'Kamu udah selesai $_sesiSelesai sesi! Capybara bangga! 🌟';
    }
    return 'Capybara menunggu... 👀';
  }

  // Warna tema berdasarkan mode
  Color get _warnaTema {
    switch (_mode) {
      case SesiMode.fokus:
        return const Color(0xFF5C7A45);
      case SesiMode.istirahatPendek:
        return const Color(0xFF2980B9);
      case SesiMode.istirahatPanjang:
        return const Color(0xFF8E44AD);
    }
  }

  // Format detik ke MM:SS
  String get _waktuFormatted {
    final menit = _detikTersisa ~/ 60;
    final detik = _detikTersisa % 60;
    return '${menit.toString().padLeft(2, '0')}:${detik.toString().padLeft(2, '0')}';
  }

  // Progress 0.0 - 1.0
  double get _progress {
    final total = _durasi[_mode]!;
    return 1 - (_detikTersisa / total);
  }

  // Menit total fokus
  String get _totalFokusMenit {
    return '${(_totalFokusDetik / 60).floor()} menit';
  }

  // ===== AKSI =====

  void _mulaiTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_detikTersisa > 0) {
        setState(() {
          _detikTersisa--;
          if (_mode == SesiMode.fokus) _totalFokusDetik++;
        });
      } else {
        _sesiHabis();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _sesiHabis() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_mode == SesiMode.fokus) {
        _sesiSelesai++;
        // Setelah 4 sesi → istirahat panjang
        if (_sesiSelesai % 4 == 0) {
          _gantMode(SesiMode.istirahatPanjang);
        } else {
          _gantMode(SesiMode.istirahatPendek);
        }
      } else {
        _gantMode(SesiMode.fokus);
      }
    });
    _tampilSnackbar();
  }

  void _gantMode(SesiMode mode) {
    setState(() {
      _mode = mode;
      _detikTersisa = _durasi[mode]!;
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _detikTersisa = _durasi[_mode]!;
    });
  }

  void _resetSemua() {
    _timer?.cancel();
    setState(() {
      _mode = SesiMode.fokus;
      _isRunning = false;
      _detikTersisa = _durasi[SesiMode.fokus]!;
      _sesiSelesai = 0;
      _totalFokusDetik = 0;
      _tugasSekarang = '';
    });
  }

  void _tampilSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _mode == SesiMode.fokus
              ? '🦫 Sesi selesai! Waktunya fokus lagi!'
              : '🦫 Istirahat selesai! Ayo kembali belajar!',
        ),
        backgroundColor: _warnaTema,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. WIDGET: Scaffold
      backgroundColor: const Color(0xFFF4F7EE),
      appBar: AppBar(
        // 2. WIDGET: AppBar
        backgroundColor: _warnaTema,
        title: const Text(
          '🦫 Pomodoro Capybara',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetSemua,
            tooltip: 'Reset semua',
          ),
        ],
      ),

      body: SingleChildScrollView(
        // 3. WIDGET: SingleChildScrollView
        padding: const EdgeInsets.all(20),
        child: Column(
          // 4. WIDGET: Column
          children: [

            // === MODE SELECTOR ===
            // 5. WIDGET: Row (tombol pilih mode)
            Row(
              children: SesiMode.values.map((mode) {
                final labels = {
                  SesiMode.fokus: '🧠 Fokus',
                  SesiMode.istirahatPendek: '☕ Pendek',
                  SesiMode.istirahatPanjang: '🛁 Panjang',
                };
                final isActive = _mode == mode;
                return Expanded(
                  child: GestureDetector(
                    onTap: _isRunning
                        ? null
                        : () {
                            _timer?.cancel();
                            _gantMode(mode);
                            setState(() => _isRunning = false);
                          },
                    child: AnimatedContainer(
                      // 6. WIDGET: AnimatedContainer
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? _warnaTema : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? _warnaTema
                              : const Color(0xFFB8D4A0),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        labels[mode]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : const Color(0xFF5C7A45),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // === TIMER CARD ===
            // 7. WIDGET: Container (timer utama)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFB8D4A0), width: 1.5),
              ),
              child: Column(
                children: [
                  Text(
                    _labelMode,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _warnaTema,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Capybara besar
                  Text(_emojiCapy, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),

                  // 8. WIDGET: Text (waktu besar)
                  Text(
                    _waktuFormatted,
                    style: TextStyle(
                      fontSize: 68,
                      fontWeight: FontWeight.bold,
                      color: _warnaTema,
                      letterSpacing: 2,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      // 9. WIDGET: LinearProgressIndicator
                      value: _progress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFE8F0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(_warnaTema),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pesan capybara
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7EE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        _pesanCapy,
                        key: ValueKey(_pesanCapy),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF4A6335),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // === TOMBOL KONTROL ===
            // 10. WIDGET: Row (tombol play/pause/reset)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? _pauseTimer : _mulaiTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _warnaTema,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 24),
                        const SizedBox(width: 8),
                        Text(
                          _isRunning ? 'Pause' : 'Mulai',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _warnaTema,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: _warnaTema, width: 1.5),
                    ),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.refresh_rounded, size: 24),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === INPUT TUGAS ===
            // 11. WIDGET: TextField
            TextField(
              onChanged: (val) => setState(() => _tugasSekarang = val),
              decoration: InputDecoration(
                labelText: '📝 Tugas yang sedang dikerjakan...',
                labelStyle: const TextStyle(color: Color(0xFF8AAE72)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFB8D4A0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: Color(0xFF5C7A45), width: 2),
                ),
                prefixIcon: const Icon(Icons.edit_note_rounded,
                    color: Color(0xFF8AAE72)),
              ),
            ),

            if (_tugasSekarang.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '🎯 Fokus: $_tugasSekarang',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3A5228),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // === STATISTIK ===
            // 12. WIDGET: Row stats
            Row(
              children: [
                _StatBox(
                  emoji: '✅',
                  label: 'Sesi Selesai',
                  nilai: '$_sesiSelesai sesi',
                  color: const Color(0xFF5C7A45),
                ),
                const SizedBox(width: 12),
                _StatBox(
                  emoji: '⏱️',
                  label: 'Total Fokus',
                  nilai: _totalFokusMenit,
                  color: const Color(0xFF2980B9),
                ),
                const SizedBox(width: 12),
                _StatBox(
                  emoji: '🏆',
                  label: 'Target Hari',
                  nilai: '${_sesiSelesai}/8',
                  color: const Color(0xFFE67E22),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Motivasi berdasarkan sesi
            if (_sesiSelesai >= 4)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFFFD700), width: 1),
                ),
                child: const Row(
                  children: [
                    Text('🌟', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Luar biasa! Kamu sudah 4+ sesi hari ini.\nCapybara sangat bangga padamu! 🦫❤️',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7D6608),
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Widget helper: Stat Box
class _StatBox extends StatelessWidget {
  final String emoji;
  final String label;
  final String nilai;
  final Color color;

  const _StatBox({
    required this.emoji,
    required this.label,
    required this.nilai,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              nilai,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 9, color: Color(0xFF8AAE72)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}