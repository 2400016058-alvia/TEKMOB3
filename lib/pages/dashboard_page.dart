import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'journal_page.dart';
import 'add_entry_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<dynamic>> _futureEntries;

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

  @override
  void initState() {
    super.initState();
    _futureEntries = _fetch();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _greetEmoji() {
    final h = DateTime.now().hour;
    if (h < 11) return '🌤';
    if (h < 15) return '☀️';
    if (h < 18) return '🌅';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greetEmoji()}  ${_greeting()}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A9472),
                          fontFamily: 'Georgia',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Text(
                        'Jurnal Saya',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C2B19),
                          fontFamily: 'Georgia',
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _IconBtn(
                        icon: Icons.refresh_rounded,
                        onTap: _refresh,
                      ),
                      const SizedBox(width: 10),
                      _IconBtn(
                        icon: Icons.add_rounded,
                        filled: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddEntryPage()),
                        ).then((_) => _refresh()),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── STATS ROW ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FutureBuilder<List<dynamic>>(
                future: _futureEntries,
                builder: (context, snapshot) {
                  final count =
                      snapshot.hasData ? snapshot.data!.length : 0;
                  final hasData =
                      snapshot.hasData && snapshot.data!.isNotEmpty;
                  return Row(
                    children: [
                      _StatTile(
                        value: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? '—'
                            : '$count',
                        label: 'Total Catatan',
                        color: const Color(0xFF1C2B19),
                        textColor: const Color(0xFFF7F3ED),
                        icon: '📝',
                      ),
                      const SizedBox(width: 10),
                      _StatTile(
                        value: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? '—'
                            : hasData
                                ? '✓'
                                : '–',
                        label: 'Aktif Belajar',
                        color: const Color(0xFFDCEDD8),
                        textColor: const Color(0xFF1C2B19),
                        icon: '🌿',
                      ),
                      const SizedBox(width: 10),
                      const _StatTile(
                        value: '🔥',
                        label: 'Semangat!',
                        color: Color(0xFFFFF0DC),
                        textColor: Color(0xFF1C2B19),
                        icon: '',
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ── TAB BAR ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1C2B19).withOpacity(0.07),
                  ),
                ),
                child: Row(
                  children: [
                    _TabItem(
                      label: 'Terbaru',
                      selected: true,
                      onTap: () {},
                    ),
                    _TabItem(
                      label: 'Semua',
                      selected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const JournalPage()),
                        ).then((_) => _refresh());
                      },
                    ),
                    _TabItem(
                      label: '+ Tambah',
                      selected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddEntryPage()),
                        ).then((_) => _refresh());
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── FUTUREBUILDER LIST ──
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _futureEntries,
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3D6B35),
                        strokeWidth: 2,
                      ),
                    );
                  }

                  // Empty
                  final entries = snapshot.data ?? [];
                  if (entries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCEDD8),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('📭',
                                  style: TextStyle(fontSize: 40)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada catatan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1C2B19),
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Mulai tulis sesuatu hari ini!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A9472),
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // List (tampilkan 5 terbaru)
                  final recent = entries.reversed
                      .take(5)
                      .toList();

                  return RefreshIndicator(
                    color: const Color(0xFF3D6B35),
                    onRefresh: () async => _refresh(),
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      itemCount: recent.length,
                      itemBuilder: (context, index) {
                        final item = recent[index];
                        return _EntryCard(item: item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── BOTTOM NAV ──
      bottomNavigationBar: _BottomBar(
        onJournal: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JournalPage()),
        ).then((_) => _refresh()),
        onAdd: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEntryPage()),
        ).then((_) => _refresh()),
      ),
    );
  }
}

// ── ENTRY CARD ──
class _EntryCard extends StatelessWidget {
  final dynamic item;
  const _EntryCard({required this.item});

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
  Widget build(BuildContext context) {
    final idx = (item['id'].hashCode) % _colors.length;
    final bg = _colors[idx.abs()];
    final tc = _textColors[idx.abs()];
    final initial = (item['judul'] as String? ?? '?').isNotEmpty
        ? item['judul'][0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1C2B19).withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: tc,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['judul'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C2B19),
                    fontFamily: 'Georgia',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  item['deskripsi'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7A9472),
                    fontFamily: 'Georgia',
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFB5CEB0),
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ── STAT TILE ──
class _StatTile extends StatelessWidget {
  final String value, label, icon;
  final Color color, textColor;

  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon.isNotEmpty)
              Text(icon, style: const TextStyle(fontSize: 20)),
            if (icon.isNotEmpty) const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.6),
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── TAB ITEM ──
class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF3D6B35)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.white
                  : const Color(0xFF7A9472),
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
    );
  }
}

// ── ICON BUTTON ──
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF3D6B35) : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: filled
              ? null
              : Border.all(
                  color: const Color(0xFF1C2B19).withOpacity(0.08),
                ),
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : const Color(0xFF1C2B19),
          size: 22,
        ),
      ),
    );
  }
}

// ── BOTTOM BAR ──
class _BottomBar extends StatelessWidget {
  final VoidCallback onJournal, onAdd;
  const _BottomBar({required this.onJournal, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3ED),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1C2B19).withOpacity(0.06),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onJournal,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1C2B19).withOpacity(0.08),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book_outlined,
                        color: Color(0xFF3D6B35), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Semua Jurnal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C2B19),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF3D6B35),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}