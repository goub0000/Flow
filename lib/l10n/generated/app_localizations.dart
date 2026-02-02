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

  /// No description provided for @searchSuggestionGhana.
  ///
  /// In en, this message translates to:
  /// **'University of Ghana'**
  String get searchSuggestionGhana;

  /// No description provided for @searchSuggestionGhanaLocation.
  ///
  /// In en, this message translates to:
  /// **'Accra, Ghana'**
  String get searchSuggestionGhanaLocation;

  /// No description provided for @searchSuggestionCapeTown.
  ///
  /// In en, this message translates to:
  /// **'University of Cape Town'**
  String get searchSuggestionCapeTown;

  /// No description provided for @searchSuggestionCapeTownLocation.
  ///
  /// In en, this message translates to:
  /// **'Cape Town, South Africa'**
  String get searchSuggestionCapeTownLocation;

  /// No description provided for @searchSuggestionAshesi.
  ///
  /// In en, this message translates to:
  /// **'Ashesi University'**
  String get searchSuggestionAshesi;

  /// No description provided for @searchSuggestionAshesiLocation.
  ///
  /// In en, this message translates to:
  /// **'Berekuso, Ghana'**
  String get searchSuggestionAshesiLocation;

  /// No description provided for @searchSuggestionPublicUniversity.
  ///
  /// In en, this message translates to:
  /// **'Public University'**
  String get searchSuggestionPublicUniversity;

  /// No description provided for @searchSuggestionPrivateUniversity.
  ///
  /// In en, this message translates to:
  /// **'Private University'**
  String get searchSuggestionPrivateUniversity;

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

  /// No description provided for @homeNewFeature.
  ///
  /// In en, this message translates to:
  /// **'NEW FEATURE'**
  String get homeNewFeature;

  /// No description provided for @homeFindYourPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get homeFindYourPathTitle;

  /// No description provided for @homeFindYourPathDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover universities that match your goals, budget, and aspirations.\nLet our intelligent recommendation system guide you to the perfect fit.'**
  String get homeFindYourPathDesc;

  /// No description provided for @homePersonalizedRecs.
  ///
  /// In en, this message translates to:
  /// **'Personalized Recommendations'**
  String get homePersonalizedRecs;

  /// No description provided for @homeTopUniversities.
  ///
  /// In en, this message translates to:
  /// **'12+ Top Universities'**
  String get homeTopUniversities;

  /// No description provided for @homeSmartMatching.
  ///
  /// In en, this message translates to:
  /// **'Smart Matching Algorithm'**
  String get homeSmartMatching;

  /// No description provided for @homeStartYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get homeStartYourJourney;

  /// No description provided for @homeNoAccountRequired.
  ///
  /// In en, this message translates to:
  /// **'No account required - get started instantly'**
  String get homeNoAccountRequired;

  /// No description provided for @homeSearchUniversitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore 18,000+ universities from around the world.\nFilter by country, tuition, acceptance rate, and more.'**
  String get homeSearchUniversitiesDesc;

  /// No description provided for @homeFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get homeFilters;

  /// No description provided for @homeBrowseUniversities.
  ///
  /// In en, this message translates to:
  /// **'Browse Universities'**
  String get homeBrowseUniversities;

  /// No description provided for @helpBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get helpBack;

  /// No description provided for @helpContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get helpContactSupport;

  /// No description provided for @helpWeAreHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help!'**
  String get helpWeAreHereToHelp;

  /// No description provided for @helpSupportResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Our support team typically responds within 24 hours'**
  String get helpSupportResponseTime;

  /// No description provided for @helpSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get helpSubject;

  /// No description provided for @helpSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of your issue'**
  String get helpSubjectHint;

  /// No description provided for @helpSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject'**
  String get helpSubjectRequired;

  /// No description provided for @helpSubjectMinLength.
  ///
  /// In en, this message translates to:
  /// **'Subject must be at least 5 characters'**
  String get helpSubjectMinLength;

  /// No description provided for @helpCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get helpCategory;

  /// No description provided for @helpCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Inquiry'**
  String get helpCategoryGeneral;

  /// No description provided for @helpCategoryTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical Issue'**
  String get helpCategoryTechnical;

  /// No description provided for @helpCategoryBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing & Payments'**
  String get helpCategoryBilling;

  /// No description provided for @helpCategoryAccount.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get helpCategoryAccount;

  /// No description provided for @helpCategoryCourse.
  ///
  /// In en, this message translates to:
  /// **'Course Content'**
  String get helpCategoryCourse;

  /// No description provided for @helpCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get helpCategoryOther;

  /// No description provided for @helpPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get helpPriority;

  /// No description provided for @helpPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get helpPriorityLow;

  /// No description provided for @helpPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get helpPriorityMedium;

  /// No description provided for @helpPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get helpPriorityHigh;

  /// No description provided for @helpPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get helpPriorityUrgent;

  /// No description provided for @helpDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get helpDescription;

  /// No description provided for @helpDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please provide detailed information about your issue...'**
  String get helpDescriptionHint;

  /// No description provided for @helpDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue'**
  String get helpDescriptionRequired;

  /// No description provided for @helpDescriptionMinLength.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 20 characters'**
  String get helpDescriptionMinLength;

  /// No description provided for @helpAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get helpAttachments;

  /// No description provided for @helpNoFilesAttached.
  ///
  /// In en, this message translates to:
  /// **'No files attached'**
  String get helpNoFilesAttached;

  /// No description provided for @helpAddAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get helpAddAttachment;

  /// No description provided for @helpAttachmentTypes.
  ///
  /// In en, this message translates to:
  /// **'Images, PDFs, documents (max 10MB each)'**
  String get helpAttachmentTypes;

  /// No description provided for @helpPreferredContactMethod.
  ///
  /// In en, this message translates to:
  /// **'Preferred Contact Method'**
  String get helpPreferredContactMethod;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get helpEmail;

  /// No description provided for @helpRespondViaEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ll respond via email'**
  String get helpRespondViaEmail;

  /// No description provided for @helpPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get helpPhone;

  /// No description provided for @helpCallYouBack.
  ///
  /// In en, this message translates to:
  /// **'We\'ll call you back'**
  String get helpCallYouBack;

  /// No description provided for @helpSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get helpSubmitting;

  /// No description provided for @helpSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get helpSubmitRequest;

  /// No description provided for @helpOtherWaysToReachUs.
  ///
  /// In en, this message translates to:
  /// **'Other Ways to Reach Us'**
  String get helpOtherWaysToReachUs;

  /// No description provided for @helpEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard'**
  String get helpEmailCopied;

  /// No description provided for @helpPhoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard'**
  String get helpPhoneCopied;

  /// No description provided for @helpBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get helpBusinessHours;

  /// No description provided for @helpBusinessHoursDetails.
  ///
  /// In en, this message translates to:
  /// **'Monday - Friday\n9:00 AM - 6:00 PM EST'**
  String get helpBusinessHoursDetails;

  /// No description provided for @helpAverageResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Average Response Time'**
  String get helpAverageResponseTime;

  /// No description provided for @helpTypicallyRespond24h.
  ///
  /// In en, this message translates to:
  /// **'We typically respond within 24 hours'**
  String get helpTypicallyRespond24h;

  /// No description provided for @helpRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted'**
  String get helpRequestSubmitted;

  /// No description provided for @helpRequestSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your support request has been submitted successfully!'**
  String get helpRequestSubmittedSuccess;

  /// No description provided for @helpTrackRequestInfo.
  ///
  /// In en, this message translates to:
  /// **'We\'ll respond to your email within 24 hours. You can track your request in the Support Tickets section.'**
  String get helpTrackRequestInfo;

  /// No description provided for @helpOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get helpOk;

  /// No description provided for @helpViewTicketInSupport.
  ///
  /// In en, this message translates to:
  /// **'View your ticket in Support Tickets'**
  String get helpViewTicketInSupport;

  /// No description provided for @helpViewTickets.
  ///
  /// In en, this message translates to:
  /// **'View Tickets'**
  String get helpViewTickets;

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpFaqTitle;

  /// No description provided for @helpFaqAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get helpFaqAll;

  /// No description provided for @helpFaqGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get helpFaqGettingStarted;

  /// No description provided for @helpFaqAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get helpFaqAccount;

  /// No description provided for @helpFaqCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get helpFaqCourses;

  /// No description provided for @helpFaqPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get helpFaqPayments;

  /// No description provided for @helpFaqTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get helpFaqTechnical;

  /// No description provided for @helpSearchFaqs.
  ///
  /// In en, this message translates to:
  /// **'Search FAQs...'**
  String get helpSearchFaqs;

  /// No description provided for @helpNoFaqsFound.
  ///
  /// In en, this message translates to:
  /// **'No FAQs found'**
  String get helpNoFaqsFound;

  /// No description provided for @helpTryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get helpTryDifferentSearch;

  /// No description provided for @helpThanksForFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback!'**
  String get helpThanksForFeedback;

  /// No description provided for @helpCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenterTitle;

  /// No description provided for @helpHowCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get helpHowCanWeHelp;

  /// No description provided for @helpSearchOrBrowse.
  ///
  /// In en, this message translates to:
  /// **'Search for answers or browse help topics'**
  String get helpSearchOrBrowse;

  /// No description provided for @helpSearchForHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get helpSearchForHelp;

  /// No description provided for @helpQuickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get helpQuickHelp;

  /// No description provided for @helpBrowseFaqs.
  ///
  /// In en, this message translates to:
  /// **'Browse FAQs'**
  String get helpBrowseFaqs;

  /// No description provided for @helpBrowseFaqsDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick answers to common questions'**
  String get helpBrowseFaqsDesc;

  /// No description provided for @helpContactSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Get help from our support team'**
  String get helpContactSupportDesc;

  /// No description provided for @helpMySupportTickets.
  ///
  /// In en, this message translates to:
  /// **'My Support Tickets'**
  String get helpMySupportTickets;

  /// No description provided for @helpMySupportTicketsDesc.
  ///
  /// In en, this message translates to:
  /// **'View your open and closed tickets'**
  String get helpMySupportTicketsDesc;

  /// No description provided for @helpBrowseByTopic.
  ///
  /// In en, this message translates to:
  /// **'Browse by Topic'**
  String get helpBrowseByTopic;

  /// No description provided for @helpViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get helpViewAll;

  /// No description provided for @helpPopularArticles.
  ///
  /// In en, this message translates to:
  /// **'Popular Articles'**
  String get helpPopularArticles;

  /// No description provided for @helpRemovedFromBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Removed from bookmarks'**
  String get helpRemovedFromBookmarks;

  /// No description provided for @helpAddedToBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Added to bookmarks'**
  String get helpAddedToBookmarks;

  /// No description provided for @helpStillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get helpStillNeedHelp;

  /// No description provided for @helpSupportTeamHere.
  ///
  /// In en, this message translates to:
  /// **'Our support team is here to help you'**
  String get helpSupportTeamHere;

  /// No description provided for @helpWasArticleHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this article helpful?'**
  String get helpWasArticleHelpful;

  /// No description provided for @helpYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get helpYes;

  /// No description provided for @helpNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get helpNo;

  /// No description provided for @helpThanksWeWillImprove.
  ///
  /// In en, this message translates to:
  /// **'Thanks! We\'ll improve this article.'**
  String get helpThanksWeWillImprove;

  /// No description provided for @helpSupportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support Tickets'**
  String get helpSupportTickets;

  /// No description provided for @helpTicketActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get helpTicketActive;

  /// No description provided for @helpTicketWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get helpTicketWaiting;

  /// No description provided for @helpTicketResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get helpTicketResolved;

  /// No description provided for @helpNewTicket.
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get helpNewTicket;

  /// No description provided for @helpNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets'**
  String get helpNoTickets;

  /// No description provided for @helpCreateTicketToGetSupport.
  ///
  /// In en, this message translates to:
  /// **'Create a ticket to get support'**
  String get helpCreateTicketToGetSupport;

  /// No description provided for @helpTypeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get helpTypeYourMessage;

  /// No description provided for @helpMessageSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent!'**
  String get helpMessageSent;

  /// No description provided for @helpCreateSupportTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Support Ticket'**
  String get helpCreateSupportTicket;

  /// No description provided for @helpDescribeIssueDetail.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail...'**
  String get helpDescribeIssueDetail;

  /// No description provided for @helpCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get helpCancel;

  /// No description provided for @helpSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get helpSubmit;

  /// No description provided for @helpTicketCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Support ticket created successfully!'**
  String get helpTicketCreatedSuccess;

  /// No description provided for @cookiePreferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Cookie preferences saved'**
  String get cookiePreferencesSaved;

  /// No description provided for @cookieEssentialOnly.
  ///
  /// In en, this message translates to:
  /// **'Essential Only'**
  String get cookieEssentialOnly;

  /// No description provided for @cookieWeUseCookies.
  ///
  /// In en, this message translates to:
  /// **'We use cookies'**
  String get cookieWeUseCookies;

  /// No description provided for @cookieBannerDescription.
  ///
  /// In en, this message translates to:
  /// **'We use cookies to enhance your experience, analyze site usage, and provide personalized content. By clicking \"Accept All\", you consent to our use of cookies.'**
  String get cookieBannerDescription;

  /// No description provided for @cookieAcceptAll.
  ///
  /// In en, this message translates to:
  /// **'Accept All'**
  String get cookieAcceptAll;

  /// No description provided for @cookieCustomize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get cookieCustomize;

  /// No description provided for @cookiePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get cookiePrivacyPolicy;

  /// No description provided for @cookiePreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookie Preferences'**
  String get cookiePreferencesTitle;

  /// No description provided for @cookieCustomizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize your cookie preferences. Essential cookies are always enabled.'**
  String get cookieCustomizeDescription;

  /// No description provided for @cookiePreferencesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cookie preferences saved successfully'**
  String get cookiePreferencesSavedSuccess;

  /// No description provided for @cookieFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save preferences. Please try again.'**
  String get cookieFailedToSave;

  /// No description provided for @cookieRejectAll.
  ///
  /// In en, this message translates to:
  /// **'Reject All'**
  String get cookieRejectAll;

  /// No description provided for @cookieSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get cookieSavePreferences;

  /// No description provided for @cookieAlwaysActive.
  ///
  /// In en, this message translates to:
  /// **'Always Active'**
  String get cookieAlwaysActive;

  /// No description provided for @cookieSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookie Settings'**
  String get cookieSettingsTitle;

  /// No description provided for @cookieNoConsentData.
  ///
  /// In en, this message translates to:
  /// **'No consent data available'**
  String get cookieNoConsentData;

  /// No description provided for @cookieSetPreferences.
  ///
  /// In en, this message translates to:
  /// **'Set Preferences'**
  String get cookieSetPreferences;

  /// No description provided for @cookieConsentActive.
  ///
  /// In en, this message translates to:
  /// **'Consent Active'**
  String get cookieConsentActive;

  /// No description provided for @cookieNoConsentGiven.
  ///
  /// In en, this message translates to:
  /// **'No Consent Given'**
  String get cookieNoConsentGiven;

  /// No description provided for @cookieCurrentPreferences.
  ///
  /// In en, this message translates to:
  /// **'Current Preferences'**
  String get cookieCurrentPreferences;

  /// No description provided for @cookieChangePreferences.
  ///
  /// In en, this message translates to:
  /// **'Change Preferences'**
  String get cookieChangePreferences;

  /// No description provided for @cookieExportMyData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get cookieExportMyData;

  /// No description provided for @cookieDeleteMyData.
  ///
  /// In en, this message translates to:
  /// **'Delete My Data'**
  String get cookieDeleteMyData;

  /// No description provided for @cookieAboutCookies.
  ///
  /// In en, this message translates to:
  /// **'About Cookies'**
  String get cookieAboutCookies;

  /// No description provided for @cookieAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Cookies help us provide you with a better experience. You can change your preferences at any time. Essential cookies are always active for security and functionality.'**
  String get cookieAboutDescription;

  /// No description provided for @cookieReadPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read Privacy Policy'**
  String get cookieReadPrivacyPolicy;

  /// No description provided for @cookieExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get cookieExportData;

  /// No description provided for @cookieExportDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will create a file with all your cookie and consent data. The file will be saved to your downloads folder.'**
  String get cookieExportDataDescription;

  /// No description provided for @cookieCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cookieCancel;

  /// No description provided for @cookieExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get cookieExport;

  /// No description provided for @cookieDeleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete Data'**
  String get cookieDeleteData;

  /// No description provided for @cookieDeleteDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your cookie data. Essential cookies required for the app to function will remain. This action cannot be undone.'**
  String get cookieDeleteDataDescription;

  /// No description provided for @cookieDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get cookieDelete;

  /// No description provided for @cookieDataDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully'**
  String get cookieDataDeletedSuccess;

  /// No description provided for @careerCounselingTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Counseling'**
  String get careerCounselingTitle;

  /// No description provided for @careerFindCounselor.
  ///
  /// In en, this message translates to:
  /// **'Find Counselor'**
  String get careerFindCounselor;

  /// No description provided for @careerUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get careerUpcoming;

  /// No description provided for @careerPastSessions.
  ///
  /// In en, this message translates to:
  /// **'Past Sessions'**
  String get careerPastSessions;

  /// No description provided for @careerSearchCounselors.
  ///
  /// In en, this message translates to:
  /// **'Search by name, specialization, or expertise...'**
  String get careerSearchCounselors;

  /// No description provided for @careerAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get careerAvailableNow;

  /// No description provided for @careerHighestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get careerHighestRated;

  /// No description provided for @careerMostExperienced.
  ///
  /// In en, this message translates to:
  /// **'Most Experienced'**
  String get careerMostExperienced;

  /// No description provided for @careerNoCounselorsFound.
  ///
  /// In en, this message translates to:
  /// **'No counselors found'**
  String get careerNoCounselorsFound;

  /// No description provided for @careerTryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search'**
  String get careerTryAdjustingSearch;

  /// No description provided for @careerReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get careerReschedule;

  /// No description provided for @careerJoinSession.
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get careerJoinSession;

  /// No description provided for @careerNoPastSessions.
  ///
  /// In en, this message translates to:
  /// **'No past sessions'**
  String get careerNoPastSessions;

  /// No description provided for @careerCompletedSessionsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your completed sessions will appear here'**
  String get careerCompletedSessionsAppearHere;

  /// No description provided for @careerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get careerAbout;

  /// No description provided for @careerAreasOfExpertise.
  ///
  /// In en, this message translates to:
  /// **'Areas of Expertise'**
  String get careerAreasOfExpertise;

  /// No description provided for @careerBookSession.
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get careerBookSession;

  /// No description provided for @careerCurrentlyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Currently Unavailable'**
  String get careerCurrentlyUnavailable;

  /// No description provided for @careerBookCounselingSession.
  ///
  /// In en, this message translates to:
  /// **'Book Counseling Session'**
  String get careerBookCounselingSession;

  /// No description provided for @careerSessionType.
  ///
  /// In en, this message translates to:
  /// **'Session Type'**
  String get careerSessionType;

  /// No description provided for @careerPreferredDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get careerPreferredDate;

  /// No description provided for @careerSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get careerSelectDate;

  /// No description provided for @careerSessionNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Session Notes (Optional)'**
  String get careerSessionNotesOptional;

  /// No description provided for @careerWhatToDiscuss.
  ///
  /// In en, this message translates to:
  /// **'What would you like to discuss?'**
  String get careerWhatToDiscuss;

  /// No description provided for @careerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get careerCancel;

  /// No description provided for @careerConfirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get careerConfirmBooking;

  /// No description provided for @careerSessionBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Session booked successfully!'**
  String get careerSessionBookedSuccess;

  /// No description provided for @careerResourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Career Resources'**
  String get careerResourcesTitle;

  /// No description provided for @careerAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get careerAll;

  /// No description provided for @careerArticles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get careerArticles;

  /// No description provided for @careerVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get careerVideos;

  /// No description provided for @careerCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get careerCourses;

  /// No description provided for @careerSearchResources.
  ///
  /// In en, this message translates to:
  /// **'Search resources...'**
  String get careerSearchResources;

  /// No description provided for @careerRemovedFromBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Removed from bookmarks'**
  String get careerRemovedFromBookmarks;

  /// No description provided for @careerAddedToBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Added to bookmarks'**
  String get careerAddedToBookmarks;

  /// No description provided for @careerCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get careerCategories;

  /// No description provided for @careerNoResourcesFound.
  ///
  /// In en, this message translates to:
  /// **'No resources found'**
  String get careerNoResourcesFound;

  /// No description provided for @careerWhatYoullLearn.
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Learn'**
  String get careerWhatYoullLearn;

  /// No description provided for @careerSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get careerSaved;

  /// No description provided for @careerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get careerSave;

  /// No description provided for @careerOpeningResource.
  ///
  /// In en, this message translates to:
  /// **'Opening resource...'**
  String get careerOpeningResource;

  /// No description provided for @careerStartLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get careerStartLearning;

  /// No description provided for @careerBrowseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get careerBrowseCategories;

  /// No description provided for @jobDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetailsTitle;

  /// No description provided for @jobSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job saved successfully'**
  String get jobSavedSuccessfully;

  /// No description provided for @jobRemovedFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Job removed from saved'**
  String get jobRemovedFromSaved;

  /// No description provided for @jobShareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share functionality coming soon'**
  String get jobShareComingSoon;

  /// No description provided for @jobApplyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get jobApplyNow;

  /// No description provided for @jobSalaryRange.
  ///
  /// In en, this message translates to:
  /// **'Salary Range'**
  String get jobSalaryRange;

  /// No description provided for @jobLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get jobLocation;

  /// No description provided for @jobApplicationDeadline.
  ///
  /// In en, this message translates to:
  /// **'Application Deadline'**
  String get jobApplicationDeadline;

  /// No description provided for @jobDescription.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get jobDescription;

  /// No description provided for @jobRequirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get jobRequirements;

  /// No description provided for @jobResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get jobResponsibilities;

  /// No description provided for @jobBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get jobBenefits;

  /// No description provided for @jobRequiredSkills.
  ///
  /// In en, this message translates to:
  /// **'Required Skills'**
  String get jobRequiredSkills;

  /// No description provided for @jobAboutTheCompany.
  ///
  /// In en, this message translates to:
  /// **'About the Company'**
  String get jobAboutTheCompany;

  /// No description provided for @jobCompanyProfileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Company profile coming soon'**
  String get jobCompanyProfileComingSoon;

  /// No description provided for @jobViewCompanyProfile.
  ///
  /// In en, this message translates to:
  /// **'View Company Profile'**
  String get jobViewCompanyProfile;

  /// No description provided for @jobSimilarJobs.
  ///
  /// In en, this message translates to:
  /// **'Similar Jobs'**
  String get jobSimilarJobs;

  /// No description provided for @jobApplyForThisJob.
  ///
  /// In en, this message translates to:
  /// **'Apply for this Job'**
  String get jobApplyForThisJob;

  /// No description provided for @jobYouAreApplyingFor.
  ///
  /// In en, this message translates to:
  /// **'You are applying for:'**
  String get jobYouAreApplyingFor;

  /// No description provided for @jobCoverLetter.
  ///
  /// In en, this message translates to:
  /// **'Cover Letter'**
  String get jobCoverLetter;

  /// No description provided for @jobCoverLetterHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us why you\'re a great fit...'**
  String get jobCoverLetterHint;

  /// No description provided for @jobUploadResume.
  ///
  /// In en, this message translates to:
  /// **'Upload Resume'**
  String get jobUploadResume;

  /// No description provided for @jobCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get jobCancel;

  /// No description provided for @jobSubmitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get jobSubmitApplication;

  /// No description provided for @jobApplicationSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application submitted successfully!'**
  String get jobApplicationSubmittedSuccess;

  /// No description provided for @jobOpportunitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Opportunities'**
  String get jobOpportunitiesTitle;

  /// No description provided for @jobAllJobs.
  ///
  /// In en, this message translates to:
  /// **'All Jobs'**
  String get jobAllJobs;

  /// No description provided for @jobSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get jobSaved;

  /// No description provided for @jobApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get jobApplied;

  /// No description provided for @jobSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search jobs, companies, or skills...'**
  String get jobSearchHint;

  /// No description provided for @jobRemoteOnly.
  ///
  /// In en, this message translates to:
  /// **'Remote Only'**
  String get jobRemoteOnly;

  /// No description provided for @jobNoApplicationsYet.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get jobNoApplicationsYet;

  /// No description provided for @jobStartApplyingToSee.
  ///
  /// In en, this message translates to:
  /// **'Start applying to jobs to see them here'**
  String get jobStartApplyingToSee;

  /// No description provided for @jobNoJobsFound.
  ///
  /// In en, this message translates to:
  /// **'No jobs found'**
  String get jobNoJobsFound;

  /// No description provided for @jobTryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get jobTryAdjustingFilters;

  /// No description provided for @jobDetailComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Job detail screen coming soon'**
  String get jobDetailComingSoon;

  /// No description provided for @jobFilterJobs.
  ///
  /// In en, this message translates to:
  /// **'Filter Jobs'**
  String get jobFilterJobs;

  /// No description provided for @jobClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get jobClearAll;

  /// No description provided for @jobJobType.
  ///
  /// In en, this message translates to:
  /// **'Job Type'**
  String get jobJobType;

  /// No description provided for @jobExperienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get jobExperienceLevel;

  /// No description provided for @jobApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get jobApplyFilters;

  /// No description provided for @jobSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get jobSortBy;

  /// No description provided for @jobRelevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get jobRelevance;

  /// No description provided for @jobNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get jobNewestFirst;

  /// No description provided for @jobHighestSalary.
  ///
  /// In en, this message translates to:
  /// **'Highest Salary'**
  String get jobHighestSalary;

  /// No description provided for @msgFailedToSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get msgFailedToSendMessage;

  /// No description provided for @msgPhotoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo from Gallery'**
  String get msgPhotoFromGallery;

  /// No description provided for @msgTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get msgTakePhoto;

  /// No description provided for @msgOpensCameraOnMobile.
  ///
  /// In en, this message translates to:
  /// **'Opens camera on mobile devices'**
  String get msgOpensCameraOnMobile;

  /// No description provided for @msgDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get msgDocument;

  /// No description provided for @msgCameraNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Camera not available in browser. Use \"Photo from Gallery\" to select an image.'**
  String get msgCameraNotAvailable;

  /// No description provided for @msgNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get msgNoMessagesYet;

  /// No description provided for @msgSendMessageToStart.
  ///
  /// In en, this message translates to:
  /// **'Send a message to start the conversation'**
  String get msgSendMessageToStart;

  /// No description provided for @msgConversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get msgConversation;

  /// No description provided for @msgOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get msgOnline;

  /// No description provided for @msgConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get msgConnecting;

  /// No description provided for @msgTypeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get msgTypeAMessage;

  /// No description provided for @msgMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get msgMessages;

  /// No description provided for @msgSearchMessages.
  ///
  /// In en, this message translates to:
  /// **'Search Messages'**
  String get msgSearchMessages;

  /// No description provided for @msgSearchConversations.
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get msgSearchConversations;

  /// No description provided for @msgRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get msgRetry;

  /// No description provided for @msgCheckDatabaseSetup.
  ///
  /// In en, this message translates to:
  /// **'Check Database Setup'**
  String get msgCheckDatabaseSetup;

  /// No description provided for @msgDatabaseSetupStatus.
  ///
  /// In en, this message translates to:
  /// **'Database Setup Status'**
  String get msgDatabaseSetupStatus;

  /// No description provided for @msgTestInsertResult.
  ///
  /// In en, this message translates to:
  /// **'Test Insert Result'**
  String get msgTestInsertResult;

  /// No description provided for @msgTestInsert.
  ///
  /// In en, this message translates to:
  /// **'Test Insert'**
  String get msgTestInsert;

  /// No description provided for @msgNoConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get msgNoConversationsYet;

  /// No description provided for @msgFailedToCreateConversation.
  ///
  /// In en, this message translates to:
  /// **'Failed to create conversation'**
  String get msgFailedToCreateConversation;

  /// No description provided for @msgNewConversation.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get msgNewConversation;

  /// No description provided for @msgSearchByNameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email...'**
  String get msgSearchByNameOrEmail;

  /// No description provided for @msgNoUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get msgNoUsersFound;

  /// No description provided for @msgNoUsersMatch.
  ///
  /// In en, this message translates to:
  /// **'No users match \"{query}\"'**
  String msgNoUsersMatch(String query);

  /// No description provided for @progressAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get progressAchievementsTitle;

  /// No description provided for @progressNoAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get progressNoAchievementsYet;

  /// No description provided for @progressClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get progressClose;

  /// No description provided for @progressMyProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progressMyProgress;

  /// No description provided for @progressKeepUpGreatWork.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work!'**
  String get progressKeepUpGreatWork;

  /// No description provided for @progressMakingExcellentProgress.
  ///
  /// In en, this message translates to:
  /// **'You\'re making excellent progress'**
  String get progressMakingExcellentProgress;

  /// No description provided for @progressCoursesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Courses Completed'**
  String get progressCoursesCompleted;

  /// No description provided for @progressStudyTime.
  ///
  /// In en, this message translates to:
  /// **'Study Time'**
  String get progressStudyTime;

  /// No description provided for @progressTotalLearningTime.
  ///
  /// In en, this message translates to:
  /// **'Total learning time'**
  String get progressTotalLearningTime;

  /// No description provided for @progressAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get progressAverageScore;

  /// No description provided for @progressCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get progressCertificates;

  /// No description provided for @progressLearningActivity.
  ///
  /// In en, this message translates to:
  /// **'Learning Activity'**
  String get progressLearningActivity;

  /// No description provided for @progressStudyTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Study Time (minutes)'**
  String get progressStudyTimeMinutes;

  /// No description provided for @progressCourseProgress.
  ///
  /// In en, this message translates to:
  /// **'Course Progress'**
  String get progressCourseProgress;

  /// No description provided for @progressViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get progressViewAll;

  /// No description provided for @progressStudyGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Goals'**
  String get progressStudyGoalsTitle;

  /// No description provided for @progressYourGoals.
  ///
  /// In en, this message translates to:
  /// **'Your Goals'**
  String get progressYourGoals;

  /// No description provided for @progressCreateGoalComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Create goal coming soon'**
  String get progressCreateGoalComingSoon;

  /// No description provided for @progressNewGoal.
  ///
  /// In en, this message translates to:
  /// **'New Goal'**
  String get progressNewGoal;

  /// No description provided for @instApplicantDetails.
  ///
  /// In en, this message translates to:
  /// **'Applicant Details'**
  String get instApplicantDetails;

  /// No description provided for @instApplicantMarkUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Mark as Under Review'**
  String get instApplicantMarkUnderReview;

  /// No description provided for @instApplicantAcceptApplication.
  ///
  /// In en, this message translates to:
  /// **'Accept Application'**
  String get instApplicantAcceptApplication;

  /// No description provided for @instApplicantRejectApplication.
  ///
  /// In en, this message translates to:
  /// **'Reject Application'**
  String get instApplicantRejectApplication;

  /// No description provided for @instApplicantApplicationStatus.
  ///
  /// In en, this message translates to:
  /// **'Application Status'**
  String get instApplicantApplicationStatus;

  /// No description provided for @instApplicantStudentInfo.
  ///
  /// In en, this message translates to:
  /// **'Student Information'**
  String get instApplicantStudentInfo;

  /// No description provided for @instApplicantFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get instApplicantFullName;

  /// No description provided for @instApplicantEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get instApplicantEmail;

  /// No description provided for @instApplicantPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get instApplicantPhone;

  /// No description provided for @instApplicantPreviousSchool.
  ///
  /// In en, this message translates to:
  /// **'Previous School'**
  String get instApplicantPreviousSchool;

  /// No description provided for @instApplicantGpa.
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get instApplicantGpa;

  /// No description provided for @instApplicantProgramApplied.
  ///
  /// In en, this message translates to:
  /// **'Program Applied'**
  String get instApplicantProgramApplied;

  /// No description provided for @instApplicantSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get instApplicantSubmitted;

  /// No description provided for @instApplicantStatementOfPurpose.
  ///
  /// In en, this message translates to:
  /// **'Statement of Purpose'**
  String get instApplicantStatementOfPurpose;

  /// No description provided for @instApplicantDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get instApplicantDocuments;

  /// No description provided for @instApplicantDocViewerComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Document viewer coming soon'**
  String get instApplicantDocViewerComingSoon;

  /// No description provided for @instApplicantDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {name}...'**
  String instApplicantDownloading(String name);

  /// No description provided for @instApplicantReviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Review Information'**
  String get instApplicantReviewInfo;

  /// No description provided for @instApplicantReviewedBy.
  ///
  /// In en, this message translates to:
  /// **'Reviewed By'**
  String get instApplicantReviewedBy;

  /// No description provided for @instApplicantUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get instApplicantUnknown;

  /// No description provided for @instApplicantReviewDate.
  ///
  /// In en, this message translates to:
  /// **'Review Date'**
  String get instApplicantReviewDate;

  /// No description provided for @instApplicantReviewNotes.
  ///
  /// In en, this message translates to:
  /// **'Review Notes'**
  String get instApplicantReviewNotes;

  /// No description provided for @instApplicantReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get instApplicantReject;

  /// No description provided for @instApplicantAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get instApplicantAccept;

  /// No description provided for @instApplicantStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get instApplicantStatusPending;

  /// No description provided for @instApplicantStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get instApplicantStatusUnderReview;

  /// No description provided for @instApplicantStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get instApplicantStatusAccepted;

  /// No description provided for @instApplicantStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get instApplicantStatusRejected;

  /// No description provided for @instApplicantDocTranscript.
  ///
  /// In en, this message translates to:
  /// **'Academic Transcript'**
  String get instApplicantDocTranscript;

  /// No description provided for @instApplicantDocId.
  ///
  /// In en, this message translates to:
  /// **'ID Document'**
  String get instApplicantDocId;

  /// No description provided for @instApplicantDocPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get instApplicantDocPhoto;

  /// No description provided for @instApplicantDocRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Letter'**
  String get instApplicantDocRecommendation;

  /// No description provided for @instApplicantDocGeneric.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get instApplicantDocGeneric;

  /// No description provided for @instApplicantRecommendationLetters.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Letters'**
  String get instApplicantRecommendationLetters;

  /// No description provided for @instApplicantReceivedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} received'**
  String instApplicantReceivedCount(int count);

  /// No description provided for @instApplicantNoRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No Recommendation Letters Yet'**
  String get instApplicantNoRecommendations;

  /// No description provided for @instApplicantNoRecommendationsDesc.
  ///
  /// In en, this message translates to:
  /// **'The applicant has not submitted any recommendation letters with this application.'**
  String get instApplicantNoRecommendationsDesc;

  /// No description provided for @instApplicantType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get instApplicantType;

  /// No description provided for @instApplicantLetterPreview.
  ///
  /// In en, this message translates to:
  /// **'Letter Preview'**
  String get instApplicantLetterPreview;

  /// No description provided for @instApplicantClickViewFull.
  ///
  /// In en, this message translates to:
  /// **'Click \"View Full\" to open the complete recommendation letter.'**
  String get instApplicantClickViewFull;

  /// No description provided for @instApplicantLetterPreviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Letter content preview not available.'**
  String get instApplicantLetterPreviewUnavailable;

  /// No description provided for @instApplicantClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get instApplicantClose;

  /// No description provided for @instApplicantViewFull.
  ///
  /// In en, this message translates to:
  /// **'View Full'**
  String get instApplicantViewFull;

  /// No description provided for @instApplicantDownloadNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Download not available'**
  String get instApplicantDownloadNotAvailable;

  /// No description provided for @instApplicantOpeningLetter.
  ///
  /// In en, this message translates to:
  /// **'Opening letter: {url}'**
  String instApplicantOpeningLetter(String url);

  /// No description provided for @instApplicantMarkedUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Marked as Under Review'**
  String get instApplicantMarkedUnderReview;

  /// No description provided for @instApplicantFailedUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status'**
  String get instApplicantFailedUpdateStatus;

  /// No description provided for @instApplicantErrorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error updating status: {error}'**
  String instApplicantErrorUpdatingStatus(String error);

  /// No description provided for @instApplicantConfirmAccept.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this application?'**
  String get instApplicantConfirmAccept;

  /// No description provided for @instApplicantConfirmReject.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this application?'**
  String get instApplicantConfirmReject;

  /// No description provided for @instApplicantReviewNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Review Notes (Optional)'**
  String get instApplicantReviewNotesOptional;

  /// No description provided for @instApplicantReviewNotesRequired.
  ///
  /// In en, this message translates to:
  /// **'Review Notes (Required)'**
  String get instApplicantReviewNotesRequired;

  /// No description provided for @instApplicantAddComments.
  ///
  /// In en, this message translates to:
  /// **'Add comments about your decision...'**
  String get instApplicantAddComments;

  /// No description provided for @instApplicantCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get instApplicantCancel;

  /// No description provided for @instApplicantNotesRequiredRejection.
  ///
  /// In en, this message translates to:
  /// **'Review notes are required for rejection'**
  String get instApplicantNotesRequiredRejection;

  /// No description provided for @instApplicantAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application accepted successfully'**
  String get instApplicantAcceptedSuccess;

  /// No description provided for @instApplicantRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application rejected'**
  String get instApplicantRejectedSuccess;

  /// No description provided for @instApplicantErrorProcessingReview.
  ///
  /// In en, this message translates to:
  /// **'Error processing review: {error}'**
  String instApplicantErrorProcessingReview(String error);

  /// No description provided for @instApplicantReceived.
  ///
  /// In en, this message translates to:
  /// **'RECEIVED'**
  String get instApplicantReceived;

  /// No description provided for @instApplicantViewLetter.
  ///
  /// In en, this message translates to:
  /// **'View Letter'**
  String get instApplicantViewLetter;

  /// No description provided for @instApplicantDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get instApplicantDownload;

  /// No description provided for @instApplicantRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get instApplicantRetry;

  /// No description provided for @instApplicantSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search applicants...'**
  String get instApplicantSearchHint;

  /// No description provided for @instApplicantTabAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String instApplicantTabAll(int count);

  /// No description provided for @instApplicantTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending ({count})'**
  String instApplicantTabPending(int count);

  /// No description provided for @instApplicantTabUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review ({count})'**
  String instApplicantTabUnderReview(int count);

  /// No description provided for @instApplicantTabAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted ({count})'**
  String instApplicantTabAccepted(int count);

  /// No description provided for @instApplicantTabRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected ({count})'**
  String instApplicantTabRejected(int count);

  /// No description provided for @instApplicantLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading applicants...'**
  String get instApplicantLoading;

  /// No description provided for @instApplicantNoApplicantsFound.
  ///
  /// In en, this message translates to:
  /// **'No Applicants Found'**
  String get instApplicantNoApplicantsFound;

  /// No description provided for @instApplicantTryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search'**
  String get instApplicantTryAdjustingSearch;

  /// No description provided for @instApplicantNoAppsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No applications in this category'**
  String get instApplicantNoAppsInCategory;

  /// No description provided for @instApplicantGpaValue.
  ///
  /// In en, this message translates to:
  /// **'GPA: {gpa}'**
  String instApplicantGpaValue(String gpa);

  /// No description provided for @instApplicantSubmittedDate.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String instApplicantSubmittedDate(String date);

  /// No description provided for @instApplicantChipPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get instApplicantChipPending;

  /// No description provided for @instApplicantChipReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get instApplicantChipReviewing;

  /// No description provided for @instCourseEditCourse.
  ///
  /// In en, this message translates to:
  /// **'Edit Course'**
  String get instCourseEditCourse;

  /// No description provided for @instCourseCreateCourse.
  ///
  /// In en, this message translates to:
  /// **'Create Course'**
  String get instCourseCreateCourse;

  /// No description provided for @instCourseBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get instCourseBasicInfo;

  /// No description provided for @instCourseTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Course Title *'**
  String get instCourseTitleLabel;

  /// No description provided for @instCourseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Introduction to Programming'**
  String get instCourseTitleHint;

  /// No description provided for @instCourseTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get instCourseTitleRequired;

  /// No description provided for @instCourseTitleMinLength.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get instCourseTitleMinLength;

  /// No description provided for @instCourseTitleMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Title must be less than 200 characters'**
  String get instCourseTitleMaxLength;

  /// No description provided for @instCourseDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get instCourseDescriptionLabel;

  /// No description provided for @instCourseDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what students will learn...'**
  String get instCourseDescriptionHint;

  /// No description provided for @instCourseDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get instCourseDescriptionRequired;

  /// No description provided for @instCourseDescriptionMinLength.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get instCourseDescriptionMinLength;

  /// No description provided for @instCourseCourseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get instCourseCourseDetails;

  /// No description provided for @instCourseCourseType.
  ///
  /// In en, this message translates to:
  /// **'Course Type *'**
  String get instCourseCourseType;

  /// No description provided for @instCourseDifficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty Level *'**
  String get instCourseDifficultyLevel;

  /// No description provided for @instCourseDurationHours.
  ///
  /// In en, this message translates to:
  /// **'Duration (hours)'**
  String get instCourseDurationHours;

  /// No description provided for @instCourseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get instCourseCategory;

  /// No description provided for @instCourseCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get instCourseCategoryHint;

  /// No description provided for @instCoursePricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get instCoursePricing;

  /// No description provided for @instCoursePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price *'**
  String get instCoursePriceLabel;

  /// No description provided for @instCoursePriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get instCoursePriceRequired;

  /// No description provided for @instCourseInvalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get instCourseInvalidPrice;

  /// No description provided for @instCourseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get instCourseCurrency;

  /// No description provided for @instCourseMaxStudents.
  ///
  /// In en, this message translates to:
  /// **'Max Students (optional)'**
  String get instCourseMaxStudents;

  /// No description provided for @instCourseMaxStudentsHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for unlimited'**
  String get instCourseMaxStudentsHint;

  /// No description provided for @instCourseMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get instCourseMedia;

  /// No description provided for @instCourseThumbnailUrl.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail URL (optional)'**
  String get instCourseThumbnailUrl;

  /// No description provided for @instCourseTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get instCourseTags;

  /// No description provided for @instCourseAddTagHint.
  ///
  /// In en, this message translates to:
  /// **'Add tag (e.g., programming, python)'**
  String get instCourseAddTagHint;

  /// No description provided for @instCourseLearningOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Learning Outcomes'**
  String get instCourseLearningOutcomes;

  /// No description provided for @instCourseOutcomeHint.
  ///
  /// In en, this message translates to:
  /// **'What will students learn?'**
  String get instCourseOutcomeHint;

  /// No description provided for @instCoursePrerequisites.
  ///
  /// In en, this message translates to:
  /// **'Prerequisites'**
  String get instCoursePrerequisites;

  /// No description provided for @instCoursePrerequisiteHint.
  ///
  /// In en, this message translates to:
  /// **'What do students need to know?'**
  String get instCoursePrerequisiteHint;

  /// No description provided for @instCourseUpdateCourse.
  ///
  /// In en, this message translates to:
  /// **'Update Course'**
  String get instCourseUpdateCourse;

  /// No description provided for @instCourseCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Course created successfully!'**
  String get instCourseCreatedSuccess;

  /// No description provided for @instCourseUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Course updated successfully!'**
  String get instCourseUpdatedSuccess;

  /// No description provided for @instCourseFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save course. Please try again.'**
  String get instCourseFailedToSave;

  /// No description provided for @instCourseCourseRoster.
  ///
  /// In en, this message translates to:
  /// **'Course Roster'**
  String get instCourseCourseRoster;

  /// No description provided for @instCourseRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get instCourseRefresh;

  /// No description provided for @instCourseRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get instCourseRetry;

  /// No description provided for @instCourseNoEnrolledStudents.
  ///
  /// In en, this message translates to:
  /// **'No enrolled students yet'**
  String get instCourseNoEnrolledStudents;

  /// No description provided for @instCourseApprovedStudentsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Students with approved permissions will appear here'**
  String get instCourseApprovedStudentsAppearHere;

  /// No description provided for @instCourseEnrolledStudents.
  ///
  /// In en, this message translates to:
  /// **'Enrolled Students'**
  String get instCourseEnrolledStudents;

  /// No description provided for @instCourseMaxCapacity.
  ///
  /// In en, this message translates to:
  /// **'Max Capacity'**
  String get instCourseMaxCapacity;

  /// No description provided for @instCourseEnrolledDate.
  ///
  /// In en, this message translates to:
  /// **'Enrolled: {date}'**
  String instCourseEnrolledDate(String date);

  /// No description provided for @instCourseEnrollmentPermissions.
  ///
  /// In en, this message translates to:
  /// **'Enrollment Permissions'**
  String get instCourseEnrollmentPermissions;

  /// No description provided for @instCoursePendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get instCoursePendingRequests;

  /// No description provided for @instCourseApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get instCourseApproved;

  /// No description provided for @instCourseAllStudents.
  ///
  /// In en, this message translates to:
  /// **'All Students'**
  String get instCourseAllStudents;

  /// No description provided for @instCourseGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get instCourseGrantPermission;

  /// No description provided for @instCourseSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one student'**
  String get instCourseSelectAtLeastOne;

  /// No description provided for @instCourseGrantedPermission.
  ///
  /// In en, this message translates to:
  /// **'Granted permission to {count} student(s)'**
  String instCourseGrantedPermission(int count);

  /// No description provided for @instCourseFailedGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Failed to grant permission to {count} student(s)'**
  String instCourseFailedGrantPermission(int count);

  /// No description provided for @instCourseGrantEnrollmentPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Enrollment Permission'**
  String get instCourseGrantEnrollmentPermission;

  /// No description provided for @instCourseSelectStudentsGrant.
  ///
  /// In en, this message translates to:
  /// **'Select students to grant access to this course'**
  String get instCourseSelectStudentsGrant;

  /// No description provided for @instCourseSearchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search students...'**
  String get instCourseSearchStudents;

  /// No description provided for @instCourseSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String instCourseSelectedCount(int count);

  /// No description provided for @instCourseClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get instCourseClear;

  /// No description provided for @instCourseCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get instCourseCancel;

  /// No description provided for @instCourseSelectStudents.
  ///
  /// In en, this message translates to:
  /// **'Select Students'**
  String get instCourseSelectStudents;

  /// No description provided for @instCourseGrantToStudents.
  ///
  /// In en, this message translates to:
  /// **'Grant to {count} Student(s)'**
  String instCourseGrantToStudents(int count);

  /// No description provided for @instCourseNoStudentsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No students available'**
  String get instCourseNoStudentsAvailable;

  /// No description provided for @instCourseAllStudentsHavePermissions.
  ///
  /// In en, this message translates to:
  /// **'All admitted students already have permissions'**
  String get instCourseAllStudentsHavePermissions;

  /// No description provided for @instCourseNoMatchingStudents.
  ///
  /// In en, this message translates to:
  /// **'No matching students'**
  String get instCourseNoMatchingStudents;

  /// No description provided for @instCourseNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get instCourseNoPendingRequests;

  /// No description provided for @instCourseStudentsCanRequest.
  ///
  /// In en, this message translates to:
  /// **'Students can request enrollment permission'**
  String get instCourseStudentsCanRequest;

  /// No description provided for @instCourseMessage.
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get instCourseMessage;

  /// No description provided for @instCourseRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested: {date}'**
  String instCourseRequested(String date);

  /// No description provided for @instCourseDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get instCourseDeny;

  /// No description provided for @instCourseApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get instCourseApprove;

  /// No description provided for @instCourseApprovedStudent.
  ///
  /// In en, this message translates to:
  /// **'Approved {name}'**
  String instCourseApprovedStudent(String name);

  /// No description provided for @instCourseFailedToApprove.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve'**
  String get instCourseFailedToApprove;

  /// No description provided for @instCourseDenyPermissionRequest.
  ///
  /// In en, this message translates to:
  /// **'Deny Permission Request'**
  String get instCourseDenyPermissionRequest;

  /// No description provided for @instCourseDenyStudent.
  ///
  /// In en, this message translates to:
  /// **'Deny {name}?'**
  String instCourseDenyStudent(String name);

  /// No description provided for @instCourseReasonForDenial.
  ///
  /// In en, this message translates to:
  /// **'Reason for denial'**
  String get instCourseReasonForDenial;

  /// No description provided for @instCourseEnterReason.
  ///
  /// In en, this message translates to:
  /// **'Enter reason...'**
  String get instCourseEnterReason;

  /// No description provided for @instCoursePleaseProvideReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason'**
  String get instCoursePleaseProvideReason;

  /// No description provided for @instCourseDeniedStudent.
  ///
  /// In en, this message translates to:
  /// **'Denied {name}'**
  String instCourseDeniedStudent(String name);

  /// No description provided for @instCourseNoApprovedPermissions.
  ///
  /// In en, this message translates to:
  /// **'No approved permissions yet'**
  String get instCourseNoApprovedPermissions;

  /// No description provided for @instCourseGrantToAllowEnroll.
  ///
  /// In en, this message translates to:
  /// **'Grant permissions to allow students to enroll'**
  String get instCourseGrantToAllowEnroll;

  /// No description provided for @instCourseRevokePermission.
  ///
  /// In en, this message translates to:
  /// **'Revoke Permission'**
  String get instCourseRevokePermission;

  /// No description provided for @instCourseRevokePermissionFor.
  ///
  /// In en, this message translates to:
  /// **'Revoke permission for {name}?'**
  String instCourseRevokePermissionFor(String name);

  /// No description provided for @instCourseReasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get instCourseReasonOptional;

  /// No description provided for @instCourseRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get instCourseRevoke;

  /// No description provided for @instCourseRevokedPermissionFor.
  ///
  /// In en, this message translates to:
  /// **'Revoked permission for {name}'**
  String instCourseRevokedPermissionFor(String name);

  /// No description provided for @instCourseNoAdmittedStudents.
  ///
  /// In en, this message translates to:
  /// **'No admitted students'**
  String get instCourseNoAdmittedStudents;

  /// No description provided for @instCourseAcceptedStudentsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Students with accepted applications will appear here'**
  String get instCourseAcceptedStudentsAppearHere;

  /// No description provided for @instCourseRequestPending.
  ///
  /// In en, this message translates to:
  /// **'Request Pending'**
  String get instCourseRequestPending;

  /// No description provided for @instCourseAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Access Granted'**
  String get instCourseAccessGranted;

  /// No description provided for @instCourseDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get instCourseDenied;

  /// No description provided for @instCourseRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get instCourseRevoked;

  /// No description provided for @instCourseGrantAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get instCourseGrantAccess;

  /// No description provided for @instCourseGrantStudentPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant {name} permission to enroll in this course?'**
  String instCourseGrantStudentPermission(String name);

  /// No description provided for @instCourseNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get instCourseNotesOptional;

  /// No description provided for @instCourseAddNotes.
  ///
  /// In en, this message translates to:
  /// **'Add any notes...'**
  String get instCourseAddNotes;

  /// No description provided for @instCourseGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get instCourseGrant;

  /// No description provided for @instCourseGrantedPermissionTo.
  ///
  /// In en, this message translates to:
  /// **'Granted permission to {name}'**
  String instCourseGrantedPermissionTo(String name);

  /// No description provided for @instCourseFailedToGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Failed to grant permission'**
  String get instCourseFailedToGrantPermission;

  /// No description provided for @instCourseRequestApproved.
  ///
  /// In en, this message translates to:
  /// **'Request approved'**
  String get instCourseRequestApproved;

  /// No description provided for @instCourseFailedToApproveRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve request'**
  String get instCourseFailedToApproveRequest;

  /// No description provided for @instCourseContentBuilder.
  ///
  /// In en, this message translates to:
  /// **'Course Content Builder'**
  String get instCourseContentBuilder;

  /// No description provided for @instCoursePreviewCourse.
  ///
  /// In en, this message translates to:
  /// **'Preview Course'**
  String get instCoursePreviewCourse;

  /// No description provided for @instCourseAddModule.
  ///
  /// In en, this message translates to:
  /// **'Add Module'**
  String get instCourseAddModule;

  /// No description provided for @instCourseCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get instCourseCourseTitle;

  /// No description provided for @instCourseEditInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Info'**
  String get instCourseEditInfo;

  /// No description provided for @instCourseCourseModules.
  ///
  /// In en, this message translates to:
  /// **'Course Modules'**
  String get instCourseCourseModules;

  /// No description provided for @instCourseNoModulesYet.
  ///
  /// In en, this message translates to:
  /// **'No modules yet'**
  String get instCourseNoModulesYet;

  /// No description provided for @instCourseStartBuildingModules.
  ///
  /// In en, this message translates to:
  /// **'Start building your course by adding modules'**
  String get instCourseStartBuildingModules;

  /// No description provided for @instCourseModuleIndex.
  ///
  /// In en, this message translates to:
  /// **'Module {index}'**
  String instCourseModuleIndex(int index);

  /// No description provided for @instCourseLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String instCourseLessonsCount(int count);

  /// No description provided for @instCourseEditModule.
  ///
  /// In en, this message translates to:
  /// **'Edit Module'**
  String get instCourseEditModule;

  /// No description provided for @instCourseDeleteModule.
  ///
  /// In en, this message translates to:
  /// **'Delete Module'**
  String get instCourseDeleteModule;

  /// No description provided for @instCourseLearningObjectives.
  ///
  /// In en, this message translates to:
  /// **'Learning Objectives:'**
  String get instCourseLearningObjectives;

  /// No description provided for @instCourseLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get instCourseLessons;

  /// No description provided for @instCourseAddLesson.
  ///
  /// In en, this message translates to:
  /// **'Add Lesson'**
  String get instCourseAddLesson;

  /// No description provided for @instCourseNoLessonsInModule.
  ///
  /// In en, this message translates to:
  /// **'No lessons in this module'**
  String get instCourseNoLessonsInModule;

  /// No description provided for @instCourseEditLesson.
  ///
  /// In en, this message translates to:
  /// **'Edit Lesson'**
  String get instCourseEditLesson;

  /// No description provided for @instCourseDeleteLesson.
  ///
  /// In en, this message translates to:
  /// **'Delete Lesson'**
  String get instCourseDeleteLesson;

  /// No description provided for @instCourseError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get instCourseError;

  /// No description provided for @instCourseModuleCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Module \"{title}\" created successfully'**
  String instCourseModuleCreatedSuccess(String title);

  /// No description provided for @instCourseModuleUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Module \"{title}\" updated successfully'**
  String instCourseModuleUpdatedSuccess(String title);

  /// No description provided for @instCourseAddNewLesson.
  ///
  /// In en, this message translates to:
  /// **'Add New Lesson'**
  String get instCourseAddNewLesson;

  /// No description provided for @instCourseLessonType.
  ///
  /// In en, this message translates to:
  /// **'Lesson Type'**
  String get instCourseLessonType;

  /// No description provided for @instCourseLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson Title'**
  String get instCourseLessonTitle;

  /// No description provided for @instCoursePleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get instCoursePleaseEnterTitle;

  /// No description provided for @instCourseDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get instCourseDescription;

  /// No description provided for @instCourseLessonCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Lesson created successfully'**
  String get instCourseLessonCreatedSuccess;

  /// No description provided for @instCourseCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get instCourseCreate;

  /// No description provided for @instCourseDeleteModuleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this module? This will also delete all lessons in the module.'**
  String get instCourseDeleteModuleConfirm;

  /// No description provided for @instCourseDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get instCourseDelete;

  /// No description provided for @instCourseModuleDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Module deleted successfully'**
  String get instCourseModuleDeletedSuccess;

  /// No description provided for @instCourseDeleteLessonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this lesson?'**
  String get instCourseDeleteLessonConfirm;

  /// No description provided for @instCourseLessonDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Lesson deleted successfully'**
  String get instCourseLessonDeletedSuccess;

  /// No description provided for @instCourseEditCourseInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Course Info'**
  String get instCourseEditCourseInfo;

  /// No description provided for @instCourseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter course title'**
  String get instCourseEnterTitle;

  /// No description provided for @instCourseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter course description'**
  String get instCourseEnterDescription;

  /// No description provided for @instCourseLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get instCourseLevel;

  /// No description provided for @instCourseInfoUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Course info updated successfully'**
  String get instCourseInfoUpdatedSuccess;

  /// No description provided for @instCourseSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get instCourseSaving;

  /// No description provided for @instCourseSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get instCourseSaveChanges;

  /// No description provided for @instProgramCreateProgram.
  ///
  /// In en, this message translates to:
  /// **'Create Program'**
  String get instProgramCreateProgram;

  /// No description provided for @instProgramNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Program Name *'**
  String get instProgramNameLabel;

  /// No description provided for @instProgramNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Bachelor of Computer Science'**
  String get instProgramNameHint;

  /// No description provided for @instProgramDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get instProgramDescriptionLabel;

  /// No description provided for @instProgramDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the program...'**
  String get instProgramDescriptionHint;

  /// No description provided for @instProgramCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get instProgramCategoryLabel;

  /// No description provided for @instProgramLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level *'**
  String get instProgramLevelLabel;

  /// No description provided for @instProgramDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get instProgramDuration;

  /// No description provided for @instProgramFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Program Fee (USD) *'**
  String get instProgramFeeLabel;

  /// No description provided for @instProgramMaxStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum Students *'**
  String get instProgramMaxStudentsLabel;

  /// No description provided for @instProgramMaxStudentsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 100'**
  String get instProgramMaxStudentsHint;

  /// No description provided for @instProgramStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get instProgramStartDate;

  /// No description provided for @instProgramApplicationDeadline.
  ///
  /// In en, this message translates to:
  /// **'Application Deadline'**
  String get instProgramApplicationDeadline;

  /// No description provided for @instProgramRequirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get instProgramRequirements;

  /// No description provided for @instProgramAddRequirementHint.
  ///
  /// In en, this message translates to:
  /// **'Add a requirement...'**
  String get instProgramAddRequirementHint;

  /// No description provided for @instProgramAddAtLeastOneRequirement.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one requirement'**
  String get instProgramAddAtLeastOneRequirement;

  /// No description provided for @instProgramDeadlineBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Application deadline must be before start date'**
  String get instProgramDeadlineBeforeStart;

  /// No description provided for @instProgramCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Program created successfully!'**
  String get instProgramCreatedSuccess;

  /// No description provided for @instProgramFailedToCreate.
  ///
  /// In en, this message translates to:
  /// **'Failed to create program'**
  String get instProgramFailedToCreate;

  /// No description provided for @instProgramErrorCreating.
  ///
  /// In en, this message translates to:
  /// **'Error creating program: {error}'**
  String instProgramErrorCreating(String error);

  /// No description provided for @instProgramDetails.
  ///
  /// In en, this message translates to:
  /// **'Program Details'**
  String get instProgramDetails;

  /// No description provided for @instProgramBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get instProgramBack;

  /// No description provided for @instProgramEditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit feature coming soon'**
  String get instProgramEditComingSoon;

  /// No description provided for @instProgramEditProgram.
  ///
  /// In en, this message translates to:
  /// **'Edit Program'**
  String get instProgramEditProgram;

  /// No description provided for @instProgramDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get instProgramDeactivate;

  /// No description provided for @instProgramActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get instProgramActivate;

  /// No description provided for @instProgramDeleteProgram.
  ///
  /// In en, this message translates to:
  /// **'Delete Program'**
  String get instProgramDeleteProgram;

  /// No description provided for @instProgramInactiveMessage.
  ///
  /// In en, this message translates to:
  /// **'This program is currently inactive and not accepting applications'**
  String get instProgramInactiveMessage;

  /// No description provided for @instProgramEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get instProgramEnrolled;

  /// No description provided for @instProgramAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get instProgramAvailable;

  /// No description provided for @instProgramFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get instProgramFee;

  /// No description provided for @instProgramDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get instProgramDescription;

  /// No description provided for @instProgramProgramDetails.
  ///
  /// In en, this message translates to:
  /// **'Program Details'**
  String get instProgramProgramDetails;

  /// No description provided for @instProgramCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get instProgramCategory;

  /// No description provided for @instProgramInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get instProgramInstitution;

  /// No description provided for @instProgramMaxStudents.
  ///
  /// In en, this message translates to:
  /// **'Maximum Students'**
  String get instProgramMaxStudents;

  /// No description provided for @instProgramEnrollmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Enrollment Status'**
  String get instProgramEnrollmentStatus;

  /// No description provided for @instProgramFillRate.
  ///
  /// In en, this message translates to:
  /// **'Fill Rate'**
  String get instProgramFillRate;

  /// No description provided for @instProgramIsFull.
  ///
  /// In en, this message translates to:
  /// **'Program is full'**
  String get instProgramIsFull;

  /// No description provided for @instProgramSlotsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} slots remaining'**
  String instProgramSlotsRemaining(int count);

  /// No description provided for @instProgramDeactivateQuestion.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Program?'**
  String get instProgramDeactivateQuestion;

  /// No description provided for @instProgramActivateQuestion.
  ///
  /// In en, this message translates to:
  /// **'Activate Program?'**
  String get instProgramActivateQuestion;

  /// No description provided for @instProgramStopAccepting.
  ///
  /// In en, this message translates to:
  /// **'This program will stop accepting new applications.'**
  String get instProgramStopAccepting;

  /// No description provided for @instProgramStartAccepting.
  ///
  /// In en, this message translates to:
  /// **'This program will start accepting new applications.'**
  String get instProgramStartAccepting;

  /// No description provided for @instProgramCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get instProgramCancel;

  /// No description provided for @instProgramConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get instProgramConfirm;

  /// No description provided for @instProgramActivated.
  ///
  /// In en, this message translates to:
  /// **'Program activated'**
  String get instProgramActivated;

  /// No description provided for @instProgramDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Program deactivated'**
  String get instProgramDeactivated;

  /// No description provided for @instProgramErrorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error updating program status: {error}'**
  String instProgramErrorUpdatingStatus(String error);

  /// No description provided for @instProgramDeleteProgramQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Program?'**
  String get instProgramDeleteProgramQuestion;

  /// No description provided for @instProgramDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All data associated with this program will be permanently deleted.'**
  String get instProgramDeleteConfirm;

  /// No description provided for @instProgramDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get instProgramDelete;

  /// No description provided for @instProgramDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Program deleted successfully'**
  String get instProgramDeletedSuccess;

  /// No description provided for @instProgramFailedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete program'**
  String get instProgramFailedToDelete;

  /// No description provided for @instProgramErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting program: {error}'**
  String instProgramErrorDeleting(String error);

  /// No description provided for @instProgramPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get instProgramPrograms;

  /// No description provided for @instProgramRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get instProgramRetry;

  /// No description provided for @instProgramLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading programs...'**
  String get instProgramLoading;

  /// No description provided for @instProgramActiveOnly.
  ///
  /// In en, this message translates to:
  /// **'Active Only'**
  String get instProgramActiveOnly;

  /// No description provided for @instProgramShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get instProgramShowAll;

  /// No description provided for @instProgramSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search programs...'**
  String get instProgramSearchHint;

  /// No description provided for @instProgramNewProgram.
  ///
  /// In en, this message translates to:
  /// **'New Program'**
  String get instProgramNewProgram;

  /// No description provided for @instProgramNoProgramsFound.
  ///
  /// In en, this message translates to:
  /// **'No Programs Found'**
  String get instProgramNoProgramsFound;

  /// No description provided for @instProgramTryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search'**
  String get instProgramTryAdjustingSearch;

  /// No description provided for @instProgramCreateFirstProgram.
  ///
  /// In en, this message translates to:
  /// **'Create your first program'**
  String get instProgramCreateFirstProgram;

  /// No description provided for @instProgramInactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get instProgramInactive;

  /// No description provided for @instProgramEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Enrollment'**
  String get instProgramEnrollment;

  /// No description provided for @instProgramFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get instProgramFull;

  /// No description provided for @instProgramSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} slots available'**
  String instProgramSlotsAvailable(int count);

  /// No description provided for @instCounselorSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search counselors...'**
  String get instCounselorSearchHint;

  /// No description provided for @instCounselorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get instCounselorRetry;

  /// No description provided for @instCounselorNoCounselorsFound.
  ///
  /// In en, this message translates to:
  /// **'No Counselors Found'**
  String get instCounselorNoCounselorsFound;

  /// No description provided for @instCounselorNoMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No counselors match your search'**
  String get instCounselorNoMatchSearch;

  /// No description provided for @instCounselorAddToInstitution.
  ///
  /// In en, this message translates to:
  /// **'Add counselors to your institution'**
  String get instCounselorAddToInstitution;

  /// No description provided for @instCounselorPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String instCounselorPageOf(int current, int total);

  /// No description provided for @instCounselorCounselingOverview.
  ///
  /// In en, this message translates to:
  /// **'Counseling Overview'**
  String get instCounselorCounselingOverview;

  /// No description provided for @instCounselorCounselors.
  ///
  /// In en, this message translates to:
  /// **'Counselors'**
  String get instCounselorCounselors;

  /// No description provided for @instCounselorStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get instCounselorStudents;

  /// No description provided for @instCounselorSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get instCounselorSessions;

  /// No description provided for @instCounselorCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get instCounselorCompleted;

  /// No description provided for @instCounselorUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get instCounselorUpcoming;

  /// No description provided for @instCounselorAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get instCounselorAvgRating;

  /// No description provided for @instCounselorStudentAssigned.
  ///
  /// In en, this message translates to:
  /// **'Student assigned successfully'**
  String get instCounselorStudentAssigned;

  /// No description provided for @instCounselorAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get instCounselorAssign;

  /// No description provided for @instCounselorTotalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get instCounselorTotalSessions;

  /// No description provided for @instCounselorAssignStudents.
  ///
  /// In en, this message translates to:
  /// **'Assign Students'**
  String get instCounselorAssignStudents;

  /// No description provided for @instCounselorAssignStudentTo.
  ///
  /// In en, this message translates to:
  /// **'Assign Student to {name}'**
  String instCounselorAssignStudentTo(String name);

  /// No description provided for @instCounselorSearchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search students...'**
  String get instCounselorSearchStudents;

  /// No description provided for @instCounselorNoStudentsFound.
  ///
  /// In en, this message translates to:
  /// **'No students found'**
  String get instCounselorNoStudentsFound;

  /// No description provided for @instCounselorCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get instCounselorCancel;

  /// No description provided for @studentCounselingBookSession.
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get studentCounselingBookSession;

  /// No description provided for @studentCounselingSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get studentCounselingSelectDate;

  /// No description provided for @studentCounselingSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get studentCounselingSelectTime;

  /// No description provided for @studentCounselingSessionType.
  ///
  /// In en, this message translates to:
  /// **'Session Type'**
  String get studentCounselingSessionType;

  /// No description provided for @studentCounselingTopicOptional.
  ///
  /// In en, this message translates to:
  /// **'Topic (Optional)'**
  String get studentCounselingTopicOptional;

  /// No description provided for @studentCounselingTopicHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to discuss?'**
  String get studentCounselingTopicHint;

  /// No description provided for @studentCounselingDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional Details (Optional)'**
  String get studentCounselingDetailsOptional;

  /// No description provided for @studentCounselingDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional information for your counselor...'**
  String get studentCounselingDetailsHint;

  /// No description provided for @studentCounselingSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get studentCounselingSessionSummary;

  /// No description provided for @studentCounselingCounselor.
  ///
  /// In en, this message translates to:
  /// **'Counselor'**
  String get studentCounselingCounselor;

  /// No description provided for @studentCounselingDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get studentCounselingDate;

  /// No description provided for @studentCounselingTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get studentCounselingTime;

  /// No description provided for @studentCounselingType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get studentCounselingType;

  /// No description provided for @studentCounselingTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get studentCounselingTopic;

  /// No description provided for @studentCounselingBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Session booked successfully!'**
  String get studentCounselingBookedSuccess;

  /// No description provided for @studentCounselingBookFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to book session'**
  String get studentCounselingBookFailed;

  /// No description provided for @studentCounselingUpcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming ({count})'**
  String studentCounselingUpcomingTab(int count);

  /// No description provided for @studentCounselingPastTab.
  ///
  /// In en, this message translates to:
  /// **'Past ({count})'**
  String studentCounselingPastTab(int count);

  /// No description provided for @studentCounselingContactAdmin.
  ///
  /// In en, this message translates to:
  /// **'Please contact your institution administrator for counselor assignment.'**
  String get studentCounselingContactAdmin;

  /// No description provided for @studentCounselingTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get studentCounselingTotal;

  /// No description provided for @studentCounselingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get studentCounselingCompleted;

  /// No description provided for @studentCounselingUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get studentCounselingUpcoming;

  /// No description provided for @studentCounselingRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get studentCounselingRating;

  /// No description provided for @studentCounselingNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions scheduled'**
  String get studentCounselingNoUpcoming;

  /// No description provided for @studentCounselingNoPast.
  ///
  /// In en, this message translates to:
  /// **'No past sessions yet'**
  String get studentCounselingNoPast;

  /// No description provided for @studentCounselingCancelSession.
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get studentCounselingCancelSession;

  /// No description provided for @studentCounselingCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this session? This action cannot be undone.'**
  String get studentCounselingCancelConfirm;

  /// No description provided for @studentCounselingKeepIt.
  ///
  /// In en, this message translates to:
  /// **'No, Keep It'**
  String get studentCounselingKeepIt;

  /// No description provided for @studentCounselingSessionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Session cancelled'**
  String get studentCounselingSessionCancelled;

  /// No description provided for @studentCounselingYesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get studentCounselingYesCancel;

  /// No description provided for @studentCounselingRateSession.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Session'**
  String get studentCounselingRateSession;

  /// No description provided for @studentCounselingHowWasSession.
  ///
  /// In en, this message translates to:
  /// **'How was your counseling session?'**
  String get studentCounselingHowWasSession;

  /// No description provided for @studentCounselingCommentsOptional.
  ///
  /// In en, this message translates to:
  /// **'Comments (optional)'**
  String get studentCounselingCommentsOptional;

  /// No description provided for @studentCounselingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get studentCounselingCancel;

  /// No description provided for @studentCounselingFeedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get studentCounselingFeedbackThanks;

  /// No description provided for @studentCounselingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get studentCounselingSubmit;

  /// No description provided for @studentCounselingSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get studentCounselingSessions;

  /// No description provided for @studentCounselingAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get studentCounselingAvailability;

  /// No description provided for @studentCounselingBookASession.
  ///
  /// In en, this message translates to:
  /// **'Book a Session'**
  String get studentCounselingBookASession;

  /// No description provided for @studentCounselingDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get studentCounselingDuration;

  /// No description provided for @studentCounselingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String studentCounselingMinutes(int count);

  /// No description provided for @studentCounselingNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get studentCounselingNotes;

  /// No description provided for @studentCounselingYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get studentCounselingYourFeedback;

  /// No description provided for @studentCounselingLeaveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Feedback'**
  String get studentCounselingLeaveFeedback;

  /// No description provided for @studentHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get studentHelpTitle;

  /// No description provided for @studentHelpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get studentHelpSearchHint;

  /// No description provided for @studentHelpQuickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get studentHelpQuickHelp;

  /// No description provided for @studentHelpLiveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get studentHelpLiveChat;

  /// No description provided for @studentHelpChatWithSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with support'**
  String get studentHelpChatWithSupport;

  /// No description provided for @studentHelpEmailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get studentHelpEmailUs;

  /// No description provided for @studentHelpEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'support@flow.edu'**
  String get studentHelpEmailAddress;

  /// No description provided for @studentHelpTutorials.
  ///
  /// In en, this message translates to:
  /// **'Tutorials'**
  String get studentHelpTutorials;

  /// No description provided for @studentHelpVideoGuides.
  ///
  /// In en, this message translates to:
  /// **'Video guides'**
  String get studentHelpVideoGuides;

  /// No description provided for @studentHelpUserGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get studentHelpUserGuide;

  /// No description provided for @studentHelpFullDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Full documentation'**
  String get studentHelpFullDocumentation;

  /// No description provided for @studentHelpFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get studentHelpFaq;

  /// No description provided for @studentHelpSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get studentHelpSearchResults;

  /// No description provided for @studentHelpNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get studentHelpNoResults;

  /// No description provided for @studentHelpTryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords or contact support'**
  String get studentHelpTryDifferentKeywords;

  /// No description provided for @studentHelpContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get studentHelpContactSupport;

  /// No description provided for @studentHelpQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String studentHelpQuestionsCount(int count);

  /// No description provided for @studentHelpComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon!'**
  String studentHelpComingSoon(String feature);

  /// No description provided for @studentHelpReachOut.
  ///
  /// In en, this message translates to:
  /// **'Need help? Reach out to us through any of these channels:'**
  String get studentHelpReachOut;

  /// No description provided for @studentHelpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get studentHelpEmail;

  /// No description provided for @studentHelpPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get studentHelpPhone;

  /// No description provided for @studentHelpHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get studentHelpHours;

  /// No description provided for @studentHelpBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri, 9 AM - 6 PM EST'**
  String get studentHelpBusinessHours;

  /// No description provided for @studentHelpClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get studentHelpClose;

  /// No description provided for @studentHelpOpeningEmail.
  ///
  /// In en, this message translates to:
  /// **'Opening email client...'**
  String get studentHelpOpeningEmail;

  /// No description provided for @studentHelpSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get studentHelpSendEmail;

  /// No description provided for @parentLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Linking'**
  String get parentLinkTitle;

  /// No description provided for @parentLinkLinkedTab.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get parentLinkLinkedTab;

  /// No description provided for @parentLinkRequestsTab.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get parentLinkRequestsTab;

  /// No description provided for @parentLinkInviteCodesTab.
  ///
  /// In en, this message translates to:
  /// **'Invite Codes'**
  String get parentLinkInviteCodesTab;

  /// No description provided for @parentLinkLoadingLinked.
  ///
  /// In en, this message translates to:
  /// **'Loading linked parents...'**
  String get parentLinkLoadingLinked;

  /// No description provided for @parentLinkNoLinkedParents.
  ///
  /// In en, this message translates to:
  /// **'No Linked Parents'**
  String get parentLinkNoLinkedParents;

  /// No description provided for @parentLinkNoLinkedMessage.
  ///
  /// In en, this message translates to:
  /// **'When a parent links their account to yours, they will appear here.'**
  String get parentLinkNoLinkedMessage;

  /// No description provided for @parentLinkRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get parentLinkRefresh;

  /// No description provided for @parentLinkManagePermissionsFor.
  ///
  /// In en, this message translates to:
  /// **'Manage Permissions for {name}'**
  String parentLinkManagePermissionsFor(String name);

  /// No description provided for @parentLinkControlPermissions.
  ///
  /// In en, this message translates to:
  /// **'Control what this parent can see:'**
  String get parentLinkControlPermissions;

  /// No description provided for @parentLinkViewGrades.
  ///
  /// In en, this message translates to:
  /// **'View Grades'**
  String get parentLinkViewGrades;

  /// No description provided for @parentLinkAllowViewGrades.
  ///
  /// In en, this message translates to:
  /// **'Allow viewing your academic grades'**
  String get parentLinkAllowViewGrades;

  /// No description provided for @parentLinkViewActivity.
  ///
  /// In en, this message translates to:
  /// **'View Activity'**
  String get parentLinkViewActivity;

  /// No description provided for @parentLinkAllowViewActivity.
  ///
  /// In en, this message translates to:
  /// **'Allow viewing your app activity'**
  String get parentLinkAllowViewActivity;

  /// No description provided for @parentLinkViewMessages.
  ///
  /// In en, this message translates to:
  /// **'View Messages'**
  String get parentLinkViewMessages;

  /// No description provided for @parentLinkAllowViewMessages.
  ///
  /// In en, this message translates to:
  /// **'Allow viewing your messages (private)'**
  String get parentLinkAllowViewMessages;

  /// No description provided for @parentLinkReceiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive Alerts'**
  String get parentLinkReceiveAlerts;

  /// No description provided for @parentLinkSendAlerts.
  ///
  /// In en, this message translates to:
  /// **'Send alerts about important updates'**
  String get parentLinkSendAlerts;

  /// No description provided for @parentLinkCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get parentLinkCancel;

  /// No description provided for @parentLinkSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get parentLinkSave;

  /// No description provided for @parentLinkPermissionsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Permissions updated'**
  String get parentLinkPermissionsUpdated;

  /// No description provided for @parentLinkUnlinkParent.
  ///
  /// In en, this message translates to:
  /// **'Unlink Parent'**
  String get parentLinkUnlinkParent;

  /// No description provided for @parentLinkUnlinkConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink {name}? They will no longer be able to view your information.'**
  String parentLinkUnlinkConfirm(String name);

  /// No description provided for @parentLinkUnlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get parentLinkUnlink;

  /// No description provided for @parentLinkUnlinked.
  ///
  /// In en, this message translates to:
  /// **'{name} has been unlinked'**
  String parentLinkUnlinked(String name);

  /// No description provided for @parentLinkLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get parentLinkLinked;

  /// No description provided for @parentLinkPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions:'**
  String get parentLinkPermissions;

  /// No description provided for @parentLinkManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get parentLinkManage;

  /// No description provided for @parentLinkLoadingRequests.
  ///
  /// In en, this message translates to:
  /// **'Loading requests...'**
  String get parentLinkLoadingRequests;

  /// No description provided for @parentLinkNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No Pending Requests'**
  String get parentLinkNoPendingRequests;

  /// No description provided for @parentLinkNoPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any parent link requests to review.'**
  String get parentLinkNoPendingMessage;

  /// No description provided for @parentLinkApproved.
  ///
  /// In en, this message translates to:
  /// **'{name} has been linked to your account'**
  String parentLinkApproved(String name);

  /// No description provided for @parentLinkDeclineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get parentLinkDeclineRequest;

  /// No description provided for @parentLinkDeclineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline the link request from {name}?'**
  String parentLinkDeclineConfirm(String name);

  /// No description provided for @parentLinkDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get parentLinkDecline;

  /// No description provided for @parentLinkRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get parentLinkRequestDeclined;

  /// No description provided for @parentLinkRequestedPermissions.
  ///
  /// In en, this message translates to:
  /// **'Requested Permissions:'**
  String get parentLinkRequestedPermissions;

  /// No description provided for @parentLinkApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get parentLinkApprove;

  /// No description provided for @parentLinkGenerateNewCode.
  ///
  /// In en, this message translates to:
  /// **'Generate New Invite Code'**
  String get parentLinkGenerateNewCode;

  /// No description provided for @parentLinkShareCodeInfo.
  ///
  /// In en, this message translates to:
  /// **'Share your invite code with your parent so they can link their account to yours.'**
  String get parentLinkShareCodeInfo;

  /// No description provided for @parentLinkNoInviteCodes.
  ///
  /// In en, this message translates to:
  /// **'No Invite Codes'**
  String get parentLinkNoInviteCodes;

  /// No description provided for @parentLinkNoCodesMessage.
  ///
  /// In en, this message translates to:
  /// **'Generate an invite code to share with your parent.'**
  String get parentLinkNoCodesMessage;

  /// No description provided for @parentLinkGenerateInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Generate Invite Code'**
  String get parentLinkGenerateInviteCode;

  /// No description provided for @parentLinkConfigureCode.
  ///
  /// In en, this message translates to:
  /// **'Configure your invite code settings:'**
  String get parentLinkConfigureCode;

  /// No description provided for @parentLinkGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get parentLinkGenerate;

  /// No description provided for @parentLinkCodeGenerated.
  ///
  /// In en, this message translates to:
  /// **'Code Generated!'**
  String get parentLinkCodeGenerated;

  /// No description provided for @parentLinkShareCode.
  ///
  /// In en, this message translates to:
  /// **'Share this code with your parent:'**
  String get parentLinkShareCode;

  /// No description provided for @parentLinkCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get parentLinkCodeCopied;

  /// No description provided for @parentLinkDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get parentLinkDone;

  /// No description provided for @parentLinkDeleteCode.
  ///
  /// In en, this message translates to:
  /// **'Delete Invite Code'**
  String get parentLinkDeleteCode;

  /// No description provided for @parentLinkDeleteCodeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this invite code?'**
  String get parentLinkDeleteCodeConfirm;

  /// No description provided for @parentLinkDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get parentLinkDelete;

  /// No description provided for @studentProgressLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading progress...'**
  String get studentProgressLoading;

  /// No description provided for @studentProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get studentProgressTitle;

  /// No description provided for @studentProgressError.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Progress'**
  String get studentProgressError;

  /// No description provided for @studentProgressRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get studentProgressRetry;

  /// No description provided for @studentProgressNoData.
  ///
  /// In en, this message translates to:
  /// **'No Progress Data'**
  String get studentProgressNoData;

  /// No description provided for @studentProgressEnrollMessage.
  ///
  /// In en, this message translates to:
  /// **'Enroll in courses to start tracking your progress.'**
  String get studentProgressEnrollMessage;

  /// No description provided for @studentProgressOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get studentProgressOverview;

  /// No description provided for @studentProgressCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get studentProgressCourses;

  /// No description provided for @studentProgressAvgGrade.
  ///
  /// In en, this message translates to:
  /// **'Average Grade'**
  String get studentProgressAvgGrade;

  /// No description provided for @studentProgressCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get studentProgressCompletion;

  /// No description provided for @studentProgressAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get studentProgressAssignments;

  /// No description provided for @studentProgressGradeTrend.
  ///
  /// In en, this message translates to:
  /// **'Grade Trend'**
  String get studentProgressGradeTrend;

  /// No description provided for @studentProgressStudyTime.
  ///
  /// In en, this message translates to:
  /// **'Study Time (Hours)'**
  String get studentProgressStudyTime;

  /// No description provided for @studentProgressCourseCompletion.
  ///
  /// In en, this message translates to:
  /// **'Course Completion'**
  String get studentProgressCourseCompletion;

  /// No description provided for @studentProgressCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get studentProgressCompleted;

  /// No description provided for @studentProgressInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get studentProgressInProgress;

  /// No description provided for @studentProgressProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get studentProgressProgress;

  /// No description provided for @studentProgressAppSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Application Success Rate'**
  String get studentProgressAppSuccessRate;

  /// No description provided for @studentProgressNoAppData.
  ///
  /// In en, this message translates to:
  /// **'No application data available'**
  String get studentProgressNoAppData;

  /// No description provided for @studentProgressNoAppsYet.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get studentProgressNoAppsYet;

  /// No description provided for @studentProgressAcceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get studentProgressAcceptanceRate;

  /// No description provided for @studentProgressGpaTrend.
  ///
  /// In en, this message translates to:
  /// **'GPA Trend'**
  String get studentProgressGpaTrend;

  /// No description provided for @studentProgressNoGpaData.
  ///
  /// In en, this message translates to:
  /// **'No GPA data available'**
  String get studentProgressNoGpaData;

  /// No description provided for @studentProgressCurrentGpa.
  ///
  /// In en, this message translates to:
  /// **'Current GPA'**
  String get studentProgressCurrentGpa;

  /// No description provided for @studentProgressGoalGpa.
  ///
  /// In en, this message translates to:
  /// **'Goal GPA'**
  String get studentProgressGoalGpa;

  /// No description provided for @studentProgressTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get studentProgressTrend;

  /// No description provided for @studentProgressHistoricalGpa.
  ///
  /// In en, this message translates to:
  /// **'Historical GPA data will appear here as you progress through semesters'**
  String get studentProgressHistoricalGpa;

  /// No description provided for @studentProgressCurrentGrade.
  ///
  /// In en, this message translates to:
  /// **'Current Grade'**
  String get studentProgressCurrentGrade;

  /// No description provided for @studentProgressTimeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get studentProgressTimeSpent;

  /// No description provided for @studentProgressModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get studentProgressModules;

  /// No description provided for @studentProgressRecentGrades.
  ///
  /// In en, this message translates to:
  /// **'Recent Grades'**
  String get studentProgressRecentGrades;

  /// No description provided for @studentProgressFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get studentProgressFeedback;

  /// No description provided for @studentRecTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Letters'**
  String get studentRecTitle;

  /// No description provided for @studentRecAllTab.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String studentRecAllTab(int count);

  /// No description provided for @studentRecPendingTab.
  ///
  /// In en, this message translates to:
  /// **'Pending ({count})'**
  String studentRecPendingTab(int count);

  /// No description provided for @studentRecInProgressTab.
  ///
  /// In en, this message translates to:
  /// **'In Progress ({count})'**
  String studentRecInProgressTab(int count);

  /// No description provided for @studentRecCompletedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String studentRecCompletedTab(int count);

  /// No description provided for @studentRecRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get studentRecRetry;

  /// No description provided for @studentRecLoadingRequests.
  ///
  /// In en, this message translates to:
  /// **'Loading requests...'**
  String get studentRecLoadingRequests;

  /// No description provided for @studentRecRequestLetter.
  ///
  /// In en, this message translates to:
  /// **'Request Letter'**
  String get studentRecRequestLetter;

  /// No description provided for @studentRecNoPending.
  ///
  /// In en, this message translates to:
  /// **'No pending recommendation requests'**
  String get studentRecNoPending;

  /// No description provided for @studentRecNoInProgress.
  ///
  /// In en, this message translates to:
  /// **'No letters being written'**
  String get studentRecNoInProgress;

  /// No description provided for @studentRecNoCompleted.
  ///
  /// In en, this message translates to:
  /// **'No completed recommendation letters yet'**
  String get studentRecNoCompleted;

  /// No description provided for @studentRecNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No recommendation requests yet.\nTap + to request a letter.'**
  String get studentRecNoRequests;

  /// No description provided for @studentRecNoRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Requests'**
  String get studentRecNoRequestsTitle;

  /// No description provided for @studentRecRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Recommendation request sent! The recommender will receive an email invitation.'**
  String get studentRecRequestSent;

  /// No description provided for @studentRecFailedToSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to send request'**
  String get studentRecFailedToSend;

  /// No description provided for @studentRecStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get studentRecStatus;

  /// No description provided for @studentRecType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get studentRecType;

  /// No description provided for @studentRecPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get studentRecPurpose;

  /// No description provided for @studentRecInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get studentRecInstitution;

  /// No description provided for @studentRecDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get studentRecDeadline;

  /// No description provided for @studentRecRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get studentRecRequested;

  /// No description provided for @studentRecDeclineReason.
  ///
  /// In en, this message translates to:
  /// **'Decline Reason'**
  String get studentRecDeclineReason;

  /// No description provided for @studentRecClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get studentRecClose;

  /// No description provided for @studentRecCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get studentRecCancelRequest;

  /// No description provided for @studentRecSendReminder.
  ///
  /// In en, this message translates to:
  /// **'Send Reminder'**
  String get studentRecSendReminder;

  /// No description provided for @studentRecCancelRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request?'**
  String get studentRecCancelRequestTitle;

  /// No description provided for @studentRecCancelRequestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this recommendation request?'**
  String get studentRecCancelRequestConfirm;

  /// No description provided for @studentRecNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get studentRecNo;

  /// No description provided for @studentRecYesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get studentRecYesCancel;

  /// No description provided for @studentRecRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get studentRecRequestCancelled;

  /// No description provided for @studentRecFailedToCancel.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel request'**
  String get studentRecFailedToCancel;

  /// No description provided for @studentRecReminderSent.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent!'**
  String get studentRecReminderSent;

  /// No description provided for @studentRecFailedReminder.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reminder'**
  String get studentRecFailedReminder;

  /// No description provided for @studentRecCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get studentRecCompleted;

  /// No description provided for @studentRecOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue!'**
  String get studentRecOverdue;

  /// No description provided for @studentRecDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get studentRecDueToday;

  /// No description provided for @studentRecDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String studentRecDaysLeft(int count);

  /// No description provided for @studentRecEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get studentRecEdit;

  /// No description provided for @studentRecCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get studentRecCancel;

  /// No description provided for @studentRecRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get studentRecRemind;

  /// No description provided for @studentRecRequestRecLetter.
  ///
  /// In en, this message translates to:
  /// **'Request Recommendation Letter'**
  String get studentRecRequestRecLetter;

  /// No description provided for @studentRecRecommenderEmail.
  ///
  /// In en, this message translates to:
  /// **'Recommender Email *'**
  String get studentRecRecommenderEmail;

  /// No description provided for @studentRecEmailHelperText.
  ///
  /// In en, this message translates to:
  /// **'They will receive an invitation to submit the recommendation'**
  String get studentRecEmailHelperText;

  /// No description provided for @studentRecEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter recommender email'**
  String get studentRecEnterEmail;

  /// No description provided for @studentRecValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get studentRecValidEmail;

  /// No description provided for @studentRecRecommenderName.
  ///
  /// In en, this message translates to:
  /// **'Recommender Name *'**
  String get studentRecRecommenderName;

  /// No description provided for @studentRecNameHint.
  ///
  /// In en, this message translates to:
  /// **'Dr. John Smith'**
  String get studentRecNameHint;

  /// No description provided for @studentRecEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter recommender name'**
  String get studentRecEnterName;

  /// No description provided for @studentRecTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Type *'**
  String get studentRecTypeRequired;

  /// No description provided for @studentRecAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get studentRecAcademic;

  /// No description provided for @studentRecProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get studentRecProfessional;

  /// No description provided for @studentRecCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get studentRecCharacter;

  /// No description provided for @studentRecScholarship.
  ///
  /// In en, this message translates to:
  /// **'Scholarship'**
  String get studentRecScholarship;

  /// No description provided for @studentRecPurposeRequired.
  ///
  /// In en, this message translates to:
  /// **'Purpose *'**
  String get studentRecPurposeRequired;

  /// No description provided for @studentRecPurposeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Graduate school application, Job application'**
  String get studentRecPurposeHint;

  /// No description provided for @studentRecPurposeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please describe the purpose (min 10 characters)'**
  String get studentRecPurposeValidation;

  /// No description provided for @studentRecTargetInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Target Institutions *'**
  String get studentRecTargetInstitutions;

  /// No description provided for @studentRecNoAppsWarning.
  ///
  /// In en, this message translates to:
  /// **'You have no applications yet. Please submit applications first to request recommendations.'**
  String get studentRecNoAppsWarning;

  /// No description provided for @studentRecSelectInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Select institutions ({count} selected)'**
  String studentRecSelectInstitutions(int count);

  /// No description provided for @studentRecSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one institution'**
  String get studentRecSelectAtLeastOne;

  /// No description provided for @studentRecDeadlineRequired.
  ///
  /// In en, this message translates to:
  /// **'Deadline *'**
  String get studentRecDeadlineRequired;

  /// No description provided for @studentRecPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get studentRecPriority;

  /// No description provided for @studentRecLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get studentRecLow;

  /// No description provided for @studentRecNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get studentRecNormal;

  /// No description provided for @studentRecHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get studentRecHigh;

  /// No description provided for @studentRecUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get studentRecUrgent;

  /// No description provided for @studentRecMessageToRecommender.
  ///
  /// In en, this message translates to:
  /// **'Message to Recommender'**
  String get studentRecMessageToRecommender;

  /// No description provided for @studentRecMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Any specific points you\'d like them to highlight?'**
  String get studentRecMessageHint;

  /// No description provided for @studentRecYourAchievements.
  ///
  /// In en, this message translates to:
  /// **'Your Achievements'**
  String get studentRecYourAchievements;

  /// No description provided for @studentRecAchievementsHint.
  ///
  /// In en, this message translates to:
  /// **'List relevant achievements to help the recommender'**
  String get studentRecAchievementsHint;

  /// No description provided for @studentRecYourGoals.
  ///
  /// In en, this message translates to:
  /// **'Your Goals'**
  String get studentRecYourGoals;

  /// No description provided for @studentRecGoalsHint.
  ///
  /// In en, this message translates to:
  /// **'What are your career/academic goals?'**
  String get studentRecGoalsHint;

  /// No description provided for @studentRecSendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get studentRecSendRequest;

  /// No description provided for @studentRecEditRequest.
  ///
  /// In en, this message translates to:
  /// **'Edit Request'**
  String get studentRecEditRequest;

  /// No description provided for @studentRecTargetInstitution.
  ///
  /// In en, this message translates to:
  /// **'Target Institution'**
  String get studentRecTargetInstitution;

  /// No description provided for @studentRecInstitutionHint.
  ///
  /// In en, this message translates to:
  /// **'Institution name'**
  String get studentRecInstitutionHint;

  /// No description provided for @studentRecSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get studentRecSaveChanges;

  /// No description provided for @studentRecRequestUpdated.
  ///
  /// In en, this message translates to:
  /// **'Request updated successfully!'**
  String get studentRecRequestUpdated;

  /// No description provided for @studentRecFailedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update request'**
  String get studentRecFailedToUpdate;

  /// No description provided for @studentResourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get studentResourcesTitle;

  /// No description provided for @studentResourcesAllResources.
  ///
  /// In en, this message translates to:
  /// **'All Resources'**
  String get studentResourcesAllResources;

  /// No description provided for @studentResourcesFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get studentResourcesFavorites;

  /// No description provided for @studentResourcesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search resources...'**
  String get studentResourcesSearchHint;

  /// No description provided for @studentResourcesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get studentResourcesAll;

  /// No description provided for @studentResourcesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No resources found'**
  String get studentResourcesNoResults;

  /// No description provided for @studentResourcesTryAdjusting.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get studentResourcesTryAdjusting;

  /// No description provided for @studentResourcesRemovedFavorite.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get studentResourcesRemovedFavorite;

  /// No description provided for @studentResourcesAddedFavorite.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get studentResourcesAddedFavorite;

  /// No description provided for @studentResourcesOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open Link'**
  String get studentResourcesOpenLink;

  /// No description provided for @studentResourcesDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get studentResourcesDownload;

  /// No description provided for @studentScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get studentScheduleTitle;

  /// No description provided for @studentScheduleGoToToday.
  ///
  /// In en, this message translates to:
  /// **'Go to today'**
  String get studentScheduleGoToToday;

  /// No description provided for @studentScheduleAddEventSoon.
  ///
  /// In en, this message translates to:
  /// **'Add event feature coming soon!'**
  String get studentScheduleAddEventSoon;

  /// No description provided for @studentScheduleAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get studentScheduleAddEvent;

  /// No description provided for @studentScheduleEnjoyFreeTime.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your free time!'**
  String get studentScheduleEnjoyFreeTime;

  /// No description provided for @studentScheduleDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get studentScheduleDate;

  /// No description provided for @studentScheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get studentScheduleTime;

  /// No description provided for @studentScheduleLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get studentScheduleLocation;

  /// No description provided for @studentScheduleEditSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit feature coming soon!'**
  String get studentScheduleEditSoon;

  /// No description provided for @studentScheduleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get studentScheduleEdit;

  /// No description provided for @studentScheduleReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set!'**
  String get studentScheduleReminderSet;

  /// No description provided for @studentScheduleRemindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind Me'**
  String get studentScheduleRemindMe;

  /// No description provided for @parentChildAddChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get parentChildAddChild;

  /// No description provided for @parentChildByEmail.
  ///
  /// In en, this message translates to:
  /// **'By Email'**
  String get parentChildByEmail;

  /// No description provided for @parentChildByCode.
  ///
  /// In en, this message translates to:
  /// **'By Code'**
  String get parentChildByCode;

  /// No description provided for @parentChildEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your child\'s email address to send them a link request.'**
  String get parentChildEmailDescription;

  /// No description provided for @parentChildStudentEmail.
  ///
  /// In en, this message translates to:
  /// **'Student Email'**
  String get parentChildStudentEmail;

  /// No description provided for @parentChildStudentEmailHint.
  ///
  /// In en, this message translates to:
  /// **'student@example.com'**
  String get parentChildStudentEmailHint;

  /// No description provided for @parentChildEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get parentChildEnterEmail;

  /// No description provided for @parentChildValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get parentChildValidEmail;

  /// No description provided for @parentChildSendLinkRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Link Request'**
  String get parentChildSendLinkRequest;

  /// No description provided for @parentChildApprovalNotice.
  ///
  /// In en, this message translates to:
  /// **'Your child will receive a notification to approve this request.'**
  String get parentChildApprovalNotice;

  /// No description provided for @parentChildCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the invite code your child shared with you.'**
  String get parentChildCodeDescription;

  /// No description provided for @parentChildInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get parentChildInviteCode;

  /// No description provided for @parentChildInviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'ABCD1234'**
  String get parentChildInviteCodeHint;

  /// No description provided for @parentChildEnterInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the invite code'**
  String get parentChildEnterInviteCode;

  /// No description provided for @parentChildCodeMinLength.
  ///
  /// In en, this message translates to:
  /// **'Code must be at least 6 characters'**
  String get parentChildCodeMinLength;

  /// No description provided for @parentChildUseInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Use Invite Code'**
  String get parentChildUseInviteCode;

  /// No description provided for @parentChildInviteCodeInfo.
  ///
  /// In en, this message translates to:
  /// **'Ask your child to generate an invite code from their app settings.'**
  String get parentChildInviteCodeInfo;

  /// No description provided for @parentChildRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get parentChildRelationship;

  /// No description provided for @parentChildBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get parentChildBack;

  /// No description provided for @parentChildOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get parentChildOverview;

  /// No description provided for @parentChildCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get parentChildCourses;

  /// No description provided for @parentChildApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get parentChildApplications;

  /// No description provided for @parentChildCounseling.
  ///
  /// In en, this message translates to:
  /// **'Counseling'**
  String get parentChildCounseling;

  /// No description provided for @parentChildAcademicPerformance.
  ///
  /// In en, this message translates to:
  /// **'Academic Performance'**
  String get parentChildAcademicPerformance;

  /// No description provided for @parentChildAverageGrade.
  ///
  /// In en, this message translates to:
  /// **'Average Grade'**
  String get parentChildAverageGrade;

  /// No description provided for @parentChildActiveCourses.
  ///
  /// In en, this message translates to:
  /// **'Active Courses'**
  String get parentChildActiveCourses;

  /// No description provided for @parentChildSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get parentChildSchool;

  /// No description provided for @parentChildNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get parentChildNotSet;

  /// No description provided for @parentChildRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get parentChildRecentActivity;

  /// No description provided for @parentChildCompletedAssignment.
  ///
  /// In en, this message translates to:
  /// **'Completed Assignment'**
  String get parentChildCompletedAssignment;

  /// No description provided for @parentChildMathChapter5.
  ///
  /// In en, this message translates to:
  /// **'Mathematics - Chapter 5 Test'**
  String get parentChildMathChapter5;

  /// No description provided for @parentChildHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String parentChildHoursAgo(String count);

  /// No description provided for @parentChildSubmittedProject.
  ///
  /// In en, this message translates to:
  /// **'Submitted Project'**
  String get parentChildSubmittedProject;

  /// No description provided for @parentChildCsFinalProject.
  ///
  /// In en, this message translates to:
  /// **'Computer Science - Final Project'**
  String get parentChildCsFinalProject;

  /// No description provided for @parentChildDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String parentChildDaysAgo(String count);

  /// No description provided for @parentChildReceivedGrade.
  ///
  /// In en, this message translates to:
  /// **'Received Grade'**
  String get parentChildReceivedGrade;

  /// No description provided for @parentChildPhysicsLabReport.
  ///
  /// In en, this message translates to:
  /// **'Physics - Lab Report (92/100)'**
  String get parentChildPhysicsLabReport;

  /// No description provided for @parentChildRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get parentChildRetry;

  /// No description provided for @parentChildLoadingCourses.
  ///
  /// In en, this message translates to:
  /// **'Loading courses...'**
  String get parentChildLoadingCourses;

  /// No description provided for @parentChildNoCourseData.
  ///
  /// In en, this message translates to:
  /// **'No Course Data'**
  String get parentChildNoCourseData;

  /// No description provided for @parentChildNoCourseProgress.
  ///
  /// In en, this message translates to:
  /// **'No course progress data available'**
  String get parentChildNoCourseProgress;

  /// No description provided for @parentChildCourseProgress.
  ///
  /// In en, this message translates to:
  /// **'Course Progress'**
  String get parentChildCourseProgress;

  /// No description provided for @parentChildAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments: {completed}/{total}'**
  String parentChildAssignments(String completed, String total);

  /// No description provided for @parentChildNoApplications.
  ///
  /// In en, this message translates to:
  /// **'No Applications'**
  String get parentChildNoApplications;

  /// No description provided for @parentChildNoApplicationsYet.
  ///
  /// In en, this message translates to:
  /// **'Your child hasn\'t submitted any applications yet'**
  String get parentChildNoApplicationsYet;

  /// No description provided for @parentChildSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String parentChildSubmitted(String date);

  /// No description provided for @parentChildStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get parentChildStatusPending;

  /// No description provided for @parentChildStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get parentChildStatusUnderReview;

  /// No description provided for @parentChildStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get parentChildStatusAccepted;

  /// No description provided for @parentChildStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get parentChildStatusRejected;

  /// No description provided for @parentChildLoadingChildren.
  ///
  /// In en, this message translates to:
  /// **'Loading children...'**
  String get parentChildLoadingChildren;

  /// No description provided for @parentChildNoChildren.
  ///
  /// In en, this message translates to:
  /// **'No Children'**
  String get parentChildNoChildren;

  /// No description provided for @parentChildAddToMonitor.
  ///
  /// In en, this message translates to:
  /// **'Add your children to monitor their progress'**
  String get parentChildAddToMonitor;

  /// No description provided for @parentChildAvg.
  ///
  /// In en, this message translates to:
  /// **'AVG'**
  String get parentChildAvg;

  /// No description provided for @parentChildLastActive.
  ///
  /// In en, this message translates to:
  /// **'Last Active'**
  String get parentChildLastActive;

  /// No description provided for @parentChildPendingLinkRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Link Requests'**
  String get parentChildPendingLinkRequests;

  /// No description provided for @parentChildWaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for student approval'**
  String get parentChildWaitingApproval;

  /// No description provided for @parentChildAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get parentChildAwaitingApproval;

  /// No description provided for @parentChildNoCounselor.
  ///
  /// In en, this message translates to:
  /// **'No Counselor Assigned'**
  String get parentChildNoCounselor;

  /// No description provided for @parentChildNoCounselorDescription.
  ///
  /// In en, this message translates to:
  /// **'{childName} doesn\'t have a counselor assigned yet.'**
  String parentChildNoCounselorDescription(String childName);

  /// No description provided for @parentChildChildCounselor.
  ///
  /// In en, this message translates to:
  /// **'{childName}\'s Counselor'**
  String parentChildChildCounselor(String childName);

  /// No description provided for @parentChildAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned: {date}'**
  String parentChildAssigned(String date);

  /// No description provided for @parentChildTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get parentChildTotal;

  /// No description provided for @parentChildUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get parentChildUpcoming;

  /// No description provided for @parentChildCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get parentChildCompleted;

  /// No description provided for @parentChildUpcomingSessions.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get parentChildUpcomingSessions;

  /// No description provided for @parentChildNoUpcomingSessions.
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions'**
  String get parentChildNoUpcomingSessions;

  /// No description provided for @parentChildPastSessions.
  ///
  /// In en, this message translates to:
  /// **'Past Sessions'**
  String get parentChildPastSessions;

  /// No description provided for @parentChildNoPastSessions.
  ///
  /// In en, this message translates to:
  /// **'No past sessions'**
  String get parentChildNoPastSessions;

  /// No description provided for @parentChildMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String parentChildMinutes(String count);

  /// No description provided for @parentReportBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get parentReportBack;

  /// No description provided for @parentReportAcademicReports.
  ///
  /// In en, this message translates to:
  /// **'Academic Reports'**
  String get parentReportAcademicReports;

  /// No description provided for @parentReportProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get parentReportProgress;

  /// No description provided for @parentReportGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get parentReportGrades;

  /// No description provided for @parentReportAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get parentReportAttendance;

  /// No description provided for @parentReportStudentProgressReports.
  ///
  /// In en, this message translates to:
  /// **'Student Progress Reports'**
  String get parentReportStudentProgressReports;

  /// No description provided for @parentReportTrackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track academic progress and course completion'**
  String get parentReportTrackProgress;

  /// No description provided for @parentReportNoProgressData.
  ///
  /// In en, this message translates to:
  /// **'No Progress Data'**
  String get parentReportNoProgressData;

  /// No description provided for @parentReportAddChildrenProgress.
  ///
  /// In en, this message translates to:
  /// **'Add children to view their progress reports'**
  String get parentReportAddChildrenProgress;

  /// No description provided for @parentReportCoursesEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Courses Enrolled'**
  String get parentReportCoursesEnrolled;

  /// No description provided for @parentReportApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get parentReportApplications;

  /// No description provided for @parentReportOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get parentReportOverallProgress;

  /// No description provided for @parentReportGradeReports.
  ///
  /// In en, this message translates to:
  /// **'Grade Reports'**
  String get parentReportGradeReports;

  /// No description provided for @parentReportGradeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Detailed breakdown of grades by subject'**
  String get parentReportGradeBreakdown;

  /// No description provided for @parentReportNoGradeData.
  ///
  /// In en, this message translates to:
  /// **'No Grade Data'**
  String get parentReportNoGradeData;

  /// No description provided for @parentReportAddChildrenGrades.
  ///
  /// In en, this message translates to:
  /// **'Add children to view their grade reports'**
  String get parentReportAddChildrenGrades;

  /// No description provided for @parentReportAttendanceReports.
  ///
  /// In en, this message translates to:
  /// **'Attendance Reports'**
  String get parentReportAttendanceReports;

  /// No description provided for @parentReportTrackAttendance.
  ///
  /// In en, this message translates to:
  /// **'Track attendance and participation'**
  String get parentReportTrackAttendance;

  /// No description provided for @parentReportNoAttendanceData.
  ///
  /// In en, this message translates to:
  /// **'No Attendance Data'**
  String get parentReportNoAttendanceData;

  /// No description provided for @parentReportAddChildrenAttendance.
  ///
  /// In en, this message translates to:
  /// **'Add children to view their attendance reports'**
  String get parentReportAddChildrenAttendance;

  /// No description provided for @parentReportPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get parentReportPresent;

  /// No description provided for @parentReportLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get parentReportLate;

  /// No description provided for @parentReportAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get parentReportAbsent;

  /// No description provided for @parentReportThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month: {present} of {total} days present'**
  String parentReportThisMonth(String present, String total);

  /// No description provided for @parentReportMathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get parentReportMathematics;

  /// No description provided for @parentReportEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get parentReportEnglish;

  /// No description provided for @parentReportScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get parentReportScience;

  /// No description provided for @parentReportHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get parentReportHistory;

  /// No description provided for @parentMeetingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get parentMeetingBack;

  /// No description provided for @parentMeetingScheduleCounselor.
  ///
  /// In en, this message translates to:
  /// **'Schedule Counselor Meeting'**
  String get parentMeetingScheduleCounselor;

  /// No description provided for @parentMeetingScheduleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Schedule Teacher Meeting'**
  String get parentMeetingScheduleTeacher;

  /// No description provided for @parentMeetingCounselorMeeting.
  ///
  /// In en, this message translates to:
  /// **'Counselor Meeting'**
  String get parentMeetingCounselorMeeting;

  /// No description provided for @parentMeetingParentTeacherConference.
  ///
  /// In en, this message translates to:
  /// **'Parent-Teacher Conference'**
  String get parentMeetingParentTeacherConference;

  /// No description provided for @parentMeetingCounselorDescription.
  ///
  /// In en, this message translates to:
  /// **'Discuss guidance and academic planning'**
  String get parentMeetingCounselorDescription;

  /// No description provided for @parentMeetingTeacherDescription.
  ///
  /// In en, this message translates to:
  /// **'Discuss student progress and performance'**
  String get parentMeetingTeacherDescription;

  /// No description provided for @parentMeetingSelectStudent.
  ///
  /// In en, this message translates to:
  /// **'Select Student'**
  String get parentMeetingSelectStudent;

  /// No description provided for @parentMeetingNoChildren.
  ///
  /// In en, this message translates to:
  /// **'No children added. Please add children to schedule meetings.'**
  String get parentMeetingNoChildren;

  /// No description provided for @parentMeetingSelectCounselor.
  ///
  /// In en, this message translates to:
  /// **'Select Counselor'**
  String get parentMeetingSelectCounselor;

  /// No description provided for @parentMeetingSelectTeacher.
  ///
  /// In en, this message translates to:
  /// **'Select Teacher'**
  String get parentMeetingSelectTeacher;

  /// No description provided for @parentMeetingNoCounselors.
  ///
  /// In en, this message translates to:
  /// **'No counselors available at this time.'**
  String get parentMeetingNoCounselors;

  /// No description provided for @parentMeetingNoTeachers.
  ///
  /// In en, this message translates to:
  /// **'No teachers available at this time.'**
  String get parentMeetingNoTeachers;

  /// No description provided for @parentMeetingCounselor.
  ///
  /// In en, this message translates to:
  /// **'Counselor'**
  String get parentMeetingCounselor;

  /// No description provided for @parentMeetingTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get parentMeetingTeacher;

  /// No description provided for @parentMeetingSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get parentMeetingSelectDateTime;

  /// No description provided for @parentMeetingDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get parentMeetingDate;

  /// No description provided for @parentMeetingSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get parentMeetingSelectDate;

  /// No description provided for @parentMeetingTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get parentMeetingTime;

  /// No description provided for @parentMeetingSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get parentMeetingSelectTime;

  /// No description provided for @parentMeetingMode.
  ///
  /// In en, this message translates to:
  /// **'Meeting Mode'**
  String get parentMeetingMode;

  /// No description provided for @parentMeetingVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get parentMeetingVideoCall;

  /// No description provided for @parentMeetingInPerson.
  ///
  /// In en, this message translates to:
  /// **'In Person'**
  String get parentMeetingInPerson;

  /// No description provided for @parentMeetingPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get parentMeetingPhone;

  /// No description provided for @parentMeetingDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get parentMeetingDuration;

  /// No description provided for @parentMeetingDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Meeting duration'**
  String get parentMeetingDurationLabel;

  /// No description provided for @parentMeeting15Min.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get parentMeeting15Min;

  /// No description provided for @parentMeeting30Min.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get parentMeeting30Min;

  /// No description provided for @parentMeeting45Min.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get parentMeeting45Min;

  /// No description provided for @parentMeeting1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get parentMeeting1Hour;

  /// No description provided for @parentMeeting1Point5Hours.
  ///
  /// In en, this message translates to:
  /// **'1.5 hours'**
  String get parentMeeting1Point5Hours;

  /// No description provided for @parentMeeting2Hours.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get parentMeeting2Hours;

  /// No description provided for @parentMeetingSubject.
  ///
  /// In en, this message translates to:
  /// **'Meeting Subject'**
  String get parentMeetingSubject;

  /// No description provided for @parentMeetingSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get parentMeetingSubjectLabel;

  /// No description provided for @parentMeetingSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Math progress discussion'**
  String get parentMeetingSubjectHint;

  /// No description provided for @parentMeetingAdditionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (Optional)'**
  String get parentMeetingAdditionalNotes;

  /// No description provided for @parentMeetingNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get parentMeetingNotesLabel;

  /// No description provided for @parentMeetingNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional information...'**
  String get parentMeetingNotesHint;

  /// No description provided for @parentMeetingRequesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting...'**
  String get parentMeetingRequesting;

  /// No description provided for @parentMeetingRequestMeeting.
  ///
  /// In en, this message translates to:
  /// **'Request Meeting'**
  String get parentMeetingRequestMeeting;

  /// No description provided for @parentMeetingRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Meeting Request Sent'**
  String get parentMeetingRequestSent;

  /// No description provided for @parentMeetingRequestSentDescription.
  ///
  /// In en, this message translates to:
  /// **'Your meeting request has been sent to {staffName}. You will be notified once they respond.'**
  String parentMeetingRequestSentDescription(String staffName);

  /// No description provided for @parentMeetingOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get parentMeetingOk;

  /// No description provided for @parentMeetingRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to request meeting. Please try again.'**
  String get parentMeetingRequestFailed;

  /// No description provided for @parentMeetingError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get parentMeetingError;

  /// No description provided for @counselorMeetingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get counselorMeetingBack;

  /// No description provided for @counselorMeetingRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get counselorMeetingRefresh;

  /// No description provided for @counselorMeetingManageAvailability.
  ///
  /// In en, this message translates to:
  /// **'Manage Availability'**
  String get counselorMeetingManageAvailability;

  /// No description provided for @counselorMeetingWeeklyAvailability.
  ///
  /// In en, this message translates to:
  /// **'Weekly Availability'**
  String get counselorMeetingWeeklyAvailability;

  /// No description provided for @counselorMeetingSetAvailableHours.
  ///
  /// In en, this message translates to:
  /// **'Set your available hours for parent meetings'**
  String get counselorMeetingSetAvailableHours;

  /// No description provided for @counselorMeetingAddAvailabilitySlot.
  ///
  /// In en, this message translates to:
  /// **'Add Availability Slot'**
  String get counselorMeetingAddAvailabilitySlot;

  /// No description provided for @counselorMeetingAddNewAvailability.
  ///
  /// In en, this message translates to:
  /// **'Add New Availability'**
  String get counselorMeetingAddNewAvailability;

  /// No description provided for @counselorMeetingDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get counselorMeetingDayOfWeek;

  /// No description provided for @counselorMeetingStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get counselorMeetingStartTime;

  /// No description provided for @counselorMeetingEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get counselorMeetingEndTime;

  /// No description provided for @counselorMeetingStartWithTime.
  ///
  /// In en, this message translates to:
  /// **'Start: {time}'**
  String counselorMeetingStartWithTime(String time);

  /// No description provided for @counselorMeetingEndWithTime.
  ///
  /// In en, this message translates to:
  /// **'End: {time}'**
  String counselorMeetingEndWithTime(String time);

  /// No description provided for @counselorMeetingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get counselorMeetingCancel;

  /// No description provided for @counselorMeetingSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get counselorMeetingSave;

  /// No description provided for @counselorMeetingNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get counselorMeetingNotAvailable;

  /// No description provided for @counselorMeetingInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get counselorMeetingInactive;

  /// No description provided for @counselorMeetingDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get counselorMeetingDeactivate;

  /// No description provided for @counselorMeetingActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get counselorMeetingActivate;

  /// No description provided for @counselorMeetingDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get counselorMeetingDelete;

  /// No description provided for @counselorMeetingAvailabilityAdded.
  ///
  /// In en, this message translates to:
  /// **'Availability added successfully'**
  String get counselorMeetingAvailabilityAdded;

  /// No description provided for @counselorMeetingFailedToAddAvailability.
  ///
  /// In en, this message translates to:
  /// **'Failed to add availability'**
  String get counselorMeetingFailedToAddAvailability;

  /// No description provided for @counselorMeetingSlotDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Slot deactivated'**
  String get counselorMeetingSlotDeactivated;

  /// No description provided for @counselorMeetingSlotActivated.
  ///
  /// In en, this message translates to:
  /// **'Slot activated'**
  String get counselorMeetingSlotActivated;

  /// No description provided for @counselorMeetingFailedToUpdateAvailability.
  ///
  /// In en, this message translates to:
  /// **'Failed to update availability'**
  String get counselorMeetingFailedToUpdateAvailability;

  /// No description provided for @counselorMeetingDeleteAvailability.
  ///
  /// In en, this message translates to:
  /// **'Delete Availability'**
  String get counselorMeetingDeleteAvailability;

  /// No description provided for @counselorMeetingConfirmDeleteSlot.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the {dayName} slot?'**
  String counselorMeetingConfirmDeleteSlot(String dayName);

  /// No description provided for @counselorMeetingAvailabilityDeleted.
  ///
  /// In en, this message translates to:
  /// **'Availability deleted successfully'**
  String get counselorMeetingAvailabilityDeleted;

  /// No description provided for @counselorMeetingFailedToDeleteAvailability.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete availability'**
  String get counselorMeetingFailedToDeleteAvailability;

  /// No description provided for @counselorMeetingSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get counselorMeetingSunday;

  /// No description provided for @counselorMeetingMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get counselorMeetingMonday;

  /// No description provided for @counselorMeetingTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get counselorMeetingTuesday;

  /// No description provided for @counselorMeetingWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get counselorMeetingWednesday;

  /// No description provided for @counselorMeetingThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get counselorMeetingThursday;

  /// No description provided for @counselorMeetingFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get counselorMeetingFriday;

  /// No description provided for @counselorMeetingSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get counselorMeetingSaturday;

  /// No description provided for @counselorMeetingRequests.
  ///
  /// In en, this message translates to:
  /// **'Meeting Requests'**
  String get counselorMeetingRequests;

  /// No description provided for @counselorMeetingPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get counselorMeetingPending;

  /// No description provided for @counselorMeetingToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get counselorMeetingToday;

  /// No description provided for @counselorMeetingUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get counselorMeetingUpcoming;

  /// No description provided for @counselorMeetingNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No Pending Requests'**
  String get counselorMeetingNoPendingRequests;

  /// No description provided for @counselorMeetingNoPendingRequestsMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no meeting requests at this time.'**
  String get counselorMeetingNoPendingRequestsMessage;

  /// No description provided for @counselorMeetingNoMeetingsToday.
  ///
  /// In en, this message translates to:
  /// **'No Meetings Today'**
  String get counselorMeetingNoMeetingsToday;

  /// No description provided for @counselorMeetingNoMeetingsTodayMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no scheduled meetings for today.'**
  String get counselorMeetingNoMeetingsTodayMessage;

  /// No description provided for @counselorMeetingNoUpcomingMeetings.
  ///
  /// In en, this message translates to:
  /// **'No Upcoming Meetings'**
  String get counselorMeetingNoUpcomingMeetings;

  /// No description provided for @counselorMeetingNoUpcomingMeetingsMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no scheduled meetings.'**
  String get counselorMeetingNoUpcomingMeetingsMessage;

  /// No description provided for @counselorMeetingParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get counselorMeetingParent;

  /// No description provided for @counselorMeetingUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get counselorMeetingUnknown;

  /// No description provided for @counselorMeetingStudentLabel.
  ///
  /// In en, this message translates to:
  /// **'Student: {name}'**
  String counselorMeetingStudentLabel(String name);

  /// No description provided for @counselorMeetingPendingBadge.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get counselorMeetingPendingBadge;

  /// No description provided for @counselorMeetingRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested: {dateTime}'**
  String counselorMeetingRequested(String dateTime);

  /// No description provided for @counselorMeetingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String counselorMeetingMinutes(String count);

  /// No description provided for @counselorMeetingDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get counselorMeetingDecline;

  /// No description provided for @counselorMeetingApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get counselorMeetingApprove;

  /// No description provided for @counselorMeetingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get counselorMeetingSoon;

  /// No description provided for @counselorMeetingCancelMeeting.
  ///
  /// In en, this message translates to:
  /// **'Cancel Meeting'**
  String get counselorMeetingCancelMeeting;

  /// No description provided for @counselorMeetingTimeWithDuration.
  ///
  /// In en, this message translates to:
  /// **'{time} ({minutes} min)'**
  String counselorMeetingTimeWithDuration(String time, String minutes);

  /// No description provided for @counselorMeetingApproveMeeting.
  ///
  /// In en, this message translates to:
  /// **'Approve Meeting'**
  String get counselorMeetingApproveMeeting;

  /// No description provided for @counselorMeetingApproveWith.
  ///
  /// In en, this message translates to:
  /// **'Approve meeting with {parentName}'**
  String counselorMeetingApproveWith(String parentName);

  /// No description provided for @counselorMeetingSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get counselorMeetingSelectDate;

  /// No description provided for @counselorMeetingSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get counselorMeetingSelectTime;

  /// No description provided for @counselorMeetingDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get counselorMeetingDuration;

  /// No description provided for @counselorMeeting1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get counselorMeeting1Hour;

  /// No description provided for @counselorMeeting1Point5Hours.
  ///
  /// In en, this message translates to:
  /// **'1.5 hours'**
  String get counselorMeeting1Point5Hours;

  /// No description provided for @counselorMeeting2Hours.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get counselorMeeting2Hours;

  /// No description provided for @counselorMeetingMeetingLink.
  ///
  /// In en, this message translates to:
  /// **'Meeting Link'**
  String get counselorMeetingMeetingLink;

  /// No description provided for @counselorMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get counselorMeetingLocation;

  /// No description provided for @counselorMeetingLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Room 101, Main Building'**
  String get counselorMeetingLocationHint;

  /// No description provided for @counselorMeetingNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get counselorMeetingNotesOptional;

  /// No description provided for @counselorMeetingApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Meeting approved successfully'**
  String get counselorMeetingApprovedSuccessfully;

  /// No description provided for @counselorMeetingFailedToApprove.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve meeting'**
  String get counselorMeetingFailedToApprove;

  /// No description provided for @counselorMeetingDeclineMeeting.
  ///
  /// In en, this message translates to:
  /// **'Decline Meeting'**
  String get counselorMeetingDeclineMeeting;

  /// No description provided for @counselorMeetingDeclineFrom.
  ///
  /// In en, this message translates to:
  /// **'Decline meeting request from {parentName}?'**
  String counselorMeetingDeclineFrom(String parentName);

  /// No description provided for @counselorMeetingReasonForDeclining.
  ///
  /// In en, this message translates to:
  /// **'Reason for declining'**
  String get counselorMeetingReasonForDeclining;

  /// No description provided for @counselorMeetingProvideReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason...'**
  String get counselorMeetingProvideReason;

  /// No description provided for @counselorMeetingPleaseProvideReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for declining'**
  String get counselorMeetingPleaseProvideReason;

  /// No description provided for @counselorMeetingDeclined.
  ///
  /// In en, this message translates to:
  /// **'Meeting declined'**
  String get counselorMeetingDeclined;

  /// No description provided for @counselorMeetingFailedToDecline.
  ///
  /// In en, this message translates to:
  /// **'Failed to decline meeting'**
  String get counselorMeetingFailedToDecline;

  /// No description provided for @counselorMeetingCancelWith.
  ///
  /// In en, this message translates to:
  /// **'Cancel this meeting with {parentName}?'**
  String counselorMeetingCancelWith(String parentName);

  /// No description provided for @counselorMeetingCancellationReasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason (Optional)'**
  String get counselorMeetingCancellationReasonOptional;

  /// No description provided for @counselorMeetingBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get counselorMeetingBackButton;

  /// No description provided for @counselorMeetingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Meeting cancelled'**
  String get counselorMeetingCancelled;

  /// No description provided for @counselorMeetingFailedToCancel.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel meeting'**
  String get counselorMeetingFailedToCancel;

  /// No description provided for @counselorSessionPleaseSelectStudent.
  ///
  /// In en, this message translates to:
  /// **'Please select a student'**
  String get counselorSessionPleaseSelectStudent;

  /// No description provided for @counselorSessionScheduledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Session scheduled successfully!'**
  String get counselorSessionScheduledSuccessfully;

  /// No description provided for @counselorSessionErrorScheduling.
  ///
  /// In en, this message translates to:
  /// **'Error scheduling session: {error}'**
  String counselorSessionErrorScheduling(String error);

  /// No description provided for @counselorSessionScheduleSession.
  ///
  /// In en, this message translates to:
  /// **'Schedule Session'**
  String get counselorSessionScheduleSession;

  /// No description provided for @counselorSessionSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get counselorSessionSave;

  /// No description provided for @counselorSessionStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get counselorSessionStudent;

  /// No description provided for @counselorSessionNoStudentsFound.
  ///
  /// In en, this message translates to:
  /// **'No students found. Please add students first.'**
  String get counselorSessionNoStudentsFound;

  /// No description provided for @counselorSessionSelectStudent.
  ///
  /// In en, this message translates to:
  /// **'Select a student'**
  String get counselorSessionSelectStudent;

  /// No description provided for @counselorSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Title'**
  String get counselorSessionTitle;

  /// No description provided for @counselorSessionTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Career Planning Discussion'**
  String get counselorSessionTitleHint;

  /// No description provided for @counselorSessionPleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a session title'**
  String get counselorSessionPleaseEnterTitle;

  /// No description provided for @counselorSessionType.
  ///
  /// In en, this message translates to:
  /// **'Session Type'**
  String get counselorSessionType;

  /// No description provided for @counselorSessionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get counselorSessionDate;

  /// No description provided for @counselorSessionTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get counselorSessionTime;

  /// No description provided for @counselorSessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get counselorSessionDuration;

  /// No description provided for @counselorSessionDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String counselorSessionDurationMin(String count);

  /// No description provided for @counselorSessionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get counselorSessionLocation;

  /// No description provided for @counselorSessionNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get counselorSessionNotesOptional;

  /// No description provided for @counselorSessionNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any additional notes or agenda items...'**
  String get counselorSessionNotesHint;

  /// No description provided for @counselorSessionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get counselorSessionCancel;

  /// No description provided for @counselorSessionSelectStudentDialog.
  ///
  /// In en, this message translates to:
  /// **'Select Student'**
  String get counselorSessionSelectStudentDialog;

  /// No description provided for @counselorSessionGradeAndGpa.
  ///
  /// In en, this message translates to:
  /// **'{grade} • GPA: {gpa}'**
  String counselorSessionGradeAndGpa(String grade, String gpa);

  /// No description provided for @counselorSessionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get counselorSessionRetry;

  /// No description provided for @counselorSessionLoadingSessions.
  ///
  /// In en, this message translates to:
  /// **'Loading sessions...'**
  String get counselorSessionLoadingSessions;

  /// No description provided for @counselorSessionTodayTab.
  ///
  /// In en, this message translates to:
  /// **'Today ({count})'**
  String counselorSessionTodayTab(String count);

  /// No description provided for @counselorSessionUpcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming ({count})'**
  String counselorSessionUpcomingTab(String count);

  /// No description provided for @counselorSessionCompletedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String counselorSessionCompletedTab(String count);

  /// No description provided for @counselorSessionNoSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Sessions'**
  String get counselorSessionNoSessionsTitle;

  /// No description provided for @counselorSessionNoSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'No sessions scheduled for today'**
  String get counselorSessionNoSessionsToday;

  /// No description provided for @counselorSessionNoUpcomingSessions.
  ///
  /// In en, this message translates to:
  /// **'No upcoming sessions'**
  String get counselorSessionNoUpcomingSessions;

  /// No description provided for @counselorSessionNoCompletedSessions.
  ///
  /// In en, this message translates to:
  /// **'No completed sessions yet'**
  String get counselorSessionNoCompletedSessions;

  /// No description provided for @counselorSessionNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get counselorSessionNoSessions;

  /// No description provided for @counselorSessionStudentLabel.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get counselorSessionStudentLabel;

  /// No description provided for @counselorSessionDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get counselorSessionDateTime;

  /// No description provided for @counselorSessionDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get counselorSessionDurationLabel;

  /// No description provided for @counselorSessionMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String counselorSessionMinutesValue(String count);

  /// No description provided for @counselorSessionStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get counselorSessionStatusLabel;

  /// No description provided for @counselorSessionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get counselorSessionNotes;

  /// No description provided for @counselorSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get counselorSessionSummary;

  /// No description provided for @counselorSessionActionItems.
  ///
  /// In en, this message translates to:
  /// **'Action Items'**
  String get counselorSessionActionItems;

  /// No description provided for @counselorSessionStartSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get counselorSessionStartSession;

  /// No description provided for @counselorSessionCancelSession.
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get counselorSessionCancelSession;

  /// No description provided for @counselorSessionIndividualCounseling.
  ///
  /// In en, this message translates to:
  /// **'Individual Counseling'**
  String get counselorSessionIndividualCounseling;

  /// No description provided for @counselorSessionGroupSession.
  ///
  /// In en, this message translates to:
  /// **'Group Session'**
  String get counselorSessionGroupSession;

  /// No description provided for @counselorSessionCareerCounseling.
  ///
  /// In en, this message translates to:
  /// **'Career Counseling'**
  String get counselorSessionCareerCounseling;

  /// No description provided for @counselorSessionAcademicAdvising.
  ///
  /// In en, this message translates to:
  /// **'Academic Advising'**
  String get counselorSessionAcademicAdvising;

  /// No description provided for @counselorSessionPersonalCounseling.
  ///
  /// In en, this message translates to:
  /// **'Personal Counseling'**
  String get counselorSessionPersonalCounseling;

  /// No description provided for @counselorSessionStartSessionWith.
  ///
  /// In en, this message translates to:
  /// **'Start counseling session with {studentName}?'**
  String counselorSessionStartSessionWith(String studentName);

  /// No description provided for @counselorSessionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get counselorSessionStart;

  /// No description provided for @counselorSessionStarted.
  ///
  /// In en, this message translates to:
  /// **'Session with {studentName} started'**
  String counselorSessionStarted(String studentName);

  /// No description provided for @counselorSessionCancelSessionWith.
  ///
  /// In en, this message translates to:
  /// **'Cancel session with {studentName}?'**
  String counselorSessionCancelSessionWith(String studentName);

  /// No description provided for @counselorSessionReasonForCancellation.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancellation:'**
  String get counselorSessionReasonForCancellation;

  /// No description provided for @counselorSessionStudentUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Student unavailable'**
  String get counselorSessionStudentUnavailable;

  /// No description provided for @counselorSessionCounselorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Counselor unavailable'**
  String get counselorSessionCounselorUnavailable;

  /// No description provided for @counselorSessionRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get counselorSessionRescheduled;

  /// No description provided for @counselorSessionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get counselorSessionOther;

  /// No description provided for @counselorSessionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get counselorSessionBack;

  /// No description provided for @counselorSessionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Session with {studentName} cancelled'**
  String counselorSessionCancelled(String studentName);

  /// No description provided for @counselorSessionTodayBadge.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get counselorSessionTodayBadge;

  /// No description provided for @counselorSessionIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get counselorSessionIndividual;

  /// No description provided for @counselorSessionGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get counselorSessionGroup;

  /// No description provided for @counselorSessionCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get counselorSessionCareer;

  /// No description provided for @counselorSessionAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get counselorSessionAcademic;

  /// No description provided for @counselorSessionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get counselorSessionPersonal;

  /// No description provided for @counselorSessionScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get counselorSessionScheduled;

  /// No description provided for @counselorSessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get counselorSessionCompleted;

  /// No description provided for @counselorSessionCancelledStatus.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get counselorSessionCancelledStatus;

  /// No description provided for @counselorSessionNoShow.
  ///
  /// In en, this message translates to:
  /// **'No Show'**
  String get counselorSessionNoShow;

  /// No description provided for @counselorStudentBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get counselorStudentBack;

  /// No description provided for @counselorStudentAddNotesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add notes feature coming soon'**
  String get counselorStudentAddNotesComingSoon;

  /// No description provided for @counselorStudentOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get counselorStudentOverview;

  /// No description provided for @counselorStudentSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get counselorStudentSessions;

  /// No description provided for @counselorStudentNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get counselorStudentNotes;

  /// No description provided for @counselorStudentScheduleSession.
  ///
  /// In en, this message translates to:
  /// **'Schedule Session'**
  String get counselorStudentScheduleSession;

  /// No description provided for @counselorStudentAcademicPerformance.
  ///
  /// In en, this message translates to:
  /// **'Academic Performance'**
  String get counselorStudentAcademicPerformance;

  /// No description provided for @counselorStudentGpa.
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get counselorStudentGpa;

  /// No description provided for @counselorStudentInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get counselorStudentInterests;

  /// No description provided for @counselorStudentStrengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get counselorStudentStrengths;

  /// No description provided for @counselorStudentAreasForGrowth.
  ///
  /// In en, this message translates to:
  /// **'Areas for Growth'**
  String get counselorStudentAreasForGrowth;

  /// No description provided for @counselorStudentNoSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No Sessions Yet'**
  String get counselorStudentNoSessionsYet;

  /// No description provided for @counselorStudentScheduleSessionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Schedule a session with this student'**
  String get counselorStudentScheduleSessionPrompt;

  /// No description provided for @counselorStudentNoNotesYet.
  ///
  /// In en, this message translates to:
  /// **'No Notes Yet'**
  String get counselorStudentNoNotesYet;

  /// No description provided for @counselorStudentAddPrivateNotes.
  ///
  /// In en, this message translates to:
  /// **'Add private notes about this student'**
  String get counselorStudentAddPrivateNotes;

  /// No description provided for @counselorStudentAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get counselorStudentAddNote;

  /// No description provided for @counselorStudentIndividualCounseling.
  ///
  /// In en, this message translates to:
  /// **'Individual Counseling'**
  String get counselorStudentIndividualCounseling;

  /// No description provided for @counselorStudentGroupSession.
  ///
  /// In en, this message translates to:
  /// **'Group Session'**
  String get counselorStudentGroupSession;

  /// No description provided for @counselorStudentCareerCounseling.
  ///
  /// In en, this message translates to:
  /// **'Career Counseling'**
  String get counselorStudentCareerCounseling;

  /// No description provided for @counselorStudentAcademicAdvising.
  ///
  /// In en, this message translates to:
  /// **'Academic Advising'**
  String get counselorStudentAcademicAdvising;

  /// No description provided for @counselorStudentPersonalCounseling.
  ///
  /// In en, this message translates to:
  /// **'Personal Counseling'**
  String get counselorStudentPersonalCounseling;

  /// No description provided for @counselorStudentScheduleFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Session scheduling feature will be implemented with calendar integration.'**
  String get counselorStudentScheduleFeatureComingSoon;

  /// No description provided for @counselorStudentClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get counselorStudentClose;

  /// No description provided for @counselorStudentScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get counselorStudentScheduled;

  /// No description provided for @counselorStudentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get counselorStudentCompleted;

  /// No description provided for @counselorStudentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get counselorStudentCancelled;

  /// No description provided for @counselorStudentNoShow.
  ///
  /// In en, this message translates to:
  /// **'No Show'**
  String get counselorStudentNoShow;

  /// No description provided for @counselorStudentRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get counselorStudentRetry;

  /// No description provided for @counselorStudentLoadingStudents.
  ///
  /// In en, this message translates to:
  /// **'Loading students...'**
  String get counselorStudentLoadingStudents;

  /// No description provided for @counselorStudentSearchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search students...'**
  String get counselorStudentSearchStudents;

  /// No description provided for @counselorStudentNoStudentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Students Found'**
  String get counselorStudentNoStudentsFound;

  /// No description provided for @counselorStudentTryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search'**
  String get counselorStudentTryAdjustingSearch;

  /// No description provided for @counselorStudentNoStudentsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No students assigned yet'**
  String get counselorStudentNoStudentsAssigned;

  /// No description provided for @counselorStudentGradeAndGpa.
  ///
  /// In en, this message translates to:
  /// **'{grade} • GPA: {gpa}'**
  String counselorStudentGradeAndGpa(String grade, String gpa);

  /// No description provided for @counselorStudentSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String counselorStudentSessionsCount(String count);

  /// No description provided for @counselorStudentToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get counselorStudentToday;

  /// No description provided for @counselorStudentYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get counselorStudentYesterday;

  /// No description provided for @counselorStudentDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String counselorStudentDaysAgo(String count);

  /// No description provided for @counselorStudentWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}w ago'**
  String counselorStudentWeeksAgo(String count);

  /// No description provided for @recRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get recRetry;

  /// No description provided for @recLoadingRequests.
  ///
  /// In en, this message translates to:
  /// **'Loading requests...'**
  String get recLoadingRequests;

  /// No description provided for @recTabAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String recTabAll(int count);

  /// No description provided for @recTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending ({count})'**
  String recTabPending(int count);

  /// No description provided for @recTabInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress ({count})'**
  String recTabInProgress(int count);

  /// No description provided for @recTabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String recTabCompleted(int count);

  /// No description provided for @recNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending recommendation requests'**
  String get recNoPendingRequests;

  /// No description provided for @recNoLettersInProgress.
  ///
  /// In en, this message translates to:
  /// **'No letters in progress'**
  String get recNoLettersInProgress;

  /// No description provided for @recNoCompletedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No completed recommendations yet'**
  String get recNoCompletedRecommendations;

  /// No description provided for @recNoRecommendationRequests.
  ///
  /// In en, this message translates to:
  /// **'No recommendation requests'**
  String get recNoRecommendationRequests;

  /// No description provided for @recNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No Requests'**
  String get recNoRequests;

  /// No description provided for @recStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get recStudent;

  /// No description provided for @recInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get recInstitution;

  /// No description provided for @recOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue!'**
  String get recOverdue;

  /// No description provided for @recDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get recDueToday;

  /// No description provided for @recDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String recDaysLeft(int count);

  /// No description provided for @recUrgent.
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get recUrgent;

  /// No description provided for @recStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'OVERDUE'**
  String get recStatusOverdue;

  /// No description provided for @recStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get recStatusPending;

  /// No description provided for @recStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'ACCEPTED'**
  String get recStatusAccepted;

  /// No description provided for @recStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get recStatusInProgress;

  /// No description provided for @recStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get recStatusCompleted;

  /// No description provided for @recStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'DECLINED'**
  String get recStatusDeclined;

  /// No description provided for @recStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get recStatusCancelled;

  /// No description provided for @recRecommendationLetter.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Letter'**
  String get recRecommendationLetter;

  /// No description provided for @recSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get recSaveDraft;

  /// No description provided for @recApplyingTo.
  ///
  /// In en, this message translates to:
  /// **'Applying to {institution}'**
  String recApplyingTo(String institution);

  /// No description provided for @recPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get recPurpose;

  /// No description provided for @recType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get recType;

  /// No description provided for @recDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get recDeadline;

  /// No description provided for @recStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get recStatus;

  /// No description provided for @recMessageFromStudent.
  ///
  /// In en, this message translates to:
  /// **'Message from Student'**
  String get recMessageFromStudent;

  /// No description provided for @recAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get recAchievements;

  /// No description provided for @recDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get recDecline;

  /// No description provided for @recAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get recAccept;

  /// No description provided for @recQuickStartTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick Start Templates'**
  String get recQuickStartTemplates;

  /// No description provided for @recProfessionalTemplate.
  ///
  /// In en, this message translates to:
  /// **'Professional Template'**
  String get recProfessionalTemplate;

  /// No description provided for @recProfessionalTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Formal business-style recommendation'**
  String get recProfessionalTemplateDesc;

  /// No description provided for @recAcademicTemplate.
  ///
  /// In en, this message translates to:
  /// **'Academic Template'**
  String get recAcademicTemplate;

  /// No description provided for @recAcademicTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on academic achievements'**
  String get recAcademicTemplateDesc;

  /// No description provided for @recPersonalTemplate.
  ///
  /// In en, this message translates to:
  /// **'Personal Template'**
  String get recPersonalTemplate;

  /// No description provided for @recPersonalTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Emphasize personal qualities'**
  String get recPersonalTemplateDesc;

  /// No description provided for @recWriteHint.
  ///
  /// In en, this message translates to:
  /// **'Write your recommendation here or use a template above...'**
  String get recWriteHint;

  /// No description provided for @recPleaseWriteRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Please write a recommendation'**
  String get recPleaseWriteRecommendation;

  /// No description provided for @recMinCharacters.
  ///
  /// In en, this message translates to:
  /// **'Recommendation should be at least 100 characters'**
  String get recMinCharacters;

  /// No description provided for @recSubmitRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Submit Recommendation'**
  String get recSubmitRecommendation;

  /// No description provided for @recTheStudent.
  ///
  /// In en, this message translates to:
  /// **'the student'**
  String get recTheStudent;

  /// No description provided for @recYourInstitution.
  ///
  /// In en, this message translates to:
  /// **'your institution'**
  String get recYourInstitution;

  /// No description provided for @recRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Request accepted! You can now write the letter.'**
  String get recRequestAccepted;

  /// No description provided for @recFailedToAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept request'**
  String get recFailedToAcceptRequest;

  /// No description provided for @recErrorAcceptingRequest.
  ///
  /// In en, this message translates to:
  /// **'Error accepting request: {error}'**
  String recErrorAcceptingRequest(String error);

  /// No description provided for @recDeclineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get recDeclineRequest;

  /// No description provided for @recDeclineReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for declining this request.'**
  String get recDeclineReason;

  /// No description provided for @recReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get recReasonLabel;

  /// No description provided for @recReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 10 characters'**
  String get recReasonHint;

  /// No description provided for @recCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recCancel;

  /// No description provided for @recReasonMinCharacters.
  ///
  /// In en, this message translates to:
  /// **'Reason must be at least 10 characters'**
  String get recReasonMinCharacters;

  /// No description provided for @recRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get recRequestDeclined;

  /// No description provided for @recFailedToDeclineRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to decline request'**
  String get recFailedToDeclineRequest;

  /// No description provided for @recErrorDecliningRequest.
  ///
  /// In en, this message translates to:
  /// **'Error declining request: {error}'**
  String recErrorDecliningRequest(String error);

  /// No description provided for @recLetterMinCharacters.
  ///
  /// In en, this message translates to:
  /// **'Letter content must be at least 100 characters'**
  String get recLetterMinCharacters;

  /// No description provided for @recDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved successfully'**
  String get recDraftSaved;

  /// No description provided for @recErrorSavingDraft.
  ///
  /// In en, this message translates to:
  /// **'Error saving draft: {error}'**
  String recErrorSavingDraft(String error);

  /// No description provided for @recSubmitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Recommendation?'**
  String get recSubmitConfirmTitle;

  /// No description provided for @recSubmitConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Once submitted, you will not be able to edit this recommendation. Are you sure you want to submit?'**
  String get recSubmitConfirmMessage;

  /// No description provided for @recSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get recSubmit;

  /// No description provided for @recSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Recommendation submitted successfully!'**
  String get recSubmittedSuccessfully;

  /// No description provided for @recFailedToSubmit.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit recommendation'**
  String get recFailedToSubmit;

  /// No description provided for @recErrorSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Error submitting recommendation: {error}'**
  String recErrorSubmitting(String error);

  /// No description provided for @notifPrefTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notifPrefTitle;

  /// No description provided for @notifPrefDefaultCreated.
  ///
  /// In en, this message translates to:
  /// **'Default notification preferences created successfully!'**
  String get notifPrefDefaultCreated;

  /// No description provided for @notifPrefErrorCreating.
  ///
  /// In en, this message translates to:
  /// **'Error creating preferences: {error}'**
  String notifPrefErrorCreating(String error);

  /// No description provided for @notifPrefNotFound.
  ///
  /// In en, this message translates to:
  /// **'No notification preferences found'**
  String get notifPrefNotFound;

  /// No description provided for @notifPrefCreateDefaults.
  ///
  /// In en, this message translates to:
  /// **'Create Default Preferences'**
  String get notifPrefCreateDefaults;

  /// No description provided for @notifPrefWaitingAuth.
  ///
  /// In en, this message translates to:
  /// **'Waiting for authentication...'**
  String get notifPrefWaitingAuth;

  /// No description provided for @notifPrefSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notifPrefSettings;

  /// No description provided for @notifPrefDescription.
  ///
  /// In en, this message translates to:
  /// **'Control which notifications you want to receive. Changes are saved automatically.'**
  String get notifPrefDescription;

  /// No description provided for @notifPrefCollegeApplications.
  ///
  /// In en, this message translates to:
  /// **'College Applications'**
  String get notifPrefCollegeApplications;

  /// No description provided for @notifPrefAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get notifPrefAcademic;

  /// No description provided for @notifPrefCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get notifPrefCommunication;

  /// No description provided for @notifPrefMeetingsEvents.
  ///
  /// In en, this message translates to:
  /// **'Meetings & Events'**
  String get notifPrefMeetingsEvents;

  /// No description provided for @notifPrefAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get notifPrefAchievements;

  /// No description provided for @notifPrefSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notifPrefSystem;

  /// No description provided for @notifPrefErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading preferences: {error}'**
  String notifPrefErrorLoading(String error);

  /// No description provided for @notifPrefRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get notifPrefRetry;

  /// No description provided for @notifPrefEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get notifPrefEmail;

  /// No description provided for @notifPrefPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get notifPrefPush;

  /// No description provided for @notifPrefSoon.
  ///
  /// In en, this message translates to:
  /// **'(soon)'**
  String get notifPrefSoon;

  /// No description provided for @notifPrefDescApplicationStatus.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your application status changes'**
  String get notifPrefDescApplicationStatus;

  /// No description provided for @notifPrefDescGradePosted.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when new grades are posted'**
  String get notifPrefDescGradePosted;

  /// No description provided for @notifPrefDescMessageReceived.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new messages'**
  String get notifPrefDescMessageReceived;

  /// No description provided for @notifPrefDescMeetingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for scheduled meetings'**
  String get notifPrefDescMeetingScheduled;

  /// No description provided for @notifPrefDescMeetingReminder.
  ///
  /// In en, this message translates to:
  /// **'Get reminders before your meetings'**
  String get notifPrefDescMeetingReminder;

  /// No description provided for @notifPrefDescAchievementEarned.
  ///
  /// In en, this message translates to:
  /// **'Celebrate when you earn new achievements'**
  String get notifPrefDescAchievementEarned;

  /// No description provided for @notifPrefDescDeadlineReminder.
  ///
  /// In en, this message translates to:
  /// **'Get reminded about upcoming deadlines'**
  String get notifPrefDescDeadlineReminder;

  /// No description provided for @notifPrefDescRecommendationReady.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for new recommendations'**
  String get notifPrefDescRecommendationReady;

  /// No description provided for @notifPrefDescSystemAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with system announcements'**
  String get notifPrefDescSystemAnnouncement;

  /// No description provided for @notifPrefDescCommentReceived.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone comments on your posts'**
  String get notifPrefDescCommentReceived;

  /// No description provided for @notifPrefDescMention.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when you are mentioned'**
  String get notifPrefDescMention;

  /// No description provided for @notifPrefDescEventReminder.
  ///
  /// In en, this message translates to:
  /// **'Get reminders about upcoming events'**
  String get notifPrefDescEventReminder;

  /// No description provided for @notifPrefDescApprovalNew.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new approval requests'**
  String get notifPrefDescApprovalNew;

  /// No description provided for @notifPrefDescApprovalActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders about pending approval actions'**
  String get notifPrefDescApprovalActionNeeded;

  /// No description provided for @notifPrefDescApprovalStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your request status changes'**
  String get notifPrefDescApprovalStatusChanged;

  /// No description provided for @notifPrefDescApprovalEscalated.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when requests are escalated to you'**
  String get notifPrefDescApprovalEscalated;

  /// No description provided for @notifPrefDescApprovalExpiring.
  ///
  /// In en, this message translates to:
  /// **'Get reminders about expiring approval requests'**
  String get notifPrefDescApprovalExpiring;

  /// No description provided for @notifPrefDescApprovalComment.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new comments on requests'**
  String get notifPrefDescApprovalComment;

  /// No description provided for @notifPrefUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preferences updated'**
  String get notifPrefUpdated;

  /// No description provided for @notifPrefErrorUpdating.
  ///
  /// In en, this message translates to:
  /// **'Error updating preferences: {error}'**
  String notifPrefErrorUpdating(String error);

  /// No description provided for @biometricSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Biometric'**
  String get biometricSetupTitle;

  /// No description provided for @biometricSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Settings'**
  String get biometricSettingsTitle;

  /// No description provided for @biometricErrorChecking.
  ///
  /// In en, this message translates to:
  /// **'Error checking biometrics: {error}'**
  String biometricErrorChecking(String error);

  /// No description provided for @biometricEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication enabled successfully'**
  String get biometricEnabledSuccess;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get biometricAuthFailed;

  /// No description provided for @biometricError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String biometricError(String error);

  /// No description provided for @biometricDisabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication disabled'**
  String get biometricDisabledSuccess;

  /// No description provided for @biometricEnableLogin.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Login'**
  String get biometricEnableLogin;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// No description provided for @biometricUseType.
  ///
  /// In en, this message translates to:
  /// **'Use {type}'**
  String biometricUseType(String type);

  /// No description provided for @biometricEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get biometricEnabled;

  /// No description provided for @biometricDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get biometricDisabled;

  /// No description provided for @biometricWhyUse.
  ///
  /// In en, this message translates to:
  /// **'Why use biometric?'**
  String get biometricWhyUse;

  /// No description provided for @biometricBenefitFaster.
  ///
  /// In en, this message translates to:
  /// **'Faster login experience'**
  String get biometricBenefitFaster;

  /// No description provided for @biometricBenefitSecure.
  ///
  /// In en, this message translates to:
  /// **'More secure than passwords'**
  String get biometricBenefitSecure;

  /// No description provided for @biometricBenefitUnique.
  ///
  /// In en, this message translates to:
  /// **'Unique to you - cannot be copied'**
  String get biometricBenefitUnique;

  /// No description provided for @biometricSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'Security Note'**
  String get biometricSecurityNote;

  /// No description provided for @biometricSecurityNoteDesc.
  ///
  /// In en, this message translates to:
  /// **'Your biometric data stays on your device and is never shared with Flow or third parties.'**
  String get biometricSecurityNoteDesc;

  /// No description provided for @biometricSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get biometricSkipForNow;

  /// No description provided for @biometricNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Not Supported'**
  String get biometricNotSupported;

  /// No description provided for @biometricNotSupportedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your device does not support biometric authentication.'**
  String get biometricNotSupportedDesc;

  /// No description provided for @biometricGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get biometricGoBack;

  /// No description provided for @biometricNotEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No Biometrics Enrolled'**
  String get biometricNotEnrolled;

  /// No description provided for @biometricNotEnrolledDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enroll your fingerprint or face ID in your device settings first.'**
  String get biometricNotEnrolledDesc;

  /// No description provided for @biometricOpenSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Please open Settings > Security > Biometrics'**
  String get biometricOpenSettingsHint;

  /// No description provided for @biometricOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get biometricOpenSettings;

  /// No description provided for @biometricTypeFace.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get biometricTypeFace;

  /// No description provided for @biometricTypeFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get biometricTypeFingerprint;

  /// No description provided for @biometricTypeIris.
  ///
  /// In en, this message translates to:
  /// **'Iris Recognition'**
  String get biometricTypeIris;

  /// No description provided for @biometricTypeGeneric.
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get biometricTypeGeneric;

  /// No description provided for @biometricDescEnabled.
  ///
  /// In en, this message translates to:
  /// **'Your {type} is currently being used to secure your account. You can sign in quickly and securely.'**
  String biometricDescEnabled(String type);

  /// No description provided for @biometricDescDisabled.
  ///
  /// In en, this message translates to:
  /// **'Use your {type} to sign in quickly and securely without entering your password.'**
  String biometricDescDisabled(String type);
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
