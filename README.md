# Katalog Genius — Flutter Mobile App

**GPU-powered retail shelf analytics platform with ONDC-compliant seller onboarding.**

---

## Features

| Feature | Description |
|---|---|
| 🏠 Landing Page | Animated hero, features, story, footer |
| 🔐 Seller Auth | Email + password login with ONDC 2FA (OTP) |
| 📋 KYC Registration | PAN, GST, Bank account, IFSC — ONDC mandated |
| 📊 Dashboard | Overview stats, quick actions, profile/KYC status |
| 📷 Shelf Analyzer | Upload/capture a shelf image → GPU inference → bounding boxes + inventory |
| ✏️ Manual Catalog | Add items by name, brand, SKU & qty without needing an image |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| Routing | `go_router` |
| Networking | `http` |
| Image Picking | `image_picker` |
| Fonts | `google_fonts` (Orbitron + Inter) |
| Animations | `flutter_animate` |
| Secure Storage | `flutter_secure_storage` (ONDC JWT storage) |
| Backend | Python / FastAPI (`requirements.txt` in repo root) |

---

## Project Structure

```
lib/
├── main.dart
├── app_router.dart
├── theme/app_theme.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── secure_storage_service.dart
├── widgets/
│   ├── neural_background.dart
│   ├── neon_button.dart
│   ├── stat_card.dart
│   ├── inventory_list_tile.dart
│   └── loading_overlay.dart
└── screens/
    ├── landing/landing_screen.dart
    ├── auth/seller_login_screen.dart
    ├── auth/seller_register_screen.dart
    ├── auth/otp_screen.dart
    ├── dashboard/seller_dashboard_screen.dart
    ├── analyzer/shelf_analyzer_screen.dart
    └── catalog/manual_item_screen.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code with Flutter plugin
- Python ≥ 3.9 (for the backend — see `requirements.txt`)

Requires Gradle 8.13 and Kotlin 1.9.24 for Flutter 3.41 compatibility.

### Flutter Setup

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

### Backend Setup

```bash
# Install Python dependencies
pip install -r requirements.txt

# Start the FastAPI backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Connecting Flutter to the Backend

Edit the `_baseUrl` constant in both:
- `lib/services/api_service.dart`
- `lib/services/auth_service.dart`

| Environment | URL |
|---|---|
| Android emulator | `http://10.0.2.2:8000` |
| Physical device (LAN) | `http://192.168.x.x:8000` |
| Production | `https://your-domain.com` |

---

## Android Permissions

Add to `android/app/src/main/AndroidManifest.xml` (inside `<manifest>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

## iOS Permissions

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Used to capture retail shelf images for GPU analysis</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to select shelf images from your gallery</string>
```

---

## ONDC Compliance

| Requirement | Status |
|---|---|
| Seller login (mandatory) | ✅ |
| 2FA / OTP verification | ✅ |
| KYC details at registration (PAN, GST, Bank/IFSC) | ✅ |
| Secure JWT storage | ✅ `flutter_secure_storage` |
| HTTPS-ready API | ✅ Configurable base URL |
| Cryptographic key pairs (Ed25519) | 🔧 Backend responsibility |

---

## Routes

| Path | Screen |
|---|---|
| `/` | Landing |
| `/seller/login` | Login |
| `/seller/register` | Register + KYC |
| `/seller/otp` | OTP Verification |
| `/seller/dashboard` | Dashboard |
| `/seller/dashboard/analyzer` | Shelf Analyzer |
| `/seller/dashboard/catalog` | Manual Item Entry |

---

## License

MIT
