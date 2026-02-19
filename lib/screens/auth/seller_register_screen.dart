import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/neon_button.dart';

class SellerRegisterScreen extends StatefulWidget {
  const SellerRegisterScreen({super.key});

  @override
  State<SellerRegisterScreen> createState() => _SellerRegisterScreenState();
}

class _SellerRegisterScreenState extends State<SellerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _panCtrl = TextEditingController();
  final _gstCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _showKyc = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _passwordCtrl,
      _panCtrl,
      _gstCtrl,
      _bankCtrl,
      _ifscCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.register(
        SellerDetails(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text,
          panNumber: _panCtrl.text.trim().isEmpty ? null : _panCtrl.text.trim(),
          gstNumber: _gstCtrl.text.trim().isEmpty ? null : _gstCtrl.text.trim(),
          bankAccount: _bankCtrl.text.trim().isEmpty
              ? null
              : _bankCtrl.text.trim(),
          ifscCode: _ifscCtrl.text.trim().isEmpty
              ? null
              : _ifscCtrl.text.trim(),
        ),
      );
      if (mounted) {
        context.go(
          '/seller/otp',
          extra: {
            'phone': _phoneCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
          },
        );
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go('/seller/login'),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.textDim,
                      size: 16,
                    ),
                    Text(
                      'Back',
                      style: TextStyle(color: AppTheme.textDim, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'SELLER REGISTER',
                style: GoogleFonts.orbitron(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        AppTheme.accentPrimary,
                        AppTheme.accentSecondary,
                      ],
                    ).createShader(const Rect.fromLTWH(0, 0, 220, 30)),
                ),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 8),
              Text(
                'Create your Katalog Genius seller account',
                style: TextStyle(color: AppTheme.textDim, fontSize: 14),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Basic Info ───────────────────────────────
                    _sectionLabel('BASIC INFORMATION'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration: AppTheme.neonInput(
                        'Full Name',
                        icon: Icons.person_outline,
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration: AppTheme.neonInput(
                        'Email Address',
                        icon: Icons.email_outlined,
                      ),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter valid email'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration: AppTheme.neonInput(
                        'Phone Number',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (v) => (v == null || v.length < 10)
                          ? 'Enter valid phone'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      style: const TextStyle(color: AppTheme.textMain),
                      decoration:
                          AppTheme.neonInput(
                            'Password',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textDim,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Min 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // ── KYC Section ──────────────────────────────
                    GestureDetector(
                      onTap: () => setState(() => _showKyc = !_showKyc),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.accentSecondary.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.accentSecondary.withOpacity(0.05),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: AppTheme.accentSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KYC Details (ONDC Required)',
                                    style: TextStyle(
                                      color: AppTheme.textMain,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'PAN, GST, and bank details for ONDC onboarding',
                                    style: TextStyle(
                                      color: AppTheme.textDim,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _showKyc ? Icons.expand_less : Icons.expand_more,
                              color: AppTheme.textDim,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_showKyc) ...[
                      const SizedBox(height: 14),
                      _sectionLabel('KYC INFORMATION'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _panCtrl,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: AppTheme.textMain),
                        decoration: AppTheme.neonInput(
                          'PAN Number',
                          hint: 'ABCDE1234F',
                          icon: Icons.credit_card_outlined,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _gstCtrl,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: AppTheme.textMain),
                        decoration: AppTheme.neonInput(
                          'GST Number',
                          hint: '22AAAAA0000A1Z5',
                          icon: Icons.receipt_outlined,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _bankCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.textMain),
                        decoration: AppTheme.neonInput(
                          'Bank Account Number',
                          icon: Icons.account_balance_outlined,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _ifscCtrl,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: AppTheme.textMain),
                        decoration: AppTheme.neonInput(
                          'IFSC Code',
                          hint: 'SBIN0000000',
                          icon: Icons.swap_horiz_outlined,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    NeonButton(
                      label: 'CREATE ACCOUNT',
                      onTap: _register,
                      isLoading: _loading,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already registered? ',
                          style: TextStyle(
                            color: AppTheme.textDim,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/seller/login'),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: AppTheme.accentPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: TextStyle(
      color: AppTheme.textDim,
      fontSize: 11,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
    ),
  );
}
