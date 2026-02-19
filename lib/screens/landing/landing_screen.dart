import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neural_background.dart';
import '../../widgets/neon_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Stack(
        children: [
          // Animated background
          const Positioned.fill(child: NeuralBackground()),

          // Radial gradients
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.8, -0.6),
                  radius: 0.7,
                  colors: [Color(0x0D7000FF), Colors.transparent],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavbar(context),
                  _buildHero(context),
                  _buildFeatures(),
                  _buildStory(),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KATALOG GENIUS',
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 20)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.accentGreen, width: 1),
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.accentGreen.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppTheme.accentGreen, blurRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'RTX GPU READY',
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
    );
  }

  Widget _buildHero(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Text(
            'GPU-POWERED\nSHELF ANALYTICS',
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(const Rect.fromLTWH(0, 0, 300, 80)),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            'AI-driven retail intelligence.\nDetect, count, and catalog your inventory\nwith real-time GPU inference.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textDim,
              fontSize: 15,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 40),
          SizedBox(
            width: 240,
            child: NeonButton(
              label: 'GET STARTED',
              icon: Icons.arrow_forward_rounded,
              onTap: () => context.go('/seller/login'),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go('/seller/login'),
            child: Text(
              'Already a seller? Sign in',
              style: TextStyle(
                color: AppTheme.accentPrimary.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      {
        'icon': '⚡',
        'title': 'GPU Inference',
        'desc':
            'Real-time shelf detection powered by NVIDIA RTX GPUs for sub-100ms analysis.',
      },
      {
        'icon': '🔍',
        'title': 'Catalog Detection',
        'desc':
            'Identify SKUs, brands, and products on crowded retail shelves automatically.',
      },
      {
        'icon': '📦',
        'title': 'Live Inventory',
        'desc':
            'Track stock levels, gaps, and product counts with ONDC-ready data export.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Text(
            'CAPABILITIES',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              color: AppTheme.accentPrimary,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Built for Retail Intelligence',
            style: GoogleFonts.orbitron(
              color: AppTheme.textMain,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...features.asMap().entries.map(
            (e) => _FeatureCard(
              icon: e.value['icon']!,
              title: e.value['title']!,
              desc: e.value['desc']!,
              delay: (e.key * 100).ms,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassCard(
          borderColor: AppTheme.accentSecondary.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OUR MISSION',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                color: AppTheme.accentSecondary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Democratizing Retail Intelligence for Every Seller',
              style: GoogleFonts.orbitron(
                color: AppTheme.textMain,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Katalog Genius empowers sellers on the ONDC network with enterprise-grade GPU analytics — '
              'no expensive hardware, no data scientists required. Upload a shelf photo, and our AI '
              'does the rest: counting, classifying, and cataloging in real time.',
              style: TextStyle(
                color: AppTheme.textDim,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Divider(color: Color(0x1AFFFFFF)),
          const SizedBox(height: 16),
          Text(
            'KATALOG GENIUS',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
                ).createShader(const Rect.fromLTWH(0, 0, 150, 16)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2026 Katalog Genius. ONDC-Ready Platform.',
            style: TextStyle(color: AppTheme.textDim, fontSize: 11),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final Duration delay;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.glassCard(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.orbitron(
                        color: AppTheme.textMain,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: TextStyle(
                        color: AppTheme.textDim,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay)
        .slideX(begin: 0.1, end: 0);
  }
}
