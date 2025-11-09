# Cookie Implementation Checklist

Quick reference for implementing the cookie consent system in order of priority.

---

## Week 1: Foundation (P0-P1)

### Day 1: Setup & Constants
- [ ] Create `cookie_constants.dart` with all enums and constants
- [ ] Add dependencies: `freezed_annotation`, `build_runner`, `freezed`, `json_serializable`
- [ ] Run `flutter pub get`

### Day 2: Core Models
- [ ] Create `user_consent.dart` model with Freezed
- [ ] Create `cookie_data.dart` model with Freezed
- [ ] Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Test model factories and extensions

### Day 3: Services - Part 1
- [ ] Create `consent_service.dart`
- [ ] Implement CRUD operations
- [ ] Implement consent validation logic
- [ ] Test consent service methods

### Day 4: Services - Part 2
- [ ] Create `cookie_service.dart`
- [ ] Add dependency: `uuid`
- [ ] Implement data storage with consent checks
- [ ] Implement data export functionality

### Day 5: Services - Part 3
- [ ] Create `analytics_service.dart`
- [ ] Implement session tracking
- [ ] Implement event tracking
- [ ] Create Riverpod providers in `cookie_providers.dart`

---

## Week 2: User Interface (P2)

### Day 6-7: Cookie Banner
- [ ] Create `cookie_banner.dart`
- [ ] Implement slide-in animation
- [ ] Add "Accept All", "Essential Only", and "Customize" buttons
- [ ] Test banner appearance logic

### Day 8-9: Preferences Modal
- [ ] Create `cookie_preferences_modal.dart`
- [ ] Implement category toggles
- [ ] Add save/reject functionality
- [ ] Test category selection logic

### Day 10-11: Settings Page
- [ ] Create `cookie_settings_screen.dart`
- [ ] Display current consent status
- [ ] Implement export data functionality
- [ ] Implement delete data functionality

### Day 12: Integration
- [ ] Update `main.dart` to initialize SharedPreferences
- [ ] Add cookie settings route to `app_router.dart`
- [ ] Integrate banner into main app scaffold
- [ ] Test end-to-end user flow

---

## Week 3: Admin Dashboard (P3)

### Day 13-14: Consent Analytics
- [ ] Create `consent_analytics_screen.dart`
- [ ] Add dependency: `fl_chart`
- [ ] Implement summary cards
- [ ] Create pie chart for consent distribution

### Day 15: Analytics Charts
- [ ] Implement category consent bar chart
- [ ] Add detailed breakdown table
- [ ] Test with real data

### Day 16-17: User Data Viewer
- [ ] Create `user_cookie_viewer_screen.dart`
- [ ] Display user consent status
- [ ] Show analytics summary
- [ ] Implement category filtering

### Day 18: Admin Navigation
- [ ] Add cookie routes to `admin_sidebar.dart`
- [ ] Add routes to `app_router.dart`
- [ ] Test admin navigation
- [ ] Verify role-based access

---

## Week 4: Backend & Testing (P4)

### Day 19-20: Firebase Structure (Optional)
- [ ] Design Firestore collections
- [ ] Create security rules
- [ ] Plan indexes
- [ ] Document query patterns

### Day 21-22: Backend Integration (Optional)
- [ ] Implement `firebase_cookie_service.dart`
- [ ] Add Firebase SDK dependencies
- [ ] Test CRUD operations
- [ ] Implement real-time updates

### Day 23-24: Unit Tests
- [ ] Write tests for `user_consent` model
- [ ] Write tests for `consent_service`
- [ ] Write tests for `cookie_service`
- [ ] Write tests for `analytics_service`
- [ ] Target 80%+ code coverage

### Day 25: Integration Tests
- [ ] Test user consent flow
- [ ] Test preferences customization
- [ ] Test data export/delete
- [ ] Test admin analytics
- [ ] Test admin user viewer

### Day 26: GDPR Compliance
- [ ] Verify consent before non-essential cookies
- [ ] Test essential-only option
- [ ] Verify data export works
- [ ] Verify data deletion works
- [ ] Test consent withdrawal
- [ ] Check privacy policy links

---

## Quick Start (Minimum Viable Product)

If you need a working system ASAP, implement these tasks first:

### Phase 1: Minimum (3 days)
1. Day 1: Create constants, enums, and models
2. Day 2: Create consent service and cookie service
3. Day 3: Create cookie banner with accept/reject buttons

This gives you:
- ✅ Basic consent tracking
- ✅ User-facing cookie banner
- ✅ GDPR-compliant essential-only option

### Phase 2: Standard (5 days)
4. Day 4: Create preferences modal
5. Day 5: Create settings page
6. Day 6: Integrate into app
7. Day 7-8: Test and fix bugs

This adds:
- ✅ Granular cookie control
- ✅ User data management
- ✅ Complete user experience

### Phase 3: Complete (10 days)
9. Day 9-13: Implement admin analytics dashboard
10. Day 14-18: Implement admin user viewer
11. Day 19-20: Write tests

This completes:
- ✅ Admin oversight capabilities
- ✅ Data analytics
- ✅ Production-ready system

---

## File Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── cookie_constants.dart ✨ NEW
│   ├── models/
│   │   ├── user_consent.dart ✨ NEW
│   │   └── cookie_data.dart ✨ NEW
│   ├── services/
│   │   ├── consent_service.dart ✨ NEW
│   │   ├── cookie_service.dart ✨ NEW
│   │   ├── analytics_service.dart ✨ NEW
│   │   └── firebase_cookie_service.dart ✨ NEW (optional)
│   └── providers/
│       └── cookie_providers.dart ✨ NEW
│
├── features/
│   ├── shared/
│   │   └── cookies/
│   │       └── presentation/
│   │           ├── cookie_banner.dart ✨ NEW
│   │           ├── cookie_preferences_modal.dart ✨ NEW
│   │           └── cookie_settings_screen.dart ✨ NEW
│   │
│   └── admin/
│       └── cookies/
│           └── presentation/
│               ├── consent_analytics_screen.dart ✨ NEW
│               └── user_cookie_viewer_screen.dart ✨ NEW
│
├── routing/
│   └── app_router.dart 📝 MODIFY
│
└── main.dart 📝 MODIFY

test/
└── core/
    ├── models/
    │   ├── user_consent_test.dart ✨ NEW
    │   └── cookie_data_test.dart ✨ NEW
    └── services/
        ├── consent_service_test.dart ✨ NEW
        ├── cookie_service_test.dart ✨ NEW
        └── analytics_service_test.dart ✨ NEW
```

**Legend:**
- ✨ NEW: Create new file
- 📝 MODIFY: Update existing file

---

## Dependencies to Add

```yaml
dependencies:
  # Existing dependencies...
  freezed_annotation: ^2.4.1
  uuid: ^4.2.1
  fl_chart: ^0.66.0  # For admin charts

dev_dependencies:
  # Existing dependencies...
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

Run after updating pubspec.yaml:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Testing Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/services/consent_service_test.dart

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Analyze code
flutter analyze

# Format code
dart format lib test
```

---

## Common Issues & Solutions

### Issue: Freezed generation fails
**Solution:** Delete generated files and rebuild
```bash
find . -name "*.freezed.dart" -delete
find . -name "*.g.dart" -delete
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: SharedPreferences not initialized
**Solution:** Ensure `main.dart` properly initializes it
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const MyApp(),
  ));
}
```

### Issue: Banner not showing
**Solution:** Check these conditions:
1. User ID is passed correctly
2. `needsConsent` returns true
3. Banner is in widget tree (use Flutter DevTools)
4. No z-index issues with Stack

### Issue: Consent not persisting
**Solution:** Verify SharedPreferences keys
```dart
// Check stored data
final prefs = await SharedPreferences.getInstance();
print(prefs.getKeys());
```

---

## Performance Checklist

- [ ] Cookie data pruned regularly (max 90 days)
- [ ] Consent checked before heavy operations
- [ ] Analytics batched, not real-time
- [ ] LocalStorage cleared periodically
- [ ] No blocking operations on UI thread
- [ ] Charts lazy-loaded in admin dashboard

---

## Security Checklist

- [ ] No sensitive data in cookies without consent
- [ ] User IDs hashed when anonymized
- [ ] IP addresses not stored by default
- [ ] Admin routes require authentication
- [ ] Data export rate-limited
- [ ] Consent tampering prevented

---

## GDPR Compliance Checklist

### Before Launch
- [ ] Cookie banner appears before non-essential cookies
- [ ] "Essential Only" option available
- [ ] Clear descriptions of cookie categories
- [ ] Privacy policy linked and accessible
- [ ] Consent freely given (no forced acceptance)
- [ ] Consent specific to each category
- [ ] Consent can be withdrawn anytime

### User Rights
- [ ] Right to access data (export)
- [ ] Right to deletion (delete data)
- [ ] Right to rectification (update preferences)
- [ ] Right to portability (JSON export)
- [ ] Right to object (decline cookies)

### Record Keeping
- [ ] Consent timestamp recorded
- [ ] Consent history maintained
- [ ] IP address logged (optional)
- [ ] User agent captured
- [ ] Version tracked

### Data Retention
- [ ] Consent expires after 1 year
- [ ] Consent renewal prompted
- [ ] Old data pruned (90 days)
- [ ] Deleted users purged completely

---

## Launch Checklist

### Pre-Launch
- [ ] All unit tests passing
- [ ] Integration tests passing
- [ ] Manual testing complete
- [ ] GDPR compliance verified
- [ ] Privacy policy updated
- [ ] Admin dashboard accessible
- [ ] Performance benchmarks met

### Launch Day
- [ ] Monitor error logs
- [ ] Track consent rates
- [ ] Check banner appearance
- [ ] Verify analytics collection
- [ ] Test on multiple devices
- [ ] Monitor server load (if backend)

### Post-Launch (Week 1)
- [ ] Review consent statistics
- [ ] Check for bugs
- [ ] Gather user feedback
- [ ] Optimize performance
- [ ] Update documentation

---

## Success Metrics

### User Metrics
- **Target: 80%+ consent rate**
  - Track: Accepted vs Customized vs Declined
  - Optimize: Banner messaging, timing

- **Target: <5% banner dismissals without consent**
  - Track: Banner impressions vs actions
  - Optimize: Banner design, CTA clarity

### Technical Metrics
- **Target: <100ms banner render time**
  - Measure: Time to first render
  - Optimize: Lazy loading, caching

- **Target: <50KB storage per user**
  - Measure: LocalStorage size
  - Optimize: Data pruning, compression

### Compliance Metrics
- **Target: 100% consent before tracking**
  - Audit: All analytics calls
  - Fix: Add consent checks

- **Target: <24h data export time**
  - Measure: Export request to delivery
  - Optimize: Background processing

---

## Support & Resources

### Documentation
- Full implementation guide: `COOKIES_IMPLEMENTATION_GUIDE.md`
- Architecture plan: `COOKIES_IMPLEMENTATION_PLAN.md`
- API reference: Generate with `dart doc`

### Getting Help
- Check existing code in `lib/core/services/`
- Review Riverpod docs for state management
- Flutter docs for widget implementation
- GDPR guidelines for compliance

### Code Review Checklist
- [ ] Follows project style guide
- [ ] No hardcoded strings
- [ ] Error handling comprehensive
- [ ] Comments for complex logic
- [ ] Tests written and passing
- [ ] Performance optimized
- [ ] Security vulnerabilities addressed

---

**Ready to start? Begin with Week 1, Day 1: Setup & Constants**
