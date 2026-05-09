import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _deskCtrl = TextEditingController();
  bool _isSaving = false;
  int _charCount = 0;

  static const _baseUrl =
      'https://69fc10edfce564e259173dea.mockapi.io/tasks';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'judul': _judulCtrl.text.trim(),
          'deskripsi': _deskCtrl.text.trim(),
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF3D6B35),
            content: const Text('Catatan berhasil disimpan! ✓',
                style: TextStyle(fontFamily: 'Georgia')),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        );
      }
    } catch (_) {}
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _deskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3ED),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF1C2B19).withOpacity(0.08)),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: Color(0xFF1C2B19), size: 20),
          ),
        ),
        title: const Text(
          'Catatan Baru',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C2B19),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── MOTIVATIONAL CARD ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2B19),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Chip(label: '✦ Hari ini'),
                        const SizedBox(width: 8),
                        _Chip(label: '📅 ${_todayLabel()}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Apa yang kamu\npelajari hari ini?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7F3ED),
                        fontFamily: 'Georgia',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Catatan kecil hari ini = kemajuan besar esok.',
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFFF7F3ED).withOpacity(0.5),
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── JUDUL ──
              _Label('Judul Kegiatan'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _judulCtrl,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 15,
                  color: Color(0xFF1C2B19),
                ),
                decoration: _inputDeco('Contoh: Belajar Dart OOP'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Judul wajib diisi'
                    : null,
              ),

              const SizedBox(height: 20),

              // ── DESKRIPSI ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Label('Catatan / Refleksi'),
                  Text(
                    '$_charCount / 300',
                    style: TextStyle(
                      fontSize: 11,
                      color: _charCount > 250
                          ? Colors.orange
                          : const Color(0xFF7A9472),
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _deskCtrl,
                maxLines: 6,
                onChanged: (v) =>
                    setState(() => _charCount = v.length),
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 14,
                  color: Color(0xFF1C2B19),
                  height: 1.6,
                ),
                decoration: _inputDeco(
                    'Tulis detail, insight, atau refleksimu hari ini...'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Catatan wajib diisi'
                    : null,
              ),

              const SizedBox(height: 12),

              // ── QUICK TAGS ──
              const _Label('Tag Cepat'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '📖 Membaca',
                  '💻 Coding',
                  '🎨 Desain',
                  '🧮 Matematika',
                  '🗣️ Bahasa',
                  '🔬 Sains',
                ].map((tag) {
                  return GestureDetector(
                    onTap: () {
                      _judulCtrl.text = tag;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1C2B19).withOpacity(0.08),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1C2B19),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // ── SAVE BUTTON ──
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan Catatan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7A9472),
                    side: BorderSide(
                        color: const Color(0xFF1C2B19).withOpacity(0.12)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () {
                    _judulCtrl.clear();
                    _deskCtrl.clear();
                    setState(() => _charCount = 0);
                  },
                  child: const Text(
                    'Reset Form',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Georgia',
        fontStyle: FontStyle.italic,
        color: const Color(0xFF1C2B19).withOpacity(0.25),
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
            color: const Color(0xFF1C2B19).withOpacity(0.07)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
            const BorderSide(color: Color(0xFF3D6B35), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
            const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${now.day} ${months[now.month - 1]}';
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1C2B19),
        fontFamily: 'Georgia',
        letterSpacing: 0.3,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: 'Georgia',
        ),
      ),
    );
  }
}