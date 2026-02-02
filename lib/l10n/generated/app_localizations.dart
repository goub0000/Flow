import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flow - African EdTech Platform'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @backToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to Top'**
  String get backToTop;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navUniversities.
  ///
  /// In en, this message translates to:
  /// **'Universities'**
  String get navUniversities;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get navSignIn;

  /// No description provided for @navGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get navGetStarted;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'African EdTech Platform'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginPasswordEmpty;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginPasswordTooShort;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get loginOr;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginCreateAccount;

  /// No description provided for @loginResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get loginResetPassword;

  /// No description provided for @loginAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get loginAlreadyHaveAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Flow'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your educational journey'**
  String get registerSubtitle;

  /// No description provided for @registerAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerAppBarTitle;

  /// No description provided for @registerFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerFullNameLabel;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'I am a...'**
  String get registerRoleLabel;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get registerConfirmPasswordEmpty;

  /// No description provided for @registerPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordsDoNotMatch;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @registerLoginInstead.
  ///
  /// In en, this message translates to:
  /// **'Login Instead'**
  String get registerLoginInstead;

  /// No description provided for @registerResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get registerResetPassword;

  /// No description provided for @registerLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get registerLogin;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordReq8Chars.
  ///
  /// In en, this message translates to:
  /// **'8+ characters'**
  String get passwordReq8Chars;

  /// No description provided for @passwordReqUppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase'**
  String get passwordReqUppercase;

  /// No description provided for @passwordReqLowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase'**
  String get passwordReqLowercase;

  /// No description provided for @passwordReqNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get passwordReqNumber;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you instructions to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get forgotPasswordEmailLabel;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotPasswordSendButton;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get forgotPasswordCheckEmail;

  /// No description provided for @forgotPasswordSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent password reset instructions to:'**
  String get forgotPasswordSentTo;

  /// No description provided for @forgotPasswordDidntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email?'**
  String get forgotPasswordDidntReceive;

  /// No description provided for @forgotPasswordCheckSpam.
  ///
  /// In en, this message translates to:
  /// **'Check your spam/junk folder'**
  String get forgotPasswordCheckSpam;

  /// No description provided for @forgotPasswordCheckCorrect.
  ///
  /// In en, this message translates to:
  /// **'Make sure the email address is correct'**
  String get forgotPasswordCheckCorrect;

  /// No description provided for @forgotPasswordWait.
  ///
  /// In en, this message translates to:
  /// **'Wait a few minutes for the email to arrive'**
  String get forgotPasswordWait;

  /// No description provided for @forgotPasswordResend.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get forgotPasswordResend;

  /// No description provided for @emailVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get emailVerifyTitle;

  /// No description provided for @emailVerifyAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get emailVerifyAppBarTitle;

  /// No description provided for @emailVerifySentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to:'**
  String get emailVerifySentTo;

  /// No description provided for @emailVerifyNextSteps.
  ///
  /// In en, this message translates to:
  /// **'Next Steps'**
  String get emailVerifyNextSteps;

  /// No description provided for @emailVerifyStep1.
  ///
  /// In en, this message translates to:
  /// **'Check your email inbox'**
  String get emailVerifyStep1;

  /// No description provided for @emailVerifyStep2.
  ///
  /// In en, this message translates to:
  /// **'Click the verification link'**
  String get emailVerifyStep2;

  /// No description provided for @emailVerifyStep3.
  ///
  /// In en, this message translates to:
  /// **'Return here to continue'**
  String get emailVerifyStep3;

  /// No description provided for @emailVerifyCheckButton.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Verified My Email'**
  String get emailVerifyCheckButton;

  /// No description provided for @emailVerifyChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get emailVerifyChecking;

  /// No description provided for @emailVerifyResend.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get emailVerifyResend;

  /// No description provided for @emailVerifyResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String emailVerifyResendIn(int seconds);

  /// No description provided for @emailVerifyNotYet.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Please check your inbox.'**
  String get emailVerifyNotYet;

  /// No description provided for @emailVerifyCheckError.
  ///
  /// In en, this message translates to:
  /// **'Error checking verification: {error}'**
  String emailVerifyCheckError(String error);

  /// No description provided for @emailVerifySent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent! Check your inbox.'**
  String get emailVerifySent;

  /// No description provided for @emailVerifySendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send email: {error}'**
  String emailVerifySendFailed(String error);

  /// No description provided for @emailVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Email Verified!'**
  String get emailVerifySuccess;

  /// No description provided for @emailVerifySuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your email has been successfully verified.'**
  String get emailVerifySuccessMessage;

  /// No description provided for @emailVerifyDidntReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email?'**
  String get emailVerifyDidntReceive;

  /// No description provided for @emailVerifySpamTip.
  ///
  /// In en, this message translates to:
  /// **'Check your spam/junk folder'**
  String get emailVerifySpamTip;

  /// No description provided for @emailVerifyCorrectTip.
  ///
  /// In en, this message translates to:
  /// **'Make sure the email is correct'**
  String get emailVerifyCorrectTip;

  /// No description provided for @emailVerifyWaitTip.
  ///
  /// In en, this message translates to:
  /// **'Wait a few minutes and try resending'**
  String get emailVerifyWaitTip;

  /// No description provided for @emailVerifyAutoCheck.
  ///
  /// In en, this message translates to:
  /// **'Auto-checking every 5 seconds'**
  String get emailVerifyAutoCheck;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flow'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Your comprehensive platform for educational opportunities across Africa'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Courses'**
  String get onboardingCoursesTitle;

  /// No description provided for @onboardingCoursesDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse and enroll in courses from top institutions across the continent'**
  String get onboardingCoursesDesc;

  /// No description provided for @onboardingProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboardingProgressTitle;

  /// No description provided for @onboardingProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your academic journey with detailed analytics and insights'**
  String get onboardingProgressDesc;

  /// No description provided for @onboardingConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect & Collaborate'**
  String get onboardingConnectTitle;

  /// No description provided for @onboardingConnectDesc.
  ///
  /// In en, this message translates to:
  /// **'Engage with counselors, get recommendations, and manage applications'**
  String get onboardingConnectDesc;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingFeatureCourseSelection.
  ///
  /// In en, this message translates to:
  /// **'Wide selection of courses'**
  String get onboardingFeatureCourseSelection;

  /// No description provided for @onboardingFeatureFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter by category and level'**
  String get onboardingFeatureFilter;

  /// No description provided for @onboardingFeatureDetails.
  ///
  /// In en, this message translates to:
  /// **'Detailed course information'**
  String get onboardingFeatureDetails;

  /// No description provided for @onboardingFeatureProgress.
  ///
  /// In en, this message translates to:
  /// **'Real-time progress tracking'**
  String get onboardingFeatureProgress;

  /// No description provided for @onboardingFeatureAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Performance analytics'**
  String get onboardingFeatureAnalytics;

  /// No description provided for @onboardingFeatureAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievement system'**
  String get onboardingFeatureAchievements;

  /// No description provided for @heroTrustBadge.
  ///
  /// In en, this message translates to:
  /// **'Trusted by 200+ Universities'**
  String get heroTrustBadge;

  /// No description provided for @heroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect\nUniversity Match'**
  String get heroHeadline;

  /// No description provided for @heroSubheadline.
  ///
  /// In en, this message translates to:
  /// **'Discover, compare, and apply to 18,000+ universities\nwith personalized recommendations powered by AI'**
  String get heroSubheadline;

  /// No description provided for @heroStartFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get heroStartFreeTrial;

  /// No description provided for @heroTakeATour.
  ///
  /// In en, this message translates to:
  /// **'Take a Tour'**
  String get heroTakeATour;

  /// No description provided for @heroStatActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get heroStatActiveUsers;

  /// No description provided for @heroStatUniversities.
  ///
  /// In en, this message translates to:
  /// **'Universities'**
  String get heroStatUniversities;

  /// No description provided for @heroStatCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get heroStatCountries;

  /// No description provided for @whyChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Choose Flow?'**
  String get whyChooseTitle;

  /// No description provided for @whyChooseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Built for Africa, designed for everyone'**
  String get whyChooseSubtitle;

  /// No description provided for @valueOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline-First'**
  String get valueOfflineTitle;

  /// No description provided for @valueOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'Access your content anytime, anywhere—even without internet connectivity'**
  String get valueOfflineDesc;

  /// No description provided for @valueMobileMoneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get valueMobileMoneyTitle;

  /// No description provided for @valueMobileMoneyDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay with M-Pesa, MTN Money, and other local payment methods you trust'**
  String get valueMobileMoneyDesc;

  /// No description provided for @valueMultiLangTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Language'**
  String get valueMultiLangTitle;

  /// No description provided for @valueMultiLangDesc.
  ///
  /// In en, this message translates to:
  /// **'Platform available in multiple African languages for your convenience'**
  String get valueMultiLangDesc;

  /// No description provided for @socialProofTitle.
  ///
  /// In en, this message translates to:
  /// **'Trusted by Leading Institutions Across Africa'**
  String get socialProofTitle;

  /// No description provided for @testimonialsTitle.
  ///
  /// In en, this message translates to:
  /// **'What Our Users Say'**
  String get testimonialsTitle;

  /// No description provided for @testimonialsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Success stories from students, institutions, and educators'**
  String get testimonialsSubtitle;

  /// No description provided for @quizBadge.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get quizBadge;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Sure Where\nto Start?'**
  String get quizTitle;

  /// No description provided for @quizDescription.
  ///
  /// In en, this message translates to:
  /// **'Take our quick quiz to discover universities and programs that match your interests, goals, and academic profile.'**
  String get quizDescription;

  /// No description provided for @quizDuration.
  ///
  /// In en, this message translates to:
  /// **'2 minutes'**
  String get quizDuration;

  /// No description provided for @quizAIPowered.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered'**
  String get quizAIPowered;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need'**
  String get featuresTitle;

  /// No description provided for @featuresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A complete educational ecosystem designed for modern Africa'**
  String get featuresSubtitle;

  /// No description provided for @featureLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Learning'**
  String get featureLearningTitle;

  /// No description provided for @featureLearningDesc.
  ///
  /// In en, this message translates to:
  /// **'Access courses, track progress, and manage applications all in one place'**
  String get featureLearningDesc;

  /// No description provided for @featureCollabTitle.
  ///
  /// In en, this message translates to:
  /// **'Built for Collaboration'**
  String get featureCollabTitle;

  /// No description provided for @featureCollabDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect students, parents, counselors, and institutions seamlessly'**
  String get featureCollabDesc;

  /// No description provided for @featureSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise-Grade Security'**
  String get featureSecurityTitle;

  /// No description provided for @featureSecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'Bank-level encryption and GDPR-compliant data protection'**
  String get featureSecurityDesc;

  /// No description provided for @featuresWorksOnAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Works on all devices'**
  String get featuresWorksOnAllDevices;

  /// No description provided for @builtForEveryoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Built for Everyone'**
  String get builtForEveryoneTitle;

  /// No description provided for @builtForEveryoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your role and get started with a personalized experience'**
  String get builtForEveryoneSubtitle;

  /// No description provided for @roleStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get roleStudents;

  /// No description provided for @roleStudentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track courses, manage applications, and achieve your educational goals'**
  String get roleStudentsDesc;

  /// No description provided for @roleInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Institutions'**
  String get roleInstitutions;

  /// No description provided for @roleInstitutionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Streamline admissions, manage programs, and engage with students'**
  String get roleInstitutionsDesc;

  /// No description provided for @roleParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get roleParents;

  /// No description provided for @roleParentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor progress, communicate with teachers, and support your children'**
  String get roleParentsDesc;

  /// No description provided for @roleCounselors.
  ///
  /// In en, this message translates to:
  /// **'Counselors'**
  String get roleCounselors;

  /// No description provided for @roleCounselorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Guide students, manage sessions, and track counseling outcomes'**
  String get roleCounselorsDesc;

  /// No description provided for @getStartedAs.
  ///
  /// In en, this message translates to:
  /// **'Get Started as {role}'**
  String getStartedAs(String role);

  /// No description provided for @ctaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Transform\nYour Educational Journey?'**
  String get ctaTitle;

  /// No description provided for @ctaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join 50,000+ students, institutions, and educators who trust Flow'**
  String get ctaSubtitle;

  /// No description provided for @ctaButton.
  ///
  /// In en, this message translates to:
  /// **'Start Your Free Trial'**
  String get ctaButton;

  /// No description provided for @ctaNoCreditCard.
  ///
  /// In en, this message translates to:
  /// **'No credit card required'**
  String get ctaNoCreditCard;

  /// No description provided for @cta14DayTrial.
  ///
  /// In en, this message translates to:
  /// **'14-day free trial'**
  String get cta14DayTrial;

  /// No description provided for @footerTagline.
  ///
  /// In en, this message translates to:
  /// **'Africa\'s Leading EdTech Platform\nEmpowering education without boundaries.'**
  String get footerTagline;

  /// No description provided for @footerProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get footerProducts;

  /// No description provided for @footerStudentPortal.
  ///
  /// In en, this message translates to:
  /// **'Student Portal'**
  String get footerStudentPortal;

  /// No description provided for @footerInstitutionDashboard.
  ///
  /// In en, this message translates to:
  /// **'Institution Dashboard'**
  String get footerInstitutionDashboard;

  /// No description provided for @footerParentApp.
  ///
  /// In en, this message translates to:
  /// **'Parent App'**
  String get footerParentApp;

  /// No description provided for @footerCounselorTools.
  ///
  /// In en, this message translates to:
  /// **'Counselor Tools'**
  String get footerCounselorTools;

  /// No description provided for @footerMobileApps.
  ///
  /// In en, this message translates to:
  /// **'Mobile Apps'**
  String get footerMobileApps;

  /// No description provided for @footerCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get footerCompany;

  /// No description provided for @footerAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get footerAboutUs;

  /// No description provided for @footerCareers.
  ///
  /// In en, this message translates to:
  /// **'Careers'**
  String get footerCareers;

  /// No description provided for @footerPressKit.
  ///
  /// In en, this message translates to:
  /// **'Press Kit'**
  String get footerPressKit;

  /// No description provided for @footerPartners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get footerPartners;

  /// No description provided for @footerContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get footerContact;

  /// No description provided for @footerResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get footerResources;

  /// No description provided for @footerHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get footerHelpCenter;

  /// No description provided for @footerDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get footerDocumentation;

  /// No description provided for @footerApiReference.
  ///
  /// In en, this message translates to:
  /// **'API Reference'**
  String get footerApiReference;

  /// No description provided for @footerCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get footerCommunity;

  /// No description provided for @footerBlog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get footerBlog;

  /// No description provided for @footerLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get footerLegal;

  /// No description provided for @footerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footerPrivacyPolicy;

  /// No description provided for @footerTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get footerTermsOfService;

  /// No description provided for @footerCookiePolicy.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get footerCookiePolicy;

  /// No description provided for @footerDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get footerDataProtection;

  /// No description provided for @footerCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get footerCompliance;

  /// No description provided for @footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Flow EdTech. All rights reserved.'**
  String get footerCopyright;

  /// No description provided for @footerSoc2.
  ///
  /// In en, this message translates to:
  /// **'SOC 2 Certified'**
  String get footerSoc2;

  /// No description provided for @footerIso27001.
  ///
  /// In en, this message translates to:
  /// **'ISO 27001'**
  String get footerIso27001;

  /// No description provided for @footerGdpr.
  ///
  /// In en, this message translates to:
  /// **'GDPR Compliant'**
  String get footerGdpr;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search universities by name, country, or program...'**
  String get searchHint;

  /// No description provided for @searchUniversitiesCount.
  ///
  /// In en, this message translates to:
  /// **'Search 18,000+ Universities'**
  String get searchUniversitiesCount;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search universities...'**
  String get searchPlaceholder;

  /// No description provided for @searchBadge.
  ///
  /// In en, this message translates to:
  /// **'18K+'**
  String get searchBadge;

  /// No description provided for @filterEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get filterEngineering;

  /// No description provided for @filterBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get filterBusiness;

  /// No description provided for @filterMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get filterMedicine;

  /// No description provided for @filterArts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get filterArts;

  /// No description provided for @filterScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get filterScience;

  /// No description provided for @quizFindYourPath.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get quizFindYourPath;

  /// No description provided for @quizQuickPreview.
  ///
  /// In en, this message translates to:
  /// **'Quick Preview'**
  String get quizQuickPreview;

  /// No description provided for @quizFieldQuestion.
  ///
  /// In en, this message translates to:
  /// **'What field interests you most?'**
  String get quizFieldQuestion;

  /// No description provided for @quizFieldTechEngineering.
  ///
  /// In en, this message translates to:
  /// **'Technology & Engineering'**
  String get quizFieldTechEngineering;

  /// No description provided for @quizFieldBusinessFinance.
  ///
  /// In en, this message translates to:
  /// **'Business & Finance'**
  String get quizFieldBusinessFinance;

  /// No description provided for @quizFieldHealthcareMedicine.
  ///
  /// In en, this message translates to:
  /// **'Healthcare & Medicine'**
  String get quizFieldHealthcareMedicine;

  /// No description provided for @quizFieldArtsHumanities.
  ///
  /// In en, this message translates to:
  /// **'Arts & Humanities'**
  String get quizFieldArtsHumanities;

  /// No description provided for @quizLocationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where would you prefer to study?'**
  String get quizLocationQuestion;

  /// No description provided for @quizLocationWestAfrica.
  ///
  /// In en, this message translates to:
  /// **'West Africa'**
  String get quizLocationWestAfrica;

  /// No description provided for @quizLocationEastAfrica.
  ///
  /// In en, this message translates to:
  /// **'East Africa'**
  String get quizLocationEastAfrica;

  /// No description provided for @quizLocationSouthernAfrica.
  ///
  /// In en, this message translates to:
  /// **'Southern Africa'**
  String get quizLocationSouthernAfrica;

  /// No description provided for @quizLocationAnywhereAfrica.
  ///
  /// In en, this message translates to:
  /// **'Anywhere in Africa'**
  String get quizLocationAnywhereAfrica;

  /// No description provided for @quizGetRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get Your Recommendations'**
  String get quizGetRecommendations;

  /// No description provided for @quizTakeTheQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take the quiz'**
  String get quizTakeTheQuiz;

  /// No description provided for @tourTitle.
  ///
  /// In en, this message translates to:
  /// **'See Flow in Action'**
  String get tourTitle;

  /// No description provided for @tourSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A guided tour of the platform'**
  String get tourSubtitle;

  /// No description provided for @tourClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get tourClose;

  /// No description provided for @tourBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tourBack;

  /// No description provided for @tourNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// No description provided for @tourGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get tourGetStarted;

  /// No description provided for @tourSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Universities'**
  String get tourSlide1Title;

  /// No description provided for @tourSlide1Desc.
  ///
  /// In en, this message translates to:
  /// **'Search and compare universities across Africa with detailed profiles, rankings, and program information.'**
  String get tourSlide1Desc;

  /// No description provided for @tourSlide1H1.
  ///
  /// In en, this message translates to:
  /// **'Browse 500+ institutions'**
  String get tourSlide1H1;

  /// No description provided for @tourSlide1H2.
  ///
  /// In en, this message translates to:
  /// **'Filter by country, program & tuition'**
  String get tourSlide1H2;

  /// No description provided for @tourSlide1H3.
  ///
  /// In en, this message translates to:
  /// **'View detailed university profiles'**
  String get tourSlide1H3;

  /// No description provided for @tourSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get tourSlide2Title;

  /// No description provided for @tourSlide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Take our guided quiz to get personalized university and program recommendations matched to your goals.'**
  String get tourSlide2Desc;

  /// No description provided for @tourSlide2H1.
  ///
  /// In en, this message translates to:
  /// **'AI-powered recommendations'**
  String get tourSlide2H1;

  /// No description provided for @tourSlide2H2.
  ///
  /// In en, this message translates to:
  /// **'Personality & interest matching'**
  String get tourSlide2H2;

  /// No description provided for @tourSlide2H3.
  ///
  /// In en, this message translates to:
  /// **'Tailored program suggestions'**
  String get tourSlide2H3;

  /// No description provided for @tourSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Role-Based Dashboards'**
  String get tourSlide3Title;

  /// No description provided for @tourSlide3Desc.
  ///
  /// In en, this message translates to:
  /// **'Purpose-built dashboards for students, parents, counselors, and institutions — each with the tools they need.'**
  String get tourSlide3Desc;

  /// No description provided for @tourSlide3H1.
  ///
  /// In en, this message translates to:
  /// **'Track applications & progress'**
  String get tourSlide3H1;

  /// No description provided for @tourSlide3H2.
  ///
  /// In en, this message translates to:
  /// **'Monitor student performance'**
  String get tourSlide3H2;

  /// No description provided for @tourSlide3H3.
  ///
  /// In en, this message translates to:
  /// **'Manage institutional data'**
  String get tourSlide3H3;

  /// No description provided for @tourSlide4Title.
  ///
  /// In en, this message translates to:
  /// **'AI Study Assistant'**
  String get tourSlide4Title;

  /// No description provided for @tourSlide4Desc.
  ///
  /// In en, this message translates to:
  /// **'Get instant help with admissions questions, application guidance, and academic planning from our AI chatbot.'**
  String get tourSlide4Desc;

  /// No description provided for @tourSlide4H1.
  ///
  /// In en, this message translates to:
  /// **'Available 24/7'**
  String get tourSlide4H1;

  /// No description provided for @tourSlide4H2.
  ///
  /// In en, this message translates to:
  /// **'Context-aware answers'**
  String get tourSlide4H2;

  /// No description provided for @tourSlide4H3.
  ///
  /// In en, this message translates to:
  /// **'Application deadline reminders'**
  String get tourSlide4H3;

  /// No description provided for @tourSlide5Title.
  ///
  /// In en, this message translates to:
  /// **'Connected Ecosystem'**
  String get tourSlide5Title;

  /// No description provided for @tourSlide5Desc.
  ///
  /// In en, this message translates to:
  /// **'Students, parents, counselors, and institutions collaborate seamlessly on one platform.'**
  String get tourSlide5Desc;

  /// No description provided for @tourSlide5H1.
  ///
  /// In en, this message translates to:
  /// **'Real-time notifications'**
  String get tourSlide5H1;

  /// No description provided for @tourSlide5H2.
  ///
  /// In en, this message translates to:
  /// **'Shared progress tracking'**
  String get tourSlide5H2;

  /// No description provided for @tourSlide5H3.
  ///
  /// In en, this message translates to:
  /// **'Secure messaging'**
  String get tourSlide5H3;

  /// No description provided for @uniSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Universities'**
  String get uniSearchTitle;

  /// No description provided for @uniSearchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get uniSearchClearAll;

  /// No description provided for @uniSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by university name...'**
  String get uniSearchHint;

  /// No description provided for @uniSearchFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get uniSearchFilters;

  /// No description provided for @uniSearchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count} universities found'**
  String uniSearchResultCount(int count);

  /// No description provided for @uniSearchNoMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No universities match your filters'**
  String get uniSearchNoMatchFilters;

  /// No description provided for @uniSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No universities found'**
  String get uniSearchNoResults;

  /// No description provided for @uniSearchAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters to see more results'**
  String get uniSearchAdjustFilters;

  /// No description provided for @uniSearchTrySearching.
  ///
  /// In en, this message translates to:
  /// **'Try searching for a university name'**
  String get uniSearchTrySearching;

  /// No description provided for @uniSearchError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get uniSearchError;

  /// No description provided for @uniSearchRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get uniSearchRetry;

  /// No description provided for @uniSearchFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get uniSearchFilterReset;

  /// No description provided for @uniSearchFilterCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get uniSearchFilterCountry;

  /// No description provided for @uniSearchFilterSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get uniSearchFilterSelectCountry;

  /// No description provided for @uniSearchFilterAllCountries.
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get uniSearchFilterAllCountries;

  /// No description provided for @uniSearchFilterUniType.
  ///
  /// In en, this message translates to:
  /// **'University Type'**
  String get uniSearchFilterUniType;

  /// No description provided for @uniSearchFilterSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get uniSearchFilterSelectType;

  /// No description provided for @uniSearchFilterAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get uniSearchFilterAllTypes;

  /// No description provided for @uniSearchFilterLocationType.
  ///
  /// In en, this message translates to:
  /// **'Location Type'**
  String get uniSearchFilterLocationType;

  /// No description provided for @uniSearchFilterSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select location type'**
  String get uniSearchFilterSelectLocation;

  /// No description provided for @uniSearchFilterAllLocations.
  ///
  /// In en, this message translates to:
  /// **'All Locations'**
  String get uniSearchFilterAllLocations;

  /// No description provided for @uniSearchFilterMaxTuition.
  ///
  /// In en, this message translates to:
  /// **'Maximum Tuition (USD/year)'**
  String get uniSearchFilterMaxTuition;

  /// No description provided for @uniSearchFilterNoLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get uniSearchFilterNoLimit;

  /// No description provided for @uniSearchFilterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get uniSearchFilterAny;

  /// No description provided for @uniSearchFilterAcceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get uniSearchFilterAcceptanceRate;

  /// No description provided for @uniSearchFilterAnyRate.
  ///
  /// In en, this message translates to:
  /// **'Any rate'**
  String get uniSearchFilterAnyRate;

  /// No description provided for @uniSearchFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get uniSearchFilterApply;

  /// No description provided for @uniSearchAcceptance.
  ///
  /// In en, this message translates to:
  /// **'{rate}% acceptance'**
  String uniSearchAcceptance(String rate);

  /// No description provided for @uniSearchStudents.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String uniSearchStudents(String count);

  /// No description provided for @uniDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'This university could not be found.'**
  String get uniDetailNotFound;

  /// No description provided for @uniDetailError.
  ///
  /// In en, this message translates to:
  /// **'Error loading university: {error}'**
  String uniDetailError(String error);

  /// No description provided for @uniDetailVisitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get uniDetailVisitWebsite;

  /// No description provided for @uniDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get uniDetailLocation;

  /// No description provided for @uniDetailAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get uniDetailAddress;

  /// No description provided for @uniDetailSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get uniDetailSetting;

  /// No description provided for @uniDetailKeyStats.
  ///
  /// In en, this message translates to:
  /// **'Key Statistics'**
  String get uniDetailKeyStats;

  /// No description provided for @uniDetailTotalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get uniDetailTotalStudents;

  /// No description provided for @uniDetailAcceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get uniDetailAcceptanceRate;

  /// No description provided for @uniDetailGradRate.
  ///
  /// In en, this message translates to:
  /// **'4-Year Graduation Rate'**
  String get uniDetailGradRate;

  /// No description provided for @uniDetailAvgGPA.
  ///
  /// In en, this message translates to:
  /// **'Average GPA'**
  String get uniDetailAvgGPA;

  /// No description provided for @uniDetailTuitionCosts.
  ///
  /// In en, this message translates to:
  /// **'Tuition & Costs'**
  String get uniDetailTuitionCosts;

  /// No description provided for @uniDetailTuitionOutState.
  ///
  /// In en, this message translates to:
  /// **'Tuition (Out-of-State)'**
  String get uniDetailTuitionOutState;

  /// No description provided for @uniDetailTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get uniDetailTotalCost;

  /// No description provided for @uniDetailMedianEarnings.
  ///
  /// In en, this message translates to:
  /// **'Median Earnings (10 yr)'**
  String get uniDetailMedianEarnings;

  /// No description provided for @uniDetailTestScores.
  ///
  /// In en, this message translates to:
  /// **'Test Scores (25th-75th Percentile)'**
  String get uniDetailTestScores;

  /// No description provided for @uniDetailSATMath.
  ///
  /// In en, this message translates to:
  /// **'SAT Math'**
  String get uniDetailSATMath;

  /// No description provided for @uniDetailSATEBRW.
  ///
  /// In en, this message translates to:
  /// **'SAT EBRW'**
  String get uniDetailSATEBRW;

  /// No description provided for @uniDetailACTComposite.
  ///
  /// In en, this message translates to:
  /// **'ACT Composite'**
  String get uniDetailACTComposite;

  /// No description provided for @uniDetailRankings.
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get uniDetailRankings;

  /// No description provided for @uniDetailGlobalRank.
  ///
  /// In en, this message translates to:
  /// **'Global Rank'**
  String get uniDetailGlobalRank;

  /// No description provided for @uniDetailNationalRank.
  ///
  /// In en, this message translates to:
  /// **'National Rank'**
  String get uniDetailNationalRank;

  /// No description provided for @uniDetailAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get uniDetailAbout;

  /// No description provided for @uniDetailType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get uniDetailType;

  /// No description provided for @uniDetailWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get uniDetailWebsite;

  /// No description provided for @uniDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get uniDetailDescription;

  /// No description provided for @dashCommonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get dashCommonBack;

  /// No description provided for @dashCommonHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashCommonHome;

  /// No description provided for @dashCommonProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashCommonProfile;

  /// No description provided for @dashCommonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dashCommonSettings;

  /// No description provided for @dashCommonOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashCommonOverview;

  /// No description provided for @dashCommonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dashCommonRetry;

  /// No description provided for @dashCommonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashCommonViewAll;

  /// No description provided for @dashCommonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dashCommonClose;

  /// No description provided for @dashCommonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dashCommonCancel;

  /// No description provided for @dashCommonPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dashCommonPending;

  /// No description provided for @dashCommonLoadingOverview.
  ///
  /// In en, this message translates to:
  /// **'Loading overview...'**
  String get dashCommonLoadingOverview;

  /// No description provided for @dashCommonNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashCommonNotifications;

  /// No description provided for @dashCommonMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get dashCommonMessages;

  /// No description provided for @dashCommonQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashCommonQuickActions;

  /// No description provided for @dashCommonWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get dashCommonWelcomeBack;

  /// No description provided for @dashCommonRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashCommonRecentActivity;

  /// No description provided for @dashCommonNoRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get dashCommonNoRecentActivity;

  /// No description provided for @dashCommonSwitchRole.
  ///
  /// In en, this message translates to:
  /// **'Switch Role'**
  String get dashCommonSwitchRole;

  /// No description provided for @dashCommonLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dashCommonLogout;

  /// No description provided for @dashCommonRecommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get dashCommonRecommendedForYou;

  /// No description provided for @dashCommonApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get dashCommonApplications;

  /// No description provided for @dashCommonAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get dashCommonAccepted;

  /// No description provided for @dashCommonRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get dashCommonRejected;

  /// No description provided for @dashCommonUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get dashCommonUnderReview;

  /// No description provided for @dashCommonRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get dashCommonRequests;

  /// No description provided for @dashCommonUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get dashCommonUpcoming;

  /// No description provided for @dashCommonMeetings.
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get dashCommonMeetings;

  /// No description provided for @dashCommonSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get dashCommonSubmitted;

  /// No description provided for @dashCommonDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get dashCommonDraft;

  /// No description provided for @dashCommonDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String dashCommonDays(int count);

  /// No description provided for @dashCommonMin.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String dashCommonMin(int count);

  /// No description provided for @dashCommonNoDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get dashCommonNoDataAvailable;

  /// No description provided for @dashStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Dashboard'**
  String get dashStudentTitle;

  /// No description provided for @dashStudentMyApplications.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get dashStudentMyApplications;

  /// No description provided for @dashStudentMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get dashStudentMyCourses;

  /// No description provided for @dashStudentProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get dashStudentProgress;

  /// No description provided for @dashStudentEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get dashStudentEditProfile;

  /// No description provided for @dashStudentCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get dashStudentCourses;

  /// No description provided for @dashStudentContinueJourney.
  ///
  /// In en, this message translates to:
  /// **'Continue your learning journey'**
  String get dashStudentContinueJourney;

  /// No description provided for @dashStudentSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Application Success Rate'**
  String get dashStudentSuccessRate;

  /// No description provided for @dashStudentLetters.
  ///
  /// In en, this message translates to:
  /// **'Letters'**
  String get dashStudentLetters;

  /// No description provided for @dashStudentParentLink.
  ///
  /// In en, this message translates to:
  /// **'Parent Link'**
  String get dashStudentParentLink;

  /// No description provided for @dashStudentCounseling.
  ///
  /// In en, this message translates to:
  /// **'Counseling'**
  String get dashStudentCounseling;

  /// No description provided for @dashStudentSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get dashStudentSchedule;

  /// No description provided for @dashStudentResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get dashStudentResources;

  /// No description provided for @dashStudentHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get dashStudentHelp;

  /// No description provided for @dashStudentTotalApplications.
  ///
  /// In en, this message translates to:
  /// **'Total Applications'**
  String get dashStudentTotalApplications;

  /// No description provided for @dashStudentInReview.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get dashStudentInReview;

  /// No description provided for @dashStudentFindYourPath.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get dashStudentFindYourPath;

  /// No description provided for @dashStudentNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get dashStudentNew;

  /// No description provided for @dashStudentFindYourPathDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover universities that match your profile, goals, and preferences with AI-powered recommendations'**
  String get dashStudentFindYourPathDesc;

  /// No description provided for @dashStudentStartJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get dashStudentStartJourney;

  /// No description provided for @dashStudentFailedActivities.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activities'**
  String get dashStudentFailedActivities;

  /// No description provided for @dashStudentActivityHistory.
  ///
  /// In en, this message translates to:
  /// **'Activity History'**
  String get dashStudentActivityHistory;

  /// No description provided for @dashStudentActivityHistoryMsg.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive activity history view with filters and search capabilities is coming soon.'**
  String get dashStudentActivityHistoryMsg;

  /// No description provided for @dashStudentAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get dashStudentAchievement;

  /// No description provided for @dashStudentPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get dashStudentPaymentHistory;

  /// No description provided for @dashStudentPaymentHistoryMsg.
  ///
  /// In en, this message translates to:
  /// **'View detailed payment history and transaction records.'**
  String get dashStudentPaymentHistoryMsg;

  /// No description provided for @dashStudentFailedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recommendations'**
  String get dashStudentFailedRecommendations;

  /// No description provided for @dashParentTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Dashboard'**
  String get dashParentTitle;

  /// No description provided for @dashParentMyChildren.
  ///
  /// In en, this message translates to:
  /// **'My Children'**
  String get dashParentMyChildren;

  /// No description provided for @dashParentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get dashParentAlerts;

  /// No description provided for @dashParentChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get dashParentChildren;

  /// No description provided for @dashParentAvgGrade.
  ///
  /// In en, this message translates to:
  /// **'Avg Grade'**
  String get dashParentAvgGrade;

  /// No description provided for @dashParentUpcomingMeetings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Meetings'**
  String get dashParentUpcomingMeetings;

  /// No description provided for @dashParentNoUpcomingMeetings.
  ///
  /// In en, this message translates to:
  /// **'No Upcoming Meetings'**
  String get dashParentNoUpcomingMeetings;

  /// No description provided for @dashParentScheduleMeetingsHint.
  ///
  /// In en, this message translates to:
  /// **'Schedule meetings with teachers or counselors'**
  String get dashParentScheduleMeetingsHint;

  /// No description provided for @dashParentScheduleMeeting.
  ///
  /// In en, this message translates to:
  /// **'Schedule Meeting'**
  String get dashParentScheduleMeeting;

  /// No description provided for @dashParentViewMoreMeetings.
  ///
  /// In en, this message translates to:
  /// **'View {count} more meetings'**
  String dashParentViewMoreMeetings(int count);

  /// No description provided for @dashParentChildrenOverview.
  ///
  /// In en, this message translates to:
  /// **'Children Overview'**
  String get dashParentChildrenOverview;

  /// No description provided for @dashParentNoChildren.
  ///
  /// In en, this message translates to:
  /// **'No Children Added'**
  String get dashParentNoChildren;

  /// No description provided for @dashParentNoChildrenHint.
  ///
  /// In en, this message translates to:
  /// **'Add your children to track their progress'**
  String get dashParentNoChildrenHint;

  /// No description provided for @dashParentCourseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String dashParentCourseCount(int count);

  /// No description provided for @dashParentAppCount.
  ///
  /// In en, this message translates to:
  /// **'{count} apps'**
  String dashParentAppCount(int count);

  /// No description provided for @dashParentViewAllReports.
  ///
  /// In en, this message translates to:
  /// **'View All Reports'**
  String get dashParentViewAllReports;

  /// No description provided for @dashParentAcademicReports.
  ///
  /// In en, this message translates to:
  /// **'Academic performance reports'**
  String get dashParentAcademicReports;

  /// No description provided for @dashParentWithTeachersOrCounselors.
  ///
  /// In en, this message translates to:
  /// **'With teachers or counselors'**
  String get dashParentWithTeachersOrCounselors;

  /// No description provided for @dashParentNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get dashParentNotificationSettings;

  /// No description provided for @dashParentManageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts and updates'**
  String get dashParentManageAlerts;

  /// No description provided for @dashParentMeetWith.
  ///
  /// In en, this message translates to:
  /// **'Who would you like to meet with?'**
  String get dashParentMeetWith;

  /// No description provided for @dashParentTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get dashParentTeacher;

  /// No description provided for @dashParentTeacherConference.
  ///
  /// In en, this message translates to:
  /// **'Schedule a parent-teacher conference'**
  String get dashParentTeacherConference;

  /// No description provided for @dashParentCounselor.
  ///
  /// In en, this message translates to:
  /// **'Counselor'**
  String get dashParentCounselor;

  /// No description provided for @dashParentCounselorMeeting.
  ///
  /// In en, this message translates to:
  /// **'Meet with a guidance counselor'**
  String get dashParentCounselorMeeting;

  /// No description provided for @dashParentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get dashParentStatusPending;

  /// No description provided for @dashParentStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get dashParentStatusApproved;

  /// No description provided for @dashParentStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'DECLINED'**
  String get dashParentStatusDeclined;

  /// No description provided for @dashParentStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get dashParentStatusCancelled;

  /// No description provided for @dashParentStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get dashParentStatusCompleted;

  /// No description provided for @dashCounselorTitle.
  ///
  /// In en, this message translates to:
  /// **'Counselor Dashboard'**
  String get dashCounselorTitle;

  /// No description provided for @dashCounselorMyStudents.
  ///
  /// In en, this message translates to:
  /// **'My Students'**
  String get dashCounselorMyStudents;

  /// No description provided for @dashCounselorSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get dashCounselorSessions;

  /// No description provided for @dashCounselorStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get dashCounselorStudents;

  /// No description provided for @dashCounselorToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashCounselorToday;

  /// No description provided for @dashCounselorMeetingRequests.
  ///
  /// In en, this message translates to:
  /// **'Meeting Requests'**
  String get dashCounselorMeetingRequests;

  /// No description provided for @dashCounselorManageAvailability.
  ///
  /// In en, this message translates to:
  /// **'Manage Availability'**
  String get dashCounselorManageAvailability;

  /// No description provided for @dashCounselorSetMeetingHours.
  ///
  /// In en, this message translates to:
  /// **'Set your meeting hours'**
  String get dashCounselorSetMeetingHours;

  /// No description provided for @dashCounselorPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'{count} pending approval'**
  String dashCounselorPendingApproval(int count);

  /// No description provided for @dashCounselorViewMoreRequests.
  ///
  /// In en, this message translates to:
  /// **'View {count} more requests'**
  String dashCounselorViewMoreRequests(int count);

  /// No description provided for @dashCounselorTodaySessions.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sessions'**
  String get dashCounselorTodaySessions;

  /// No description provided for @dashCounselorNoStudents.
  ///
  /// In en, this message translates to:
  /// **'No Students Assigned'**
  String get dashCounselorNoStudents;

  /// No description provided for @dashCounselorNoStudentsHint.
  ///
  /// In en, this message translates to:
  /// **'Your students will appear here when assigned'**
  String get dashCounselorNoStudentsHint;

  /// No description provided for @dashCounselorPendingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Pending Recommendations'**
  String get dashCounselorPendingRecommendations;

  /// No description provided for @dashCounselorDraftRecommendations.
  ///
  /// In en, this message translates to:
  /// **'You have {count} draft recommendations'**
  String dashCounselorDraftRecommendations(int count);

  /// No description provided for @dashCounselorSessionIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get dashCounselorSessionIndividual;

  /// No description provided for @dashCounselorSessionGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get dashCounselorSessionGroup;

  /// No description provided for @dashCounselorSessionCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get dashCounselorSessionCareer;

  /// No description provided for @dashCounselorSessionAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get dashCounselorSessionAcademic;

  /// No description provided for @dashCounselorSessionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get dashCounselorSessionPersonal;

  /// No description provided for @dashCounselorStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get dashCounselorStatusPending;

  /// No description provided for @dashAdminNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Not authenticated'**
  String get dashAdminNotAuthenticated;

  /// No description provided for @dashAdminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashAdminDashboard;

  /// No description provided for @dashAdminWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String dashAdminWelcomeBack(String name);

  /// No description provided for @dashAdminQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Quick Action'**
  String get dashAdminQuickAction;

  /// No description provided for @dashAdminAddUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get dashAdminAddUser;

  /// No description provided for @dashAdminCreateAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Create Announcement'**
  String get dashAdminCreateAnnouncement;

  /// No description provided for @dashAdminGenerateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get dashAdminGenerateReport;

  /// No description provided for @dashAdminBulkActions.
  ///
  /// In en, this message translates to:
  /// **'Bulk Actions'**
  String get dashAdminBulkActions;

  /// No description provided for @dashAdminTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get dashAdminTotalUsers;

  /// No description provided for @dashAdminStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get dashAdminStudents;

  /// No description provided for @dashAdminInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Institutions'**
  String get dashAdminInstitutions;

  /// No description provided for @dashAdminRecommenders.
  ///
  /// In en, this message translates to:
  /// **'Recommenders'**
  String get dashAdminRecommenders;

  /// No description provided for @dashAdminCountStudents.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String dashAdminCountStudents(int count);

  /// No description provided for @dashAdminCountParents.
  ///
  /// In en, this message translates to:
  /// **'{count} parents'**
  String dashAdminCountParents(int count);

  /// No description provided for @dashAdminCountCounselors.
  ///
  /// In en, this message translates to:
  /// **'{count} counselors'**
  String dashAdminCountCounselors(int count);

  /// No description provided for @dashAdminCountAdmins.
  ///
  /// In en, this message translates to:
  /// **'{count} admins'**
  String dashAdminCountAdmins(int count);

  /// No description provided for @dashAdminJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get dashAdminJustNow;

  /// No description provided for @dashAdminMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String dashAdminMinutesAgo(int count);

  /// No description provided for @dashAdminHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String dashAdminHoursAgo(int count);

  /// No description provided for @dashAdminDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String dashAdminDaysAgo(int count);

  /// No description provided for @dashAdminRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashAdminRefresh;

  /// No description provided for @dashAdminQuickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get dashAdminQuickStats;

  /// No description provided for @dashAdminActive30d.
  ///
  /// In en, this message translates to:
  /// **'Active (30d)'**
  String get dashAdminActive30d;

  /// No description provided for @dashAdminNewUsers7d.
  ///
  /// In en, this message translates to:
  /// **'New Users (7d)'**
  String get dashAdminNewUsers7d;

  /// No description provided for @dashAdminApplications7d.
  ///
  /// In en, this message translates to:
  /// **'Applications (7d)'**
  String get dashAdminApplications7d;

  /// No description provided for @dashAdminUserGrowth.
  ///
  /// In en, this message translates to:
  /// **'User Growth'**
  String get dashAdminUserGrowth;

  /// No description provided for @dashAdminUserGrowthDesc.
  ///
  /// In en, this message translates to:
  /// **'New user registrations over the past 6 months'**
  String get dashAdminUserGrowthDesc;

  /// No description provided for @dashAdminUserDistribution.
  ///
  /// In en, this message translates to:
  /// **'User Distribution'**
  String get dashAdminUserDistribution;

  /// No description provided for @dashAdminByUserType.
  ///
  /// In en, this message translates to:
  /// **'By user type'**
  String get dashAdminByUserType;

  /// No description provided for @dashInstTitle.
  ///
  /// In en, this message translates to:
  /// **'Institution Dashboard'**
  String get dashInstTitle;

  /// No description provided for @dashInstDebugPanel.
  ///
  /// In en, this message translates to:
  /// **'Debug Panel'**
  String get dashInstDebugPanel;

  /// No description provided for @dashInstApplicants.
  ///
  /// In en, this message translates to:
  /// **'Applicants'**
  String get dashInstApplicants;

  /// No description provided for @dashInstPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get dashInstPrograms;

  /// No description provided for @dashInstCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get dashInstCourses;

  /// No description provided for @dashInstCounselors.
  ///
  /// In en, this message translates to:
  /// **'Counselors'**
  String get dashInstCounselors;

  /// No description provided for @dashInstNewProgram.
  ///
  /// In en, this message translates to:
  /// **'New Program'**
  String get dashInstNewProgram;

  /// No description provided for @dashInstNewCourse.
  ///
  /// In en, this message translates to:
  /// **'New Course'**
  String get dashInstNewCourse;

  /// No description provided for @dashInstTotalApplicants.
  ///
  /// In en, this message translates to:
  /// **'Total Applicants'**
  String get dashInstTotalApplicants;

  /// No description provided for @dashInstPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get dashInstPendingReview;

  /// No description provided for @dashInstActivePrograms.
  ///
  /// In en, this message translates to:
  /// **'Active Programs'**
  String get dashInstActivePrograms;

  /// No description provided for @dashInstTotalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get dashInstTotalStudents;

  /// No description provided for @dashInstReviewPending.
  ///
  /// In en, this message translates to:
  /// **'Review Pending Applications'**
  String get dashInstReviewPending;

  /// No description provided for @dashInstApplicationsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count} applications waiting'**
  String dashInstApplicationsWaiting(int count);

  /// No description provided for @dashInstApplicationsInProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} applications in progress'**
  String dashInstApplicationsInProgress(int count);

  /// No description provided for @dashInstAcceptedApplicants.
  ///
  /// In en, this message translates to:
  /// **'Accepted Applicants'**
  String get dashInstAcceptedApplicants;

  /// No description provided for @dashInstApplicationsApproved.
  ///
  /// In en, this message translates to:
  /// **'{count} applications approved'**
  String dashInstApplicationsApproved(int count);

  /// No description provided for @dashInstCreateNewProgram.
  ///
  /// In en, this message translates to:
  /// **'Create New Program'**
  String get dashInstCreateNewProgram;

  /// No description provided for @dashInstAddProgramHint.
  ///
  /// In en, this message translates to:
  /// **'Add a new course or program'**
  String get dashInstAddProgramHint;

  /// No description provided for @dashInstApplicationSummary.
  ///
  /// In en, this message translates to:
  /// **'Application Summary'**
  String get dashInstApplicationSummary;

  /// No description provided for @dashInstProgramsOverview.
  ///
  /// In en, this message translates to:
  /// **'Programs Overview'**
  String get dashInstProgramsOverview;

  /// No description provided for @dashInstTotalPrograms.
  ///
  /// In en, this message translates to:
  /// **'Total Programs'**
  String get dashInstTotalPrograms;

  /// No description provided for @dashInstInactivePrograms.
  ///
  /// In en, this message translates to:
  /// **'Inactive Programs'**
  String get dashInstInactivePrograms;

  /// No description provided for @dashInstTotalEnrollments.
  ///
  /// In en, this message translates to:
  /// **'Total Enrollments'**
  String get dashInstTotalEnrollments;

  /// No description provided for @dashInstApplicationFunnel.
  ///
  /// In en, this message translates to:
  /// **'Application Funnel'**
  String get dashInstApplicationFunnel;

  /// No description provided for @dashInstConversionRate.
  ///
  /// In en, this message translates to:
  /// **'Overall Conversion Rate: {rate}%'**
  String dashInstConversionRate(String rate);

  /// No description provided for @dashInstApplicantDemographics.
  ///
  /// In en, this message translates to:
  /// **'Applicant Demographics'**
  String get dashInstApplicantDemographics;

  /// No description provided for @dashInstTotalApplicantsCount.
  ///
  /// In en, this message translates to:
  /// **'Total Applicants: {count}'**
  String dashInstTotalApplicantsCount(int count);

  /// No description provided for @dashInstByLocation.
  ///
  /// In en, this message translates to:
  /// **'By Location'**
  String get dashInstByLocation;

  /// No description provided for @dashInstByAgeGroup.
  ///
  /// In en, this message translates to:
  /// **'By Age Group'**
  String get dashInstByAgeGroup;

  /// No description provided for @dashInstByAcademicBackground.
  ///
  /// In en, this message translates to:
  /// **'By Academic Background'**
  String get dashInstByAcademicBackground;

  /// No description provided for @dashInstProgramPopularity.
  ///
  /// In en, this message translates to:
  /// **'Program Popularity'**
  String get dashInstProgramPopularity;

  /// No description provided for @dashInstTopPrograms.
  ///
  /// In en, this message translates to:
  /// **'Top Programs by Applications'**
  String get dashInstTopPrograms;

  /// No description provided for @dashInstAppsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} apps'**
  String dashInstAppsCount(int count);

  /// No description provided for @dashInstProcessingTime.
  ///
  /// In en, this message translates to:
  /// **'Application Processing Time'**
  String get dashInstProcessingTime;

  /// No description provided for @dashInstAverageTime.
  ///
  /// In en, this message translates to:
  /// **'Average Time'**
  String get dashInstAverageTime;

  /// No description provided for @dashInstDaysValue.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String dashInstDaysValue(String count);

  /// No description provided for @dashRecTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommender Dashboard'**
  String get dashRecTitle;

  /// No description provided for @dashRecRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get dashRecRecommendations;

  /// No description provided for @dashRecTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dashRecTotal;

  /// No description provided for @dashRecUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get dashRecUrgent;

  /// No description provided for @dashRecUrgentRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Urgent Recommendations'**
  String get dashRecUrgentRecommendations;

  /// No description provided for @dashRecPendingCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} pending recommendation{count, plural, =1{} other{s}}'**
  String dashRecPendingCount(int count);

  /// No description provided for @dashRecUnknownStudent.
  ///
  /// In en, this message translates to:
  /// **'Unknown Student'**
  String get dashRecUnknownStudent;

  /// No description provided for @dashRecInstitutionNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Institution not specified'**
  String get dashRecInstitutionNotSpecified;

  /// No description provided for @dashRecRecentRequests.
  ///
  /// In en, this message translates to:
  /// **'Recent Requests'**
  String get dashRecRecentRequests;

  /// No description provided for @dashRecNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No Recommendation Requests'**
  String get dashRecNoRequests;

  /// No description provided for @dashRecNoRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Requests will appear here when students request recommendations'**
  String get dashRecNoRequestsHint;

  /// No description provided for @dashRecQuickTips.
  ///
  /// In en, this message translates to:
  /// **'Quick Tips'**
  String get dashRecQuickTips;

  /// No description provided for @dashRecTip1.
  ///
  /// In en, this message translates to:
  /// **'Write specific examples of student achievements'**
  String get dashRecTip1;

  /// No description provided for @dashRecTip2.
  ///
  /// In en, this message translates to:
  /// **'Submit recommendations at least 2 weeks before deadline'**
  String get dashRecTip2;

  /// No description provided for @dashRecTip3.
  ///
  /// In en, this message translates to:
  /// **'Personalize each recommendation for the institution'**
  String get dashRecTip3;

  /// No description provided for @chatViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get chatViewDetails;

  /// No description provided for @chatApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get chatApply;

  /// No description provided for @chatLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get chatLearnMore;

  /// No description provided for @chatEnroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get chatEnroll;

  /// No description provided for @chatContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get chatContinue;

  /// No description provided for @chatRankLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank: #{rank}'**
  String chatRankLabel(int rank);

  /// No description provided for @chatAcceptanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Acceptance: {rate}%'**
  String chatAcceptanceLabel(String rate);

  /// No description provided for @chatDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline: {deadline}'**
  String chatDeadlineLabel(String deadline);

  /// No description provided for @chatRecommendedUniversities.
  ///
  /// In en, this message translates to:
  /// **'Recommended Universities'**
  String get chatRecommendedUniversities;

  /// No description provided for @chatRecommendedCourses.
  ///
  /// In en, this message translates to:
  /// **'Recommended Courses'**
  String get chatRecommendedCourses;

  /// No description provided for @chatDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get chatDetails;

  /// No description provided for @chatAcceptanceRateLabel.
  ///
  /// In en, this message translates to:
  /// **'{rate}% acceptance'**
  String chatAcceptanceRateLabel(String rate);

  /// No description provided for @chatHiNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Hi! Need help? 👋'**
  String get chatHiNeedHelp;

  /// No description provided for @chatTalkToHuman.
  ///
  /// In en, this message translates to:
  /// **'Talk to a Human'**
  String get chatTalkToHuman;

  /// No description provided for @chatConnectWithAgent.
  ///
  /// In en, this message translates to:
  /// **'Would you like to connect with a support agent?'**
  String get chatConnectWithAgent;

  /// No description provided for @chatAgentWillJoin.
  ///
  /// In en, this message translates to:
  /// **'A member of our team will join this conversation to assist you.'**
  String get chatAgentWillJoin;

  /// No description provided for @chatCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chatCancel;

  /// No description provided for @chatConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get chatConnect;

  /// No description provided for @chatYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your Account'**
  String get chatYourAccount;

  /// No description provided for @chatSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get chatSignIn;

  /// No description provided for @chatSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as:'**
  String get chatSignedInAs;

  /// No description provided for @chatDefaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get chatDefaultUserName;

  /// No description provided for @chatConversationsSynced.
  ///
  /// In en, this message translates to:
  /// **'Your conversations are being synced to your account.'**
  String get chatConversationsSynced;

  /// No description provided for @chatSignInDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your conversations across devices and get personalized assistance.'**
  String get chatSignInDescription;

  /// No description provided for @chatHistorySaved.
  ///
  /// In en, this message translates to:
  /// **'Your chat history will be saved to your account.'**
  String get chatHistorySaved;

  /// No description provided for @chatClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get chatClose;

  /// No description provided for @chatViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get chatViewProfile;

  /// No description provided for @chatHumanSupport.
  ///
  /// In en, this message translates to:
  /// **'Human Support'**
  String get chatHumanSupport;

  /// No description provided for @chatFlowAssistant.
  ///
  /// In en, this message translates to:
  /// **'Flow Assistant'**
  String get chatFlowAssistant;

  /// No description provided for @chatWaitingForAgent.
  ///
  /// In en, this message translates to:
  /// **'Waiting for agent...'**
  String get chatWaitingForAgent;

  /// No description provided for @chatOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get chatOnline;

  /// No description provided for @chatStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get chatStartConversation;

  /// No description provided for @chatUserRequestedHumanSupport.
  ///
  /// In en, this message translates to:
  /// **'User requested human support'**
  String get chatUserRequestedHumanSupport;

  /// No description provided for @chatRankStat.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get chatRankStat;

  /// No description provided for @chatAcceptStat.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get chatAcceptStat;

  /// No description provided for @chatMatchStat.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get chatMatchStat;

  /// No description provided for @chatLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String chatLessonsCount(int count);

  /// No description provided for @chatProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get chatProgress;

  /// No description provided for @chatToDo.
  ///
  /// In en, this message translates to:
  /// **'To Do:'**
  String get chatToDo;

  /// No description provided for @chatFailedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get chatFailedToLoadImage;

  /// No description provided for @chatImageCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String chatImageCounter(int current, int total);

  /// No description provided for @chatTypeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get chatTypeYourMessage;

  /// No description provided for @chatSupportAgent.
  ///
  /// In en, this message translates to:
  /// **'Support Agent'**
  String get chatSupportAgent;

  /// No description provided for @chatSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get chatSystem;

  /// No description provided for @chatConfidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get chatConfidenceHigh;

  /// No description provided for @chatConfidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get chatConfidenceMedium;

  /// No description provided for @chatConfidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get chatConfidenceLow;

  /// No description provided for @chatHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get chatHelpful;

  /// No description provided for @chatNotHelpful.
  ///
  /// In en, this message translates to:
  /// **'Not helpful'**
  String get chatNotHelpful;

  /// No description provided for @chatWasThisHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this helpful?'**
  String get chatWasThisHelpful;

  /// No description provided for @chatRateThisResponse.
  ///
  /// In en, this message translates to:
  /// **'Rate this response'**
  String get chatRateThisResponse;

  /// No description provided for @chatCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get chatCopied;

  /// No description provided for @chatCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get chatCopy;

  /// No description provided for @chatViewRecommendations.
  ///
  /// In en, this message translates to:
  /// **'View Recommendations'**
  String get chatViewRecommendations;

  /// No description provided for @chatUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get chatUpdateProfile;

  /// No description provided for @chatMyApplications.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get chatMyApplications;

  /// No description provided for @chatCompareSchools.
  ///
  /// In en, this message translates to:
  /// **'Compare Schools'**
  String get chatCompareSchools;

  /// No description provided for @chatFilterResults.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get chatFilterResults;

  /// No description provided for @chatWhyTheseSchools.
  ///
  /// In en, this message translates to:
  /// **'Why These Schools?'**
  String get chatWhyTheseSchools;

  /// No description provided for @chatViewDeadlines.
  ///
  /// In en, this message translates to:
  /// **'View Deadlines'**
  String get chatViewDeadlines;

  /// No description provided for @chatEssayTips.
  ///
  /// In en, this message translates to:
  /// **'Essay Tips'**
  String get chatEssayTips;

  /// No description provided for @chatApplicationChecklist.
  ///
  /// In en, this message translates to:
  /// **'Application Checklist'**
  String get chatApplicationChecklist;

  /// No description provided for @chatHelpWithQuestions.
  ///
  /// In en, this message translates to:
  /// **'Help with Questions'**
  String get chatHelpWithQuestions;

  /// No description provided for @chatCanISkipSections.
  ///
  /// In en, this message translates to:
  /// **'Can I Skip Sections?'**
  String get chatCanISkipSections;

  /// No description provided for @chatStartApplication.
  ///
  /// In en, this message translates to:
  /// **'Start Application'**
  String get chatStartApplication;

  /// No description provided for @chatSaveToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save to Favorites'**
  String get chatSaveToFavorites;

  /// No description provided for @chatSimilarSchools.
  ///
  /// In en, this message translates to:
  /// **'Similar Schools'**
  String get chatSimilarSchools;

  /// No description provided for @chatEssayWritingHelp.
  ///
  /// In en, this message translates to:
  /// **'Essay Writing Help'**
  String get chatEssayWritingHelp;

  /// No description provided for @chatSetDeadlineReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Deadline Reminder'**
  String get chatSetDeadlineReminder;

  /// No description provided for @chatLetterRequestTips.
  ///
  /// In en, this message translates to:
  /// **'Letter Request Tips'**
  String get chatLetterRequestTips;

  /// No description provided for @chatTranscriptGuide.
  ///
  /// In en, this message translates to:
  /// **'Transcript Guide'**
  String get chatTranscriptGuide;

  /// No description provided for @chatStartQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Start Questionnaire'**
  String get chatStartQuestionnaire;

  /// No description provided for @chatHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get chatHowItWorks;

  /// No description provided for @chatBrowseUniversities.
  ///
  /// In en, this message translates to:
  /// **'Browse Universities'**
  String get chatBrowseUniversities;

  /// No description provided for @chatHowCanYouHelp.
  ///
  /// In en, this message translates to:
  /// **'How can you help?'**
  String get chatHowCanYouHelp;

  /// No description provided for @chatGetRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendations'**
  String get chatGetRecommendations;

  /// No description provided for @chatContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get chatContactSupport;

  /// No description provided for @chatCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile ({completeness}%)'**
  String chatCompleteProfile(int completeness);

  /// No description provided for @chatWhyCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Why Complete Profile?'**
  String get chatWhyCompleteProfile;

  /// No description provided for @chatViewSchools.
  ///
  /// In en, this message translates to:
  /// **'View {count} Schools'**
  String chatViewSchools(int count);

  /// No description provided for @chatMyFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites ({count})'**
  String chatMyFavorites(int count);

  /// No description provided for @chatStartApplying.
  ///
  /// In en, this message translates to:
  /// **'Start Applying'**
  String get chatStartApplying;

  /// No description provided for @fypTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get fypTitle;

  /// No description provided for @fypHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect University'**
  String get fypHeroTitle;

  /// No description provided for @fypHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get personalized university recommendations based on your academic profile, preferences, and goals'**
  String get fypHeroSubtitle;

  /// No description provided for @fypHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get fypHowItWorks;

  /// No description provided for @fypStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Answer Questions'**
  String get fypStep1Title;

  /// No description provided for @fypStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your academic profile, intended major, and preferences'**
  String get fypStep1Description;

  /// No description provided for @fypStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Get Matched'**
  String get fypStep2Title;

  /// No description provided for @fypStep2Description.
  ///
  /// In en, this message translates to:
  /// **'Our algorithm analyzes your profile against hundreds of universities'**
  String get fypStep2Description;

  /// No description provided for @fypStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Review Results'**
  String get fypStep3Title;

  /// No description provided for @fypStep3Description.
  ///
  /// In en, this message translates to:
  /// **'See your personalized recommendations ranked as safety, match, and reach schools'**
  String get fypStep3Description;

  /// No description provided for @fypWhatYoullGet.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Get'**
  String get fypWhatYoullGet;

  /// No description provided for @fypFeatureMatchScore.
  ///
  /// In en, this message translates to:
  /// **'Match Score'**
  String get fypFeatureMatchScore;

  /// No description provided for @fypFeatureSafetyMatchReach.
  ///
  /// In en, this message translates to:
  /// **'Safety/Match/Reach'**
  String get fypFeatureSafetyMatchReach;

  /// No description provided for @fypFeatureCostAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Cost Analysis'**
  String get fypFeatureCostAnalysis;

  /// No description provided for @fypFeatureDetailedInsights.
  ///
  /// In en, this message translates to:
  /// **'Detailed Insights'**
  String get fypFeatureDetailedInsights;

  /// No description provided for @fypFeatureSaveFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save Favorites'**
  String get fypFeatureSaveFavorites;

  /// No description provided for @fypFeatureCompareOptions.
  ///
  /// In en, this message translates to:
  /// **'Compare Options'**
  String get fypFeatureCompareOptions;

  /// No description provided for @fypGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get fypGetStarted;

  /// No description provided for @fypViewMyRecommendations.
  ///
  /// In en, this message translates to:
  /// **'View My Recommendations'**
  String get fypViewMyRecommendations;

  /// No description provided for @fypDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Recommendations are based on your profile and preferences. Always do thorough research on universities and consult with guidance counselors before making final decisions.'**
  String get fypDisclaimer;

  /// No description provided for @fypQuestionnaireTitle.
  ///
  /// In en, this message translates to:
  /// **'University Questionnaire'**
  String get fypQuestionnaireTitle;

  /// No description provided for @fypStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String fypStepOf(int current, int total);

  /// No description provided for @fypStepBackgroundInfo.
  ///
  /// In en, this message translates to:
  /// **'Background Information'**
  String get fypStepBackgroundInfo;

  /// No description provided for @fypStepAcademicAchievements.
  ///
  /// In en, this message translates to:
  /// **'Academic Achievements'**
  String get fypStepAcademicAchievements;

  /// No description provided for @fypStepAcademicInterests.
  ///
  /// In en, this message translates to:
  /// **'Academic Interests'**
  String get fypStepAcademicInterests;

  /// No description provided for @fypStepLocationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Location Preferences'**
  String get fypStepLocationPreferences;

  /// No description provided for @fypStepUniversityPreferences.
  ///
  /// In en, this message translates to:
  /// **'University Preferences'**
  String get fypStepUniversityPreferences;

  /// No description provided for @fypStepFinancialInfo.
  ///
  /// In en, this message translates to:
  /// **'Financial Information'**
  String get fypStepFinancialInfo;

  /// No description provided for @fypTellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get fypTellUsAboutYourself;

  /// No description provided for @fypBackgroundHelper.
  ///
  /// In en, this message translates to:
  /// **'This helps us understand your educational background'**
  String get fypBackgroundHelper;

  /// No description provided for @fypNationalityLabel.
  ///
  /// In en, this message translates to:
  /// **'Nationality *'**
  String get fypNationalityLabel;

  /// No description provided for @fypNationalityHelper.
  ///
  /// In en, this message translates to:
  /// **'Your country of citizenship'**
  String get fypNationalityHelper;

  /// No description provided for @fypSelectNationality.
  ///
  /// In en, this message translates to:
  /// **'Please select your nationality'**
  String get fypSelectNationality;

  /// No description provided for @fypCurrentStudyingLabel.
  ///
  /// In en, this message translates to:
  /// **'Where are you currently studying? *'**
  String get fypCurrentStudyingLabel;

  /// No description provided for @fypCurrentStudyingHelper.
  ///
  /// In en, this message translates to:
  /// **'Your current location (not where you want to study)'**
  String get fypCurrentStudyingHelper;

  /// No description provided for @fypSelectCurrentCountry.
  ///
  /// In en, this message translates to:
  /// **'Please select your current country'**
  String get fypSelectCurrentCountry;

  /// No description provided for @fypCurrentRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Region/State (Optional)'**
  String get fypCurrentRegionLabel;

  /// No description provided for @fypSelectRegionHelper.
  ///
  /// In en, this message translates to:
  /// **'Select your region if available'**
  String get fypSelectRegionHelper;

  /// No description provided for @fypYourAcademicAchievements.
  ///
  /// In en, this message translates to:
  /// **'Your academic achievements'**
  String get fypYourAcademicAchievements;

  /// No description provided for @fypAcademicMatchHelper.
  ///
  /// In en, this message translates to:
  /// **'This helps us match you with universities where you\'ll be competitive'**
  String get fypAcademicMatchHelper;

  /// No description provided for @fypGradingSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Grading System *'**
  String get fypGradingSystemLabel;

  /// No description provided for @fypSelectGradingSystem.
  ///
  /// In en, this message translates to:
  /// **'Please select your grading system'**
  String get fypSelectGradingSystem;

  /// No description provided for @fypYourGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Grade *'**
  String get fypYourGradeLabel;

  /// No description provided for @fypEnterGrade.
  ///
  /// In en, this message translates to:
  /// **'Please enter your grade'**
  String get fypEnterGrade;

  /// No description provided for @fypStandardizedTestLabel.
  ///
  /// In en, this message translates to:
  /// **'Standardized Test (if applicable)'**
  String get fypStandardizedTestLabel;

  /// No description provided for @fypStandardizedTestHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave blank if you haven\'t taken any'**
  String get fypStandardizedTestHelper;

  /// No description provided for @fypSatTotalScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'SAT Total Score'**
  String get fypSatTotalScoreLabel;

  /// No description provided for @fypSatScoreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1400'**
  String get fypSatScoreHint;

  /// No description provided for @fypSatValidation.
  ///
  /// In en, this message translates to:
  /// **'SAT must be between 400-1600'**
  String get fypSatValidation;

  /// No description provided for @fypActCompositeLabel.
  ///
  /// In en, this message translates to:
  /// **'ACT Composite Score'**
  String get fypActCompositeLabel;

  /// No description provided for @fypActScoreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 28'**
  String get fypActScoreHint;

  /// No description provided for @fypActValidation.
  ///
  /// In en, this message translates to:
  /// **'ACT must be between 1-36'**
  String get fypActValidation;

  /// No description provided for @fypIbScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'IB Predicted/Final Score'**
  String get fypIbScoreLabel;

  /// No description provided for @fypIbScoreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 38'**
  String get fypIbScoreHint;

  /// No description provided for @fypIbValidation.
  ///
  /// In en, this message translates to:
  /// **'IB score must be between 0-45'**
  String get fypIbValidation;

  /// No description provided for @fypTestScoresOptional.
  ///
  /// In en, this message translates to:
  /// **'Standardized test scores are optional. If you haven\'t taken these tests yet, you can skip this section.'**
  String get fypTestScoresOptional;

  /// No description provided for @fypWhatStudy.
  ///
  /// In en, this message translates to:
  /// **'What do you want to study?'**
  String get fypWhatStudy;

  /// No description provided for @fypInterestsHelper.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your academic interests and career goals'**
  String get fypInterestsHelper;

  /// No description provided for @fypIntendedMajorLabel.
  ///
  /// In en, this message translates to:
  /// **'Intended Major *'**
  String get fypIntendedMajorLabel;

  /// No description provided for @fypIntendedMajorHint.
  ///
  /// In en, this message translates to:
  /// **'Select your intended major'**
  String get fypIntendedMajorHint;

  /// No description provided for @fypSelectIntendedMajor.
  ///
  /// In en, this message translates to:
  /// **'Please select your intended major'**
  String get fypSelectIntendedMajor;

  /// No description provided for @fypFieldOfStudyLabel.
  ///
  /// In en, this message translates to:
  /// **'Field of Study *'**
  String get fypFieldOfStudyLabel;

  /// No description provided for @fypSelectFieldOfStudy.
  ///
  /// In en, this message translates to:
  /// **'Please select a field of study'**
  String get fypSelectFieldOfStudy;

  /// No description provided for @fypCareerFocused.
  ///
  /// In en, this message translates to:
  /// **'I am career-focused'**
  String get fypCareerFocused;

  /// No description provided for @fypCareerFocusedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to find universities with strong job placement and career services'**
  String get fypCareerFocusedSubtitle;

  /// No description provided for @fypResearchInterest.
  ///
  /// In en, this message translates to:
  /// **'Interested in research opportunities'**
  String get fypResearchInterest;

  /// No description provided for @fypResearchInterestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to participate in research projects during my studies'**
  String get fypResearchInterestSubtitle;

  /// No description provided for @fypWhereStudy.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to study?'**
  String get fypWhereStudy;

  /// No description provided for @fypLocationHelper.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred countries and regions'**
  String get fypLocationHelper;

  /// No description provided for @fypWhereStudyRequired.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to study? *'**
  String get fypWhereStudyRequired;

  /// No description provided for @fypSelectCountriesHelper.
  ///
  /// In en, this message translates to:
  /// **'Select the countries where you\'d like to attend university (can be different from your current location)'**
  String get fypSelectCountriesHelper;

  /// No description provided for @fypCampusSetting.
  ///
  /// In en, this message translates to:
  /// **'Campus Setting'**
  String get fypCampusSetting;

  /// No description provided for @fypUniversityCharacteristics.
  ///
  /// In en, this message translates to:
  /// **'University characteristics'**
  String get fypUniversityCharacteristics;

  /// No description provided for @fypUniversityEnvironmentHelper.
  ///
  /// In en, this message translates to:
  /// **'What type of university environment do you prefer?'**
  String get fypUniversityEnvironmentHelper;

  /// No description provided for @fypPreferredSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred University Size'**
  String get fypPreferredSizeLabel;

  /// No description provided for @fypPreferredTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred University Type'**
  String get fypPreferredTypeLabel;

  /// No description provided for @fypSportsInterest.
  ///
  /// In en, this message translates to:
  /// **'Interested in athletics/sports'**
  String get fypSportsInterest;

  /// No description provided for @fypSportsInterestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to participate in or attend university sports'**
  String get fypSportsInterestSubtitle;

  /// No description provided for @fypDesiredFeatures.
  ///
  /// In en, this message translates to:
  /// **'Desired Campus Features (optional)'**
  String get fypDesiredFeatures;

  /// No description provided for @fypFinancialConsiderations.
  ///
  /// In en, this message translates to:
  /// **'Financial Considerations'**
  String get fypFinancialConsiderations;

  /// No description provided for @fypFinancialHelper.
  ///
  /// In en, this message translates to:
  /// **'Help us recommend universities within your budget'**
  String get fypFinancialHelper;

  /// No description provided for @fypBudgetRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget Range (USD)'**
  String get fypBudgetRangeLabel;

  /// No description provided for @fypBudgetRangeHelper.
  ///
  /// In en, this message translates to:
  /// **'Approximate annual tuition budget'**
  String get fypBudgetRangeHelper;

  /// No description provided for @fypNeedFinancialAid.
  ///
  /// In en, this message translates to:
  /// **'I will need financial aid'**
  String get fypNeedFinancialAid;

  /// No description provided for @fypFinancialAidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll prioritize universities with strong financial aid programs'**
  String get fypFinancialAidSubtitle;

  /// No description provided for @fypInStateTuitionLabel.
  ///
  /// In en, this message translates to:
  /// **'Eligible for In-State Tuition? (US)'**
  String get fypInStateTuitionLabel;

  /// No description provided for @fypNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'Not Applicable'**
  String get fypNotApplicable;

  /// No description provided for @fypBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get fypBack;

  /// No description provided for @fypNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get fypNext;

  /// No description provided for @fypGetRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendations'**
  String get fypGetRecommendations;

  /// No description provided for @fypErrorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String fypErrorSavingProfile(String error);

  /// No description provided for @fypErrorGeneratingRecs.
  ///
  /// In en, this message translates to:
  /// **'Error generating recommendations: {error}'**
  String fypErrorGeneratingRecs(String error);

  /// No description provided for @fypRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get fypRetry;

  /// No description provided for @fypSignUpToSave.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save your recommendations!'**
  String get fypSignUpToSave;

  /// No description provided for @fypSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get fypSignUp;

  /// No description provided for @fypUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {error}'**
  String fypUnexpectedError(String error);

  /// No description provided for @fypGeneratingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Generating Recommendations'**
  String get fypGeneratingRecommendations;

  /// No description provided for @fypGeneratingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we analyze universities\nand create personalized matches for you...'**
  String get fypGeneratingPleaseWait;

  /// No description provided for @fypYourRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Your Recommendations'**
  String get fypYourRecommendations;

  /// No description provided for @fypRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get fypRefresh;

  /// No description provided for @fypErrorLoadingRecs.
  ///
  /// In en, this message translates to:
  /// **'Error loading recommendations'**
  String get fypErrorLoadingRecs;

  /// No description provided for @fypTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get fypTryAgain;

  /// No description provided for @fypNoRecsYet.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet'**
  String get fypNoRecsYet;

  /// No description provided for @fypCompleteQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Complete the questionnaire to get personalized recommendations'**
  String get fypCompleteQuestionnaire;

  /// No description provided for @fypStartQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Start Questionnaire'**
  String get fypStartQuestionnaire;

  /// No description provided for @fypFoundPerfectMatches.
  ///
  /// In en, this message translates to:
  /// **'We found your perfect matches!'**
  String get fypFoundPerfectMatches;

  /// No description provided for @fypStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get fypStatTotal;

  /// No description provided for @fypStatSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get fypStatSafety;

  /// No description provided for @fypStatMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get fypStatMatch;

  /// No description provided for @fypStatReach.
  ///
  /// In en, this message translates to:
  /// **'Reach'**
  String get fypStatReach;

  /// No description provided for @fypFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String fypFilterAll(int count);

  /// No description provided for @fypFilterSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety ({count})'**
  String fypFilterSafety(int count);

  /// No description provided for @fypFilterMatch.
  ///
  /// In en, this message translates to:
  /// **'Match ({count})'**
  String fypFilterMatch(int count);

  /// No description provided for @fypFilterReach.
  ///
  /// In en, this message translates to:
  /// **'Reach ({count})'**
  String fypFilterReach(int count);

  /// No description provided for @fypNoFilterMatch.
  ///
  /// In en, this message translates to:
  /// **'No universities match the selected filter'**
  String get fypNoFilterMatch;

  /// No description provided for @fypPercentMatch.
  ///
  /// In en, this message translates to:
  /// **'{score}% Match'**
  String fypPercentMatch(String score);

  /// No description provided for @fypLoadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading university details...'**
  String get fypLoadingDetails;

  /// No description provided for @fypLocationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get fypLocationNotAvailable;

  /// No description provided for @fypStatAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get fypStatAcceptance;

  /// No description provided for @fypStatTuition.
  ///
  /// In en, this message translates to:
  /// **'Tuition'**
  String get fypStatTuition;

  /// No description provided for @fypStatStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get fypStatStudents;

  /// No description provided for @fypStatRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get fypStatRank;

  /// No description provided for @fypWhyGoodMatch.
  ///
  /// In en, this message translates to:
  /// **'Why it\'s a good match:'**
  String get fypWhyGoodMatch;

  /// No description provided for @fypViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get fypViewDetails;

  /// No description provided for @fypUniversityDetails.
  ///
  /// In en, this message translates to:
  /// **'University Details'**
  String get fypUniversityDetails;

  /// No description provided for @fypVisitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get fypVisitWebsite;

  /// No description provided for @fypUniversityNotFound.
  ///
  /// In en, this message translates to:
  /// **'University not found'**
  String get fypUniversityNotFound;

  /// No description provided for @fypErrorLoadingUniversity.
  ///
  /// In en, this message translates to:
  /// **'Error loading university'**
  String get fypErrorLoadingUniversity;

  /// No description provided for @fypUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get fypUnknownError;

  /// No description provided for @fypKStudents.
  ///
  /// In en, this message translates to:
  /// **'{count}k Students'**
  String fypKStudents(String count);

  /// No description provided for @fypNationalRank.
  ///
  /// In en, this message translates to:
  /// **'National Rank'**
  String get fypNationalRank;

  /// No description provided for @fypAcceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get fypAcceptanceRate;

  /// No description provided for @fypAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get fypAbout;

  /// No description provided for @fypAdmissions.
  ///
  /// In en, this message translates to:
  /// **'Admissions'**
  String get fypAdmissions;

  /// No description provided for @fypCostsFinancialAid.
  ///
  /// In en, this message translates to:
  /// **'Costs & Financial Aid'**
  String get fypCostsFinancialAid;

  /// No description provided for @fypStudentOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Student Outcomes'**
  String get fypStudentOutcomes;

  /// No description provided for @fypProgramsOffered.
  ///
  /// In en, this message translates to:
  /// **'Programs Offered'**
  String get fypProgramsOffered;

  /// No description provided for @fypAverageGPA.
  ///
  /// In en, this message translates to:
  /// **'Average GPA'**
  String get fypAverageGPA;

  /// No description provided for @fypSatMathRange.
  ///
  /// In en, this message translates to:
  /// **'SAT Math Range'**
  String get fypSatMathRange;

  /// No description provided for @fypSatEbrwRange.
  ///
  /// In en, this message translates to:
  /// **'SAT EBRW Range'**
  String get fypSatEbrwRange;

  /// No description provided for @fypActRange.
  ///
  /// In en, this message translates to:
  /// **'ACT Range'**
  String get fypActRange;

  /// No description provided for @fypOutOfStateTuition.
  ///
  /// In en, this message translates to:
  /// **'Out-of-State Tuition'**
  String get fypOutOfStateTuition;

  /// No description provided for @fypTotalCostEst.
  ///
  /// In en, this message translates to:
  /// **'Total Cost (est.)'**
  String get fypTotalCostEst;

  /// No description provided for @fypFinancialAidNote.
  ///
  /// In en, this message translates to:
  /// **'Financial aid may be available. Contact the university for details.'**
  String get fypFinancialAidNote;

  /// No description provided for @fypGraduationRate.
  ///
  /// In en, this message translates to:
  /// **'4-Year Graduation Rate'**
  String get fypGraduationRate;

  /// No description provided for @fypMedianEarnings.
  ///
  /// In en, this message translates to:
  /// **'Median Earnings (10 years)'**
  String get fypMedianEarnings;

  /// No description provided for @appListTitle.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get appListTitle;

  /// No description provided for @appTabAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String appTabAll(int count);

  /// No description provided for @appTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending ({count})'**
  String appTabPending(int count);

  /// No description provided for @appTabUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review ({count})'**
  String appTabUnderReview(int count);

  /// No description provided for @appTabAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted ({count})'**
  String appTabAccepted(int count);

  /// No description provided for @appLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading applications...'**
  String get appLoadingMessage;

  /// No description provided for @appRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get appRetry;

  /// No description provided for @appNewApplication.
  ///
  /// In en, this message translates to:
  /// **'New Application'**
  String get appNewApplication;

  /// No description provided for @appEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Applications'**
  String get appEmptyTitle;

  /// No description provided for @appEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t submitted any applications yet.'**
  String get appEmptyMessage;

  /// No description provided for @appCreateApplication.
  ///
  /// In en, this message translates to:
  /// **'Create Application'**
  String get appCreateApplication;

  /// No description provided for @appToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get appToday;

  /// No description provided for @appYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get appYesterday;

  /// No description provided for @appDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String appDaysAgo(int days);

  /// No description provided for @appFeePaid.
  ///
  /// In en, this message translates to:
  /// **'Fee Paid'**
  String get appFeePaid;

  /// No description provided for @appPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get appPaymentPending;

  /// No description provided for @appReviewedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Reviewed {days} days ago'**
  String appReviewedDaysAgo(int days);

  /// No description provided for @appDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Details'**
  String get appDetailTitle;

  /// No description provided for @appDetailShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get appDetailShare;

  /// No description provided for @appDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Application Status'**
  String get appDetailStatus;

  /// No description provided for @appStatusPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get appStatusPendingReview;

  /// No description provided for @appStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get appStatusUnderReview;

  /// No description provided for @appStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get appStatusAccepted;

  /// No description provided for @appStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get appStatusRejected;

  /// No description provided for @appStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get appStatusUnknown;

  /// No description provided for @appDetailInfo.
  ///
  /// In en, this message translates to:
  /// **'Application Information'**
  String get appDetailInfo;

  /// No description provided for @appDetailInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get appDetailInstitution;

  /// No description provided for @appDetailProgram.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get appDetailProgram;

  /// No description provided for @appDetailSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get appDetailSubmitted;

  /// No description provided for @appDetailReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get appDetailReviewed;

  /// No description provided for @appDetailPaymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get appDetailPaymentInfo;

  /// No description provided for @appDetailApplicationFee.
  ///
  /// In en, this message translates to:
  /// **'Application Fee'**
  String get appDetailApplicationFee;

  /// No description provided for @appDetailPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get appDetailPaymentStatus;

  /// No description provided for @appDetailPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get appDetailPaid;

  /// No description provided for @appDetailPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get appDetailPendingPayment;

  /// No description provided for @appDetailPayFee.
  ///
  /// In en, this message translates to:
  /// **'Pay Application Fee'**
  String get appDetailPayFee;

  /// No description provided for @appPaymentDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get appPaymentDialogTitle;

  /// No description provided for @appPaymentDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Pay application fee of \${fee}?'**
  String appPaymentDialogContent(String fee);

  /// No description provided for @appCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get appCancel;

  /// No description provided for @appPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get appPayNow;

  /// No description provided for @appPaymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get appPaymentSuccess;

  /// No description provided for @appPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed. Please try again.'**
  String get appPaymentFailed;

  /// No description provided for @appErrorPayment.
  ///
  /// In en, this message translates to:
  /// **'Error processing payment: {error}'**
  String appErrorPayment(String error);

  /// No description provided for @appDetailReviewNotes.
  ///
  /// In en, this message translates to:
  /// **'Review Notes'**
  String get appDetailReviewNotes;

  /// No description provided for @appDetailDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get appDetailDocuments;

  /// No description provided for @appDetailTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get appDetailTranscript;

  /// No description provided for @appDetailUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get appDetailUploaded;

  /// No description provided for @appDetailIdDocument.
  ///
  /// In en, this message translates to:
  /// **'ID Document'**
  String get appDetailIdDocument;

  /// No description provided for @appDetailPersonalStatement.
  ///
  /// In en, this message translates to:
  /// **'Personal Statement'**
  String get appDetailPersonalStatement;

  /// No description provided for @appDetailWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get appDetailWithdraw;

  /// No description provided for @appDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get appDetailEdit;

  /// No description provided for @appWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Application'**
  String get appWithdrawTitle;

  /// No description provided for @appWithdrawConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to withdraw this application? This action cannot be undone.'**
  String get appWithdrawConfirmation;

  /// No description provided for @appWithdrawSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application withdrawn successfully'**
  String get appWithdrawSuccess;

  /// No description provided for @appWithdrawFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to withdraw application'**
  String get appWithdrawFailed;

  /// No description provided for @appErrorWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Error withdrawing application: {error}'**
  String appErrorWithdraw(String error);

  /// No description provided for @appCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Application'**
  String get appCreateTitle;

  /// No description provided for @appStepProgramSelection.
  ///
  /// In en, this message translates to:
  /// **'Program Selection'**
  String get appStepProgramSelection;

  /// No description provided for @appSelectUniversity.
  ///
  /// In en, this message translates to:
  /// **'Select University'**
  String get appSelectUniversity;

  /// No description provided for @appBrowseInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Browse Institutions'**
  String get appBrowseInstitutions;

  /// No description provided for @appNoProgramsYet.
  ///
  /// In en, this message translates to:
  /// **'This institution has no active programs yet. Please select another institution.'**
  String get appNoProgramsYet;

  /// No description provided for @appSelectProgramLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a Program *'**
  String get appSelectProgramLabel;

  /// No description provided for @appProgramsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} programs available'**
  String appProgramsAvailable(int count);

  /// No description provided for @appStepPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get appStepPersonalInfo;

  /// No description provided for @appFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get appFullNameLabel;

  /// No description provided for @appEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get appEmailLabel;

  /// No description provided for @appPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get appPhoneLabel;

  /// No description provided for @appStreetAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Street Address *'**
  String get appStreetAddressLabel;

  /// No description provided for @appCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City/Town *'**
  String get appCityLabel;

  /// No description provided for @appCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country *'**
  String get appCountryLabel;

  /// No description provided for @appStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State/Province *'**
  String get appStateLabel;

  /// No description provided for @appSelectCountryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a country first'**
  String get appSelectCountryFirst;

  /// No description provided for @appStepAcademicInfo.
  ///
  /// In en, this message translates to:
  /// **'Academic Information'**
  String get appStepAcademicInfo;

  /// No description provided for @appPreviousSchoolLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous School/Institution'**
  String get appPreviousSchoolLabel;

  /// No description provided for @appGpaLabel.
  ///
  /// In en, this message translates to:
  /// **'GPA / Grade Average'**
  String get appGpaLabel;

  /// No description provided for @appPersonalStatementLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal Statement'**
  String get appPersonalStatementLabel;

  /// No description provided for @appPersonalStatementHint.
  ///
  /// In en, this message translates to:
  /// **'Why are you interested in this program?'**
  String get appPersonalStatementHint;

  /// No description provided for @appStepDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents (Required)'**
  String get appStepDocuments;

  /// No description provided for @appUploadRequiredDocs.
  ///
  /// In en, this message translates to:
  /// **'Upload Required Documents'**
  String get appUploadRequiredDocs;

  /// No description provided for @appDocTranscriptTitle.
  ///
  /// In en, this message translates to:
  /// **'Academic Transcript'**
  String get appDocTranscriptTitle;

  /// No description provided for @appDocTranscriptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official transcript from your previous school (PDF, DOC, or DOCX format, max 5MB)'**
  String get appDocTranscriptSubtitle;

  /// No description provided for @appDocIdTitle.
  ///
  /// In en, this message translates to:
  /// **'ID Document'**
  String get appDocIdTitle;

  /// No description provided for @appDocIdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Valid government-issued ID: passport, national ID card, or driver\'s license (PDF, JPG, or PNG)'**
  String get appDocIdSubtitle;

  /// No description provided for @appDocPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Passport Photo'**
  String get appDocPhotoTitle;

  /// No description provided for @appDocPhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent passport-sized photo with a plain background (JPG or PNG format)'**
  String get appDocPhotoSubtitle;

  /// No description provided for @appDocRequiredWarning.
  ///
  /// In en, this message translates to:
  /// **'All three documents are required. Please upload the transcript, ID document, and passport photo before submitting.'**
  String get appDocRequiredWarning;

  /// No description provided for @appSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get appSubmit;

  /// No description provided for @appContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get appContinue;

  /// No description provided for @appBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get appBack;

  /// No description provided for @courseListTitle.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courseListTitle;

  /// No description provided for @courseFiltersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get courseFiltersTooltip;

  /// No description provided for @courseBrowseAll.
  ///
  /// In en, this message translates to:
  /// **'Browse All'**
  String get courseBrowseAll;

  /// No description provided for @courseAssignedToMe.
  ///
  /// In en, this message translates to:
  /// **'Assigned to Me'**
  String get courseAssignedToMe;

  /// No description provided for @courseSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search courses...'**
  String get courseSearchHint;

  /// No description provided for @courseNoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get courseNoAvailable;

  /// No description provided for @courseCheckBackLater.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new courses'**
  String get courseCheckBackLater;

  /// No description provided for @courseRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get courseRetry;

  /// No description provided for @courseFailedLoadAssigned.
  ///
  /// In en, this message translates to:
  /// **'Failed to load assigned courses'**
  String get courseFailedLoadAssigned;

  /// No description provided for @courseNoAssignedYet.
  ///
  /// In en, this message translates to:
  /// **'No courses assigned yet'**
  String get courseNoAssignedYet;

  /// No description provided for @courseAssignedDescription.
  ///
  /// In en, this message translates to:
  /// **'Courses assigned by your admin or institution will appear here.'**
  String get courseAssignedDescription;

  /// No description provided for @courseRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get courseRequired;

  /// No description provided for @courseLessonsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String courseLessonsLabel(int count);

  /// No description provided for @coursePercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String coursePercentComplete(int percent);

  /// No description provided for @courseNoRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get courseNoRatingsYet;

  /// No description provided for @courseEnrolledCount.
  ///
  /// In en, this message translates to:
  /// **'{count} enrolled'**
  String courseEnrolledCount(int count);

  /// No description provided for @courseFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get courseFiltersTitle;

  /// No description provided for @courseLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get courseLevelLabel;

  /// No description provided for @courseAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get courseAllLevels;

  /// No description provided for @courseLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get courseLevelBeginner;

  /// No description provided for @courseLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get courseLevelIntermediate;

  /// No description provided for @courseLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get courseLevelAdvanced;

  /// No description provided for @courseLevelExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get courseLevelExpert;

  /// No description provided for @courseClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get courseClearAll;

  /// No description provided for @courseApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get courseApplyFilters;

  /// No description provided for @courseDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get courseDescription;

  /// No description provided for @courseWhatYoullLearn.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Learn'**
  String get courseWhatYoullLearn;

  /// No description provided for @coursePrerequisites.
  ///
  /// In en, this message translates to:
  /// **'Prerequisites'**
  String get coursePrerequisites;

  /// No description provided for @coursePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get coursePrice;

  /// No description provided for @courseCourseFull.
  ///
  /// In en, this message translates to:
  /// **'Course Full'**
  String get courseCourseFull;

  /// No description provided for @courseRequestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Permission'**
  String get courseRequestPermission;

  /// No description provided for @coursePermissionPending.
  ///
  /// In en, this message translates to:
  /// **'Permission Pending'**
  String get coursePermissionPending;

  /// No description provided for @coursePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get coursePermissionDenied;

  /// No description provided for @courseRequestPermissionAgain.
  ///
  /// In en, this message translates to:
  /// **'Request Permission Again'**
  String get courseRequestPermissionAgain;

  /// No description provided for @courseEnrollNow.
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get courseEnrollNow;

  /// No description provided for @courseRequestEnrollmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Enrollment Permission'**
  String get courseRequestEnrollmentTitle;

  /// No description provided for @courseRequestEnrollmentContent.
  ///
  /// In en, this message translates to:
  /// **'Request permission to enroll in \"{title}\"?'**
  String courseRequestEnrollmentContent(String title);

  /// No description provided for @courseInstitutionReview.
  ///
  /// In en, this message translates to:
  /// **'The institution will review your request.'**
  String get courseInstitutionReview;

  /// No description provided for @courseMessageToInstitution.
  ///
  /// In en, this message translates to:
  /// **'Message to institution (optional)'**
  String get courseMessageToInstitution;

  /// No description provided for @courseMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to take this course?'**
  String get courseMessageHint;

  /// No description provided for @courseCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get courseCancel;

  /// No description provided for @courseRequest.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get courseRequest;

  /// No description provided for @coursePermissionRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Permission request sent!'**
  String get coursePermissionRequestSent;

  /// No description provided for @courseFailedRequestPermission.
  ///
  /// In en, this message translates to:
  /// **'Failed to request permission: {error}'**
  String courseFailedRequestPermission(String error);

  /// No description provided for @courseEnrolledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully enrolled in course!'**
  String get courseEnrolledSuccess;

  /// No description provided for @courseFailedEnroll.
  ///
  /// In en, this message translates to:
  /// **'Failed to enroll'**
  String get courseFailedEnroll;

  /// No description provided for @courseContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning ({progress}%)'**
  String courseContinueLearning(String progress);

  /// No description provided for @courseStartLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get courseStartLearning;

  /// No description provided for @courseLessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} lessons completed'**
  String courseLessonsCompleted(int completed, int total);

  /// No description provided for @courseCollapseSidebar.
  ///
  /// In en, this message translates to:
  /// **'Collapse sidebar'**
  String get courseCollapseSidebar;

  /// No description provided for @courseExpandSidebar.
  ///
  /// In en, this message translates to:
  /// **'Expand sidebar'**
  String get courseExpandSidebar;

  /// No description provided for @courseErrorLoadingModules.
  ///
  /// In en, this message translates to:
  /// **'Error loading modules:\n{error}'**
  String courseErrorLoadingModules(String error);

  /// No description provided for @courseNoContentYet.
  ///
  /// In en, this message translates to:
  /// **'No content available yet'**
  String get courseNoContentYet;

  /// No description provided for @courseNoLessonsAdded.
  ///
  /// In en, this message translates to:
  /// **'The instructor hasn\'t added any lessons'**
  String get courseNoLessonsAdded;

  /// No description provided for @courseLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} lessons'**
  String courseLessonsCount(int completed, int total);

  /// No description provided for @courseWelcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {title}'**
  String courseWelcomeTo(String title);

  /// No description provided for @courseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get courseCompleted;

  /// No description provided for @coursePrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get coursePrevious;

  /// No description provided for @courseMarkAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get courseMarkAsComplete;

  /// No description provided for @courseNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get courseNext;

  /// No description provided for @courseMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get courseMyCourses;

  /// No description provided for @courseFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get courseFilterByStatus;

  /// No description provided for @courseTabAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned ({count})'**
  String courseTabAssigned(int count);

  /// No description provided for @courseTabEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled ({count})'**
  String courseTabEnrolled(int count);

  /// No description provided for @courseNoAssigned.
  ///
  /// In en, this message translates to:
  /// **'No assigned courses'**
  String get courseNoAssigned;

  /// No description provided for @courseAssignedByInstitution.
  ///
  /// In en, this message translates to:
  /// **'Courses assigned to you by your institution will appear here'**
  String get courseAssignedByInstitution;

  /// No description provided for @courseREQUIRED.
  ///
  /// In en, this message translates to:
  /// **'REQUIRED'**
  String get courseREQUIRED;

  /// No description provided for @courseProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get courseProgress;

  /// No description provided for @courseDuePrefix.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String courseDuePrefix(String date);

  /// No description provided for @courseStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get courseStatusCompleted;

  /// No description provided for @courseStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get courseStatusInProgress;

  /// No description provided for @courseStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get courseStatusOverdue;

  /// No description provided for @courseStatusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get courseStatusAssigned;

  /// No description provided for @courseDueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get courseDueToday;

  /// No description provided for @courseDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get courseDueTomorrow;

  /// No description provided for @courseDueDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String courseDueDays(int days);

  /// No description provided for @courseNoEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No enrolled courses'**
  String get courseNoEnrolled;

  /// No description provided for @courseBrowseToStart.
  ///
  /// In en, this message translates to:
  /// **'Browse courses to get started'**
  String get courseBrowseToStart;

  /// No description provided for @courseBrowseCourses.
  ///
  /// In en, this message translates to:
  /// **'Browse Courses'**
  String get courseBrowseCourses;

  /// No description provided for @courseFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get courseFilterAll;

  /// No description provided for @courseStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get courseStatusActive;

  /// No description provided for @courseStatusDropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get courseStatusDropped;

  /// No description provided for @courseStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get courseStatusSuspended;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
