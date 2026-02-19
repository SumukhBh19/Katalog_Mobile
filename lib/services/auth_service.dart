import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

class SellerDetails {
  final String name;
  final String email;
  final String phone;
  final String password;
  // KYC fields (ONDC mandated)
  final String? panNumber;
  final String? gstNumber;
  final String? bankAccount;
  final String? ifscCode;

  SellerDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.panNumber,
    this.gstNumber,
    this.bankAccount,
    this.ifscCode,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
    if (panNumber != null) 'pan_number': panNumber,
    if (gstNumber != null) 'gst_number': gstNumber,
    if (bankAccount != null) 'bank_account': bankAccount,
    if (ifscCode != null) 'ifsc_code': ifscCode,
  };
}

/// Auth Service — ONDC-compliant: login, OTP 2FA, register with KYC
class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  /// Step 1: Login with email + password → triggers OTP SMS
  static Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Login failed');
    }
  }

  /// Step 2: Verify OTP (ONDC 2FA) → returns JWT token
  static Future<void> verifyOtp(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': code}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'] as String;
      final userData = data['user'] as Map<String, dynamic>;
      await SecureStorageService.saveSession(
        token: token,
        email: userData['email'] ?? '',
        userData: userData,
      );
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'OTP verification failed');
    }
  }

  /// Register new seller with KYC details
  static Future<void> register(SellerDetails details) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(details.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Registration failed');
    }
  }

  /// Logout — clears all secure storage
  static Future<void> logout() async {
    await SecureStorageService.clearAll();
  }
}
