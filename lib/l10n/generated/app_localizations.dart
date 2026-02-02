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
