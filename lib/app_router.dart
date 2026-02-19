import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/auth/seller_login_screen.dart';
import 'screens/auth/seller_register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/dashboard/seller_dashboard_screen.dart';
import 'screens/analyzer/shelf_analyzer_screen.dart';
import 'screens/catalog/manual_item_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/seller/login',
      name: 'seller-login',
      builder: (context, state) => const SellerLoginScreen(),
    ),
    GoRoute(
      path: '/seller/register',
      name: 'seller-register',
      builder: (context, state) => const SellerRegisterScreen(),
    ),
    GoRoute(
      path: '/seller/otp',
      name: 'seller-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>? ?? {};
        return OtpScreen(
          phone: extra['phone'] ?? '',
          email: extra['email'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/seller/dashboard',
      name: 'seller-dashboard',
      builder: (context, state) => const SellerDashboardScreen(),
      routes: [
        GoRoute(
          path: 'analyzer',
          name: 'analyzer',
          builder: (context, state) => const ShelfAnalyzerScreen(),
        ),
        GoRoute(
          path: 'catalog',
          name: 'catalog',
          builder: (context, state) => const ManualItemScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF050505),
    body: Center(
      child: Text(
        'Page not found',
        style: TextStyle(color: Colors.white.withOpacity(0.5)),
      ),
    ),
  ),
);
