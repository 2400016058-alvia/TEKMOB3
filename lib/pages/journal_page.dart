import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late Future<List<dynamic>> _futureEntries;
  String _search = '';

  static const _baseUrl =
      'https://69fc10edfce564e259173dea.mockapi.io/tasks';

  Future<List<dynamic>> _fetch() async {
    try {
      final res = await http.get(Uri.parse(_baseUrl));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  void _refresh() {
    setState(() {
      _futureEntries = _fetch();
    });
  }

  Future<void> _delete(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
    _refresh();
    if (!mounted) return;
    _showSnack('Catatan dihapus.');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF3D6B35),
        content: Text(msg, style: const TextStyle(fontFamily: 'Georgia')),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _confirmDelete(dynamic item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Text('🗑️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 16),
            const Text(
              'Hapus Catatan?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C2B19),
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${item['judul']}" akan dihapus permanen.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A9472),
                fontFamily: 'Georgia',
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                          color: const Color(0xFF1C2B19).withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Color(0xFF7A9472),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _delete(item['id'].toString());
                    },
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static const _colors = [
    Color(0xFFDCEDD8),
    Color(0xFFFFF0DC),
    Color(0xFFE8E0F5),
    Color(0xFFFFE0E0),
    Color(0xFFDCEDF5),
  ];
  static const _textColors = [
    Color(0xFF2D5E26),
    Color(0xFF7A5500),
    Color(0xFF4A2D7A),
    Color(0xFF7A2D2D),
    Color(0xFF1C4D6B),
  ];

  @override
  void initState() {
    super.initState();
    _futureEntries = _fetch();
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
          'Semua Jurnal',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C2B19),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FutureBuilder<List<dynamic>>(
              future: _futureEntries,
              builder: (context, snapshot) {
                final count =
                    snapshot.hasData ? snapshot.data!.length : 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCEDD8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count catatan',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2D5E26),
                      fontFamily: 'Georgia',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── SEARCH ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF1C2B19).withOpacity(0.07)),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 14,
                  color: Color(0xFF1C2B19),
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari catatan...',
                  hintStyle: TextStyle(
                    fontFamily: 'Georgia',
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFB5CEB0),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Color(0xFF7A9472), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 14, horizontal: 8),
                ),
              ),
            ),
          ),

          // ── FUTUREBUILDER LIST ──
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureEntries,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3D6B35),
                      strokeWidth: 2,
                    ),
                  );
                }

                // Error
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Gagal memuat data.',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        color: Color(0xFF7A9472),
                      ),
                    ),
                  );
                }

                // Filter berdasarkan search
                final all = snapshot.data ?? [];
                final filtered = all.reversed
                    .where((e) =>
                        (e['judul'] ?? '')
                            .toLowerCase()
                            .contains(_search.toLowerCase()) ||
                        (e['deskripsi'] ?? '')
                            .toLowerCase()
                            .contains(_search.toLowerCase()))
                    .toList();

                // Empty
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍',
                            style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(
                          _search.isEmpty
                              ? 'Belum ada catatan'
                              : 'Tidak ditemukan',
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C2B19),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // List
                return RefreshIndicator(
                  color: const Color(0xFF3D6B35),
                  onRefresh: () async => _refresh(),
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      final idx =
                          (item['id'].hashCode) % _colors.length;
                      final bg = _colors[idx.abs()];
                      final tc = _textColors[idx.abs()];
                      final initial =
                          (item['judul'] as String? ?? '?').isNotEmpty
                              ? item['judul'][0].toUpperCase()
                              : '?';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF1C2B19)
                                .withOpacity(0.06),
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius:
                                  BorderRadius.circular(13),
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: tc,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            item['judul'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1C2B19),
                            ),
                          ),
                          subtitle: Text(
                            item['deskripsi'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                              color: Color(0xFF7A9472),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFCCB5B5),
                              size: 20,
                            ),
                            onPressed: () => _confirmDelete(item),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}