# Flow - African EdTech Platform

A comprehensive Flutter application for the African education technology market, supporting multiple user roles including students, institutions, parents, counselors, and recommenders.

## Project Overview

Flow is an offline-first EdTech platform designed for African markets with:
- Multi-role support (5 user types)
- Offline-first architecture
- Mobile money payment integration placeholders
- USSD/SMS support placeholders
- Optimized for low-end devices

## Current Implementation Status

### Completed Features

#### 1. Core Architecture
- ✅ Flutter project with feature-first architecture
- ✅ Riverpod 2.x state management
- ✅ go_router navigation with role-based routing
- ✅ Clean architecture patterns

#### 2. Design System
- ✅ Custom color theme (#0175C2 primary blue)
- ✅ Role-specific colors
- ✅ Google Fonts integration (Inter)
- ✅ Material Design 3
- ✅ WCAG 2.1 AA compliant colors

#### 3. User Roles & Permissions
- ✅ Student role
- ✅ Institution role
- ✅ Parent role
- ✅ Counselor role
- ✅ Recommender role
- ✅ Role-based access control (RBAC)
- ✅ Permission system
- ✅ Role switching for multi-role users

#### 4. Authentication
- ✅ Login screen
- ✅ Registration screen
- ✅ Firebase authentication placeholders
- ✅ Mock authentication for development
- ✅ Role selection during registration

#### 5. Dashboards
- ✅ Student dashboard with tabs (Home, Courses, Applications, Progress)
- ✅ Institution dashboard
- ✅ Parent dashboard
- ✅ Counselor dashboard
- ✅ Recommender dashboard
- ✅ Reusable dashboard scaffold
- ✅ Profile menu
- ✅ Role switcher

## Tech Stack

### Dependencies
- **State Management**: flutter_riverpod ^2.4.9
- **Navigation**: go_router ^13.0.0
- **UI**: google_fonts ^6.1.0
- **Localization**: flutter_localizations, intl
- **Storage**: shared_preferences ^2.2.2
- **Utilities**: uuid ^4.3.0

### Dev Dependencies
- build_runner ^2.4.7
- riverpod_generator ^2.3.9
- riverpod_lint ^2.3.7
- flutter_lints ^5.0.0

## Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2

### Installation

1. Navigate to project directory
```bash
cd Flow
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Development Mode

The app currently runs in development mode with:
- Mock authentication (any email/password combination works)
- Firebase integration placeholders
- Placeholder data in dashboards

### Test Credentials
Any email and password combination will work for testing. Example:
- Email: test@example.com
- Password: password123

### Selecting Roles
During registration, you can select from 5 roles:
- 🔵 Student
- 🟣 Institution
- 🟢 Parent
- 🟠 Counselor
- 🔷 Recommender

## Firebase Integration (Pending)

Firebase placeholders are in place for:
- Authentication (email/password)
- Firestore database
- Cloud Storage
- Push notifications

To integrate Firebase:
1. Create a Firebase project
2. Add Firebase configuration files
3. Uncomment Firebase dependencies in pubspec.yaml
4. Implement actual Firebase calls in auth_provider.dart
5. Set up security rules

## Color Specification

### Primary Colors
- Primary Blue: #0175C2
- Primary Dark: #015A9C
- Primary Light: #3393D4

### Role Colors
- Student: #2196F3 (Blue)
- Institution: #9C27B0 (Purple)
- Parent: #4CAF50 (Green)
- Counselor: #FF9800 (Orange)
- Recommender: #00BCD4 (Cyan)

### Status Colors
- Success: #4CAF50
- Error: #E53935
- Warning: #FFA726
- Info: #29B6F6

## Next Steps

### Immediate Priorities
1. Integrate Firebase authentication
2. Set up Firestore database structure
3. Implement offline-first data sync
4. Add course management features
5. Build application tracking system

### Future Enhancements
1. Mobile money payment integration (Flutterwave/M-Pesa)
2. USSD/SMS support via Africa's Talking
3. Offline document management
4. Real-time messaging
5. Biometric authentication
6. Multi-language support
7. PWA deployment
8. Performance optimization for low-end devices

---

Built with Flutter for Africa 🌍
