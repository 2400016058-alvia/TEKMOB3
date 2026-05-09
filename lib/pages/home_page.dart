import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'review_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,

          child: SlideTransition(
            position: _slideAnim,

            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(24, 20, 24, 32),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // ───────── TOP ROW ─────────

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      // LOGO
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFF3D6B35),

                          borderRadius:
                              BorderRadius.circular(30),
                        ),

                        child: const Row(
                          children: [

                            Text(
                              '📗',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),

                            SizedBox(width: 6),

                            Text(
                              'StudyDrop',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.bold,
                                letterSpacing: 0.5,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // DATE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(30),

                          border: Border.all(
                            color: const Color(0xFF1C2B19)
                                .withOpacity(0.08),
                          ),
                        ),

                        child: Text(
                          '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}',

                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B8C65),
                            fontFamily: 'Georgia',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ───────── HEADLINE ─────────

                  const Text(
                    'Jurnal\nBelajarmu,',

                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C2B19),
                      height: 1.0,
                      letterSpacing: -1.2,
                      fontFamily: 'Georgia',
                    ),
                  ),

                  const SizedBox(height: 6),

                  Wrap(
                    crossAxisAlignment:
                        WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 8,

                    children: [

                      const Text(
                        'Dalam',

                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C2B19),
                          height: 1.0,
                          letterSpacing: -1.2,
                          fontFamily: 'Georgia',
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFF3D6B35),

                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child: const Text(
                          'Satu',

                          style: TextStyle(
                            fontSize: 38,
                            fontWeight:
                                FontWeight.bold,
                            color: Color(0xFFF7F3ED),
                            height: 1.0,
                            letterSpacing: -1.2,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),

                      const Text(
                        'Tempat.',

                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C2B19),
                          height: 1.0,
                          letterSpacing: -1.2,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ───────── DESCRIPTION ─────────

                  const Text(
                    'Catat aktivitas belajar, kelola progres,\ndan refleksi setiap harinya.',

                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF7A9472),
                      height: 1.6,
                      fontFamily: 'Georgia',
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ───────── HERO CARD ─────────

                  Container(
                    width: double.infinity,
                    height: 260,

                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2B19),

                      borderRadius:
                          BorderRadius.circular(28),
                    ),

                    clipBehavior: Clip.hardEdge,

                    child: Stack(
                      children: [

                        Positioned(
                          top: 20,
                          right: 20,
                          child: _DotGrid(),
                        ),

                        Positioned(
                          top: -60,
                          right: -60,

                          child: Container(
                            width: 220,
                            height: 220,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: const Color(
                                0xFF3D6B35,
                              ).withOpacity(0.5),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: -40,
                          left: 80,

                          child: Container(
                            width: 120,
                            height: 120,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: const Color(
                                0xFF6B9E62,
                              ).withOpacity(0.15),
                            ),
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.all(28),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            mainAxisAlignment:
                                MainAxisAlignment.end,

                            children: [

                              Row(
                                children: const [

                                  _PillBadge(
                                    label: '✦ Produktif',
                                  ),

                                  SizedBox(width: 8),

                                  _PillBadge(
                                    label: '🎯 Fokus',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              const Text(
                                'Mulai hari ini.\nJangan tunda lagi.',

                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      Color(0xFFF7F3ED),
                                  height: 1.2,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ───────── FEATURE CARD ─────────

                  Row(
                    children: [

                      // REVIEW MATERI
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ReviewPage(),
                              ),
                            );
                          },

                          child: const _FeatureCard(
                            emoji: '📚',
                            title: 'Review Materi',
                            subtitle:
                                'Baca ulang materi belajar',
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // JURNAL
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DashboardPage(),
                              ),
                            );
                          },

                          child: const _FeatureCard(
                            emoji: '📋',
                            title: 'Kelola Jurnal',
                            subtitle:
                                'Lihat & tulis catatan',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ───────── BUTTON ─────────

                  SizedBox(
                    width: double.infinity,
                    height: 58,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF3D6B35),

                        foregroundColor: Colors.white,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,

                          PageRouteBuilder(
                            pageBuilder: (_, anim, __) =>
                                const DashboardPage(),

                            transitionsBuilder:
                                (_, anim, __, child) {

                              return FadeTransition(
                                opacity: anim,
                                child: child,
                              );
                            },

                            transitionDuration:
                                const Duration(
                              milliseconds: 400,
                            ),
                          ),
                        );
                      },

                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Text(
                            'Buka Jurnal Saya',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              fontFamily: 'Georgia',
                              letterSpacing: 0.3,
                            ),
                          ),

                          SizedBox(width: 10),

                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FOOTER
                  Center(
                    child: Text(
                      'StudyDrop v1.0 • Made with 💚',

                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF1C2B19)
                            .withOpacity(0.3),
                        fontFamily: 'Georgia',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,

      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(),

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),

        itemCount: 25,

        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                Colors.white.withOpacity(0.12),
          ),
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;

  const _PillBadge({
    required this.label,
  });

  @override
 Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.15),
        ),
      ),

      child: Text(
        label,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Georgia',
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFF1C2B19)
              .withOpacity(0.06),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            emoji,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C2B19),
              fontFamily: 'Georgia',
            ),
          ),

          Text(
            subtitle,

            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF7A9472),
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}