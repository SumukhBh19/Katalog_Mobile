import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/stat_card.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    _OverviewTab(),
    _QuickAnalyzeTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.glassBg.withOpacity(0.9),
        elevation: 0,
        title: Text(
          'KATALOG GENIUS',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
              ).createShader(const Rect.fromLTWH(0, 0, 160, 20)),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.accentGreen, width: 1),
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.accentGreen.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppTheme.accentGreen, blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppTheme.accentGreen,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.glassBg,
          border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.accentPrimary,
          unselectedItemColor: AppTheme.textDim,
          selectedLabelStyle: GoogleFonts.orbitron(fontSize: 10),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              activeIcon: Icon(Icons.document_scanner),
              label: 'Analyzer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Overview Tab ─────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Good morning, Seller 👋',
            style: TextStyle(color: AppTheme.textDim, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Dashboard Overview',
            style: GoogleFonts.orbitron(
              color: AppTheme.textMain,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: StatCard(label: 'Total Scans', value: '0'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(label: 'Items Detected', value: '0'),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Avg. Inference',
                  value: '—',
                  valueColor: AppTheme.accentSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(label: 'SKUs Cataloged', value: '0'),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
          const SizedBox(height: 28),
          Text(
            'QUICK ACTIONS',
            style: TextStyle(
              color: AppTheme.textDim,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _ActionCard(
            icon: Icons.document_scanner_rounded,
            title: 'Analyze Shelf',
            subtitle: 'Upload a shelf photo for GPU detection',
            onTap: () => context.go('/seller/dashboard/analyzer'),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.edit_note_rounded,
            title: 'Add Items Manually',
            subtitle: 'Enter product name, SKU & qty by hand',
            onTap: () => context.go('/seller/dashboard/catalog'),
          ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.verified_user_outlined,
            title: 'ONDC Status',
            subtitle: 'Check your network participant status',
            onTap: () {},
            accentColor: AppTheme.accentSecondary,
          ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? accentColor;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppTheme.accentPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.glassCard(borderColor: color.withOpacity(0.2)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textMain,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(color: AppTheme.textDim, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textDim.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick Analyze Tab ────────────────────────────────────────────────────────
class _QuickAnalyzeTab extends StatelessWidget {
  const _QuickAnalyzeTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 60,
            color: AppTheme.accentPrimary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'GPU Shelf Analyzer',
            style: GoogleFonts.orbitron(
              color: AppTheme.textMain,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap below to start a new scan',
            style: TextStyle(color: AppTheme.textDim, fontSize: 13),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: GestureDetector(
              onTap: () => context.go('/seller/dashboard/analyzer'),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppTheme.neonShadow(
                    color: AppTheme.accentSecondary,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: Colors.black),
                    const SizedBox(width: 10),
                    Text(
                      'OPEN ANALYZER',
                      style: GoogleFonts.orbitron(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Tab ───────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.accentPrimary, width: 2),
              color: AppTheme.glassBg,
            ),
            child: const Icon(
              Icons.person,
              color: AppTheme.accentPrimary,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Seller Account',
            style: GoogleFonts.orbitron(
              color: AppTheme.textMain,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ONDC Network Participant',
            style: TextStyle(color: AppTheme.textDim, fontSize: 12),
          ),
          const SizedBox(height: 28),
          _ProfileItem(
            icon: Icons.verified_user_outlined,
            label: 'KYC Status',
            value: 'Pending',
            valueColor: Colors.amber,
          ),
          _ProfileItem(
            icon: Icons.business_outlined,
            label: 'NP Type',
            value: 'NP-MSN',
          ),
          _ProfileItem(
            icon: Icons.receipt_outlined,
            label: 'GST Number',
            value: 'Not added',
          ),
          _ProfileItem(
            icon: Icons.credit_card_outlined,
            label: 'PAN Number',
            value: 'Not added',
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              await AuthService.logout();
              if (context.mounted) context.go('/');
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.glassCard(),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textDim, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.textMain, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textDim,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
