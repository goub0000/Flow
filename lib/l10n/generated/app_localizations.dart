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

  /// No description provided for @adminChatDashTitle.
  ///
  /// In en, this message translates to:
  /// **'Chatbot Dashboard'**
  String get adminChatDashTitle;

  /// No description provided for @adminChatDashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor and manage chatbot interactions'**
  String get adminChatDashSubtitle;

  /// No description provided for @adminChatDashRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminChatDashRefresh;

  /// No description provided for @adminChatDashTotalConversations.
  ///
  /// In en, this message translates to:
  /// **'Total Conversations'**
  String get adminChatDashTotalConversations;

  /// No description provided for @adminChatDashActiveNow.
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get adminChatDashActiveNow;

  /// No description provided for @adminChatDashTotalMessages.
  ///
  /// In en, this message translates to:
  /// **'Total Messages'**
  String get adminChatDashTotalMessages;

  /// No description provided for @adminChatDashAvgMessagesPerChat.
  ///
  /// In en, this message translates to:
  /// **'Avg Messages/Chat'**
  String get adminChatDashAvgMessagesPerChat;

  /// No description provided for @adminChatDashQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get adminChatDashQuickActions;

  /// No description provided for @adminChatDashManageFaqs.
  ///
  /// In en, this message translates to:
  /// **'Manage FAQs'**
  String get adminChatDashManageFaqs;

  /// No description provided for @adminChatDashManageFaqsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and organize frequently asked questions'**
  String get adminChatDashManageFaqsDesc;

  /// No description provided for @adminChatDashConversationHistory.
  ///
  /// In en, this message translates to:
  /// **'Conversation History'**
  String get adminChatDashConversationHistory;

  /// No description provided for @adminChatDashConversationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse and review past conversations'**
  String get adminChatDashConversationHistoryDesc;

  /// No description provided for @adminChatDashSupportQueue.
  ///
  /// In en, this message translates to:
  /// **'Support Queue'**
  String get adminChatDashSupportQueue;

  /// No description provided for @adminChatDashSupportQueueDesc.
  ///
  /// In en, this message translates to:
  /// **'Review escalated conversations needing attention'**
  String get adminChatDashSupportQueueDesc;

  /// No description provided for @adminChatDashLiveMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Live Monitoring'**
  String get adminChatDashLiveMonitoring;

  /// No description provided for @adminChatDashLiveMonitoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor active chatbot conversations in real-time'**
  String get adminChatDashLiveMonitoringDesc;

  /// No description provided for @adminChatDashRecentConversations.
  ///
  /// In en, this message translates to:
  /// **'Recent Conversations'**
  String get adminChatDashRecentConversations;

  /// No description provided for @adminChatDashViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get adminChatDashViewAll;

  /// No description provided for @adminChatDashNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get adminChatDashNoConversations;

  /// No description provided for @adminChatDashNoConversationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Chatbot conversations will appear here once users start interacting'**
  String get adminChatDashNoConversationsDesc;

  /// No description provided for @adminChatDashMessagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String adminChatDashMessagesCount(int count);

  /// No description provided for @adminChatDashStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminChatDashStatusActive;

  /// No description provided for @adminChatDashStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get adminChatDashStatusArchived;

  /// No description provided for @adminChatDashStatusFlagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged'**
  String get adminChatDashStatusFlagged;

  /// No description provided for @adminChatDashJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get adminChatDashJustNow;

  /// No description provided for @adminChatDashMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String adminChatDashMinutesAgo(int count);

  /// No description provided for @adminChatDashHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String adminChatDashHoursAgo(int count);

  /// No description provided for @adminChatDashDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String adminChatDashDaysAgo(int count);

  /// No description provided for @adminFeeConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Fee Configuration'**
  String get adminFeeConfigTitle;

  /// No description provided for @adminFeeConfigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage platform fees and pricing'**
  String get adminFeeConfigSubtitle;

  /// No description provided for @adminFeeConfigUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get adminFeeConfigUnsavedChanges;

  /// No description provided for @adminFeeConfigReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get adminFeeConfigReset;

  /// No description provided for @adminFeeConfigSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get adminFeeConfigSaveChanges;

  /// No description provided for @adminFeeConfigSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Fee configuration saved successfully'**
  String get adminFeeConfigSavedSuccess;

  /// No description provided for @adminFeeConfigFeeSummary.
  ///
  /// In en, this message translates to:
  /// **'Fee Summary'**
  String get adminFeeConfigFeeSummary;

  /// No description provided for @adminFeeConfigCategoriesActive.
  ///
  /// In en, this message translates to:
  /// **'categories active'**
  String get adminFeeConfigCategoriesActive;

  /// No description provided for @adminFeeConfigActiveFees.
  ///
  /// In en, this message translates to:
  /// **'Active Fees'**
  String get adminFeeConfigActiveFees;

  /// No description provided for @adminFeeConfigAvgRate.
  ///
  /// In en, this message translates to:
  /// **'Avg Rate'**
  String get adminFeeConfigAvgRate;

  /// No description provided for @adminFeeConfigDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get adminFeeConfigDisabled;

  /// No description provided for @adminFeeConfigPercentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get adminFeeConfigPercentage;

  /// No description provided for @adminFeeConfigFixedAmount.
  ///
  /// In en, this message translates to:
  /// **'Fixed Amount'**
  String get adminFeeConfigFixedAmount;

  /// No description provided for @adminFeeConfigExample.
  ///
  /// In en, this message translates to:
  /// **'Example on KES 10,000'**
  String get adminFeeConfigExample;

  /// No description provided for @adminSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminSettingsTitle;

  /// No description provided for @adminSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account and system preferences'**
  String get adminSettingsSubtitle;

  /// No description provided for @adminSettingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get adminSettingsProfile;

  /// No description provided for @adminSettingsDefaultUser.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminSettingsDefaultUser;

  /// No description provided for @adminSettingsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminSettingsEdit;

  /// No description provided for @adminSettingsRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminSettingsRole;

  /// No description provided for @adminSettingsSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get adminSettingsSuperAdmin;

  /// No description provided for @adminSettingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get adminSettingsNotifications;

  /// No description provided for @adminSettingsEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get adminSettingsEmailNotifications;

  /// No description provided for @adminSettingsEmailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive important updates via email'**
  String get adminSettingsEmailNotificationsDesc;

  /// No description provided for @adminSettingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get adminSettingsPushNotifications;

  /// No description provided for @adminSettingsPushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get real-time push notifications on your device'**
  String get adminSettingsPushNotificationsDesc;

  /// No description provided for @adminSettingsUserActivityAlerts.
  ///
  /// In en, this message translates to:
  /// **'User Activity Alerts'**
  String get adminSettingsUserActivityAlerts;

  /// No description provided for @adminSettingsUserActivityAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified about unusual user activity'**
  String get adminSettingsUserActivityAlertsDesc;

  /// No description provided for @adminSettingsSystemAlerts.
  ///
  /// In en, this message translates to:
  /// **'System Alerts'**
  String get adminSettingsSystemAlerts;

  /// No description provided for @adminSettingsSystemAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts about system health and issues'**
  String get adminSettingsSystemAlertsDesc;

  /// No description provided for @adminSettingsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get adminSettingsDisplay;

  /// No description provided for @adminSettingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get adminSettingsDarkMode;

  /// No description provided for @adminSettingsDarkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch to a darker color scheme'**
  String get adminSettingsDarkModeDesc;

  /// No description provided for @adminSettingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get adminSettingsLanguage;

  /// No description provided for @adminSettingsLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get adminSettingsLangEnglish;

  /// No description provided for @adminSettingsLangSwahili.
  ///
  /// In en, this message translates to:
  /// **'Swahili'**
  String get adminSettingsLangSwahili;

  /// No description provided for @adminSettingsLangFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get adminSettingsLangFrench;

  /// No description provided for @adminSettingsTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get adminSettingsTimezone;

  /// No description provided for @adminSettingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get adminSettingsSecurity;

  /// No description provided for @adminSettingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get adminSettingsChangePassword;

  /// No description provided for @adminSettingsChangePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get adminSettingsChangePasswordDesc;

  /// No description provided for @adminSettingsTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get adminSettingsTwoFactor;

  /// No description provided for @adminSettingsTwoFactorDesc.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security to your account'**
  String get adminSettingsTwoFactorDesc;

  /// No description provided for @adminSettingsActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get adminSettingsActiveSessions;

  /// No description provided for @adminSettingsActiveSessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage your active login sessions'**
  String get adminSettingsActiveSessionsDesc;

  /// No description provided for @adminSettingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get adminSettingsPrivacy;

  /// No description provided for @adminSettingsActivityLogging.
  ///
  /// In en, this message translates to:
  /// **'Activity Logging'**
  String get adminSettingsActivityLogging;

  /// No description provided for @adminSettingsActivityLoggingDesc.
  ///
  /// In en, this message translates to:
  /// **'Log admin actions for audit purposes'**
  String get adminSettingsActivityLoggingDesc;

  /// No description provided for @adminSettingsAnalyticsTracking.
  ///
  /// In en, this message translates to:
  /// **'Analytics Tracking'**
  String get adminSettingsAnalyticsTracking;

  /// No description provided for @adminSettingsAnalyticsTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Help improve the platform with usage analytics'**
  String get adminSettingsAnalyticsTrackingDesc;

  /// No description provided for @adminSettingsDownloadData.
  ///
  /// In en, this message translates to:
  /// **'Download My Data'**
  String get adminSettingsDownloadData;

  /// No description provided for @adminSettingsDownloadDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Export all your personal data'**
  String get adminSettingsDownloadDataDesc;

  /// No description provided for @adminSettingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get adminSettingsDangerZone;

  /// No description provided for @adminSettingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get adminSettingsSignOut;

  /// No description provided for @adminSettingsSignOutDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your admin account'**
  String get adminSettingsSignOutDesc;

  /// No description provided for @adminSettingsSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get adminSettingsSignOutConfirm;

  /// No description provided for @adminSettingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminSettingsCancel;

  /// No description provided for @adminSettingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get adminSettingsDeleteAccount;

  /// No description provided for @adminSettingsDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get adminSettingsDeleteAccountDesc;

  /// No description provided for @notifPrefScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notifPrefScreenTitle;

  /// No description provided for @notifPrefScreenNoPreferences.
  ///
  /// In en, this message translates to:
  /// **'No notification preferences found'**
  String get notifPrefScreenNoPreferences;

  /// No description provided for @notifPrefScreenCreateDefaults.
  ///
  /// In en, this message translates to:
  /// **'Create Default Preferences'**
  String get notifPrefScreenCreateDefaults;

  /// No description provided for @notifPrefScreenSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notifPrefScreenSettingsTitle;

  /// No description provided for @notifPrefScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'Control which notifications you want to receive. Changes are saved automatically.'**
  String get notifPrefScreenDescription;

  /// No description provided for @notifPrefScreenCollegeApplications.
  ///
  /// In en, this message translates to:
  /// **'College Applications'**
  String get notifPrefScreenCollegeApplications;

  /// No description provided for @notifPrefScreenAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get notifPrefScreenAcademic;

  /// No description provided for @notifPrefScreenCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get notifPrefScreenCommunication;

  /// No description provided for @notifPrefScreenMeetingsEvents.
  ///
  /// In en, this message translates to:
  /// **'Meetings & Events'**
  String get notifPrefScreenMeetingsEvents;

  /// No description provided for @notifPrefScreenAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get notifPrefScreenAchievements;

  /// No description provided for @notifPrefScreenSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notifPrefScreenSystem;

  /// No description provided for @notifPrefScreenEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get notifPrefScreenEmail;

  /// No description provided for @notifPrefScreenPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get notifPrefScreenPush;

  /// No description provided for @notifPrefScreenSoon.
  ///
  /// In en, this message translates to:
  /// **'(soon)'**
  String get notifPrefScreenSoon;

  /// No description provided for @notifPrefScreenErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading preferences'**
  String get notifPrefScreenErrorLoading;

  /// No description provided for @notifPrefScreenRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get notifPrefScreenRetry;

  /// No description provided for @notifPrefScreenErrorCreating.
  ///
  /// In en, this message translates to:
  /// **'Error creating preferences'**
  String get notifPrefScreenErrorCreating;

  /// No description provided for @notifPrefScreenErrorUpdating.
  ///
  /// In en, this message translates to:
  /// **'Error updating preferences'**
  String get notifPrefScreenErrorUpdating;

  /// No description provided for @notifPrefScreenPreferencesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preferences updated'**
  String get notifPrefScreenPreferencesUpdated;

  /// No description provided for @notifPrefScreenDescApplicationStatus.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your application status changes'**
  String get notifPrefScreenDescApplicationStatus;

  /// No description provided for @notifPrefScreenDescGradePosted.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when new grades are posted'**
  String get notifPrefScreenDescGradePosted;

  /// No description provided for @notifPrefScreenDescMessageReceived.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new messages'**
  String get notifPrefScreenDescMessageReceived;

  /// No description provided for @notifPrefScreenDescMeetingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for scheduled meetings'**
  String get notifPrefScreenDescMeetingScheduled;

  /// No description provided for @notifPrefScreenDescMeetingReminder.
  ///
  /// In en, this message translates to:
  /// **'Get reminders before your meetings'**
  String get notifPrefScreenDescMeetingReminder;

  /// No description provided for @notifPrefScreenDescAchievementEarned.
  ///
  /// In en, this message translates to:
  /// **'Celebrate when you earn new achievements'**
  String get notifPrefScreenDescAchievementEarned;

  /// No description provided for @notifPrefScreenDescDeadlineReminder.
  ///
  /// In en, this message translates to:
  /// **'Get reminded about upcoming deadlines'**
  String get notifPrefScreenDescDeadlineReminder;

  /// No description provided for @notifPrefScreenDescRecommendationReady.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for new recommendations'**
  String get notifPrefScreenDescRecommendationReady;

  /// No description provided for @notifPrefScreenDescSystemAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with system announcements'**
  String get notifPrefScreenDescSystemAnnouncement;

  /// No description provided for @notifPrefScreenDescCommentReceived.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone comments on your posts'**
  String get notifPrefScreenDescCommentReceived;

  /// No description provided for @notifPrefScreenDescMention.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when you are mentioned'**
  String get notifPrefScreenDescMention;

  /// No description provided for @notifPrefScreenDescEventReminder.
  ///
  /// In en, this message translates to:
  /// **'Get reminders about upcoming events'**
  String get notifPrefScreenDescEventReminder;

  /// No description provided for @notifPrefScreenDescApprovalRequestNew.
  ///
  /// In en, this message translates to:
  /// **'Get notified about new approval requests'**
  String get notifPrefScreenDescApprovalRequestNew;

  /// No description provided for @notifPrefScreenDescApprovalRequestActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Get notified when an approval request needs your action'**
  String get notifPrefScreenDescApprovalRequestActionNeeded;

  /// No description provided for @notifPrefScreenDescApprovalRequestStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your approval request status changes'**
  String get notifPrefScreenDescApprovalRequestStatusChanged;

  /// No description provided for @notifPrefScreenDescApprovalRequestEscalated.
  ///
  /// In en, this message translates to:
  /// **'Get notified when an approval request is escalated'**
  String get notifPrefScreenDescApprovalRequestEscalated;

  /// No description provided for @notifPrefScreenDescApprovalRequestExpiring.
  ///
  /// In en, this message translates to:
  /// **'Get notified when an approval request is about to expire'**
  String get notifPrefScreenDescApprovalRequestExpiring;

  /// No description provided for @notifPrefScreenDescApprovalRequestComment.
  ///
  /// In en, this message translates to:
  /// **'Get notified about comments on approval requests'**
  String get notifPrefScreenDescApprovalRequestComment;

  /// No description provided for @homeNavFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get homeNavFeatures;

  /// No description provided for @homeNavAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get homeNavAbout;

  /// No description provided for @homeNavContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get homeNavContact;

  /// No description provided for @homeNavLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get homeNavLogin;

  /// No description provided for @homeNavSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get homeNavSignUp;

  /// No description provided for @homeNavAccountTypes.
  ///
  /// In en, this message translates to:
  /// **'Account Types'**
  String get homeNavAccountTypes;

  /// No description provided for @homeNavStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get homeNavStudents;

  /// No description provided for @homeNavInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Institutions'**
  String get homeNavInstitutions;

  /// No description provided for @homeNavParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get homeNavParents;

  /// No description provided for @homeNavCounselors.
  ///
  /// In en, this message translates to:
  /// **'Counselors'**
  String get homeNavCounselors;

  /// No description provided for @homeNavRecommenders.
  ///
  /// In en, this message translates to:
  /// **'Recommenders'**
  String get homeNavRecommenders;

  /// No description provided for @homeNavBadge.
  ///
  /// In en, this message translates to:
  /// **'Africa\'s Premier EdTech Platform'**
  String get homeNavBadge;

  /// No description provided for @homeNavWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flow'**
  String get homeNavWelcome;

  /// No description provided for @homeNavSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect students, institutions, parents, counselors across Africa. Offline-first with mobile money.'**
  String get homeNavSubtitle;

  /// No description provided for @homeNavGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get homeNavGetStarted;

  /// No description provided for @homeNavSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get homeNavSignIn;

  /// No description provided for @homeNavActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get homeNavActiveUsers;

  /// No description provided for @homeNavCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get homeNavCountries;

  /// No description provided for @homeNavNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get homeNavNew;

  /// No description provided for @homeNavFindYourPath.
  ///
  /// In en, this message translates to:
  /// **'Find Your Path'**
  String get homeNavFindYourPath;

  /// No description provided for @homeNavFindYourPathDesc.
  ///
  /// In en, this message translates to:
  /// **'Answer a few questions and get personalized university recommendations.'**
  String get homeNavFindYourPathDesc;

  /// No description provided for @homeNavPersonalizedRec.
  ///
  /// In en, this message translates to:
  /// **'Personalized Recommendations'**
  String get homeNavPersonalizedRec;

  /// No description provided for @homeNavTopUniversities.
  ///
  /// In en, this message translates to:
  /// **'12+ Top Universities'**
  String get homeNavTopUniversities;

  /// No description provided for @homeNavSmartMatching.
  ///
  /// In en, this message translates to:
  /// **'Smart Matching Algorithm'**
  String get homeNavSmartMatching;

  /// No description provided for @homeNavStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get homeNavStartNow;

  /// No description provided for @homeNavPlatformFeatures.
  ///
  /// In en, this message translates to:
  /// **'Platform Features'**
  String get homeNavPlatformFeatures;

  /// No description provided for @homeNavOfflineFirst.
  ///
  /// In en, this message translates to:
  /// **'Offline-First Design'**
  String get homeNavOfflineFirst;

  /// No description provided for @homeNavOfflineFirstDesc.
  ///
  /// In en, this message translates to:
  /// **'Access your content even without internet connectivity'**
  String get homeNavOfflineFirstDesc;

  /// No description provided for @homeNavMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Integration'**
  String get homeNavMobileMoney;

  /// No description provided for @homeNavMobileMoneyDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay with M-Pesa, MTN, and other mobile money services'**
  String get homeNavMobileMoneyDesc;

  /// No description provided for @homeNavMultiLang.
  ///
  /// In en, this message translates to:
  /// **'Multi-Language Support'**
  String get homeNavMultiLang;

  /// No description provided for @homeNavMultiLangDesc.
  ///
  /// In en, this message translates to:
  /// **'Available in English, French, Swahili, and more'**
  String get homeNavMultiLangDesc;

  /// No description provided for @homeNavSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure & Private'**
  String get homeNavSecure;

  /// No description provided for @homeNavSecureDesc.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encryption for all your data'**
  String get homeNavSecureDesc;

  /// No description provided for @homeNavUssd.
  ///
  /// In en, this message translates to:
  /// **'USSD Support'**
  String get homeNavUssd;

  /// No description provided for @homeNavUssdDesc.
  ///
  /// In en, this message translates to:
  /// **'Access features via basic phones without internet'**
  String get homeNavUssdDesc;

  /// No description provided for @homeNavCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get homeNavCloudSync;

  /// No description provided for @homeNavCloudSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync across all your devices'**
  String get homeNavCloudSyncDesc;

  /// No description provided for @homeNavHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get homeNavHowItWorks;

  /// No description provided for @homeNavCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get homeNavCreateAccount;

  /// No description provided for @homeNavCreateAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign up with your role - student, institution, parent, counselor, or recommender'**
  String get homeNavCreateAccountDesc;

  /// No description provided for @homeNavAccessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Access Dashboard'**
  String get homeNavAccessDashboard;

  /// No description provided for @homeNavAccessDashboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Get a personalized dashboard tailored to your needs'**
  String get homeNavAccessDashboardDesc;

  /// No description provided for @homeNavExploreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Explore Features'**
  String get homeNavExploreFeatures;

  /// No description provided for @homeNavExploreFeaturesDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse courses, applications, or manage your responsibilities'**
  String get homeNavExploreFeaturesDesc;

  /// No description provided for @homeNavAchieveGoals.
  ///
  /// In en, this message translates to:
  /// **'Achieve Goals'**
  String get homeNavAchieveGoals;

  /// No description provided for @homeNavAchieveGoalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track progress, collaborate, and reach your educational objectives'**
  String get homeNavAchieveGoalsDesc;

  /// No description provided for @homeNavTrustedAcrossAfrica.
  ///
  /// In en, this message translates to:
  /// **'Trusted Across Africa'**
  String get homeNavTrustedAcrossAfrica;

  /// No description provided for @homeNavTestimonialRole1.
  ///
  /// In en, this message translates to:
  /// **'Student, University of Ghana'**
  String get homeNavTestimonialRole1;

  /// No description provided for @homeNavTestimonialQuote1.
  ///
  /// In en, this message translates to:
  /// **'Flow made my application process so much easier. I could track everything in one place!'**
  String get homeNavTestimonialQuote1;

  /// No description provided for @homeNavTestimonialRole2.
  ///
  /// In en, this message translates to:
  /// **'Dean, Ashesi University'**
  String get homeNavTestimonialRole2;

  /// No description provided for @homeNavTestimonialQuote2.
  ///
  /// In en, this message translates to:
  /// **'Managing applications has never been this efficient. Flow is a game-changer for institutions.'**
  String get homeNavTestimonialQuote2;

  /// No description provided for @homeNavTestimonialRole3.
  ///
  /// In en, this message translates to:
  /// **'Parent, Nigeria'**
  String get homeNavTestimonialRole3;

  /// No description provided for @homeNavTestimonialQuote3.
  ///
  /// In en, this message translates to:
  /// **'I can now monitor my children\'s academic progress even when I\'m traveling. Peace of mind!'**
  String get homeNavTestimonialQuote3;

  /// No description provided for @homeNavWhoCanUse.
  ///
  /// In en, this message translates to:
  /// **'Who Can Use Flow?'**
  String get homeNavWhoCanUse;

  /// No description provided for @homeNavForStudents.
  ///
  /// In en, this message translates to:
  /// **'For Students'**
  String get homeNavForStudents;

  /// No description provided for @homeNavForStudentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your gateway to academic success'**
  String get homeNavForStudentsSubtitle;

  /// No description provided for @homeNavForStudentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Flow empowers students to take control of their educational journey with comprehensive tools designed for modern learners across Africa.'**
  String get homeNavForStudentsDesc;

  /// No description provided for @homeNavCourseAccess.
  ///
  /// In en, this message translates to:
  /// **'Course Access'**
  String get homeNavCourseAccess;

  /// No description provided for @homeNavCourseAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse and enroll in thousands of courses from top institutions across Africa'**
  String get homeNavCourseAccessDesc;

  /// No description provided for @homeNavAppManagement.
  ///
  /// In en, this message translates to:
  /// **'Application Management'**
  String get homeNavAppManagement;

  /// No description provided for @homeNavAppManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply to multiple institutions, track application status, and manage deadlines in one place'**
  String get homeNavAppManagementDesc;

  /// No description provided for @homeNavProgressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get homeNavProgressTracking;

  /// No description provided for @homeNavProgressTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your academic progress with detailed analytics and performance insights'**
  String get homeNavProgressTrackingDesc;

  /// No description provided for @homeNavDocManagement.
  ///
  /// In en, this message translates to:
  /// **'Document Management'**
  String get homeNavDocManagement;

  /// No description provided for @homeNavDocManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Store and share transcripts, certificates, and other academic documents securely'**
  String get homeNavDocManagementDesc;

  /// No description provided for @homeNavEasyPayments.
  ///
  /// In en, this message translates to:
  /// **'Easy Payments'**
  String get homeNavEasyPayments;

  /// No description provided for @homeNavEasyPaymentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay tuition and fees using mobile money services like M-Pesa, MTN Money, and more'**
  String get homeNavEasyPaymentsDesc;

  /// No description provided for @homeNavOfflineAccess.
  ///
  /// In en, this message translates to:
  /// **'Offline Access'**
  String get homeNavOfflineAccess;

  /// No description provided for @homeNavOfflineAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Download course materials and access them without internet connectivity'**
  String get homeNavOfflineAccessDesc;

  /// No description provided for @homeNavForInstitutions.
  ///
  /// In en, this message translates to:
  /// **'For Institutions'**
  String get homeNavForInstitutions;

  /// No description provided for @homeNavForInstitutionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Streamline admissions and student management'**
  String get homeNavForInstitutionsSubtitle;

  /// No description provided for @homeNavForInstitutionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Transform your institution\'s operations with powerful tools for admissions, student management, and program delivery.'**
  String get homeNavForInstitutionsDesc;

  /// No description provided for @homeNavApplicantMgmt.
  ///
  /// In en, this message translates to:
  /// **'Applicant Management'**
  String get homeNavApplicantMgmt;

  /// No description provided for @homeNavApplicantMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Review, process, and track applications efficiently with automated workflows'**
  String get homeNavApplicantMgmtDesc;

  /// No description provided for @homeNavProgramMgmt.
  ///
  /// In en, this message translates to:
  /// **'Program Management'**
  String get homeNavProgramMgmt;

  /// No description provided for @homeNavProgramMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and manage academic programs, set requirements, and track enrollments'**
  String get homeNavProgramMgmtDesc;

  /// No description provided for @homeNavAnalyticsDash.
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get homeNavAnalyticsDash;

  /// No description provided for @homeNavAnalyticsDashDesc.
  ///
  /// In en, this message translates to:
  /// **'Get insights into application trends, student performance, and institutional metrics'**
  String get homeNavAnalyticsDashDesc;

  /// No description provided for @homeNavCommHub.
  ///
  /// In en, this message translates to:
  /// **'Communication Hub'**
  String get homeNavCommHub;

  /// No description provided for @homeNavCommHubDesc.
  ///
  /// In en, this message translates to:
  /// **'Engage with students, parents, and staff through integrated messaging'**
  String get homeNavCommHubDesc;

  /// No description provided for @homeNavDocVerification.
  ///
  /// In en, this message translates to:
  /// **'Document Verification'**
  String get homeNavDocVerification;

  /// No description provided for @homeNavDocVerificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify student documents and credentials securely'**
  String get homeNavDocVerificationDesc;

  /// No description provided for @homeNavFinancialMgmt.
  ///
  /// In en, this message translates to:
  /// **'Financial Management'**
  String get homeNavFinancialMgmt;

  /// No description provided for @homeNavFinancialMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Track payments, manage scholarships, and generate financial reports'**
  String get homeNavFinancialMgmtDesc;

  /// No description provided for @homeNavForParents.
  ///
  /// In en, this message translates to:
  /// **'For Parents'**
  String get homeNavForParents;

  /// No description provided for @homeNavForParentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay connected to your child\'s education'**
  String get homeNavForParentsSubtitle;

  /// No description provided for @homeNavForParentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay informed and engaged in your children\'s educational journey with real-time updates and comprehensive monitoring tools.'**
  String get homeNavForParentsDesc;

  /// No description provided for @homeNavProgressMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Progress Monitoring'**
  String get homeNavProgressMonitoring;

  /// No description provided for @homeNavProgressMonitoringDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your children\'s academic performance, attendance, and achievements'**
  String get homeNavProgressMonitoringDesc;

  /// No description provided for @homeNavRealtimeUpdates.
  ///
  /// In en, this message translates to:
  /// **'Real-time Updates'**
  String get homeNavRealtimeUpdates;

  /// No description provided for @homeNavRealtimeUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive instant notifications about grades, assignments, and school events'**
  String get homeNavRealtimeUpdatesDesc;

  /// No description provided for @homeNavTeacherComm.
  ///
  /// In en, this message translates to:
  /// **'Teacher Communication'**
  String get homeNavTeacherComm;

  /// No description provided for @homeNavTeacherCommDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect directly with teachers and counselors about your child\'s progress'**
  String get homeNavTeacherCommDesc;

  /// No description provided for @homeNavFeeMgmt.
  ///
  /// In en, this message translates to:
  /// **'Fee Management'**
  String get homeNavFeeMgmt;

  /// No description provided for @homeNavFeeMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'View and pay school fees conveniently using mobile money'**
  String get homeNavFeeMgmtDesc;

  /// No description provided for @homeNavScheduleAccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule Access'**
  String get homeNavScheduleAccess;

  /// No description provided for @homeNavScheduleAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'View class schedules, exam dates, and school calendar events'**
  String get homeNavScheduleAccessDesc;

  /// No description provided for @homeNavReportCards.
  ///
  /// In en, this message translates to:
  /// **'Report Cards'**
  String get homeNavReportCards;

  /// No description provided for @homeNavReportCardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Access detailed report cards and performance summaries'**
  String get homeNavReportCardsDesc;

  /// No description provided for @homeNavForCounselors.
  ///
  /// In en, this message translates to:
  /// **'For Counselors'**
  String get homeNavForCounselors;

  /// No description provided for @homeNavForCounselorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guide students to their best future'**
  String get homeNavForCounselorsSubtitle;

  /// No description provided for @homeNavForCounselorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Empower your counseling practice with tools to manage sessions, track student progress, and provide personalized guidance.'**
  String get homeNavForCounselorsDesc;

  /// No description provided for @homeNavSessionMgmt.
  ///
  /// In en, this message translates to:
  /// **'Session Management'**
  String get homeNavSessionMgmt;

  /// No description provided for @homeNavSessionMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedule, track, and document counseling sessions with students'**
  String get homeNavSessionMgmtDesc;

  /// No description provided for @homeNavStudentPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Student Portfolio'**
  String get homeNavStudentPortfolio;

  /// No description provided for @homeNavStudentPortfolioDesc.
  ///
  /// In en, this message translates to:
  /// **'Maintain comprehensive profiles and notes for each student you counsel'**
  String get homeNavStudentPortfolioDesc;

  /// No description provided for @homeNavActionPlans.
  ///
  /// In en, this message translates to:
  /// **'Action Plans'**
  String get homeNavActionPlans;

  /// No description provided for @homeNavActionPlansDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and monitor personalized action plans and goals for students'**
  String get homeNavActionPlansDesc;

  /// No description provided for @homeNavCollegeGuidance.
  ///
  /// In en, this message translates to:
  /// **'College Guidance'**
  String get homeNavCollegeGuidance;

  /// No description provided for @homeNavCollegeGuidanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Help students explore programs and navigate the application process'**
  String get homeNavCollegeGuidanceDesc;

  /// No description provided for @homeNavCareerAssessment.
  ///
  /// In en, this message translates to:
  /// **'Career Assessment'**
  String get homeNavCareerAssessment;

  /// No description provided for @homeNavCareerAssessmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Provide career assessments and recommend suitable paths'**
  String get homeNavCareerAssessmentDesc;

  /// No description provided for @homeNavParentCollab.
  ///
  /// In en, this message translates to:
  /// **'Parent Collaboration'**
  String get homeNavParentCollab;

  /// No description provided for @homeNavParentCollabDesc.
  ///
  /// In en, this message translates to:
  /// **'Coordinate with parents to support student success'**
  String get homeNavParentCollabDesc;

  /// No description provided for @homeNavForRecommenders.
  ///
  /// In en, this message translates to:
  /// **'For Recommenders'**
  String get homeNavForRecommenders;

  /// No description provided for @homeNavForRecommendersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support students with powerful recommendations'**
  String get homeNavForRecommendersSubtitle;

  /// No description provided for @homeNavForRecommendersDesc.
  ///
  /// In en, this message translates to:
  /// **'Write, manage, and submit recommendation letters efficiently while maintaining your professional network.'**
  String get homeNavForRecommendersDesc;

  /// No description provided for @homeNavLetterMgmt.
  ///
  /// In en, this message translates to:
  /// **'Letter Management'**
  String get homeNavLetterMgmt;

  /// No description provided for @homeNavLetterMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Write, edit, and store recommendation letters with templates'**
  String get homeNavLetterMgmtDesc;

  /// No description provided for @homeNavEasySubmission.
  ///
  /// In en, this message translates to:
  /// **'Easy Submission'**
  String get homeNavEasySubmission;

  /// No description provided for @homeNavEasySubmissionDesc.
  ///
  /// In en, this message translates to:
  /// **'Submit recommendations directly to institutions securely'**
  String get homeNavEasySubmissionDesc;

  /// No description provided for @homeNavRequestTracking.
  ///
  /// In en, this message translates to:
  /// **'Request Tracking'**
  String get homeNavRequestTracking;

  /// No description provided for @homeNavRequestTrackingDesc.
  ///
  /// In en, this message translates to:
  /// **'Track all recommendation requests and deadlines in one place'**
  String get homeNavRequestTrackingDesc;

  /// No description provided for @homeNavLetterTemplates.
  ///
  /// In en, this message translates to:
  /// **'Letter Templates'**
  String get homeNavLetterTemplates;

  /// No description provided for @homeNavLetterTemplatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Use customizable templates to streamline your writing process'**
  String get homeNavLetterTemplatesDesc;

  /// No description provided for @homeNavDigitalSignature.
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get homeNavDigitalSignature;

  /// No description provided for @homeNavDigitalSignatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign and verify letters digitally with secure authentication'**
  String get homeNavDigitalSignatureDesc;

  /// No description provided for @homeNavStudentHistory.
  ///
  /// In en, this message translates to:
  /// **'Student History'**
  String get homeNavStudentHistory;

  /// No description provided for @homeNavStudentHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Maintain records of students you\'ve recommended over time'**
  String get homeNavStudentHistoryDesc;

  /// No description provided for @homeNavReadyToStart.
  ///
  /// In en, this message translates to:
  /// **'Ready to Get Started?'**
  String get homeNavReadyToStart;

  /// No description provided for @homeNavJoinThousands.
  ///
  /// In en, this message translates to:
  /// **'Join thousands transforming education with Flow.'**
  String get homeNavJoinThousands;

  /// No description provided for @homeNavFlowEdTech.
  ///
  /// In en, this message translates to:
  /// **'Flow EdTech'**
  String get homeNavFlowEdTech;

  /// No description provided for @homeNavPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get homeNavPrivacy;

  /// No description provided for @homeNavTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get homeNavTerms;

  /// No description provided for @homeNavCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Flow EdTech'**
  String get homeNavCopyright;

  /// No description provided for @homeNavTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get homeNavTop;

  /// No description provided for @homeNavGetStartedAs.
  ///
  /// In en, this message translates to:
  /// **'Get Started as {role}'**
  String homeNavGetStartedAs(String role);

  /// No description provided for @homeNavForPrefix.
  ///
  /// In en, this message translates to:
  /// **'For '**
  String get homeNavForPrefix;

  /// No description provided for @aboutPageTitle.
  ///
  /// In en, this message translates to:
  /// **'About Flow'**
  String get aboutPageTitle;

  /// No description provided for @aboutPageFlowEdTech.
  ///
  /// In en, this message translates to:
  /// **'Flow EdTech'**
  String get aboutPageFlowEdTech;

  /// No description provided for @aboutPagePremierPlatform.
  ///
  /// In en, this message translates to:
  /// **'Africa\'s Premier Education Platform'**
  String get aboutPagePremierPlatform;

  /// No description provided for @aboutPageOurMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get aboutPageOurMission;

  /// No description provided for @aboutPageMissionContent.
  ///
  /// In en, this message translates to:
  /// **'Flow is dedicated to transforming education across Africa by connecting students with universities, counselors, and resources they need to succeed.'**
  String get aboutPageMissionContent;

  /// No description provided for @aboutPageOurVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get aboutPageOurVision;

  /// No description provided for @aboutPageVisionContent.
  ///
  /// In en, this message translates to:
  /// **'We envision a future where every African student has the tools, information, and support needed to achieve their educational dreams.'**
  String get aboutPageVisionContent;

  /// No description provided for @aboutPageOurStory.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get aboutPageOurStory;

  /// No description provided for @aboutPageOurValues.
  ///
  /// In en, this message translates to:
  /// **'Our Values'**
  String get aboutPageOurValues;

  /// No description provided for @aboutPageGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get aboutPageGetInTouch;

  /// No description provided for @privacyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPageTitle;

  /// No description provided for @privacyPageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: January 2026'**
  String get privacyPageLastUpdated;

  /// No description provided for @privacyPageSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacyPageSection1Title;

  /// No description provided for @privacyPageSection1Content.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us, such as when you create an account, fill out a form, or communicate with us. This may include:\n\n- Personal information (name, email, phone number)\n- Educational information (grades, test scores, preferences)\n- Account credentials\n- Communication preferences\n- Usage data and analytics'**
  String get privacyPageSection1Content;

  /// No description provided for @privacyPageSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacyPageSection2Title;

  /// No description provided for @privacyPageSection2Content.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to:\n\n- Provide, maintain, and improve our services\n- Match you with suitable universities and programs\n- Send you relevant notifications and updates\n- Respond to your inquiries and support requests\n- Analyze usage patterns to improve user experience\n- Comply with legal obligations'**
  String get privacyPageSection2Content;

  /// No description provided for @privacyPageSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Information Sharing'**
  String get privacyPageSection3Title;

  /// No description provided for @privacyPageSection3Content.
  ///
  /// In en, this message translates to:
  /// **'We may share your information with:\n\n- Universities and institutions you express interest in\n- Counselors you choose to connect with\n- Parents/guardians (with your consent)\n- Service providers who assist our operations\n- Legal authorities when required by law\n\nWe do not sell your personal information to third parties.'**
  String get privacyPageSection3Content;

  /// No description provided for @privacyPageSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security'**
  String get privacyPageSection4Title;

  /// No description provided for @privacyPageSection4Content.
  ///
  /// In en, this message translates to:
  /// **'We implement industry-standard security measures to protect your data:\n\n- Encryption of data in transit and at rest\n- Regular security audits and assessments\n- Access controls and authentication\n- Secure data centers with SOC 2 compliance'**
  String get privacyPageSection4Content;

  /// No description provided for @privacyPageSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get privacyPageSection5Title;

  /// No description provided for @privacyPageSection5Content.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n\n- Access your personal data\n- Correct inaccurate information\n- Delete your account and data\n- Export your data in a portable format\n- Opt out of marketing communications\n- Withdraw consent at any time'**
  String get privacyPageSection5Content;

  /// No description provided for @privacyPageSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Contact Us'**
  String get privacyPageSection6Title;

  /// No description provided for @privacyPageSection6Content.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this privacy policy, please contact us at:\n\nEmail: privacy@flowedtech.com\nAddress: Accra, Ghana'**
  String get privacyPageSection6Content;

  /// No description provided for @privacyPageContactTeam.
  ///
  /// In en, this message translates to:
  /// **'Contact Privacy Team'**
  String get privacyPageContactTeam;

  /// No description provided for @privacyPageLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String privacyPageLastUpdatedLabel(String date);

  /// No description provided for @termsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsPageTitle;

  /// No description provided for @termsPageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: January 2026'**
  String get termsPageLastUpdated;

  /// No description provided for @termsPageSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get termsPageSection1Title;

  /// No description provided for @termsPageSection1Content.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using Flow EdTech (\"the Service\"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our Service.'**
  String get termsPageSection1Content;

  /// No description provided for @termsPageSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. User Accounts'**
  String get termsPageSection2Title;

  /// No description provided for @termsPageSection2Content.
  ///
  /// In en, this message translates to:
  /// **'To use certain features, you must create an account. You agree to provide accurate and complete information, maintain the security of your account credentials, and take responsibility for all activities under your account.'**
  String get termsPageSection2Content;

  /// No description provided for @termsPageSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. User Conduct'**
  String get termsPageSection3Title;

  /// No description provided for @termsPageSection3Content.
  ///
  /// In en, this message translates to:
  /// **'You agree not to use the Service for any unlawful purpose, harass other users, submit false information, or attempt to gain unauthorized access to systems.'**
  String get termsPageSection3Content;

  /// No description provided for @termsPageSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Limitation of Liability'**
  String get termsPageSection4Title;

  /// No description provided for @termsPageSection4Content.
  ///
  /// In en, this message translates to:
  /// **'THE SERVICE IS PROVIDED \"AS IS\" WITHOUT WARRANTIES OF ANY KIND. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED.'**
  String get termsPageSection4Content;

  /// No description provided for @termsPageSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Contact'**
  String get termsPageSection5Title;

  /// No description provided for @termsPageSection5Content.
  ///
  /// In en, this message translates to:
  /// **'For questions about these terms, contact us at: legal@flowedtech.com'**
  String get termsPageSection5Content;

  /// No description provided for @termsPageAgreement.
  ///
  /// In en, this message translates to:
  /// **'By using Flow, you agree to these terms'**
  String get termsPageAgreement;

  /// No description provided for @contactPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactPageTitle;

  /// No description provided for @contactPageGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get contactPageGetInTouch;

  /// No description provided for @contactPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Have questions? We\'d love to hear from you.'**
  String get contactPageSubtitle;

  /// No description provided for @contactPageEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactPageEmail;

  /// No description provided for @contactPageEmailValue.
  ///
  /// In en, this message translates to:
  /// **'support@flowedtech.com'**
  String get contactPageEmailValue;

  /// No description provided for @contactPageEmailReply.
  ///
  /// In en, this message translates to:
  /// **'We reply within 24 hours'**
  String get contactPageEmailReply;

  /// No description provided for @contactPageOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get contactPageOffice;

  /// No description provided for @contactPageOfficeValue.
  ///
  /// In en, this message translates to:
  /// **'Accra, Ghana'**
  String get contactPageOfficeValue;

  /// No description provided for @contactPageOfficeRegion.
  ///
  /// In en, this message translates to:
  /// **'West Africa'**
  String get contactPageOfficeRegion;

  /// No description provided for @contactPageHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get contactPageHours;

  /// No description provided for @contactPageHoursValue.
  ///
  /// In en, this message translates to:
  /// **'Mon - Fri: 9AM - 6PM'**
  String get contactPageHoursValue;

  /// No description provided for @contactPageHoursTimezone.
  ///
  /// In en, this message translates to:
  /// **'GMT timezone'**
  String get contactPageHoursTimezone;

  /// No description provided for @contactPageSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get contactPageSendMessage;

  /// No description provided for @contactPageYourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get contactPageYourName;

  /// No description provided for @contactPageEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get contactPageEmailAddress;

  /// No description provided for @contactPageSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactPageSubject;

  /// No description provided for @contactPageMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactPageMessage;

  /// No description provided for @contactPageSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get contactPageSendButton;

  /// No description provided for @contactPageNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get contactPageNameRequired;

  /// No description provided for @contactPageEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get contactPageEmailRequired;

  /// No description provided for @contactPageEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get contactPageEmailInvalid;

  /// No description provided for @contactPageSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject'**
  String get contactPageSubjectRequired;

  /// No description provided for @contactPageMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get contactPageMessageRequired;

  /// No description provided for @contactPageSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your message! We will get back to you soon.'**
  String get contactPageSuccessMessage;

  /// No description provided for @blogPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Flow Blog'**
  String get blogPageTitle;

  /// No description provided for @blogPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Insights, tips, and stories about education in Africa'**
  String get blogPageSubtitle;

  /// No description provided for @blogPageCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get blogPageCategories;

  /// No description provided for @blogPageAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get blogPageAll;

  /// No description provided for @blogPageRecentPosts.
  ///
  /// In en, this message translates to:
  /// **'Recent Posts'**
  String get blogPageRecentPosts;

  /// No description provided for @blogPageFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get blogPageFeatured;

  /// No description provided for @blogPageSubscribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Our Newsletter'**
  String get blogPageSubscribeTitle;

  /// No description provided for @blogPageSubscribeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get the latest articles and resources delivered to your inbox'**
  String get blogPageSubscribeSubtitle;

  /// No description provided for @blogPageEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get blogPageEnterEmail;

  /// No description provided for @blogPageSubscribeButton.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get blogPageSubscribeButton;

  /// No description provided for @careersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Careers'**
  String get careersPageTitle;

  /// No description provided for @careersPageJoinMission.
  ///
  /// In en, this message translates to:
  /// **'Join Our Mission'**
  String get careersPageJoinMission;

  /// No description provided for @careersPageHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us transform education across Africa'**
  String get careersPageHeroSubtitle;

  /// No description provided for @careersPageWhyJoin.
  ///
  /// In en, this message translates to:
  /// **'Why Join Flow?'**
  String get careersPageWhyJoin;

  /// No description provided for @careersPageGlobalImpact.
  ///
  /// In en, this message translates to:
  /// **'Global Impact'**
  String get careersPageGlobalImpact;

  /// No description provided for @careersPageGlobalImpactDesc.
  ///
  /// In en, this message translates to:
  /// **'Work on solutions that affect millions of students across Africa'**
  String get careersPageGlobalImpactDesc;

  /// No description provided for @careersPageGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get careersPageGrowth;

  /// No description provided for @careersPageGrowthDesc.
  ///
  /// In en, this message translates to:
  /// **'Continuous learning and career development opportunities'**
  String get careersPageGrowthDesc;

  /// No description provided for @careersPageGreatTeam.
  ///
  /// In en, this message translates to:
  /// **'Great Team'**
  String get careersPageGreatTeam;

  /// No description provided for @careersPageGreatTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Collaborate with passionate and talented individuals'**
  String get careersPageGreatTeamDesc;

  /// No description provided for @careersPageFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get careersPageFlexibility;

  /// No description provided for @careersPageFlexibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Remote-friendly culture with flexible working hours'**
  String get careersPageFlexibilityDesc;

  /// No description provided for @careersPageOpenPositions.
  ///
  /// In en, this message translates to:
  /// **'Open Positions'**
  String get careersPageOpenPositions;

  /// No description provided for @careersPageApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get careersPageApply;

  /// No description provided for @careersPageNoFit.
  ///
  /// In en, this message translates to:
  /// **'Don\'t see a perfect fit?'**
  String get careersPageNoFit;

  /// No description provided for @careersPageNoFitDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'re always looking for talented individuals. Send your resume to careers@flowedtech.com'**
  String get careersPageNoFitDesc;

  /// No description provided for @careersPageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get careersPageContactUs;

  /// No description provided for @communityPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Our Community'**
  String get communityPageTitle;

  /// No description provided for @communityPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with students, counselors, and educators'**
  String get communityPageSubtitle;

  /// No description provided for @communityPageMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get communityPageMembers;

  /// No description provided for @communityPageGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get communityPageGroups;

  /// No description provided for @communityPageDiscussions.
  ///
  /// In en, this message translates to:
  /// **'Discussions'**
  String get communityPageDiscussions;

  /// No description provided for @communityPageFeaturedGroups.
  ///
  /// In en, this message translates to:
  /// **'Featured Groups'**
  String get communityPageFeaturedGroups;

  /// No description provided for @communityPagePopularDiscussions.
  ///
  /// In en, this message translates to:
  /// **'Popular Discussions'**
  String get communityPagePopularDiscussions;

  /// No description provided for @communityPageUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get communityPageUpcomingEvents;

  /// No description provided for @communityPageAttending.
  ///
  /// In en, this message translates to:
  /// **'attending'**
  String get communityPageAttending;

  /// No description provided for @communityPageJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get communityPageJoin;

  /// No description provided for @communityPageReadyToJoin.
  ///
  /// In en, this message translates to:
  /// **'Ready to Join?'**
  String get communityPageReadyToJoin;

  /// No description provided for @communityPageCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account to join the community'**
  String get communityPageCreateAccount;

  /// No description provided for @communityPageSignUpFree.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Free'**
  String get communityPageSignUpFree;

  /// No description provided for @communityPageBy.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String communityPageBy(String author);

  /// No description provided for @compliancePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get compliancePageTitle;

  /// No description provided for @compliancePageHeadline.
  ///
  /// In en, this message translates to:
  /// **'Compliance & Certifications'**
  String get compliancePageHeadline;

  /// No description provided for @compliancePageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our commitment to security, privacy, and regulatory compliance'**
  String get compliancePageSubtitle;

  /// No description provided for @compliancePageCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get compliancePageCertifications;

  /// No description provided for @compliancePageSoc2.
  ///
  /// In en, this message translates to:
  /// **'SOC 2 Type II'**
  String get compliancePageSoc2;

  /// No description provided for @compliancePageSoc2Desc.
  ///
  /// In en, this message translates to:
  /// **'Certified for security, availability, and confidentiality'**
  String get compliancePageSoc2Desc;

  /// No description provided for @compliancePageIso.
  ///
  /// In en, this message translates to:
  /// **'ISO 27001'**
  String get compliancePageIso;

  /// No description provided for @compliancePageIsoDesc.
  ///
  /// In en, this message translates to:
  /// **'Information security management certification'**
  String get compliancePageIsoDesc;

  /// No description provided for @compliancePageGdpr.
  ///
  /// In en, this message translates to:
  /// **'GDPR Compliant'**
  String get compliancePageGdpr;

  /// No description provided for @compliancePageGdprDesc.
  ///
  /// In en, this message translates to:
  /// **'EU General Data Protection Regulation'**
  String get compliancePageGdprDesc;

  /// No description provided for @compliancePageDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get compliancePageDataProtection;

  /// No description provided for @compliancePageDataProtectionContent.
  ///
  /// In en, this message translates to:
  /// **'We implement comprehensive data protection measures to safeguard your information:\n\n• End-to-end encryption for data in transit\n• AES-256 encryption for data at rest\n• Regular security audits and penetration testing\n• Multi-factor authentication support\n• Role-based access control\n• Automated backup and disaster recovery'**
  String get compliancePageDataProtectionContent;

  /// No description provided for @compliancePagePrivacyPractices.
  ///
  /// In en, this message translates to:
  /// **'Privacy Practices'**
  String get compliancePagePrivacyPractices;

  /// No description provided for @compliancePagePrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Our privacy practices are designed to protect your rights:\n\n• Transparent data collection and usage policies\n• User consent management for data processing\n• Data minimization principles\n• Right to access, rectify, and delete personal data\n• Data portability support\n• Regular privacy impact assessments'**
  String get compliancePagePrivacyContent;

  /// No description provided for @compliancePageRegulatory.
  ///
  /// In en, this message translates to:
  /// **'Regulatory Compliance'**
  String get compliancePageRegulatory;

  /// No description provided for @compliancePageRegulatoryContent.
  ///
  /// In en, this message translates to:
  /// **'Flow adheres to international and regional regulations:\n\n• General Data Protection Regulation (GDPR) - EU\n• Protection of Personal Information Act (POPIA) - South Africa\n• Data Protection Act - Ghana, Kenya, Nigeria\n• Children\'s Online Privacy Protection Act (COPPA)\n• California Consumer Privacy Act (CCPA)'**
  String get compliancePageRegulatoryContent;

  /// No description provided for @compliancePageThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Security'**
  String get compliancePageThirdParty;

  /// No description provided for @compliancePageThirdPartyContent.
  ///
  /// In en, this message translates to:
  /// **'We carefully vet and monitor our third-party service providers:\n\n• Vendor security assessments\n• Data processing agreements\n• Subprocessor transparency\n• Regular compliance reviews\n• Incident response coordination'**
  String get compliancePageThirdPartyContent;

  /// No description provided for @compliancePageSecurityPractices.
  ///
  /// In en, this message translates to:
  /// **'Security Practices'**
  String get compliancePageSecurityPractices;

  /// No description provided for @compliancePageRegularUpdates.
  ///
  /// In en, this message translates to:
  /// **'Regular Updates'**
  String get compliancePageRegularUpdates;

  /// No description provided for @compliancePageRegularUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Security patches and updates deployed continuously'**
  String get compliancePageRegularUpdatesDesc;

  /// No description provided for @compliancePageBugBounty.
  ///
  /// In en, this message translates to:
  /// **'Bug Bounty Program'**
  String get compliancePageBugBounty;

  /// No description provided for @compliancePageBugBountyDesc.
  ///
  /// In en, this message translates to:
  /// **'Responsible disclosure program for security researchers'**
  String get compliancePageBugBountyDesc;

  /// No description provided for @compliancePageMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get compliancePageMonitoring;

  /// No description provided for @compliancePageMonitoringDesc.
  ///
  /// In en, this message translates to:
  /// **'24/7 security monitoring and threat detection'**
  String get compliancePageMonitoringDesc;

  /// No description provided for @compliancePageAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get compliancePageAuditLogs;

  /// No description provided for @compliancePageAuditLogsDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive logging of all security events'**
  String get compliancePageAuditLogsDesc;

  /// No description provided for @compliancePageQuestions.
  ///
  /// In en, this message translates to:
  /// **'Compliance Questions?'**
  String get compliancePageQuestions;

  /// No description provided for @compliancePageContactTeam.
  ///
  /// In en, this message translates to:
  /// **'Contact our compliance team for inquiries'**
  String get compliancePageContactTeam;

  /// No description provided for @compliancePageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String compliancePageLastUpdated(String date);

  /// No description provided for @cookiesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get cookiesPageTitle;

  /// No description provided for @cookiesPageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: January 2026'**
  String get cookiesPageLastUpdated;

  /// No description provided for @cookiesPageWhatAreCookies.
  ///
  /// In en, this message translates to:
  /// **'What Are Cookies?'**
  String get cookiesPageWhatAreCookies;

  /// No description provided for @cookiesPageWhatAreCookiesContent.
  ///
  /// In en, this message translates to:
  /// **'Cookies are small text files that are stored on your device when you visit a website. They help the website remember information about your visit, like your preferred language and other settings, which can make your next visit easier.\n\nWe use cookies and similar technologies to provide, protect, and improve our services.'**
  String get cookiesPageWhatAreCookiesContent;

  /// No description provided for @cookiesPageHowWeUse.
  ///
  /// In en, this message translates to:
  /// **'How We Use Cookies'**
  String get cookiesPageHowWeUse;

  /// No description provided for @cookiesPageHowWeUseContent.
  ///
  /// In en, this message translates to:
  /// **'We use different types of cookies for various purposes:\n\n**Essential Cookies**\nThese cookies are necessary for the website to function properly. They enable basic features like page navigation, secure access to protected areas, and remembering your login state.\n\n**Performance Cookies**\nThese cookies help us understand how visitors interact with our website. They collect information about page visits, time spent on pages, and any error messages encountered.\n\n**Functionality Cookies**\nThese cookies enable enhanced functionality and personalization, such as remembering your preferences, language settings, and customizations.\n\n**Analytics Cookies**\nWe use analytics cookies to analyze website traffic and optimize the user experience. This data helps us improve our services.'**
  String get cookiesPageHowWeUseContent;

  /// No description provided for @cookiesPageTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Types of Cookies We Use'**
  String get cookiesPageTypesTitle;

  /// No description provided for @cookiesPageCookieType.
  ///
  /// In en, this message translates to:
  /// **'Cookie Type'**
  String get cookiesPageCookieType;

  /// No description provided for @cookiesPagePurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get cookiesPagePurpose;

  /// No description provided for @cookiesPageDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get cookiesPageDuration;

  /// No description provided for @cookiesPageSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get cookiesPageSession;

  /// No description provided for @cookiesPageAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get cookiesPageAuthentication;

  /// No description provided for @cookiesPagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get cookiesPagePreferences;

  /// No description provided for @cookiesPageUserSettings.
  ///
  /// In en, this message translates to:
  /// **'User settings'**
  String get cookiesPageUserSettings;

  /// No description provided for @cookiesPageAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get cookiesPageAnalytics;

  /// No description provided for @cookiesPageUsageStatistics.
  ///
  /// In en, this message translates to:
  /// **'Usage statistics'**
  String get cookiesPageUsageStatistics;

  /// No description provided for @cookiesPageSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get cookiesPageSecurity;

  /// No description provided for @cookiesPageFraudPrevention.
  ///
  /// In en, this message translates to:
  /// **'Fraud prevention'**
  String get cookiesPageFraudPrevention;

  /// No description provided for @cookiesPageManaging.
  ///
  /// In en, this message translates to:
  /// **'Managing Your Cookie Preferences'**
  String get cookiesPageManaging;

  /// No description provided for @cookiesPageManagingContent.
  ///
  /// In en, this message translates to:
  /// **'You have several options for managing cookies:\n\n**Browser Settings**\nMost web browsers allow you to control cookies through their settings. You can set your browser to refuse cookies, delete existing cookies, or alert you when cookies are being sent.\n\n**Our Cookie Settings**\nYou can manage your cookie preferences for our platform by visiting Settings > Cookie Preferences in your account.\n\n**Opt-Out Links**\nFor analytics and advertising cookies, you can opt out through industry opt-out mechanisms.\n\nNote: Disabling certain cookies may impact your experience and limit some features of our platform.'**
  String get cookiesPageManagingContent;

  /// No description provided for @cookiesPageThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Cookies'**
  String get cookiesPageThirdParty;

  /// No description provided for @cookiesPageThirdPartyContent.
  ///
  /// In en, this message translates to:
  /// **'Some cookies are placed by third-party services that appear on our pages. We do not control these cookies.\n\nThird-party services we use that may place cookies include:\n• Supabase (Authentication)\n• Sentry (Error Tracking)\n• Analytics services\n\nPlease refer to the privacy policies of these services for more information about their cookie practices.'**
  String get cookiesPageThirdPartyContent;

  /// No description provided for @cookiesPageUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates to This Policy'**
  String get cookiesPageUpdates;

  /// No description provided for @cookiesPageUpdatesContent.
  ///
  /// In en, this message translates to:
  /// **'We may update this Cookie Policy from time to time. When we make changes, we will update the \"Last updated\" date at the top of this page.\n\nWe encourage you to review this policy periodically to stay informed about our use of cookies.'**
  String get cookiesPageUpdatesContent;

  /// No description provided for @cookiesPageManagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage Cookie Preferences'**
  String get cookiesPageManagePreferences;

  /// No description provided for @cookiesPageCustomize.
  ///
  /// In en, this message translates to:
  /// **'Customize which cookies you allow'**
  String get cookiesPageCustomize;

  /// No description provided for @cookiesPageManageButton.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get cookiesPageManageButton;

  /// No description provided for @cookiesPageQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Questions about cookies?'**
  String get cookiesPageQuestionsTitle;

  /// No description provided for @cookiesPageQuestionsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us at privacy@flowedtech.com'**
  String get cookiesPageQuestionsContact;

  /// No description provided for @dataProtPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get dataProtPageTitle;

  /// No description provided for @dataProtPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we protect and manage your personal data'**
  String get dataProtPageSubtitle;

  /// No description provided for @dataProtPageYourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Data Rights'**
  String get dataProtPageYourRights;

  /// No description provided for @dataProtPageRightsIntro.
  ///
  /// In en, this message translates to:
  /// **'Under data protection laws, you have the following rights:'**
  String get dataProtPageRightsIntro;

  /// No description provided for @dataProtPageRightAccess.
  ///
  /// In en, this message translates to:
  /// **'Right to Access'**
  String get dataProtPageRightAccess;

  /// No description provided for @dataProtPageRightAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'You can request a copy of all personal data we hold about you. We will provide this within 30 days.'**
  String get dataProtPageRightAccessDesc;

  /// No description provided for @dataProtPageRightRectification.
  ///
  /// In en, this message translates to:
  /// **'Right to Rectification'**
  String get dataProtPageRightRectification;

  /// No description provided for @dataProtPageRightRectificationDesc.
  ///
  /// In en, this message translates to:
  /// **'You can request correction of inaccurate or incomplete personal data.'**
  String get dataProtPageRightRectificationDesc;

  /// No description provided for @dataProtPageRightErasure.
  ///
  /// In en, this message translates to:
  /// **'Right to Erasure'**
  String get dataProtPageRightErasure;

  /// No description provided for @dataProtPageRightErasureDesc.
  ///
  /// In en, this message translates to:
  /// **'You can request deletion of your personal data in certain circumstances.'**
  String get dataProtPageRightErasureDesc;

  /// No description provided for @dataProtPageRightPortability.
  ///
  /// In en, this message translates to:
  /// **'Right to Data Portability'**
  String get dataProtPageRightPortability;

  /// No description provided for @dataProtPageRightPortabilityDesc.
  ///
  /// In en, this message translates to:
  /// **'You can request your data in a structured, machine-readable format.'**
  String get dataProtPageRightPortabilityDesc;

  /// No description provided for @dataProtPageRightObject.
  ///
  /// In en, this message translates to:
  /// **'Right to Object'**
  String get dataProtPageRightObject;

  /// No description provided for @dataProtPageRightObjectDesc.
  ///
  /// In en, this message translates to:
  /// **'You can object to processing of your personal data for certain purposes.'**
  String get dataProtPageRightObjectDesc;

  /// No description provided for @dataProtPageRightRestrict.
  ///
  /// In en, this message translates to:
  /// **'Right to Restrict Processing'**
  String get dataProtPageRightRestrict;

  /// No description provided for @dataProtPageRightRestrictDesc.
  ///
  /// In en, this message translates to:
  /// **'You can request that we limit how we use your data.'**
  String get dataProtPageRightRestrictDesc;

  /// No description provided for @dataProtPageHowWeProtect.
  ///
  /// In en, this message translates to:
  /// **'How We Protect Your Data'**
  String get dataProtPageHowWeProtect;

  /// No description provided for @dataProtPageHowWeProtectContent.
  ///
  /// In en, this message translates to:
  /// **'We implement robust security measures to protect your personal data:\n\n**Technical Measures**\n• End-to-end encryption for data transmission\n• AES-256 encryption for stored data\n• Regular security audits and penetration testing\n• Intrusion detection systems\n• Secure data centers with physical security\n\n**Organizational Measures**\n• Staff training on data protection\n• Access controls and authentication\n• Data protection impact assessments\n• Incident response procedures\n• Regular compliance reviews'**
  String get dataProtPageHowWeProtectContent;

  /// No description provided for @dataProtPageStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage & Retention'**
  String get dataProtPageStorage;

  /// No description provided for @dataProtPageStorageContent.
  ///
  /// In en, this message translates to:
  /// **'**Where We Store Your Data**\nYour data is stored on secure servers located in regions with strong data protection laws. We use industry-leading cloud providers with SOC 2 and ISO 27001 certifications.\n\n**How Long We Keep Your Data**\n• Account data: Until you delete your account\n• Application data: 7 years for compliance\n• Analytics data: 2 years\n• Communication logs: 3 years\n\nAfter these periods, data is securely deleted or anonymized.'**
  String get dataProtPageStorageContent;

  /// No description provided for @dataProtPageSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataProtPageSharing;

  /// No description provided for @dataProtPageSharingContent.
  ///
  /// In en, this message translates to:
  /// **'We only share your data when necessary:\n\n• **With your consent**: When you explicitly agree\n• **Service providers**: Partners who help us deliver services\n• **Legal requirements**: When required by law\n• **Business transfers**: In case of merger or acquisition\n\nWe never sell your personal data to third parties.'**
  String get dataProtPageSharingContent;

  /// No description provided for @dataProtPageExerciseRights.
  ///
  /// In en, this message translates to:
  /// **'Exercise Your Rights'**
  String get dataProtPageExerciseRights;

  /// No description provided for @dataProtPageExerciseRightsDesc.
  ///
  /// In en, this message translates to:
  /// **'To make a data request or exercise any of your rights, contact our Data Protection Officer:'**
  String get dataProtPageExerciseRightsDesc;

  /// No description provided for @dataProtPageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get dataProtPageContactUs;

  /// No description provided for @dataProtPageManageData.
  ///
  /// In en, this message translates to:
  /// **'Manage Data'**
  String get dataProtPageManageData;

  /// No description provided for @dataProtPageRelatedInfo.
  ///
  /// In en, this message translates to:
  /// **'Related Information'**
  String get dataProtPageRelatedInfo;

  /// No description provided for @dataProtPagePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get dataProtPagePrivacyPolicy;

  /// No description provided for @dataProtPageCookiePolicy.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get dataProtPageCookiePolicy;

  /// No description provided for @dataProtPageTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get dataProtPageTermsOfService;

  /// No description provided for @dataProtPageCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get dataProtPageCompliance;

  /// No description provided for @docsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get docsPageTitle;

  /// No description provided for @docsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to know about using Flow'**
  String get docsPageSubtitle;

  /// No description provided for @docsPageGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get docsPageGettingStarted;

  /// No description provided for @docsPageGettingStartedDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn the basics of Flow'**
  String get docsPageGettingStartedDesc;

  /// No description provided for @docsPageForStudents.
  ///
  /// In en, this message translates to:
  /// **'For Students'**
  String get docsPageForStudents;

  /// No description provided for @docsPageForStudentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Guides for student users'**
  String get docsPageForStudentsDesc;

  /// No description provided for @docsPageForParents.
  ///
  /// In en, this message translates to:
  /// **'For Parents'**
  String get docsPageForParents;

  /// No description provided for @docsPageForParentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Guides for parent users'**
  String get docsPageForParentsDesc;

  /// No description provided for @docsPageForCounselors.
  ///
  /// In en, this message translates to:
  /// **'For Counselors'**
  String get docsPageForCounselors;

  /// No description provided for @docsPageForCounselorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Guides for education counselors'**
  String get docsPageForCounselorsDesc;

  /// No description provided for @docsPageForInstitutions.
  ///
  /// In en, this message translates to:
  /// **'For Institutions'**
  String get docsPageForInstitutions;

  /// No description provided for @docsPageForInstitutionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Guides for universities and colleges'**
  String get docsPageForInstitutionsDesc;

  /// No description provided for @docsPageCantFind.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find what you\'re looking for?'**
  String get docsPageCantFind;

  /// No description provided for @docsPageCheckHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Check out our Help Center or contact support'**
  String get docsPageCheckHelpCenter;

  /// No description provided for @docsPageHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get docsPageHelpCenter;

  /// No description provided for @helpCenterPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenterPageTitle;

  /// No description provided for @helpCenterPageHowCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get helpCenterPageHowCanWeHelp;

  /// No description provided for @helpCenterPageSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get helpCenterPageSearchHint;

  /// No description provided for @helpCenterPageQuickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get helpCenterPageQuickLinks;

  /// No description provided for @helpCenterPageUniversitySearch.
  ///
  /// In en, this message translates to:
  /// **'University Search'**
  String get helpCenterPageUniversitySearch;

  /// No description provided for @helpCenterPageMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get helpCenterPageMyProfile;

  /// No description provided for @helpCenterPageSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get helpCenterPageSettings;

  /// No description provided for @helpCenterPageContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get helpCenterPageContactSupport;

  /// No description provided for @helpCenterPageCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get helpCenterPageCategories;

  /// No description provided for @helpCenterPageFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpCenterPageFaq;

  /// No description provided for @helpCenterPageNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get helpCenterPageNoResults;

  /// No description provided for @helpCenterPageStillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get helpCenterPageStillNeedHelp;

  /// No description provided for @helpCenterPageSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'Our support team is here to assist you'**
  String get helpCenterPageSupportTeam;

  /// No description provided for @mobileAppsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Flow on Mobile'**
  String get mobileAppsPageTitle;

  /// No description provided for @mobileAppsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take your education journey with you.\nDownload the Flow app on your favorite platform.'**
  String get mobileAppsPageSubtitle;

  /// No description provided for @mobileAppsPageDownloadNow.
  ///
  /// In en, this message translates to:
  /// **'Download Now'**
  String get mobileAppsPageDownloadNow;

  /// No description provided for @mobileAppsPageDownloadOnThe.
  ///
  /// In en, this message translates to:
  /// **'Download on the'**
  String get mobileAppsPageDownloadOnThe;

  /// No description provided for @mobileAppsPageFeatures.
  ///
  /// In en, this message translates to:
  /// **'Mobile App Features'**
  String get mobileAppsPageFeatures;

  /// No description provided for @mobileAppsPageOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get mobileAppsPageOfflineMode;

  /// No description provided for @mobileAppsPageOfflineModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Access key features without internet'**
  String get mobileAppsPageOfflineModeDesc;

  /// No description provided for @mobileAppsPagePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get mobileAppsPagePushNotifications;

  /// No description provided for @mobileAppsPagePushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on applications'**
  String get mobileAppsPagePushNotificationsDesc;

  /// No description provided for @mobileAppsPageBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get mobileAppsPageBiometricLogin;

  /// No description provided for @mobileAppsPageBiometricLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure and fast access'**
  String get mobileAppsPageBiometricLoginDesc;

  /// No description provided for @mobileAppsPageRealtimeSync.
  ///
  /// In en, this message translates to:
  /// **'Real-time Sync'**
  String get mobileAppsPageRealtimeSync;

  /// No description provided for @mobileAppsPageRealtimeSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Always up-to-date data'**
  String get mobileAppsPageRealtimeSyncDesc;

  /// No description provided for @mobileAppsPageDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get mobileAppsPageDarkMode;

  /// No description provided for @mobileAppsPageDarkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes'**
  String get mobileAppsPageDarkModeDesc;

  /// No description provided for @mobileAppsPageFastLight.
  ///
  /// In en, this message translates to:
  /// **'Fast & Light'**
  String get mobileAppsPageFastLight;

  /// No description provided for @mobileAppsPageFastLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimized for performance'**
  String get mobileAppsPageFastLightDesc;

  /// No description provided for @mobileAppsPageAppPreview.
  ///
  /// In en, this message translates to:
  /// **'App Preview'**
  String get mobileAppsPageAppPreview;

  /// No description provided for @mobileAppsPageSystemRequirements.
  ///
  /// In en, this message translates to:
  /// **'System Requirements'**
  String get mobileAppsPageSystemRequirements;

  /// No description provided for @mobileAppsPageScanToDownload.
  ///
  /// In en, this message translates to:
  /// **'Scan to Download'**
  String get mobileAppsPageScanToDownload;

  /// No description provided for @mobileAppsPageScanDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code with your phone camera to download the app'**
  String get mobileAppsPageScanDesc;

  /// No description provided for @partnersPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get partnersPageTitle;

  /// No description provided for @partnersPageHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner With Flow'**
  String get partnersPageHeroTitle;

  /// No description provided for @partnersPageHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us in transforming education across Africa'**
  String get partnersPageHeroSubtitle;

  /// No description provided for @partnersPageOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Partnership Opportunities'**
  String get partnersPageOpportunities;

  /// No description provided for @partnersPageUniversities.
  ///
  /// In en, this message translates to:
  /// **'Universities & Institutions'**
  String get partnersPageUniversities;

  /// No description provided for @partnersPageUniversitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'List your programs, connect with prospective students, and streamline your admissions process.'**
  String get partnersPageUniversitiesDesc;

  /// No description provided for @partnersPageCounselors.
  ///
  /// In en, this message translates to:
  /// **'Education Counselors'**
  String get partnersPageCounselors;

  /// No description provided for @partnersPageCounselorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Join our network of counselors and help guide students to their perfect educational fit.'**
  String get partnersPageCounselorsDesc;

  /// No description provided for @partnersPageCorporate.
  ///
  /// In en, this message translates to:
  /// **'Corporate Partners'**
  String get partnersPageCorporate;

  /// No description provided for @partnersPageCorporateDesc.
  ///
  /// In en, this message translates to:
  /// **'Support education initiatives through scholarships, internships, and mentorship programs.'**
  String get partnersPageCorporateDesc;

  /// No description provided for @partnersPageNgo.
  ///
  /// In en, this message translates to:
  /// **'NGOs & Government'**
  String get partnersPageNgo;

  /// No description provided for @partnersPageNgoDesc.
  ///
  /// In en, this message translates to:
  /// **'Collaborate on initiatives to improve education access and outcomes across regions.'**
  String get partnersPageNgoDesc;

  /// No description provided for @partnersPageOurPartners.
  ///
  /// In en, this message translates to:
  /// **'Our Partners'**
  String get partnersPageOurPartners;

  /// No description provided for @partnersPageReadyToPartner.
  ///
  /// In en, this message translates to:
  /// **'Ready to Partner?'**
  String get partnersPageReadyToPartner;

  /// No description provided for @partnersPageLetsDiscuss.
  ///
  /// In en, this message translates to:
  /// **'Let\'s discuss how we can work together'**
  String get partnersPageLetsDiscuss;

  /// No description provided for @partnersPageContactTeam.
  ///
  /// In en, this message translates to:
  /// **'Contact Partnership Team'**
  String get partnersPageContactTeam;

  /// No description provided for @pressPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Press Kit'**
  String get pressPageTitle;

  /// No description provided for @pressPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resources for media and press coverage'**
  String get pressPageSubtitle;

  /// No description provided for @pressPageCompanyOverview.
  ///
  /// In en, this message translates to:
  /// **'Company Overview'**
  String get pressPageCompanyOverview;

  /// No description provided for @pressPageCompanyOverviewContent.
  ///
  /// In en, this message translates to:
  /// **'Flow EdTech is Africa\'s leading education technology platform, connecting students with universities, counselors, and educational resources. Founded with the mission to democratize access to quality education guidance across the African continent.'**
  String get pressPageCompanyOverviewContent;

  /// No description provided for @pressPageKeyFacts.
  ///
  /// In en, this message translates to:
  /// **'Key Facts'**
  String get pressPageKeyFacts;

  /// No description provided for @pressPageFounded.
  ///
  /// In en, this message translates to:
  /// **'Founded'**
  String get pressPageFounded;

  /// No description provided for @pressPageHeadquarters.
  ///
  /// In en, this message translates to:
  /// **'Headquarters'**
  String get pressPageHeadquarters;

  /// No description provided for @pressPageActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get pressPageActiveUsers;

  /// No description provided for @pressPagePartnerInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Partner Institutions'**
  String get pressPagePartnerInstitutions;

  /// No description provided for @pressPageCountries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get pressPageCountries;

  /// No description provided for @pressPageUniversitiesInDb.
  ///
  /// In en, this message translates to:
  /// **'Universities in Database'**
  String get pressPageUniversitiesInDb;

  /// No description provided for @pressPageBrandAssets.
  ///
  /// In en, this message translates to:
  /// **'Brand Assets'**
  String get pressPageBrandAssets;

  /// No description provided for @pressPageLogoPack.
  ///
  /// In en, this message translates to:
  /// **'Logo Pack'**
  String get pressPageLogoPack;

  /// No description provided for @pressPageLogoPackDesc.
  ///
  /// In en, this message translates to:
  /// **'PNG, SVG, and vector formats'**
  String get pressPageLogoPackDesc;

  /// No description provided for @pressPageBrandGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Brand Guidelines'**
  String get pressPageBrandGuidelines;

  /// No description provided for @pressPageBrandGuidelinesDesc.
  ///
  /// In en, this message translates to:
  /// **'Colors, typography, usage'**
  String get pressPageBrandGuidelinesDesc;

  /// No description provided for @pressPageScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get pressPageScreenshots;

  /// No description provided for @pressPageScreenshotsDesc.
  ///
  /// In en, this message translates to:
  /// **'App screenshots and demos'**
  String get pressPageScreenshotsDesc;

  /// No description provided for @pressPageVideoAssets.
  ///
  /// In en, this message translates to:
  /// **'Video Assets'**
  String get pressPageVideoAssets;

  /// No description provided for @pressPageVideoAssetsDesc.
  ///
  /// In en, this message translates to:
  /// **'Product videos and B-roll'**
  String get pressPageVideoAssetsDesc;

  /// No description provided for @pressPageDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get pressPageDownload;

  /// No description provided for @pressPageRecentNews.
  ///
  /// In en, this message translates to:
  /// **'Recent News'**
  String get pressPageRecentNews;

  /// No description provided for @pressPageMediaContact.
  ///
  /// In en, this message translates to:
  /// **'Media Contact'**
  String get pressPageMediaContact;

  /// No description provided for @pressPageMediaContactDesc.
  ///
  /// In en, this message translates to:
  /// **'For press inquiries, please contact:'**
  String get pressPageMediaContactDesc;

  /// No description provided for @apiDocsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'API Reference'**
  String get apiDocsPageTitle;

  /// No description provided for @apiDocsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Integrate Flow into your applications'**
  String get apiDocsPageSubtitle;

  /// No description provided for @apiDocsPageQuickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get apiDocsPageQuickStart;

  /// No description provided for @apiDocsPageEndpoints.
  ///
  /// In en, this message translates to:
  /// **'API Endpoints'**
  String get apiDocsPageEndpoints;

  /// No description provided for @apiDocsPageAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get apiDocsPageAuthentication;

  /// No description provided for @apiDocsPageAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'All API requests require authentication using an API key.'**
  String get apiDocsPageAuthDesc;

  /// No description provided for @apiDocsPageRateLimits.
  ///
  /// In en, this message translates to:
  /// **'Rate Limits'**
  String get apiDocsPageRateLimits;

  /// No description provided for @apiDocsPageFreeTier.
  ///
  /// In en, this message translates to:
  /// **'Free Tier'**
  String get apiDocsPageFreeTier;

  /// No description provided for @apiDocsPageBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get apiDocsPageBasic;

  /// No description provided for @apiDocsPagePro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get apiDocsPagePro;

  /// No description provided for @apiDocsPageEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get apiDocsPageEnterprise;

  /// No description provided for @apiDocsPageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get apiDocsPageUnlimited;

  /// No description provided for @apiDocsPageNeedAccess.
  ///
  /// In en, this message translates to:
  /// **'Need API Access?'**
  String get apiDocsPageNeedAccess;

  /// No description provided for @apiDocsPageContactCredentials.
  ///
  /// In en, this message translates to:
  /// **'Contact us to get your API credentials'**
  String get apiDocsPageContactCredentials;

  /// No description provided for @apiDocsPageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get apiDocsPageContactUs;

  /// No description provided for @apiDocsPageUniversities.
  ///
  /// In en, this message translates to:
  /// **'Universities'**
  String get apiDocsPageUniversities;

  /// No description provided for @apiDocsPagePrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get apiDocsPagePrograms;

  /// No description provided for @apiDocsPageRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get apiDocsPageRecommendations;

  /// No description provided for @apiDocsPageStudentsEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get apiDocsPageStudentsEndpoint;

  /// No description provided for @apiDocsPageListAll.
  ///
  /// In en, this message translates to:
  /// **'List all universities'**
  String get apiDocsPageListAll;

  /// No description provided for @apiDocsPageGetDetails.
  ///
  /// In en, this message translates to:
  /// **'Get university details'**
  String get apiDocsPageGetDetails;

  /// No description provided for @apiDocsPageSearchUniversities.
  ///
  /// In en, this message translates to:
  /// **'Search universities'**
  String get apiDocsPageSearchUniversities;

  /// No description provided for @apiDocsPageListPrograms.
  ///
  /// In en, this message translates to:
  /// **'List programs'**
  String get apiDocsPageListPrograms;

  /// No description provided for @apiDocsPageListAllPrograms.
  ///
  /// In en, this message translates to:
  /// **'List all programs'**
  String get apiDocsPageListAllPrograms;

  /// No description provided for @apiDocsPageGetProgramDetails.
  ///
  /// In en, this message translates to:
  /// **'Get program details'**
  String get apiDocsPageGetProgramDetails;

  /// No description provided for @apiDocsPageSearchPrograms.
  ///
  /// In en, this message translates to:
  /// **'Search programs'**
  String get apiDocsPageSearchPrograms;

  /// No description provided for @apiDocsPageGenerateRec.
  ///
  /// In en, this message translates to:
  /// **'Generate recommendations'**
  String get apiDocsPageGenerateRec;

  /// No description provided for @apiDocsPageGetRecDetails.
  ///
  /// In en, this message translates to:
  /// **'Get recommendation details'**
  String get apiDocsPageGetRecDetails;

  /// No description provided for @apiDocsPageGetStudentProfile.
  ///
  /// In en, this message translates to:
  /// **'Get student profile'**
  String get apiDocsPageGetStudentProfile;

  /// No description provided for @apiDocsPageUpdateStudentProfile.
  ///
  /// In en, this message translates to:
  /// **'Update student profile'**
  String get apiDocsPageUpdateStudentProfile;

  /// No description provided for @apiDocsPageListApplications.
  ///
  /// In en, this message translates to:
  /// **'List applications'**
  String get apiDocsPageListApplications;

  /// No description provided for @swErrorTechnicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get swErrorTechnicalDetails;

  /// No description provided for @swErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get swErrorRetry;

  /// No description provided for @swErrorConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get swErrorConnectionTitle;

  /// No description provided for @swErrorConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to our servers. Please check your internet connection and try again.'**
  String get swErrorConnectionMessage;

  /// No description provided for @swErrorConnectionHelp.
  ///
  /// In en, this message translates to:
  /// **'Make sure you have a stable internet connection. If the problem persists, our servers might be temporarily unavailable.'**
  String get swErrorConnectionHelp;

  /// No description provided for @swErrorAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get swErrorAuthTitle;

  /// No description provided for @swErrorAuthMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired or you don\'t have permission to access this content.'**
  String get swErrorAuthMessage;

  /// No description provided for @swErrorAuthHelp.
  ///
  /// In en, this message translates to:
  /// **'Try logging out and logging back in to refresh your session.'**
  String get swErrorAuthHelp;

  /// No description provided for @swErrorSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get swErrorSignOut;

  /// No description provided for @swErrorNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Content Not Found'**
  String get swErrorNotFoundTitle;

  /// No description provided for @swErrorNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The content you\'re looking for doesn\'t exist or has been moved.'**
  String get swErrorNotFoundMessage;

  /// No description provided for @swErrorNotFoundHelp.
  ///
  /// In en, this message translates to:
  /// **'The item may have been deleted or you may not have access to view it.'**
  String get swErrorNotFoundHelp;

  /// No description provided for @swErrorServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get swErrorServerTitle;

  /// No description provided for @swErrorServerMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. We\'re working to fix it.'**
  String get swErrorServerMessage;

  /// No description provided for @swErrorServerHelp.
  ///
  /// In en, this message translates to:
  /// **'This is a temporary issue. Please try again in a few minutes.'**
  String get swErrorServerHelp;

  /// No description provided for @swErrorRateLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Too Many Requests'**
  String get swErrorRateLimitTitle;

  /// No description provided for @swErrorRateLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve made too many requests. Please wait a moment before trying again.'**
  String get swErrorRateLimitMessage;

  /// No description provided for @swErrorRateLimitHelp.
  ///
  /// In en, this message translates to:
  /// **'To prevent abuse, we limit the number of requests. Please wait a few seconds before retrying.'**
  String get swErrorRateLimitHelp;

  /// No description provided for @swErrorValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get swErrorValidationTitle;

  /// No description provided for @swErrorValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Some information appears to be incorrect or missing. Please check your input and try again.'**
  String get swErrorValidationMessage;

  /// No description provided for @swErrorValidationHelp.
  ///
  /// In en, this message translates to:
  /// **'Make sure all required fields are filled correctly.'**
  String get swErrorValidationHelp;

  /// No description provided for @swErrorAccessDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get swErrorAccessDeniedTitle;

  /// No description provided for @swErrorAccessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this content.'**
  String get swErrorAccessDeniedMessage;

  /// No description provided for @swErrorAccessDeniedHelp.
  ///
  /// In en, this message translates to:
  /// **'Contact your administrator if you believe you should have access.'**
  String get swErrorAccessDeniedHelp;

  /// No description provided for @swErrorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get swErrorGenericTitle;

  /// No description provided for @swErrorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get swErrorGenericMessage;

  /// No description provided for @swErrorGenericHelp.
  ///
  /// In en, this message translates to:
  /// **'If this problem continues, please contact support.'**
  String get swErrorGenericHelp;

  /// No description provided for @swErrorFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get swErrorFailedToLoad;

  /// No description provided for @swEmptyStateNoApplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Applications Yet'**
  String get swEmptyStateNoApplicationsTitle;

  /// No description provided for @swEmptyStateNoApplicationsMessage.
  ///
  /// In en, this message translates to:
  /// **'Start your journey by exploring programs and submitting your first application.'**
  String get swEmptyStateNoApplicationsMessage;

  /// No description provided for @swEmptyStateBrowsePrograms.
  ///
  /// In en, this message translates to:
  /// **'Browse Programs'**
  String get swEmptyStateBrowsePrograms;

  /// No description provided for @swEmptyStateNoActivitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Recent Activities'**
  String get swEmptyStateNoActivitiesTitle;

  /// No description provided for @swEmptyStateNoActivitiesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your recent activities and updates will appear here as you use the platform.'**
  String get swEmptyStateNoActivitiesMessage;

  /// No description provided for @swEmptyStateNoRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Recommendations'**
  String get swEmptyStateNoRecommendationsTitle;

  /// No description provided for @swEmptyStateNoRecommendationsMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to receive personalized recommendations based on your interests and goals.'**
  String get swEmptyStateNoRecommendationsMessage;

  /// No description provided for @swEmptyStateCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get swEmptyStateCompleteProfile;

  /// No description provided for @swEmptyStateNoMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Messages'**
  String get swEmptyStateNoMessagesTitle;

  /// No description provided for @swEmptyStateNoMessagesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your conversations and notifications will appear here.'**
  String get swEmptyStateNoMessagesMessage;

  /// No description provided for @swEmptyStateNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get swEmptyStateNoResultsTitle;

  /// No description provided for @swEmptyStateNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria or filters to find what you\'re looking for.'**
  String get swEmptyStateNoResultsMessage;

  /// No description provided for @swEmptyStateClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get swEmptyStateClearFilters;

  /// No description provided for @swEmptyStateNoCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Courses Available'**
  String get swEmptyStateNoCoursesTitle;

  /// No description provided for @swEmptyStateNoCoursesMessage.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new courses or explore other learning opportunities.'**
  String get swEmptyStateNoCoursesMessage;

  /// No description provided for @swEmptyStateExplorePrograms.
  ///
  /// In en, this message translates to:
  /// **'Explore Programs'**
  String get swEmptyStateExplorePrograms;

  /// No description provided for @swEmptyStateNoStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Students'**
  String get swEmptyStateNoStudentsTitle;

  /// No description provided for @swEmptyStateNoStudentsMessage.
  ///
  /// In en, this message translates to:
  /// **'Students you\'re counseling will appear here once they\'re assigned or request your guidance.'**
  String get swEmptyStateNoStudentsMessage;

  /// No description provided for @swEmptyStateNoSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Upcoming Sessions'**
  String get swEmptyStateNoSessionsTitle;

  /// No description provided for @swEmptyStateNoSessionsMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any counseling sessions scheduled.'**
  String get swEmptyStateNoSessionsMessage;

  /// No description provided for @swEmptyStateScheduleSession.
  ///
  /// In en, this message translates to:
  /// **'Schedule Session'**
  String get swEmptyStateScheduleSession;

  /// No description provided for @swEmptyStateNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get swEmptyStateNoDataTitle;

  /// No description provided for @swEmptyStateNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Data will appear here once there\'s activity to display.'**
  String get swEmptyStateNoDataMessage;

  /// No description provided for @swEmptyStateNoNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get swEmptyStateNoNotificationsTitle;

  /// No description provided for @swEmptyStateNoNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! New notifications will appear here.'**
  String get swEmptyStateNoNotificationsMessage;

  /// No description provided for @swEmptyStateComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get swEmptyStateComingSoonTitle;

  /// No description provided for @swEmptyStateComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'{feature} is currently under development and will be available soon.'**
  String swEmptyStateComingSoonMessage(String feature);

  /// No description provided for @swEmptyStateAccessRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Restricted'**
  String get swEmptyStateAccessRestrictedTitle;

  /// No description provided for @swEmptyStateAccessRestrictedMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to view this content. Contact your administrator if you need access.'**
  String get swEmptyStateAccessRestrictedMessage;

  /// No description provided for @swComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get swComingSoonTitle;

  /// No description provided for @swComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'{featureName} is currently under development and will be available in a future update.'**
  String swComingSoonMessage(String featureName);

  /// No description provided for @swComingSoonStayTuned.
  ///
  /// In en, this message translates to:
  /// **'Stay tuned for updates!'**
  String get swComingSoonStayTuned;

  /// No description provided for @swComingSoonGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get swComingSoonGotIt;

  /// No description provided for @swNotifCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get swNotifCenterTitle;

  /// No description provided for @swNotifCenterMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get swNotifCenterMarkAllRead;

  /// No description provided for @swNotifCenterError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String swNotifCenterError(String error);

  /// No description provided for @swNotifCenterRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get swNotifCenterRetry;

  /// No description provided for @swNotifCenterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get swNotifCenterEmpty;

  /// No description provided for @swNotifCenterEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when something happens'**
  String get swNotifCenterEmptySubtitle;

  /// No description provided for @swNotifCenterDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get swNotifCenterDeleteTitle;

  /// No description provided for @swNotifCenterDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get swNotifCenterDeleteConfirm;

  /// No description provided for @swNotifCenterCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get swNotifCenterCancel;

  /// No description provided for @swNotifCenterDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get swNotifCenterDelete;

  /// No description provided for @swNotifCenterMarkAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get swNotifCenterMarkAsRead;

  /// No description provided for @swNotifCenterMarkAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get swNotifCenterMarkAsUnread;

  /// No description provided for @swNotifCenterArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get swNotifCenterArchive;

  /// No description provided for @swNotifCenterFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Notifications'**
  String get swNotifCenterFilterTitle;

  /// No description provided for @swNotifCenterFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get swNotifCenterFilterClear;

  /// No description provided for @swNotifCenterFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get swNotifCenterFilterStatus;

  /// No description provided for @swNotifCenterFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get swNotifCenterFilterAll;

  /// No description provided for @swNotifCenterFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get swNotifCenterFilterUnread;

  /// No description provided for @swNotifCenterFilterRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get swNotifCenterFilterRead;

  /// No description provided for @swNotifCenterApplyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get swNotifCenterApplyFilter;

  /// No description provided for @swNotifBellNoNew.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get swNotifBellNoNew;

  /// No description provided for @swNotifBellViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All Notifications'**
  String get swNotifBellViewAll;

  /// No description provided for @swNotifBellNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get swNotifBellNotifications;

  /// No description provided for @swNotifWidgetMarkAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get swNotifWidgetMarkAsRead;

  /// No description provided for @swNotifWidgetDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get swNotifWidgetDelete;

  /// No description provided for @swNotifWidgetJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get swNotifWidgetJustNow;

  /// No description provided for @swNotifWidgetMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String swNotifWidgetMinutesAgo(int count);

  /// No description provided for @swNotifWidgetHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String swNotifWidgetHoursAgo(int count);

  /// No description provided for @swNotifWidgetDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String swNotifWidgetDaysAgo(int count);

  /// No description provided for @swNotifWidgetWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String swNotifWidgetWeeksAgo(int count);

  /// No description provided for @swNotifWidgetMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month ago} other{{count} months ago}}'**
  String swNotifWidgetMonthsAgo(int count);

  /// No description provided for @swNotifWidgetYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year ago} other{{count} years ago}}'**
  String swNotifWidgetYearsAgo(int count);

  /// No description provided for @swNotifWidgetNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get swNotifWidgetNoNotifications;

  /// No description provided for @swNotifWidgetAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! Check back later for new updates.'**
  String get swNotifWidgetAllCaughtUp;

  /// No description provided for @swOfflineYouAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get swOfflineYouAreOffline;

  /// No description provided for @swOfflinePendingSync.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 action pending sync} other{{count} actions pending sync}}'**
  String swOfflinePendingSync(int count);

  /// No description provided for @swOfflineDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get swOfflineDetails;

  /// No description provided for @swOfflineSyncing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Syncing 1 action...} other{Syncing {count} actions...}}'**
  String swOfflineSyncing(int count);

  /// No description provided for @swOfflineActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Actions'**
  String get swOfflineActionsTitle;

  /// No description provided for @swOfflineNoPending.
  ///
  /// In en, this message translates to:
  /// **'No pending actions'**
  String get swOfflineNoPending;

  /// No description provided for @swOfflineClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get swOfflineClearAll;

  /// No description provided for @swOfflineClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get swOfflineClose;

  /// No description provided for @swOfflineSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get swOfflineSyncNow;

  /// No description provided for @swOfflineJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get swOfflineJustNow;

  /// No description provided for @swOfflineMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String swOfflineMinutesAgo(int count);

  /// No description provided for @swOfflineHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String swOfflineHoursAgo(int count);

  /// No description provided for @swOfflineDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String swOfflineDaysAgo(int count);

  /// No description provided for @swOfflineError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String swOfflineError(String error);

  /// No description provided for @swExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get swExportData;

  /// No description provided for @swExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get swExportTooltip;

  /// No description provided for @swExportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get swExportAsPdf;

  /// No description provided for @swExportAsCsv.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get swExportAsCsv;

  /// No description provided for @swExportAsJson.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get swExportAsJson;

  /// No description provided for @swExportNoData.
  ///
  /// In en, this message translates to:
  /// **'No data to export'**
  String get swExportNoData;

  /// No description provided for @swExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported successfully as {format}'**
  String swExportSuccess(String format);

  /// No description provided for @swExportOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get swExportOk;

  /// No description provided for @swExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String swExportFailed(String error);

  /// No description provided for @swExportRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get swExportRetry;

  /// No description provided for @swExportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get swExportCancel;

  /// No description provided for @swFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get swFilterTitle;

  /// No description provided for @swFilterResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get swFilterResetAll;

  /// No description provided for @swFilterCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get swFilterCategories;

  /// No description provided for @swFilterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range (USD)'**
  String get swFilterPriceRange;

  /// No description provided for @swFilterLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get swFilterLevel;

  /// No description provided for @swFilterCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get swFilterCountry;

  /// No description provided for @swFilterInstitutionType.
  ///
  /// In en, this message translates to:
  /// **'Institution Type'**
  String get swFilterInstitutionType;

  /// No description provided for @swFilterMinimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get swFilterMinimumRating;

  /// No description provided for @swFilterDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (weeks)'**
  String get swFilterDuration;

  /// No description provided for @swFilterSpecialOptions.
  ///
  /// In en, this message translates to:
  /// **'Special Options'**
  String get swFilterSpecialOptions;

  /// No description provided for @swFilterOnlineOnly.
  ///
  /// In en, this message translates to:
  /// **'Online Only'**
  String get swFilterOnlineOnly;

  /// No description provided for @swFilterOnlineOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show only online courses/programs'**
  String get swFilterOnlineOnlySubtitle;

  /// No description provided for @swFilterFinancialAid.
  ///
  /// In en, this message translates to:
  /// **'Financial Aid Available'**
  String get swFilterFinancialAid;

  /// No description provided for @swFilterFinancialAidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show only items with financial aid'**
  String get swFilterFinancialAidSubtitle;

  /// No description provided for @swFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get swFilterApply;

  /// No description provided for @swFilterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get swFilterClearAll;

  /// No description provided for @swFilterStarsPlus.
  ///
  /// In en, this message translates to:
  /// **'{rating}+ stars'**
  String swFilterStarsPlus(double rating);

  /// No description provided for @swFilterWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks'**
  String swFilterWeeks(int count);

  /// No description provided for @swSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get swSearchHint;

  /// No description provided for @swSearchAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get swSearchAll;

  /// No description provided for @swSearchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get swSearchRecentSearches;

  /// No description provided for @swSearchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get swSearchClear;

  /// No description provided for @swSearchSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get swSearchSuggestions;

  /// No description provided for @swSortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get swSortByTitle;

  /// No description provided for @swSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get swSortLabel;

  /// No description provided for @swSortFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get swSortFilterLabel;

  /// No description provided for @swSortRelevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get swSortRelevance;

  /// No description provided for @swSortMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get swSortMostPopular;

  /// No description provided for @swSortHighestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get swSortHighestRated;

  /// No description provided for @swSortNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get swSortNewestFirst;

  /// No description provided for @swSortOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get swSortOldestFirst;

  /// No description provided for @swSortPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get swSortPriceLowToHigh;

  /// No description provided for @swSortPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get swSortPriceHighToLow;

  /// No description provided for @swSortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get swSortNameAZ;

  /// No description provided for @swSortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name: Z to A'**
  String get swSortNameZA;

  /// No description provided for @swSortDurationShortest.
  ///
  /// In en, this message translates to:
  /// **'Duration: Shortest'**
  String get swSortDurationShortest;

  /// No description provided for @swSortDurationLongest.
  ///
  /// In en, this message translates to:
  /// **'Duration: Longest'**
  String get swSortDurationLongest;

  /// No description provided for @swStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get swStatusPending;

  /// No description provided for @swStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get swStatusApproved;

  /// No description provided for @swStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get swStatusRejected;

  /// No description provided for @swStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get swStatusInProgress;

  /// No description provided for @swStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get swStatusCompleted;

  /// No description provided for @swRefreshLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {timeAgo}'**
  String swRefreshLastUpdated(String timeAgo);

  /// No description provided for @swRefreshJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get swRefreshJustNow;

  /// No description provided for @swRefreshSecondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}s ago'**
  String swRefreshSecondsAgo(int count);

  /// No description provided for @swRefreshMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String swRefreshMinutesAgo(int count);

  /// No description provided for @swRefreshHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String swRefreshHoursAgo(int count);

  /// No description provided for @swRefreshYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get swRefreshYesterday;

  /// No description provided for @swRefreshDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String swRefreshDaysAgo(int count);

  /// No description provided for @swRefreshSuccess.
  ///
  /// In en, this message translates to:
  /// **'Dashboard refreshed successfully'**
  String get swRefreshSuccess;

  /// No description provided for @swRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh dashboard'**
  String get swRefreshFailed;

  /// No description provided for @swFileUploadDropHere.
  ///
  /// In en, this message translates to:
  /// **'Drop files here'**
  String get swFileUploadDropHere;

  /// No description provided for @swFileUploadClickToSelect.
  ///
  /// In en, this message translates to:
  /// **'Click to select files or drag and drop'**
  String get swFileUploadClickToSelect;

  /// No description provided for @swFileUploadTooLarge.
  ///
  /// In en, this message translates to:
  /// **'{fileName} is too large. Maximum size is {maxSize}MB'**
  String swFileUploadTooLarge(String fileName, int maxSize);

  /// No description provided for @swFileUploadInvalidType.
  ///
  /// In en, this message translates to:
  /// **'{fileName} has an invalid file type. Allowed: {allowedTypes}'**
  String swFileUploadInvalidType(String fileName, String allowedTypes);

  /// No description provided for @swFileUploadPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick files: {error}'**
  String swFileUploadPickFailed(String error);

  /// No description provided for @swFileUploadProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% uploaded'**
  String swFileUploadProgress(int percent);

  /// No description provided for @swFileUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get swFileUploadLabel;

  /// No description provided for @swFileUploadPickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String swFileUploadPickImageFailed(String error);

  /// No description provided for @swFileUploadTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get swFileUploadTapToSelect;

  /// No description provided for @swFileUploadImageFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG, GIF (max 5MB)'**
  String get swFileUploadImageFormats;

  /// No description provided for @swFileUploadAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed: {formats}'**
  String swFileUploadAllowed(String formats);

  /// No description provided for @swFileUploadMaxSize.
  ///
  /// In en, this message translates to:
  /// **'Max {size}MB'**
  String swFileUploadMaxSize(int size);

  /// No description provided for @swDocViewerLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading {name}...'**
  String swDocViewerLoading(String name);

  /// No description provided for @swDocViewerFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load document'**
  String get swDocViewerFailedToLoad;

  /// No description provided for @swDocViewerLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load document: {error}'**
  String swDocViewerLoadError(String error);

  /// No description provided for @swDocViewerRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get swDocViewerRetry;

  /// No description provided for @swDocViewerPinchToZoom.
  ///
  /// In en, this message translates to:
  /// **'Use pinch gesture to zoom'**
  String get swDocViewerPinchToZoom;

  /// No description provided for @swDocViewerPreviewNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Preview Not Available'**
  String get swDocViewerPreviewNotAvailable;

  /// No description provided for @swDocViewerCannotPreview.
  ///
  /// In en, this message translates to:
  /// **'This file type ({extension}) cannot be previewed'**
  String swDocViewerCannotPreview(String extension);

  /// No description provided for @swDocViewerDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {name}...'**
  String swDocViewerDownloading(String name);

  /// No description provided for @swDocViewerDownloadToView.
  ///
  /// In en, this message translates to:
  /// **'Download to View'**
  String get swDocViewerDownloadToView;

  /// No description provided for @swDocViewerPdfViewer.
  ///
  /// In en, this message translates to:
  /// **'PDF Viewer'**
  String get swDocViewerPdfViewer;

  /// No description provided for @swDocViewerPdfEnableMessage.
  ///
  /// In en, this message translates to:
  /// **'To enable PDF viewing, add one of these packages to pubspec.yaml:'**
  String get swDocViewerPdfEnableMessage;

  /// No description provided for @swDocViewerPdfOptionCommercial.
  ///
  /// In en, this message translates to:
  /// **'Full-featured, commercial'**
  String get swDocViewerPdfOptionCommercial;

  /// No description provided for @swDocViewerPdfOptionOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open source, native rendering'**
  String get swDocViewerPdfOptionOpenSource;

  /// No description provided for @swDocViewerPdfOptionModern.
  ///
  /// In en, this message translates to:
  /// **'Modern, good performance'**
  String get swDocViewerPdfOptionModern;

  /// No description provided for @swDocViewerPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String swDocViewerPageOf(int current, int total);

  /// No description provided for @swDocViewerFailedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get swDocViewerFailedToLoadImage;

  /// No description provided for @swScheduleHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get swScheduleHighPriority;

  /// No description provided for @swScheduleNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get swScheduleNow;

  /// No description provided for @swScheduleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get swScheduleCompleted;

  /// No description provided for @swScheduleMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get swScheduleMarkComplete;

  /// No description provided for @swScheduleToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swScheduleToday;

  /// No description provided for @swScheduleTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get swScheduleTomorrow;

  /// No description provided for @swScheduleYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swScheduleYesterday;

  /// No description provided for @swScheduleMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get swScheduleMonthJan;

  /// No description provided for @swScheduleMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get swScheduleMonthFeb;

  /// No description provided for @swScheduleMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get swScheduleMonthMar;

  /// No description provided for @swScheduleMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get swScheduleMonthApr;

  /// No description provided for @swScheduleMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get swScheduleMonthMay;

  /// No description provided for @swScheduleMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get swScheduleMonthJun;

  /// No description provided for @swScheduleMonthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get swScheduleMonthJul;

  /// No description provided for @swScheduleMonthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get swScheduleMonthAug;

  /// No description provided for @swScheduleMonthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get swScheduleMonthSep;

  /// No description provided for @swScheduleMonthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get swScheduleMonthOct;

  /// No description provided for @swScheduleMonthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get swScheduleMonthNov;

  /// No description provided for @swScheduleMonthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get swScheduleMonthDec;

  /// No description provided for @swScheduleNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled'**
  String get swScheduleNoEvents;

  /// No description provided for @swScheduleAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get swScheduleAddEvent;

  /// No description provided for @swSettingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get swSettingsThemeLight;

  /// No description provided for @swSettingsThemeLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bright and clean interface'**
  String get swSettingsThemeLightSubtitle;

  /// No description provided for @swSettingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get swSettingsThemeDark;

  /// No description provided for @swSettingsThemeDarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes in low light'**
  String get swSettingsThemeDarkSubtitle;

  /// No description provided for @swSettingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get swSettingsThemeSystem;

  /// No description provided for @swSettingsThemeSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow device settings'**
  String get swSettingsThemeSystemSubtitle;

  /// No description provided for @swSettingsTotalDataUsage.
  ///
  /// In en, this message translates to:
  /// **'Total Data Usage'**
  String get swSettingsTotalDataUsage;

  /// No description provided for @swSettingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get swSettingsDangerZone;

  /// No description provided for @swSettingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get swSettingsVersion;

  /// No description provided for @swSettingsFlowPlatform.
  ///
  /// In en, this message translates to:
  /// **'Flow EdTech Platform'**
  String get swSettingsFlowPlatform;

  /// No description provided for @swSettingsCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 All rights reserved'**
  String get swSettingsCopyright;

  /// No description provided for @swTaskToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swTaskToday;

  /// No description provided for @swTaskTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get swTaskTomorrow;

  /// No description provided for @swTaskYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swTaskYesterday;

  /// No description provided for @swTaskDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String swTaskDaysAgo(String count);

  /// No description provided for @swTaskInDays.
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String swTaskInDays(String count);

  /// No description provided for @swTaskOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get swTaskOverdue;

  /// No description provided for @swTaskMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get swTaskMonthJan;

  /// No description provided for @swTaskMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get swTaskMonthFeb;

  /// No description provided for @swTaskMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get swTaskMonthMar;

  /// No description provided for @swTaskMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get swTaskMonthApr;

  /// No description provided for @swTaskMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get swTaskMonthMay;

  /// No description provided for @swTaskMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get swTaskMonthJun;

  /// No description provided for @swTaskMonthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get swTaskMonthJul;

  /// No description provided for @swTaskMonthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get swTaskMonthAug;

  /// No description provided for @swTaskMonthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get swTaskMonthSep;

  /// No description provided for @swTaskMonthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get swTaskMonthOct;

  /// No description provided for @swTaskMonthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get swTaskMonthNov;

  /// No description provided for @swTaskMonthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get swTaskMonthDec;

  /// No description provided for @swTaskNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get swTaskNoTasks;

  /// No description provided for @swTaskAddTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get swTaskAddTask;

  /// No description provided for @swUserProfileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get swUserProfileEditProfile;

  /// No description provided for @swUserProfileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get swUserProfileSettings;

  /// No description provided for @swUserProfileJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get swUserProfileJustNow;

  /// No description provided for @swUserProfileMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String swUserProfileMinutesAgo(String count);

  /// No description provided for @swUserProfileHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String swUserProfileHoursAgo(String count);

  /// No description provided for @swUserProfileDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String swUserProfileDaysAgo(String count);

  /// No description provided for @swUserProfileMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get swUserProfileMonthJan;

  /// No description provided for @swUserProfileMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get swUserProfileMonthFeb;

  /// No description provided for @swUserProfileMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get swUserProfileMonthMar;

  /// No description provided for @swUserProfileMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get swUserProfileMonthApr;

  /// No description provided for @swUserProfileMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get swUserProfileMonthMay;

  /// No description provided for @swUserProfileMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get swUserProfileMonthJun;

  /// No description provided for @swUserProfileMonthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get swUserProfileMonthJul;

  /// No description provided for @swUserProfileMonthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get swUserProfileMonthAug;

  /// No description provided for @swUserProfileMonthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get swUserProfileMonthSep;

  /// No description provided for @swUserProfileMonthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get swUserProfileMonthOct;

  /// No description provided for @swUserProfileMonthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get swUserProfileMonthNov;

  /// No description provided for @swUserProfileMonthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get swUserProfileMonthDec;

  /// No description provided for @swUserProfileGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get swUserProfileGetStarted;

  /// No description provided for @swVideoCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get swVideoCompleted;

  /// No description provided for @swVideoInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get swVideoInProgress;

  /// No description provided for @swVideoLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get swVideoLike;

  /// No description provided for @swVideoDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get swVideoDownloaded;

  /// No description provided for @swVideoDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get swVideoDownload;

  /// No description provided for @swVideoViewsMillions.
  ///
  /// In en, this message translates to:
  /// **'{count}M views'**
  String swVideoViewsMillions(String count);

  /// No description provided for @swVideoViewsThousands.
  ///
  /// In en, this message translates to:
  /// **'{count}K views'**
  String swVideoViewsThousands(String count);

  /// No description provided for @swVideoViewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String swVideoViewsCount(String count);

  /// No description provided for @swVideoPercentWatched.
  ///
  /// In en, this message translates to:
  /// **'{percent}% watched'**
  String swVideoPercentWatched(String percent);

  /// No description provided for @swVideoPlaylistCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} completed'**
  String swVideoPlaylistCompleted(String completed, String total);

  /// No description provided for @swVideoNoVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos available'**
  String get swVideoNoVideos;

  /// No description provided for @swVideoBrowseVideos.
  ///
  /// In en, this message translates to:
  /// **'Browse Videos'**
  String get swVideoBrowseVideos;

  /// No description provided for @swStatsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get swStatsCurrent;

  /// No description provided for @connectionStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get connectionStatusLive;

  /// No description provided for @connectionStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connectionStatusConnecting;

  /// No description provided for @connectionStatusConnectingShort.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connectionStatusConnectingShort;

  /// No description provided for @connectionStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get connectionStatusOffline;

  /// No description provided for @connectionStatusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get connectionStatusError;

  /// No description provided for @connectionStatusTooltipConnected.
  ///
  /// In en, this message translates to:
  /// **'Real-time updates are active'**
  String get connectionStatusTooltipConnected;

  /// No description provided for @connectionStatusTooltipConnecting.
  ///
  /// In en, this message translates to:
  /// **'Establishing real-time connection...'**
  String get connectionStatusTooltipConnecting;

  /// No description provided for @connectionStatusTooltipDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Real-time updates are not available. Data will refresh periodically.'**
  String get connectionStatusTooltipDisconnected;

  /// No description provided for @connectionStatusTooltipError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet connection.'**
  String get connectionStatusTooltipError;

  /// No description provided for @loadingIndicatorDefault.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingIndicatorDefault;

  /// No description provided for @messageBadgeUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread messages'**
  String messageBadgeUnread(String count);

  /// No description provided for @messageBadgeMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messageBadgeMessages;

  /// No description provided for @notificationBadgeUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String notificationBadgeUnread(String count);

  /// No description provided for @notificationBadgeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationBadgeNotifications;

  /// No description provided for @typingIndicatorOneUser.
  ///
  /// In en, this message translates to:
  /// **'{user} is typing'**
  String typingIndicatorOneUser(String user);

  /// No description provided for @typingIndicatorTwoUsers.
  ///
  /// In en, this message translates to:
  /// **'{user1} and {user2} are typing'**
  String typingIndicatorTwoUsers(String user1, String user2);

  /// No description provided for @typingIndicatorMultipleUsers.
  ///
  /// In en, this message translates to:
  /// **'{user1}, {user2} and {count} others are typing'**
  String typingIndicatorMultipleUsers(String user1, String user2, String count);

  /// No description provided for @lessonEditorEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get lessonEditorEdit;

  /// No description provided for @lessonEditorSaveLesson.
  ///
  /// In en, this message translates to:
  /// **'Save Lesson'**
  String get lessonEditorSaveLesson;

  /// No description provided for @lessonEditorBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get lessonEditorBasicInfo;

  /// No description provided for @lessonEditorLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson Title *'**
  String get lessonEditorLessonTitle;

  /// No description provided for @lessonEditorLessonTitleHelper.
  ///
  /// In en, this message translates to:
  /// **'Give your lesson a clear, descriptive title'**
  String get lessonEditorLessonTitleHelper;

  /// No description provided for @lessonEditorLessonTitleError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a lesson title'**
  String get lessonEditorLessonTitleError;

  /// No description provided for @lessonEditorDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get lessonEditorDescription;

  /// No description provided for @lessonEditorDescriptionHelper.
  ///
  /// In en, this message translates to:
  /// **'Provide a brief overview of this lesson'**
  String get lessonEditorDescriptionHelper;

  /// No description provided for @lessonEditorDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get lessonEditorDuration;

  /// No description provided for @lessonEditorMandatory.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get lessonEditorMandatory;

  /// No description provided for @lessonEditorMandatorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Students must complete this lesson'**
  String get lessonEditorMandatorySubtitle;

  /// No description provided for @lessonEditorPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get lessonEditorPublished;

  /// No description provided for @lessonEditorPublishedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible to students'**
  String get lessonEditorPublishedSubtitle;

  /// No description provided for @lessonEditorLessonContent.
  ///
  /// In en, this message translates to:
  /// **'Lesson Content'**
  String get lessonEditorLessonContent;

  /// No description provided for @lessonEditorSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Lesson saved successfully'**
  String get lessonEditorSaveSuccess;

  /// No description provided for @lessonEditorSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving lesson'**
  String get lessonEditorSaveError;

  /// No description provided for @lessonEditorVideoSavePending.
  ///
  /// In en, this message translates to:
  /// **'Video content will be saved (API integration pending)'**
  String get lessonEditorVideoSavePending;

  /// No description provided for @lessonEditorTextSavePending.
  ///
  /// In en, this message translates to:
  /// **'Text content will be saved (API integration pending)'**
  String get lessonEditorTextSavePending;

  /// No description provided for @lessonEditorQuizSavePending.
  ///
  /// In en, this message translates to:
  /// **'Quiz content will be saved (API integration pending)'**
  String get lessonEditorQuizSavePending;

  /// No description provided for @lessonEditorAssignmentSavePending.
  ///
  /// In en, this message translates to:
  /// **'Assignment content will be saved (API integration pending)'**
  String get lessonEditorAssignmentSavePending;

  /// No description provided for @adminApprovalConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Approval Configuration'**
  String get adminApprovalConfiguration;

  /// No description provided for @adminApprovalRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminApprovalRefresh;

  /// No description provided for @adminApprovalFailedToLoadConfigurations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load configurations'**
  String get adminApprovalFailedToLoadConfigurations;

  /// No description provided for @adminApprovalRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminApprovalRetry;

  /// No description provided for @adminApprovalNoConfigurationsFound.
  ///
  /// In en, this message translates to:
  /// **'No configurations found'**
  String get adminApprovalNoConfigurationsFound;

  /// No description provided for @adminApprovalEditConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Edit configuration'**
  String get adminApprovalEditConfiguration;

  /// No description provided for @adminApprovalType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get adminApprovalType;

  /// No description provided for @adminApprovalApprovalLevel.
  ///
  /// In en, this message translates to:
  /// **'Approval Level'**
  String get adminApprovalApprovalLevel;

  /// No description provided for @adminApprovalPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get adminApprovalPriority;

  /// No description provided for @adminApprovalExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get adminApprovalExpires;

  /// No description provided for @adminApprovalAutoExecute.
  ///
  /// In en, this message translates to:
  /// **'Auto Execute'**
  String get adminApprovalAutoExecute;

  /// No description provided for @adminApprovalYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get adminApprovalYes;

  /// No description provided for @adminApprovalNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get adminApprovalNo;

  /// No description provided for @adminApprovalMfaRequired.
  ///
  /// In en, this message translates to:
  /// **'MFA Required'**
  String get adminApprovalMfaRequired;

  /// No description provided for @adminApprovalSkipLevels.
  ///
  /// In en, this message translates to:
  /// **'Skip Levels'**
  String get adminApprovalSkipLevels;

  /// No description provided for @adminApprovalAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get adminApprovalAllowed;

  /// No description provided for @adminApprovalInitiatorRoles.
  ///
  /// In en, this message translates to:
  /// **'Initiator Roles'**
  String get adminApprovalInitiatorRoles;

  /// No description provided for @adminApprovalApproverRoles.
  ///
  /// In en, this message translates to:
  /// **'Approver Roles'**
  String get adminApprovalApproverRoles;

  /// No description provided for @adminApprovalNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get adminApprovalNotifications;

  /// No description provided for @adminApprovalConfigurationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Configuration updated'**
  String get adminApprovalConfigurationUpdated;

  /// No description provided for @adminApprovalFailedToUpdateConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Failed to update configuration'**
  String get adminApprovalFailedToUpdateConfiguration;

  /// No description provided for @adminApprovalEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminApprovalEdit;

  /// No description provided for @adminApprovalDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminApprovalDescription;

  /// No description provided for @adminApprovalDescribeWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Describe this approval workflow'**
  String get adminApprovalDescribeWorkflow;

  /// No description provided for @adminApprovalDefaultPriority.
  ///
  /// In en, this message translates to:
  /// **'Default Priority'**
  String get adminApprovalDefaultPriority;

  /// No description provided for @adminApprovalPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get adminApprovalPriorityLow;

  /// No description provided for @adminApprovalPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get adminApprovalPriorityNormal;

  /// No description provided for @adminApprovalPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get adminApprovalPriorityHigh;

  /// No description provided for @adminApprovalPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get adminApprovalPriorityUrgent;

  /// No description provided for @adminApprovalExpirationHours.
  ///
  /// In en, this message translates to:
  /// **'Expiration (hours)'**
  String get adminApprovalExpirationHours;

  /// No description provided for @adminApprovalLeaveEmptyNoExpiration.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for no expiration'**
  String get adminApprovalLeaveEmptyNoExpiration;

  /// No description provided for @adminApprovalSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminApprovalSettings;

  /// No description provided for @adminApprovalActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminApprovalActive;

  /// No description provided for @adminApprovalEnableDisableWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable this workflow'**
  String get adminApprovalEnableDisableWorkflow;

  /// No description provided for @adminApprovalAutoExecuteTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Execute'**
  String get adminApprovalAutoExecuteTitle;

  /// No description provided for @adminApprovalAutoExecuteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically execute action after final approval'**
  String get adminApprovalAutoExecuteSubtitle;

  /// No description provided for @adminApprovalRequireMfa.
  ///
  /// In en, this message translates to:
  /// **'Require MFA'**
  String get adminApprovalRequireMfa;

  /// No description provided for @adminApprovalRequireMfaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require multi-factor auth for approval'**
  String get adminApprovalRequireMfaSubtitle;

  /// No description provided for @adminApprovalAllowLevelSkipping.
  ///
  /// In en, this message translates to:
  /// **'Allow Level Skipping'**
  String get adminApprovalAllowLevelSkipping;

  /// No description provided for @adminApprovalAllowLevelSkippingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow higher-level admins to skip approval levels'**
  String get adminApprovalAllowLevelSkippingSubtitle;

  /// No description provided for @adminApprovalNotificationChannels.
  ///
  /// In en, this message translates to:
  /// **'Notification Channels'**
  String get adminApprovalNotificationChannels;

  /// No description provided for @adminApprovalInApp.
  ///
  /// In en, this message translates to:
  /// **'In-App'**
  String get adminApprovalInApp;

  /// No description provided for @adminApprovalEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminApprovalEmail;

  /// No description provided for @adminApprovalPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get adminApprovalPush;

  /// No description provided for @adminApprovalSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get adminApprovalSms;

  /// No description provided for @adminApprovalCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminApprovalCancel;

  /// No description provided for @adminApprovalSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get adminApprovalSaveChanges;

  /// No description provided for @adminApprovalStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminApprovalStatusActive;

  /// No description provided for @adminApprovalStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminApprovalStatusInactive;

  /// No description provided for @adminApprovalWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Approval Workflow'**
  String get adminApprovalWorkflow;

  /// No description provided for @adminApprovalViewAllRequests.
  ///
  /// In en, this message translates to:
  /// **'View All Requests'**
  String get adminApprovalViewAllRequests;

  /// No description provided for @adminApprovalOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get adminApprovalOverview;

  /// No description provided for @adminApprovalErrorLoadingStats.
  ///
  /// In en, this message translates to:
  /// **'Error loading statistics: {error}'**
  String adminApprovalErrorLoadingStats(String error);

  /// No description provided for @adminApprovalYourPendingActions.
  ///
  /// In en, this message translates to:
  /// **'Your Pending Actions'**
  String get adminApprovalYourPendingActions;

  /// No description provided for @adminApprovalErrorLoadingPending.
  ///
  /// In en, this message translates to:
  /// **'Error loading pending actions: {error}'**
  String adminApprovalErrorLoadingPending(String error);

  /// No description provided for @adminApprovalQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get adminApprovalQuickActions;

  /// No description provided for @adminApprovalTotalRequests.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get adminApprovalTotalRequests;

  /// No description provided for @adminApprovalPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get adminApprovalPendingReview;

  /// No description provided for @adminApprovalUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get adminApprovalUnderReview;

  /// No description provided for @adminApprovalApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminApprovalApproved;

  /// No description provided for @adminApprovalDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get adminApprovalDenied;

  /// No description provided for @adminApprovalExecuted.
  ///
  /// In en, this message translates to:
  /// **'Executed'**
  String get adminApprovalExecuted;

  /// No description provided for @adminApprovalAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get adminApprovalAllCaughtUp;

  /// No description provided for @adminApprovalNoPendingActions.
  ///
  /// In en, this message translates to:
  /// **'You have no pending actions.'**
  String get adminApprovalNoPendingActions;

  /// No description provided for @adminApprovalPendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get adminApprovalPendingReviews;

  /// No description provided for @adminApprovalAwaitingYourResponse.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Your Response'**
  String get adminApprovalAwaitingYourResponse;

  /// No description provided for @adminApprovalDelegatedToYou.
  ///
  /// In en, this message translates to:
  /// **'Delegated to You'**
  String get adminApprovalDelegatedToYou;

  /// No description provided for @adminApprovalNewRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get adminApprovalNewRequest;

  /// No description provided for @adminApprovalAllRequests.
  ///
  /// In en, this message translates to:
  /// **'All Requests'**
  String get adminApprovalAllRequests;

  /// No description provided for @adminApprovalMyRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get adminApprovalMyRequests;

  /// No description provided for @adminApprovalConfigurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get adminApprovalConfigurationLabel;

  /// No description provided for @adminApprovalRequest.
  ///
  /// In en, this message translates to:
  /// **'Approval Request'**
  String get adminApprovalRequest;

  /// No description provided for @adminApprovalErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminApprovalErrorWithMessage(String error);

  /// No description provided for @adminApprovalRequestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found'**
  String get adminApprovalRequestNotFound;

  /// No description provided for @adminApprovalDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get adminApprovalDetails;

  /// No description provided for @adminApprovalInitiatedBy.
  ///
  /// In en, this message translates to:
  /// **'Initiated by'**
  String get adminApprovalInitiatedBy;

  /// No description provided for @adminApprovalRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminApprovalRole;

  /// No description provided for @adminApprovalRequestType.
  ///
  /// In en, this message translates to:
  /// **'Request Type'**
  String get adminApprovalRequestType;

  /// No description provided for @adminApprovalCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get adminApprovalCreated;

  /// No description provided for @adminApprovalExpiresLabel.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get adminApprovalExpiresLabel;

  /// No description provided for @adminApprovalJustification.
  ///
  /// In en, this message translates to:
  /// **'Justification'**
  String get adminApprovalJustification;

  /// No description provided for @adminApprovalChain.
  ///
  /// In en, this message translates to:
  /// **'Approval Chain'**
  String get adminApprovalChain;

  /// No description provided for @adminApprovalActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get adminApprovalActions;

  /// No description provided for @adminApprovalNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get adminApprovalNotesOptional;

  /// No description provided for @adminApprovalAddNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes for your action...'**
  String get adminApprovalAddNotesHint;

  /// No description provided for @adminApprovalApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get adminApprovalApprove;

  /// No description provided for @adminApprovalDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get adminApprovalDeny;

  /// No description provided for @adminApprovalRequestInfo.
  ///
  /// In en, this message translates to:
  /// **'Request Info'**
  String get adminApprovalRequestInfo;

  /// No description provided for @adminApprovalEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate'**
  String get adminApprovalEscalate;

  /// No description provided for @adminApprovalComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get adminApprovalComments;

  /// No description provided for @adminApprovalAddCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get adminApprovalAddCommentHint;

  /// No description provided for @adminApprovalNoCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get adminApprovalNoCommentsYet;

  /// No description provided for @adminApprovalStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminApprovalStatusPending;

  /// No description provided for @adminApprovalEscalated.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get adminApprovalEscalated;

  /// No description provided for @adminApprovalLevelRegional.
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get adminApprovalLevelRegional;

  /// No description provided for @adminApprovalLevelSuper.
  ///
  /// In en, this message translates to:
  /// **'Super'**
  String get adminApprovalLevelSuper;

  /// No description provided for @adminApprovalConfirmApproval.
  ///
  /// In en, this message translates to:
  /// **'Confirm Approval'**
  String get adminApprovalConfirmApproval;

  /// No description provided for @adminApprovalConfirmApproveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this request?'**
  String get adminApprovalConfirmApproveMessage;

  /// No description provided for @adminApprovalDenyRequest.
  ///
  /// In en, this message translates to:
  /// **'Deny Request'**
  String get adminApprovalDenyRequest;

  /// No description provided for @adminApprovalProvideReasonDenial.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for denial:'**
  String get adminApprovalProvideReasonDenial;

  /// No description provided for @adminApprovalReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get adminApprovalReason;

  /// No description provided for @adminApprovalRequestInformation.
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get adminApprovalRequestInformation;

  /// No description provided for @adminApprovalWhatInfoNeeded.
  ///
  /// In en, this message translates to:
  /// **'What information do you need from the requester?'**
  String get adminApprovalWhatInfoNeeded;

  /// No description provided for @adminApprovalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get adminApprovalQuestion;

  /// No description provided for @adminApprovalSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get adminApprovalSend;

  /// No description provided for @adminApprovalEscalateRequest.
  ///
  /// In en, this message translates to:
  /// **'Escalate Request'**
  String get adminApprovalEscalateRequest;

  /// No description provided for @adminApprovalConfirmEscalateMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to escalate this request to a higher level?'**
  String get adminApprovalConfirmEscalateMessage;

  /// No description provided for @adminApprovalEscalatedForReview.
  ///
  /// In en, this message translates to:
  /// **'Escalated for higher review'**
  String get adminApprovalEscalatedForReview;

  /// No description provided for @adminApprovalRequests.
  ///
  /// In en, this message translates to:
  /// **'Approval Requests'**
  String get adminApprovalRequests;

  /// No description provided for @adminApprovalFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get adminApprovalFilter;

  /// No description provided for @adminApprovalFiltersApplied.
  ///
  /// In en, this message translates to:
  /// **'Filters applied'**
  String get adminApprovalFiltersApplied;

  /// No description provided for @adminApprovalClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get adminApprovalClear;

  /// No description provided for @adminApprovalRequestCount.
  ///
  /// In en, this message translates to:
  /// **'{count} requests'**
  String adminApprovalRequestCount(int count);

  /// No description provided for @adminApprovalNoRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No approval requests found'**
  String get adminApprovalNoRequestsFound;

  /// No description provided for @adminApprovalCreateNewRequest.
  ///
  /// In en, this message translates to:
  /// **'Create New Request'**
  String get adminApprovalCreateNewRequest;

  /// No description provided for @adminApprovalCreateRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Approval Request'**
  String get adminApprovalCreateRequest;

  /// No description provided for @adminApprovalCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminApprovalCategory;

  /// No description provided for @adminApprovalAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get adminApprovalAction;

  /// No description provided for @adminApprovalTargetResource.
  ///
  /// In en, this message translates to:
  /// **'Target Resource'**
  String get adminApprovalTargetResource;

  /// No description provided for @adminApprovalResourceType.
  ///
  /// In en, this message translates to:
  /// **'Resource Type'**
  String get adminApprovalResourceType;

  /// No description provided for @adminApprovalResourceIdOptional.
  ///
  /// In en, this message translates to:
  /// **'Resource ID (optional)'**
  String get adminApprovalResourceIdOptional;

  /// No description provided for @adminApprovalEnterResourceId.
  ///
  /// In en, this message translates to:
  /// **'Enter the ID of the target resource'**
  String get adminApprovalEnterResourceId;

  /// No description provided for @adminApprovalJustificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide a detailed justification for this request.'**
  String get adminApprovalJustificationDescription;

  /// No description provided for @adminApprovalJustificationHint.
  ///
  /// In en, this message translates to:
  /// **'Explain why this action is needed and its expected impact...'**
  String get adminApprovalJustificationHint;

  /// No description provided for @adminApprovalPleaseProvideJustification.
  ///
  /// In en, this message translates to:
  /// **'Please provide a justification'**
  String get adminApprovalPleaseProvideJustification;

  /// No description provided for @adminApprovalJustificationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Justification must be at least 20 characters'**
  String get adminApprovalJustificationMinLength;

  /// No description provided for @adminApprovalSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get adminApprovalSubmitRequest;

  /// No description provided for @adminApprovalRequestSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Approval request submitted successfully'**
  String get adminApprovalRequestSubmittedSuccess;

  /// No description provided for @adminApprovalApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get adminApprovalApply;

  /// No description provided for @adminApprovalFilterRequests.
  ///
  /// In en, this message translates to:
  /// **'Filter Requests'**
  String get adminApprovalFilterRequests;

  /// No description provided for @adminApprovalSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get adminApprovalSearch;

  /// No description provided for @adminApprovalSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by request number or justification'**
  String get adminApprovalSearchHint;

  /// No description provided for @adminApprovalStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminApprovalStatus;

  /// No description provided for @adminApprovalClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get adminApprovalClearAll;

  /// No description provided for @adminApprovalUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get adminApprovalUnknown;

  /// No description provided for @adminApprovalExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get adminApprovalExpired;

  /// No description provided for @adminApprovalExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days}d'**
  String adminApprovalExpiresInDays(int days);

  /// No description provided for @adminApprovalExpiresInHours.
  ///
  /// In en, this message translates to:
  /// **'Expires in {hours}h'**
  String adminApprovalExpiresInHours(int hours);

  /// No description provided for @adminApprovalExpiresInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Expires in {minutes}m'**
  String adminApprovalExpiresInMinutes(int minutes);

  /// No description provided for @adminApprovalStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get adminApprovalStatusDraft;

  /// No description provided for @adminApprovalStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get adminApprovalStatusUnderReview;

  /// No description provided for @adminApprovalStatusInfoNeeded.
  ///
  /// In en, this message translates to:
  /// **'Info Needed'**
  String get adminApprovalStatusInfoNeeded;

  /// No description provided for @adminApprovalStatusEscalated.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get adminApprovalStatusEscalated;

  /// No description provided for @adminApprovalStatusApprovedLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminApprovalStatusApprovedLabel;

  /// No description provided for @adminApprovalStatusDeniedLabel.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get adminApprovalStatusDeniedLabel;

  /// No description provided for @adminApprovalStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get adminApprovalStatusWithdrawn;

  /// No description provided for @adminApprovalStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get adminApprovalStatusExpired;

  /// No description provided for @adminApprovalStatusExecuted.
  ///
  /// In en, this message translates to:
  /// **'Executed'**
  String get adminApprovalStatusExecuted;

  /// No description provided for @adminApprovalStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get adminApprovalStatusFailed;

  /// No description provided for @adminApprovalStatusReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get adminApprovalStatusReviewing;

  /// No description provided for @adminApprovalNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get adminApprovalNoItems;

  /// No description provided for @adminApprovalViewAllItems.
  ///
  /// In en, this message translates to:
  /// **'View all {count} items'**
  String adminApprovalViewAllItems(int count);

  /// No description provided for @adminApprovalByName.
  ///
  /// In en, this message translates to:
  /// **'By: {name}'**
  String adminApprovalByName(String name);

  /// No description provided for @adminContentAssessmentsManagement.
  ///
  /// In en, this message translates to:
  /// **'Assessments Management'**
  String get adminContentAssessmentsManagement;

  /// No description provided for @adminContentManageQuizzesAndAssignments.
  ///
  /// In en, this message translates to:
  /// **'Manage quizzes and assignments across all courses'**
  String get adminContentManageQuizzesAndAssignments;

  /// No description provided for @adminContentRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminContentRefresh;

  /// No description provided for @adminContentCreateAssessment.
  ///
  /// In en, this message translates to:
  /// **'Create Assessment'**
  String get adminContentCreateAssessment;

  /// No description provided for @adminContentCreateNewAssessment.
  ///
  /// In en, this message translates to:
  /// **'Create New Assessment'**
  String get adminContentCreateNewAssessment;

  /// No description provided for @adminContentAssessmentTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Assessment Type *'**
  String get adminContentAssessmentTypeRequired;

  /// No description provided for @adminContentQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get adminContentQuiz;

  /// No description provided for @adminContentAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get adminContentAssignment;

  /// No description provided for @adminContentCourseRequired.
  ///
  /// In en, this message translates to:
  /// **'Course *'**
  String get adminContentCourseRequired;

  /// No description provided for @adminContentLoadingCourses.
  ///
  /// In en, this message translates to:
  /// **'Loading courses...'**
  String get adminContentLoadingCourses;

  /// No description provided for @adminContentSelectACourse.
  ///
  /// In en, this message translates to:
  /// **'Select a course'**
  String get adminContentSelectACourse;

  /// No description provided for @adminContentModuleRequired.
  ///
  /// In en, this message translates to:
  /// **'Module *'**
  String get adminContentModuleRequired;

  /// No description provided for @adminContentLoadingModules.
  ///
  /// In en, this message translates to:
  /// **'Loading modules...'**
  String get adminContentLoadingModules;

  /// No description provided for @adminContentSelectACourseFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a course first'**
  String get adminContentSelectACourseFirst;

  /// No description provided for @adminContentNoModulesInCourse.
  ///
  /// In en, this message translates to:
  /// **'No modules in this course'**
  String get adminContentNoModulesInCourse;

  /// No description provided for @adminContentSelectAModule.
  ///
  /// In en, this message translates to:
  /// **'Select a module'**
  String get adminContentSelectAModule;

  /// No description provided for @adminContentLessonTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Lesson Title *'**
  String get adminContentLessonTitleRequired;

  /// No description provided for @adminContentEnterLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter lesson title'**
  String get adminContentEnterLessonTitle;

  /// No description provided for @adminContentTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get adminContentTitleRequired;

  /// No description provided for @adminContentEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get adminContentEnterTitle;

  /// No description provided for @adminContentPassingScorePercent.
  ///
  /// In en, this message translates to:
  /// **'Passing Score (%)'**
  String get adminContentPassingScorePercent;

  /// No description provided for @adminContentInstructionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Instructions *'**
  String get adminContentInstructionsRequired;

  /// No description provided for @adminContentEnterAssignmentInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter assignment instructions'**
  String get adminContentEnterAssignmentInstructions;

  /// No description provided for @adminContentPointsPossible.
  ///
  /// In en, this message translates to:
  /// **'Points Possible'**
  String get adminContentPointsPossible;

  /// No description provided for @adminContentQuizDraftNotice.
  ///
  /// In en, this message translates to:
  /// **'Quiz will be created as a draft. Add questions in the Course Builder.'**
  String get adminContentQuizDraftNotice;

  /// No description provided for @adminContentAssignmentDraftNotice.
  ///
  /// In en, this message translates to:
  /// **'Assignment will be created as a draft. Configure details in the Course Builder.'**
  String get adminContentAssignmentDraftNotice;

  /// No description provided for @adminContentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminContentCancel;

  /// No description provided for @adminContentPleaseSelectCourseAndModule.
  ///
  /// In en, this message translates to:
  /// **'Please select course and module'**
  String get adminContentPleaseSelectCourseAndModule;

  /// No description provided for @adminContentPleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get adminContentPleaseFillRequiredFields;

  /// No description provided for @adminContentPleaseEnterInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please enter assignment instructions'**
  String get adminContentPleaseEnterInstructions;

  /// No description provided for @adminContentAssessmentCreated.
  ///
  /// In en, this message translates to:
  /// **'{type} created'**
  String adminContentAssessmentCreated(String type);

  /// No description provided for @adminContentFailedToCreateAssessment.
  ///
  /// In en, this message translates to:
  /// **'Failed to create assessment'**
  String get adminContentFailedToCreateAssessment;

  /// No description provided for @adminContentCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get adminContentCreate;

  /// No description provided for @adminContentTotalAssessments.
  ///
  /// In en, this message translates to:
  /// **'Total Assessments'**
  String get adminContentTotalAssessments;

  /// No description provided for @adminContentAllAssessments.
  ///
  /// In en, this message translates to:
  /// **'All assessments'**
  String get adminContentAllAssessments;

  /// No description provided for @adminContentQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get adminContentQuizzes;

  /// No description provided for @adminContentAutoGraded.
  ///
  /// In en, this message translates to:
  /// **'Auto-graded'**
  String get adminContentAutoGraded;

  /// No description provided for @adminContentAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get adminContentAssignments;

  /// No description provided for @adminContentManualGrading.
  ///
  /// In en, this message translates to:
  /// **'Manual grading'**
  String get adminContentManualGrading;

  /// No description provided for @adminContentPendingGrading.
  ///
  /// In en, this message translates to:
  /// **'Pending Grading'**
  String get adminContentPendingGrading;

  /// No description provided for @adminContentAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get adminContentAwaitingReview;

  /// No description provided for @adminContentSearchAssessments.
  ///
  /// In en, this message translates to:
  /// **'Search assessments by title...'**
  String get adminContentSearchAssessments;

  /// No description provided for @adminContentAssessmentType.
  ///
  /// In en, this message translates to:
  /// **'Assessment Type'**
  String get adminContentAssessmentType;

  /// No description provided for @adminContentAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get adminContentAllTypes;

  /// No description provided for @adminContentTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminContentTitleLabel;

  /// No description provided for @adminContentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get adminContentTypeLabel;

  /// No description provided for @adminContentCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get adminContentCourseLabel;

  /// No description provided for @adminContentQuestionsSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Questions / Submissions'**
  String get adminContentQuestionsSubmissions;

  /// No description provided for @adminContentQuestionsAttempts.
  ///
  /// In en, this message translates to:
  /// **'{questions} questions ({attempts} attempts)'**
  String adminContentQuestionsAttempts(int questions, int attempts);

  /// No description provided for @adminContentSubmissionsGraded.
  ///
  /// In en, this message translates to:
  /// **'{submissions} submissions ({graded} graded)'**
  String adminContentSubmissionsGraded(int submissions, int graded);

  /// No description provided for @adminContentScoreGrade.
  ///
  /// In en, this message translates to:
  /// **'Score / Grade'**
  String get adminContentScoreGrade;

  /// No description provided for @adminContentPassRate.
  ///
  /// In en, this message translates to:
  /// **'{rate}% pass'**
  String adminContentPassRate(String rate);

  /// No description provided for @adminContentAvgGrade.
  ///
  /// In en, this message translates to:
  /// **'{grade}% avg'**
  String adminContentAvgGrade(String grade);

  /// No description provided for @adminContentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get adminContentUpdated;

  /// No description provided for @adminContentViewStats.
  ///
  /// In en, this message translates to:
  /// **'View Stats'**
  String get adminContentViewStats;

  /// No description provided for @adminContentEditInCourseBuilder.
  ///
  /// In en, this message translates to:
  /// **'Edit in Course Builder'**
  String get adminContentEditInCourseBuilder;

  /// No description provided for @adminContentQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get adminContentQuestions;

  /// No description provided for @adminContentAttempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get adminContentAttempts;

  /// No description provided for @adminContentAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get adminContentAverageScore;

  /// No description provided for @adminContentPassRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Pass Rate'**
  String get adminContentPassRateLabel;

  /// No description provided for @adminContentSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get adminContentSubmissions;

  /// No description provided for @adminContentGraded.
  ///
  /// In en, this message translates to:
  /// **'Graded'**
  String get adminContentGraded;

  /// No description provided for @adminContentPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminContentPending;

  /// No description provided for @adminContentAverageGrade.
  ///
  /// In en, this message translates to:
  /// **'Average Grade'**
  String get adminContentAverageGrade;

  /// No description provided for @adminContentDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get adminContentDueDate;

  /// No description provided for @adminContentLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get adminContentLastUpdated;

  /// No description provided for @adminContentClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get adminContentClose;

  /// No description provided for @adminContentToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get adminContentToday;

  /// No description provided for @adminContentYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get adminContentYesterday;

  /// No description provided for @adminContentDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String adminContentDaysAgo(int days);

  /// No description provided for @adminContentWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{weeks} weeks ago'**
  String adminContentWeeksAgo(int weeks);

  /// No description provided for @adminContentMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{months} months ago'**
  String adminContentMonthsAgo(int months);

  /// No description provided for @adminContentYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{years} years ago'**
  String adminContentYearsAgo(int years);

  /// No description provided for @adminContentManagement.
  ///
  /// In en, this message translates to:
  /// **'Content Management'**
  String get adminContentManagement;

  /// No description provided for @adminContentManageVideoCourses.
  ///
  /// In en, this message translates to:
  /// **'Manage video courses and tutorials'**
  String get adminContentManageVideoCourses;

  /// No description provided for @adminContentManageTextMaterials.
  ///
  /// In en, this message translates to:
  /// **'Manage text-based learning materials'**
  String get adminContentManageTextMaterials;

  /// No description provided for @adminContentManageInteractive.
  ///
  /// In en, this message translates to:
  /// **'Manage interactive learning content'**
  String get adminContentManageInteractive;

  /// No description provided for @adminContentManageLiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Manage live sessions and webinars'**
  String get adminContentManageLiveSessions;

  /// No description provided for @adminContentManageHybrid.
  ///
  /// In en, this message translates to:
  /// **'Manage hybrid learning experiences'**
  String get adminContentManageHybrid;

  /// No description provided for @adminContentManageEducational.
  ///
  /// In en, this message translates to:
  /// **'Manage educational content, courses, and curriculum'**
  String get adminContentManageEducational;

  /// No description provided for @adminContentExportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon'**
  String get adminContentExportComingSoon;

  /// No description provided for @adminContentExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get adminContentExport;

  /// No description provided for @adminContentCreateContent.
  ///
  /// In en, this message translates to:
  /// **'Create Content'**
  String get adminContentCreateContent;

  /// No description provided for @adminContentCreateNewContent.
  ///
  /// In en, this message translates to:
  /// **'Create New Content'**
  String get adminContentCreateNewContent;

  /// No description provided for @adminContentEnterContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter content title'**
  String get adminContentEnterContentTitle;

  /// No description provided for @adminContentDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminContentDescription;

  /// No description provided for @adminContentEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter content description'**
  String get adminContentEnterDescription;

  /// No description provided for @adminContentDraftNotice.
  ///
  /// In en, this message translates to:
  /// **'Content will be created as a draft. You can edit and publish it later.'**
  String get adminContentDraftNotice;

  /// No description provided for @adminContentPleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get adminContentPleaseEnterTitle;

  /// No description provided for @adminContentCurriculumManagement.
  ///
  /// In en, this message translates to:
  /// **'Curriculum Management'**
  String get adminContentCurriculumManagement;

  /// No description provided for @adminContentManageModulesAndLessons.
  ///
  /// In en, this message translates to:
  /// **'Manage modules and lessons across all courses'**
  String get adminContentManageModulesAndLessons;

  /// No description provided for @adminContentCreateModule.
  ///
  /// In en, this message translates to:
  /// **'Create Module'**
  String get adminContentCreateModule;

  /// No description provided for @adminContentCreateNewModule.
  ///
  /// In en, this message translates to:
  /// **'Create New Module'**
  String get adminContentCreateNewModule;

  /// No description provided for @adminContentResourcesManagement.
  ///
  /// In en, this message translates to:
  /// **'Resources Management'**
  String get adminContentResourcesManagement;

  /// No description provided for @adminContentManageVideoAndText.
  ///
  /// In en, this message translates to:
  /// **'Manage video and text content across all courses'**
  String get adminContentManageVideoAndText;

  /// No description provided for @adminContentCreateResource.
  ///
  /// In en, this message translates to:
  /// **'Create Resource'**
  String get adminContentCreateResource;

  /// No description provided for @adminContentCreateNewResource.
  ///
  /// In en, this message translates to:
  /// **'Create New Resource'**
  String get adminContentCreateNewResource;

  /// No description provided for @adminContentPageContentManagement.
  ///
  /// In en, this message translates to:
  /// **'Page Content Management'**
  String get adminContentPageContentManagement;

  /// No description provided for @adminContentManageFooterPages.
  ///
  /// In en, this message translates to:
  /// **'Manage footer pages content (About, Privacy, Terms, etc.)'**
  String get adminContentManageFooterPages;

  /// No description provided for @adminContentErrorLoadingPages.
  ///
  /// In en, this message translates to:
  /// **'Error loading pages'**
  String get adminContentErrorLoadingPages;

  /// No description provided for @adminContentRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminContentRetry;

  /// No description provided for @adminContentNoPagesFound.
  ///
  /// In en, this message translates to:
  /// **'No pages found'**
  String get adminContentNoPagesFound;

  /// No description provided for @adminContentRunMigration.
  ///
  /// In en, this message translates to:
  /// **'Run the database migration to seed initial page content.'**
  String get adminContentRunMigration;

  /// No description provided for @adminContentAtLeastOneSection.
  ///
  /// In en, this message translates to:
  /// **'At least one section is required'**
  String get adminContentAtLeastOneSection;

  /// No description provided for @adminContentRemoveSection.
  ///
  /// In en, this message translates to:
  /// **'Remove Section'**
  String get adminContentRemoveSection;

  /// No description provided for @adminContentConfirmRemoveSection.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this section?'**
  String get adminContentConfirmRemoveSection;

  /// No description provided for @adminContentRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get adminContentRemove;

  /// No description provided for @adminContentInvalidJson.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON in content field'**
  String get adminContentInvalidJson;

  /// No description provided for @adminContentPageSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Page saved successfully'**
  String get adminContentPageSavedSuccessfully;

  /// No description provided for @adminContentFailedToSavePage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save page'**
  String get adminContentFailedToSavePage;

  /// No description provided for @adminContentPagePublishedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Page published successfully'**
  String get adminContentPagePublishedSuccessfully;

  /// No description provided for @adminContentFailedToPublishPage.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish page'**
  String get adminContentFailedToPublishPage;

  /// No description provided for @adminContentPageUnpublished.
  ///
  /// In en, this message translates to:
  /// **'Page unpublished'**
  String get adminContentPageUnpublished;

  /// No description provided for @adminContentFailedToUnpublishPage.
  ///
  /// In en, this message translates to:
  /// **'Failed to unpublish page'**
  String get adminContentFailedToUnpublishPage;

  /// No description provided for @adminContentUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get adminContentUnsavedChanges;

  /// No description provided for @adminContentDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Do you want to discard them?'**
  String get adminContentDiscardChanges;

  /// No description provided for @adminContentDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get adminContentDiscard;

  /// No description provided for @adminContentStartTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing your content here...'**
  String get adminContentStartTyping;

  /// No description provided for @adminContentSupportsMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Supports Markdown formatting'**
  String get adminContentSupportsMarkdown;

  /// No description provided for @adminContentCharacterCount.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String adminContentCharacterCount(int count);

  /// No description provided for @adminContentSectionIndex.
  ///
  /// In en, this message translates to:
  /// **'Section {index}'**
  String adminContentSectionIndex(int index);

  /// No description provided for @adminContentSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Section Title'**
  String get adminContentSectionTitle;

  /// No description provided for @adminContentEnterSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter section title'**
  String get adminContentEnterSectionTitle;

  /// No description provided for @adminContentSectionContent.
  ///
  /// In en, this message translates to:
  /// **'Section Content'**
  String get adminContentSectionContent;

  /// No description provided for @adminContentEnterSectionContent.
  ///
  /// In en, this message translates to:
  /// **'Enter section content...'**
  String get adminContentEnterSectionContent;

  /// No description provided for @swAchievementToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swAchievementToday;

  /// No description provided for @swAchievementYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swAchievementYesterday;

  /// No description provided for @swAchievementDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String swAchievementDaysAgo(int count);

  /// No description provided for @swAchievementWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String swAchievementWeeksAgo(int count);

  /// No description provided for @swAchievementYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get swAchievementYou;

  /// No description provided for @swAchievementPoints.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get swAchievementPoints;

  /// No description provided for @swChartNoDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get swChartNoDataAvailable;

  /// No description provided for @swCollabPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get swCollabPublic;

  /// No description provided for @swCollabMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max} members'**
  String swCollabMembersCount(int current, int max);

  /// No description provided for @swCollabOnlineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} online'**
  String swCollabOnlineCount(int count);

  /// No description provided for @swCollabGroupFull.
  ///
  /// In en, this message translates to:
  /// **'Group Full'**
  String get swCollabGroupFull;

  /// No description provided for @swCollabJoinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Group'**
  String get swCollabJoinGroup;

  /// No description provided for @swCollabNoGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get swCollabNoGroupsYet;

  /// No description provided for @swCollabCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get swCollabCreateGroup;

  /// No description provided for @swExamQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Questions'**
  String swExamQuestionsCount(int count);

  /// No description provided for @swExamMarksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Marks'**
  String swExamMarksCount(int count);

  /// No description provided for @swExamScoreDisplay.
  ///
  /// In en, this message translates to:
  /// **'{score}/{total}'**
  String swExamScoreDisplay(int score, int total);

  /// No description provided for @swExamStartExam.
  ///
  /// In en, this message translates to:
  /// **'Start Exam'**
  String get swExamStartExam;

  /// No description provided for @swExamToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swExamToday;

  /// No description provided for @swExamTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get swExamTomorrow;

  /// No description provided for @swExamDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String swExamDaysCount(int count);

  /// No description provided for @swExamWriteAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Write your answer here...'**
  String get swExamWriteAnswerHint;

  /// No description provided for @swExamEnterAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer...'**
  String get swExamEnterAnswerHint;

  /// No description provided for @swExamExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get swExamExplanation;

  /// No description provided for @swFocusFocusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get swFocusFocusMode;

  /// No description provided for @swFocusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get swFocusPaused;

  /// No description provided for @swFocusThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get swFocusThisWeek;

  /// No description provided for @swHelpSupportArticlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String swHelpSupportArticlesCount(int count);

  /// No description provided for @swHelpSupportViewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String swHelpSupportViewsCount(int count);

  /// No description provided for @swHelpSupportHelpfulCount.
  ///
  /// In en, this message translates to:
  /// **'{count} found helpful'**
  String swHelpSupportHelpfulCount(int count);

  /// No description provided for @swHelpSupportWasThisHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this helpful?'**
  String get swHelpSupportWasThisHelpful;

  /// No description provided for @swHelpSupportYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get swHelpSupportYes;

  /// No description provided for @swHelpSupportToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swHelpSupportToday;

  /// No description provided for @swHelpSupportYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swHelpSupportYesterday;

  /// No description provided for @swHelpSupportDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String swHelpSupportDaysAgo(int count);

  /// No description provided for @swHelpSupportJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get swHelpSupportJustNow;

  /// No description provided for @swHelpSupportMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String swHelpSupportMinutesAgo(int count);

  /// No description provided for @swHelpSupportHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String swHelpSupportHoursAgo(int count);

  /// No description provided for @swHelpSupportDaysShortAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String swHelpSupportDaysShortAgo(int count);

  /// No description provided for @swInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{number}'**
  String swInvoiceNumber(String number);

  /// No description provided for @swInvoiceIssued.
  ///
  /// In en, this message translates to:
  /// **'Issued: {date}'**
  String swInvoiceIssued(String date);

  /// No description provided for @swInvoiceDue.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String swInvoiceDue(String date);

  /// No description provided for @swInvoiceBillTo.
  ///
  /// In en, this message translates to:
  /// **'BILL TO'**
  String get swInvoiceBillTo;

  /// No description provided for @swInvoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get swInvoiceDescription;

  /// No description provided for @swInvoiceQty.
  ///
  /// In en, this message translates to:
  /// **'QTY'**
  String get swInvoiceQty;

  /// No description provided for @swInvoiceRate.
  ///
  /// In en, this message translates to:
  /// **'RATE'**
  String get swInvoiceRate;

  /// No description provided for @swInvoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get swInvoiceAmount;

  /// No description provided for @swInvoiceSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get swInvoiceSubtotal;

  /// No description provided for @swInvoiceDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get swInvoiceDiscount;

  /// No description provided for @swInvoiceTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get swInvoiceTax;

  /// No description provided for @swInvoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get swInvoiceTotal;

  /// No description provided for @swInvoiceTransactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get swInvoiceTransactionId;

  /// No description provided for @swInvoiceDownloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get swInvoiceDownloadReceipt;

  /// No description provided for @swJobCareerPostedToday.
  ///
  /// In en, this message translates to:
  /// **'Posted today'**
  String get swJobCareerPostedToday;

  /// No description provided for @swJobCareerPostedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Posted yesterday'**
  String get swJobCareerPostedYesterday;

  /// No description provided for @swJobCareerPostedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Posted {count} days ago'**
  String swJobCareerPostedDaysAgo(int count);

  /// No description provided for @swJobCareerRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get swJobCareerRemote;

  /// No description provided for @swJobCareerApplyBy.
  ///
  /// In en, this message translates to:
  /// **'Apply by {date}'**
  String swJobCareerApplyBy(String date);

  /// No description provided for @swJobCareerExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get swJobCareerExpired;

  /// No description provided for @swJobCareerToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swJobCareerToday;

  /// No description provided for @swJobCareerTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get swJobCareerTomorrow;

  /// No description provided for @swJobCareerInDays.
  ///
  /// In en, this message translates to:
  /// **'in {count} days'**
  String swJobCareerInDays(int count);

  /// No description provided for @swJobCareerAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get swJobCareerAvailable;

  /// No description provided for @swJobCareerSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String swJobCareerSessionsCount(int count);

  /// No description provided for @swJobCareerBookSession.
  ///
  /// In en, this message translates to:
  /// **'Book Session'**
  String get swJobCareerBookSession;

  /// No description provided for @swJobCareerApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied {time}'**
  String swJobCareerApplied(String time);

  /// No description provided for @swJobCareerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String swJobCareerUpdated(String time);

  /// No description provided for @swJobCareerDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String swJobCareerDaysAgo(int count);

  /// No description provided for @swJobCareerHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String swJobCareerHoursAgo(int count);

  /// No description provided for @swJobCareerMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String swJobCareerMinutesAgo(int count);

  /// No description provided for @swJobCareerJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get swJobCareerJustNow;

  /// No description provided for @swJobCareerViewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String swJobCareerViewsCount(int count);

  /// No description provided for @swMessageNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get swMessageNoMessagesYet;

  /// No description provided for @swMessageTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get swMessageTypeMessage;

  /// No description provided for @swMessageToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swMessageToday;

  /// No description provided for @swMessageYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swMessageYesterday;

  /// No description provided for @swNoteEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get swNoteEdit;

  /// No description provided for @swNoteUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get swNoteUnpin;

  /// No description provided for @swNotePin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get swNotePin;

  /// No description provided for @swNoteDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get swNoteDelete;

  /// No description provided for @swNoteJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get swNoteJustNow;

  /// No description provided for @swNoteMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String swNoteMinutesAgo(int count);

  /// No description provided for @swNoteHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String swNoteHoursAgo(int count);

  /// No description provided for @swNoteDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String swNoteDaysAgo(int count);

  /// No description provided for @swNoteNotesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String swNoteNotesCount(int count);

  /// No description provided for @swNoteNoNotesYet.
  ///
  /// In en, this message translates to:
  /// **'No Notes Yet'**
  String get swNoteNoNotesYet;

  /// No description provided for @swNoteStartTakingNotes.
  ///
  /// In en, this message translates to:
  /// **'Start taking notes to remember important information'**
  String get swNoteStartTakingNotes;

  /// No description provided for @swNoteCreateNote.
  ///
  /// In en, this message translates to:
  /// **'Create Note'**
  String get swNoteCreateNote;

  /// No description provided for @swNoteSearchNotes.
  ///
  /// In en, this message translates to:
  /// **'Search notes...'**
  String get swNoteSearchNotes;

  /// No description provided for @swOnboardingStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String swOnboardingStepOf(int current, int total);

  /// No description provided for @swOnboardingSkipTutorial.
  ///
  /// In en, this message translates to:
  /// **'Skip Tutorial'**
  String get swOnboardingSkipTutorial;

  /// No description provided for @swOnboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get swOnboardingNext;

  /// No description provided for @swOnboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get swOnboardingFinish;

  /// No description provided for @swPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get swPaymentPending;

  /// No description provided for @swPaymentProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get swPaymentProcessing;

  /// No description provided for @swPaymentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get swPaymentCompleted;

  /// No description provided for @swPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get swPaymentFailed;

  /// No description provided for @swPaymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get swPaymentRefunded;

  /// No description provided for @swPaymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get swPaymentCancelled;

  /// No description provided for @swPaymentDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get swPaymentDefault;

  /// No description provided for @swPaymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get swPaymentCard;

  /// No description provided for @swPaymentBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get swPaymentBankAccount;

  /// No description provided for @swPaymentPaypalAccount.
  ///
  /// In en, this message translates to:
  /// **'PayPal Account'**
  String get swPaymentPaypalAccount;

  /// No description provided for @swPaymentStripePayment.
  ///
  /// In en, this message translates to:
  /// **'Stripe Payment'**
  String get swPaymentStripePayment;

  /// No description provided for @swPaymentRemoveMethod.
  ///
  /// In en, this message translates to:
  /// **'Remove payment method'**
  String get swPaymentRemoveMethod;

  /// No description provided for @swPaymentToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swPaymentToday;

  /// No description provided for @swPaymentYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swPaymentYesterday;

  /// No description provided for @swPaymentDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String swPaymentDaysAgo(int count);

  /// No description provided for @swPaymentCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get swPaymentCardNumber;

  /// No description provided for @swPaymentExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get swPaymentExpiryDate;

  /// No description provided for @swPaymentCvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get swPaymentCvv;

  /// No description provided for @swQuizQuestionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String swQuizQuestionOf(int current, int total);

  /// No description provided for @swQuizPointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{pt} other{pts}}'**
  String swQuizPointsCount(int count);

  /// No description provided for @swQuizTypeAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here...'**
  String get swQuizTypeAnswerHint;

  /// No description provided for @swQuizExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get swQuizExplanation;

  /// No description provided for @swQuizCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get swQuizCongratulations;

  /// No description provided for @swQuizKeepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing!'**
  String get swQuizKeepPracticing;

  /// No description provided for @swQuizYouScored.
  ///
  /// In en, this message translates to:
  /// **'You scored'**
  String get swQuizYouScored;

  /// No description provided for @swQuizScoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'{score} out of {total} points'**
  String swQuizScoreOutOf(int score, int total);

  /// No description provided for @swQuizQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String swQuizQuestionsCount(int count);

  /// No description provided for @swQuizDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String swQuizDurationMin(int count);

  /// No description provided for @swQuizAttemptsCount.
  ///
  /// In en, this message translates to:
  /// **'{used}/{max} attempts'**
  String swQuizAttemptsCount(int used, int max);

  /// No description provided for @swQuizBestScore.
  ///
  /// In en, this message translates to:
  /// **'Best Score: {score}%'**
  String swQuizBestScore(String score);

  /// No description provided for @swResourceRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get swResourceRemoveBookmark;

  /// No description provided for @swResourceBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get swResourceBookmark;

  /// No description provided for @swResourceDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get swResourceDownloaded;

  /// No description provided for @swResourceDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get swResourceDownload;

  /// No description provided for @swResourceNoResourcesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Resources Available'**
  String get swResourceNoResourcesAvailable;

  /// No description provided for @swResourceWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Resources will appear here when available'**
  String get swResourceWillAppearHere;

  /// No description provided for @swResourceDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get swResourceDownloading;

  /// No description provided for @swProgressLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} lessons'**
  String swProgressLessonsCount(int completed, int total);

  /// No description provided for @swProgressUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked {date}'**
  String swProgressUnlocked(String date);

  /// No description provided for @swProgressToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get swProgressToday;

  /// No description provided for @swProgressYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get swProgressYesterday;

  /// No description provided for @swProgressDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String swProgressDaysAgo(int count);

  /// No description provided for @swProgressCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get swProgressCompleted;

  /// No description provided for @swProgressOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get swProgressOverdue;

  /// No description provided for @swProgressDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String swProgressDaysLeft(int count);

  /// No description provided for @swProgressDayStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get swProgressDayStreak;

  /// No description provided for @swProgressLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest: {count} days'**
  String swProgressLongestStreak(int count);

  /// No description provided for @adminAnalytics30DayActiveChange.
  ///
  /// In en, this message translates to:
  /// **'30-day active change'**
  String get adminAnalytics30DayActiveChange;

  /// No description provided for @adminAnalyticsActive30d.
  ///
  /// In en, this message translates to:
  /// **'Active (30d)'**
  String get adminAnalyticsActive30d;

  /// No description provided for @adminAnalyticsActiveApplications.
  ///
  /// In en, this message translates to:
  /// **'Active Applications'**
  String get adminAnalyticsActiveApplications;

  /// No description provided for @adminAnalyticsActiveChange.
  ///
  /// In en, this message translates to:
  /// **'Active Change'**
  String get adminAnalyticsActiveChange;

  /// No description provided for @adminAnalyticsActiveLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Active in last 30 days'**
  String get adminAnalyticsActiveLast30Days;

  /// No description provided for @adminAnalyticsActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get adminAnalyticsActiveUsers;

  /// No description provided for @adminAnalyticsActiveUsers30d.
  ///
  /// In en, this message translates to:
  /// **'Active Users (30d)'**
  String get adminAnalyticsActiveUsers30d;

  /// No description provided for @adminAnalyticsAllRegisteredUsers.
  ///
  /// In en, this message translates to:
  /// **'All Registered Users'**
  String get adminAnalyticsAllRegisteredUsers;

  /// No description provided for @adminAnalyticsAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get adminAnalyticsAllTime;

  /// No description provided for @adminAnalyticsApplicationAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Application Analytics'**
  String get adminAnalyticsApplicationAnalytics;

  /// No description provided for @adminAnalyticsApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get adminAnalyticsApplications;

  /// No description provided for @adminAnalyticsApplicationSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Application Submissions'**
  String get adminAnalyticsApplicationSubmissions;

  /// No description provided for @adminAnalyticsApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminAnalyticsApproved;

  /// No description provided for @adminAnalyticsApps7d.
  ///
  /// In en, this message translates to:
  /// **'Apps (7d)'**
  String get adminAnalyticsApps7d;

  /// No description provided for @adminAnalyticsAppTrendData.
  ///
  /// In en, this message translates to:
  /// **'Application Trend Data'**
  String get adminAnalyticsAppTrendData;

  /// No description provided for @adminAnalyticsAverageTime.
  ///
  /// In en, this message translates to:
  /// **'Average Time'**
  String get adminAnalyticsAverageTime;

  /// No description provided for @adminAnalyticsAverageValue.
  ///
  /// In en, this message translates to:
  /// **'Average Value'**
  String get adminAnalyticsAverageValue;

  /// No description provided for @adminAnalyticsAvgCompletion.
  ///
  /// In en, this message translates to:
  /// **'Avg. Completion'**
  String get adminAnalyticsAvgCompletion;

  /// No description provided for @adminAnalyticsAvgTransaction.
  ///
  /// In en, this message translates to:
  /// **'Avg. Transaction'**
  String get adminAnalyticsAvgTransaction;

  /// No description provided for @adminAnalyticsAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Review'**
  String get adminAnalyticsAwaitingReview;

  /// No description provided for @adminAnalyticsBounceRate.
  ///
  /// In en, this message translates to:
  /// **'Bounce Rate'**
  String get adminAnalyticsBounceRate;

  /// No description provided for @adminAnalyticsByUserType.
  ///
  /// In en, this message translates to:
  /// **'By User Type'**
  String get adminAnalyticsByUserType;

  /// No description provided for @adminAnalyticsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get adminAnalyticsClose;

  /// No description provided for @adminAnalyticsContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get adminAnalyticsContent;

  /// No description provided for @adminAnalyticsContentAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Content Analytics'**
  String get adminAnalyticsContentAnalytics;

  /// No description provided for @adminAnalyticsContentCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Content Completion Rate'**
  String get adminAnalyticsContentCompletionRate;

  /// No description provided for @adminAnalyticsContentEngagement.
  ///
  /// In en, this message translates to:
  /// **'Content Engagement'**
  String get adminAnalyticsContentEngagement;

  /// No description provided for @adminAnalyticsContentEngagementData.
  ///
  /// In en, this message translates to:
  /// **'Content Engagement Data'**
  String get adminAnalyticsContentEngagementData;

  /// No description provided for @adminAnalyticsCounselors.
  ///
  /// In en, this message translates to:
  /// **'Counselors'**
  String get adminAnalyticsCounselors;

  /// No description provided for @adminAnalyticsCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get adminAnalyticsCourses;

  /// No description provided for @adminAnalyticsCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get adminAnalyticsCsv;

  /// No description provided for @adminAnalyticsCsvDesc.
  ///
  /// In en, this message translates to:
  /// **'Download as CSV spreadsheet'**
  String get adminAnalyticsCsvDesc;

  /// No description provided for @adminAnalyticsCustomDashboards.
  ///
  /// In en, this message translates to:
  /// **'Custom Dashboards'**
  String get adminAnalyticsCustomDashboards;

  /// No description provided for @adminAnalyticsDailyActiveUserData.
  ///
  /// In en, this message translates to:
  /// **'Daily Active User Data'**
  String get adminAnalyticsDailyActiveUserData;

  /// No description provided for @adminAnalyticsDailyActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Daily Active Users'**
  String get adminAnalyticsDailyActiveUsers;

  /// No description provided for @adminAnalyticsDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View platform metrics and insights'**
  String get adminAnalyticsDashboardSubtitle;

  /// No description provided for @adminAnalyticsDataExplorer.
  ///
  /// In en, this message translates to:
  /// **'Data Explorer'**
  String get adminAnalyticsDataExplorer;

  /// No description provided for @adminAnalyticsDataExplorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Query and analyze raw data'**
  String get adminAnalyticsDataExplorerSubtitle;

  /// No description provided for @adminAnalyticsDataExports.
  ///
  /// In en, this message translates to:
  /// **'Data Exports'**
  String get adminAnalyticsDataExports;

  /// No description provided for @adminAnalyticsDataExportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download reports and data'**
  String get adminAnalyticsDataExportsSubtitle;

  /// No description provided for @adminAnalyticsDistributionByRole.
  ///
  /// In en, this message translates to:
  /// **'Distribution by Role'**
  String get adminAnalyticsDistributionByRole;

  /// No description provided for @adminAnalyticsEngagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get adminAnalyticsEngagement;

  /// No description provided for @adminAnalyticsEngagementLabel.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get adminAnalyticsEngagementLabel;

  /// No description provided for @adminAnalyticsExcel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get adminAnalyticsExcel;

  /// No description provided for @adminAnalyticsExcelDesc.
  ///
  /// In en, this message translates to:
  /// **'Download as Excel workbook'**
  String get adminAnalyticsExcelDesc;

  /// No description provided for @adminAnalyticsExportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get adminAnalyticsExportReport;

  /// No description provided for @adminAnalyticsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Analytics'**
  String get adminAnalyticsExportTitle;

  /// No description provided for @adminAnalyticsFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get adminAnalyticsFinancial;

  /// No description provided for @adminAnalyticsFinancialAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Financial Analytics'**
  String get adminAnalyticsFinancialAnalytics;

  /// No description provided for @adminAnalyticsInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Institutions'**
  String get adminAnalyticsInstitutions;

  /// No description provided for @adminAnalyticsKpi.
  ///
  /// In en, this message translates to:
  /// **'KPI'**
  String get adminAnalyticsKpi;

  /// No description provided for @adminAnalyticsLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get adminAnalyticsLast30Days;

  /// No description provided for @adminAnalyticsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get adminAnalyticsLast7Days;

  /// No description provided for @adminAnalyticsLast7DaysShort.
  ///
  /// In en, this message translates to:
  /// **'Last 7d'**
  String get adminAnalyticsLast7DaysShort;

  /// No description provided for @adminAnalyticsLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get adminAnalyticsLast90Days;

  /// No description provided for @adminAnalyticsMonthToDate.
  ///
  /// In en, this message translates to:
  /// **'Month to Date'**
  String get adminAnalyticsMonthToDate;

  /// No description provided for @adminAnalyticsMostViewedItems.
  ///
  /// In en, this message translates to:
  /// **'Most Viewed Items'**
  String get adminAnalyticsMostViewedItems;

  /// No description provided for @adminAnalyticsNew7d.
  ///
  /// In en, this message translates to:
  /// **'New (7d)'**
  String get adminAnalyticsNew7d;

  /// No description provided for @adminAnalyticsNewAppsOverTime.
  ///
  /// In en, this message translates to:
  /// **'New Applications Over Time'**
  String get adminAnalyticsNewAppsOverTime;

  /// No description provided for @adminAnalyticsNewExport.
  ///
  /// In en, this message translates to:
  /// **'New Export'**
  String get adminAnalyticsNewExport;

  /// No description provided for @adminAnalyticsNewRegOverTime.
  ///
  /// In en, this message translates to:
  /// **'New Registrations Over Time'**
  String get adminAnalyticsNewRegOverTime;

  /// No description provided for @adminAnalyticsNewSignUpsOverTime.
  ///
  /// In en, this message translates to:
  /// **'New Sign-ups Over Time'**
  String get adminAnalyticsNewSignUpsOverTime;

  /// No description provided for @adminAnalyticsNewUsers.
  ///
  /// In en, this message translates to:
  /// **'New Users'**
  String get adminAnalyticsNewUsers;

  /// No description provided for @adminAnalyticsNewUsersThisWeek.
  ///
  /// In en, this message translates to:
  /// **'New Users This Week'**
  String get adminAnalyticsNewUsersThisWeek;

  /// No description provided for @adminAnalyticsNoDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get adminAnalyticsNoDataAvailable;

  /// No description provided for @adminAnalyticsNoMatchingRows.
  ///
  /// In en, this message translates to:
  /// **'No matching rows found'**
  String get adminAnalyticsNoMatchingRows;

  /// No description provided for @adminAnalyticsNoRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get adminAnalyticsNoRecentActivity;

  /// No description provided for @adminAnalyticsNoRoleDistData.
  ///
  /// In en, this message translates to:
  /// **'No role distribution data available'**
  String get adminAnalyticsNoRoleDistData;

  /// No description provided for @adminAnalyticsNoUserGrowthData.
  ///
  /// In en, this message translates to:
  /// **'No user growth data available'**
  String get adminAnalyticsNoUserGrowthData;

  /// No description provided for @adminAnalyticsNoWidgets.
  ///
  /// In en, this message translates to:
  /// **'No widgets configured'**
  String get adminAnalyticsNoWidgets;

  /// No description provided for @adminAnalyticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get adminAnalyticsOverview;

  /// No description provided for @adminAnalyticsPageViews.
  ///
  /// In en, this message translates to:
  /// **'Page Views'**
  String get adminAnalyticsPageViews;

  /// No description provided for @adminAnalyticsPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get adminAnalyticsPdf;

  /// No description provided for @adminAnalyticsPdfDesc.
  ///
  /// In en, this message translates to:
  /// **'Download as PDF document'**
  String get adminAnalyticsPdfDesc;

  /// No description provided for @adminAnalyticsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminAnalyticsPending;

  /// No description provided for @adminAnalyticsPlatformEngagement.
  ///
  /// In en, this message translates to:
  /// **'Platform Engagement'**
  String get adminAnalyticsPlatformEngagement;

  /// No description provided for @adminAnalyticsPlatformUptime.
  ///
  /// In en, this message translates to:
  /// **'Platform Uptime'**
  String get adminAnalyticsPlatformUptime;

  /// No description provided for @adminAnalyticsPopularContent.
  ///
  /// In en, this message translates to:
  /// **'Popular Content'**
  String get adminAnalyticsPopularContent;

  /// No description provided for @adminAnalyticsPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get adminAnalyticsPrograms;

  /// No description provided for @adminAnalyticsPublishedItems.
  ///
  /// In en, this message translates to:
  /// **'Published Items'**
  String get adminAnalyticsPublishedItems;

  /// No description provided for @adminAnalyticsQuickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get adminAnalyticsQuickStats;

  /// No description provided for @adminAnalyticsRecentApplications.
  ///
  /// In en, this message translates to:
  /// **'Recent Applications'**
  String get adminAnalyticsRecentApplications;

  /// No description provided for @adminAnalyticsRecommenders.
  ///
  /// In en, this message translates to:
  /// **'Recommenders'**
  String get adminAnalyticsRecommenders;

  /// No description provided for @adminAnalyticsRefreshAll.
  ///
  /// In en, this message translates to:
  /// **'Refresh All'**
  String get adminAnalyticsRefreshAll;

  /// No description provided for @adminAnalyticsRefreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get adminAnalyticsRefreshData;

  /// No description provided for @adminAnalyticsRegionalDataNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Regional data not available'**
  String get adminAnalyticsRegionalDataNotAvailable;

  /// No description provided for @adminAnalyticsRegionalDistribution.
  ///
  /// In en, this message translates to:
  /// **'Regional Distribution'**
  String get adminAnalyticsRegionalDistribution;

  /// No description provided for @adminAnalyticsRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get adminAnalyticsRejected;

  /// No description provided for @adminAnalyticsRevenueBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Revenue Breakdown'**
  String get adminAnalyticsRevenueBreakdown;

  /// No description provided for @adminAnalyticsRevenueMtd.
  ///
  /// In en, this message translates to:
  /// **'Revenue MTD'**
  String get adminAnalyticsRevenueMtd;

  /// No description provided for @adminAnalyticsRevenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get adminAnalyticsRevenueTrend;

  /// No description provided for @adminAnalyticsRevenueTrendData.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend Data'**
  String get adminAnalyticsRevenueTrendData;

  /// No description provided for @adminAnalyticsSearchColumns.
  ///
  /// In en, this message translates to:
  /// **'Search columns...'**
  String get adminAnalyticsSearchColumns;

  /// No description provided for @adminAnalyticsSelectDataSource.
  ///
  /// In en, this message translates to:
  /// **'Select Data Source'**
  String get adminAnalyticsSelectDataSource;

  /// No description provided for @adminAnalyticsSelectFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Format'**
  String get adminAnalyticsSelectFormat;

  /// No description provided for @adminAnalyticsSessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Session Duration'**
  String get adminAnalyticsSessionDuration;

  /// No description provided for @adminAnalyticsSinglePageVisits.
  ///
  /// In en, this message translates to:
  /// **'Single Page Visits'**
  String get adminAnalyticsSinglePageVisits;

  /// No description provided for @adminAnalyticsStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get adminAnalyticsStudents;

  /// No description provided for @adminAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Platform analytics and insights'**
  String get adminAnalyticsSubtitle;

  /// No description provided for @adminAnalyticsSuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get adminAnalyticsSuccessRate;

  /// No description provided for @adminAnalyticsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get adminAnalyticsThisMonth;

  /// No description provided for @adminAnalyticsThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get adminAnalyticsThisYear;

  /// No description provided for @adminAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get adminAnalyticsTitle;

  /// No description provided for @adminAnalyticsToggleWidgets.
  ///
  /// In en, this message translates to:
  /// **'Toggle Widgets'**
  String get adminAnalyticsToggleWidgets;

  /// No description provided for @adminAnalyticsTotalApproved.
  ///
  /// In en, this message translates to:
  /// **'Total Approved'**
  String get adminAnalyticsTotalApproved;

  /// No description provided for @adminAnalyticsTotalContent.
  ///
  /// In en, this message translates to:
  /// **'Total Content'**
  String get adminAnalyticsTotalContent;

  /// No description provided for @adminAnalyticsTotalCounselors.
  ///
  /// In en, this message translates to:
  /// **'Total Counselors'**
  String get adminAnalyticsTotalCounselors;

  /// No description provided for @adminAnalyticsTotalInstitutions.
  ///
  /// In en, this message translates to:
  /// **'Total Institutions'**
  String get adminAnalyticsTotalInstitutions;

  /// No description provided for @adminAnalyticsTotalInteractions.
  ///
  /// In en, this message translates to:
  /// **'Total Interactions'**
  String get adminAnalyticsTotalInteractions;

  /// No description provided for @adminAnalyticsTotalRecommenders.
  ///
  /// In en, this message translates to:
  /// **'Total Recommenders'**
  String get adminAnalyticsTotalRecommenders;

  /// No description provided for @adminAnalyticsTotalRejected.
  ///
  /// In en, this message translates to:
  /// **'Total Rejected'**
  String get adminAnalyticsTotalRejected;

  /// No description provided for @adminAnalyticsTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get adminAnalyticsTotalRevenue;

  /// No description provided for @adminAnalyticsTotalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get adminAnalyticsTotalStudents;

  /// No description provided for @adminAnalyticsTotalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get adminAnalyticsTotalTransactions;

  /// No description provided for @adminAnalyticsTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get adminAnalyticsTotalUsers;

  /// No description provided for @adminAnalyticsTotalViews.
  ///
  /// In en, this message translates to:
  /// **'Total Views'**
  String get adminAnalyticsTotalViews;

  /// No description provided for @adminAnalyticsTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get adminAnalyticsTransactions;

  /// No description provided for @adminAnalyticsTransactionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transaction Success'**
  String get adminAnalyticsTransactionSuccess;

  /// No description provided for @adminAnalyticsTrends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get adminAnalyticsTrends;

  /// No description provided for @adminAnalyticsUniversities.
  ///
  /// In en, this message translates to:
  /// **'Universities'**
  String get adminAnalyticsUniversities;

  /// No description provided for @adminAnalyticsUserActivityOverTime.
  ///
  /// In en, this message translates to:
  /// **'User Activity Over Time'**
  String get adminAnalyticsUserActivityOverTime;

  /// No description provided for @adminAnalyticsUserAnalytics.
  ///
  /// In en, this message translates to:
  /// **'User Analytics'**
  String get adminAnalyticsUserAnalytics;

  /// No description provided for @adminAnalyticsUserDistribution.
  ///
  /// In en, this message translates to:
  /// **'User Distribution'**
  String get adminAnalyticsUserDistribution;

  /// No description provided for @adminAnalyticsUserGrowth.
  ///
  /// In en, this message translates to:
  /// **'User Growth'**
  String get adminAnalyticsUserGrowth;

  /// No description provided for @adminAnalyticsUserGrowthVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'User Growth vs Previous Period'**
  String get adminAnalyticsUserGrowthVsPrevious;

  /// No description provided for @adminAnalyticsUserInteractionsOverTime.
  ///
  /// In en, this message translates to:
  /// **'User Interactions Over Time'**
  String get adminAnalyticsUserInteractionsOverTime;

  /// No description provided for @adminAnalyticsUserRegistrations.
  ///
  /// In en, this message translates to:
  /// **'User Registrations'**
  String get adminAnalyticsUserRegistrations;

  /// No description provided for @adminAnalyticsUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminAnalyticsUsers;

  /// No description provided for @adminAnalyticsUsersByRegion.
  ///
  /// In en, this message translates to:
  /// **'Users by Region'**
  String get adminAnalyticsUsersByRegion;

  /// No description provided for @adminAnalyticsUserTypes.
  ///
  /// In en, this message translates to:
  /// **'User Types'**
  String get adminAnalyticsUserTypes;

  /// No description provided for @adminAnalyticsVsLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'vs Last Period'**
  String get adminAnalyticsVsLastPeriod;

  /// No description provided for @adminAnalyticsWidgets.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get adminAnalyticsWidgets;

  /// No description provided for @adminChatArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get adminChatArchive;

  /// No description provided for @adminChatCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminChatCancel;

  /// No description provided for @adminChatCannedClosingLabel.
  ///
  /// In en, this message translates to:
  /// **'Closing'**
  String get adminChatCannedClosingLabel;

  /// No description provided for @adminChatCannedClosingText.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us. Have a great day!'**
  String get adminChatCannedClosingText;

  /// No description provided for @adminChatCannedEscalatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Escalating'**
  String get adminChatCannedEscalatingLabel;

  /// No description provided for @adminChatCannedEscalatingText.
  ///
  /// In en, this message translates to:
  /// **'I\'ll escalate this to a specialist who can better assist you.'**
  String get adminChatCannedEscalatingText;

  /// No description provided for @adminChatCannedFollowUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get adminChatCannedFollowUpLabel;

  /// No description provided for @adminChatCannedFollowUpText.
  ///
  /// In en, this message translates to:
  /// **'Is there anything else I can help you with?'**
  String get adminChatCannedFollowUpText;

  /// No description provided for @adminChatCannedGreetingLabel.
  ///
  /// In en, this message translates to:
  /// **'Greeting'**
  String get adminChatCannedGreetingLabel;

  /// No description provided for @adminChatCannedGreetingText.
  ///
  /// In en, this message translates to:
  /// **'Hello! How can I assist you today?'**
  String get adminChatCannedGreetingText;

  /// No description provided for @adminChatCannedMoreInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'More Info'**
  String get adminChatCannedMoreInfoLabel;

  /// No description provided for @adminChatCannedMoreInfoText.
  ///
  /// In en, this message translates to:
  /// **'Could you please provide more details about your issue?'**
  String get adminChatCannedMoreInfoText;

  /// No description provided for @adminChatCannedResolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get adminChatCannedResolutionLabel;

  /// No description provided for @adminChatCannedResolutionText.
  ///
  /// In en, this message translates to:
  /// **'Your issue has been resolved. Please let me know if you need further assistance.'**
  String get adminChatCannedResolutionText;

  /// No description provided for @adminChatConvDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation Details'**
  String get adminChatConvDetailsTitle;

  /// No description provided for @adminChatConvHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View past conversations and messages'**
  String get adminChatConvHistorySubtitle;

  /// No description provided for @adminChatConvHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation History'**
  String get adminChatConvHistoryTitle;

  /// No description provided for @adminChatConvNotFound.
  ///
  /// In en, this message translates to:
  /// **'Conversation not found'**
  String get adminChatConvNotFound;

  /// No description provided for @adminChatDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminChatDelete;

  /// No description provided for @adminChatDeleteConvConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation? This action cannot be undone.'**
  String get adminChatDeleteConvConfirm;

  /// No description provided for @adminChatDeleteConvTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get adminChatDeleteConvTitle;

  /// No description provided for @adminChatFaqActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get adminChatFaqActivate;

  /// No description provided for @adminChatFaqAdd.
  ///
  /// In en, this message translates to:
  /// **'Add FAQ'**
  String get adminChatFaqAdd;

  /// No description provided for @adminChatFaqAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get adminChatFaqAllCategories;

  /// No description provided for @adminChatFaqAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get adminChatFaqAnswer;

  /// No description provided for @adminChatFaqAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the answer to this question'**
  String get adminChatFaqAnswerHint;

  /// No description provided for @adminChatFaqAnswerRequired.
  ///
  /// In en, this message translates to:
  /// **'Answer is required'**
  String get adminChatFaqAnswerRequired;

  /// No description provided for @adminChatFaqCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminChatFaqCategory;

  /// No description provided for @adminChatFaqCreate.
  ///
  /// In en, this message translates to:
  /// **'Create FAQ'**
  String get adminChatFaqCreate;

  /// No description provided for @adminChatFaqCreated.
  ///
  /// In en, this message translates to:
  /// **'FAQ created successfully'**
  String get adminChatFaqCreated;

  /// No description provided for @adminChatFaqCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'Create your first FAQ entry'**
  String get adminChatFaqCreateFirst;

  /// No description provided for @adminChatFaqCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create FAQ Entry'**
  String get adminChatFaqCreateTitle;

  /// No description provided for @adminChatFaqDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get adminChatFaqDeactivate;

  /// No description provided for @adminChatFaqDeleted.
  ///
  /// In en, this message translates to:
  /// **'FAQ deleted successfully'**
  String get adminChatFaqDeleted;

  /// No description provided for @adminChatFaqDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete FAQ'**
  String get adminChatFaqDeleteTitle;

  /// No description provided for @adminChatFaqEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminChatFaqEdit;

  /// No description provided for @adminChatFaqEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit FAQ Entry'**
  String get adminChatFaqEditTitle;

  /// No description provided for @adminChatFaqHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get adminChatFaqHelpful;

  /// No description provided for @adminChatFaqInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminChatFaqInactive;

  /// No description provided for @adminChatFaqKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get adminChatFaqKeywords;

  /// No description provided for @adminChatFaqKeywordsHelper.
  ///
  /// In en, this message translates to:
  /// **'Keywords help the chatbot find this FAQ'**
  String get adminChatFaqKeywordsHelper;

  /// No description provided for @adminChatFaqKeywordsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter keywords separated by commas'**
  String get adminChatFaqKeywordsHint;

  /// No description provided for @adminChatFaqLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get adminChatFaqLoadMore;

  /// No description provided for @adminChatFaqNoFaqs.
  ///
  /// In en, this message translates to:
  /// **'No FAQs found'**
  String get adminChatFaqNoFaqs;

  /// No description provided for @adminChatFaqNotHelpful.
  ///
  /// In en, this message translates to:
  /// **'Not Helpful'**
  String get adminChatFaqNotHelpful;

  /// No description provided for @adminChatFaqPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get adminChatFaqPriority;

  /// No description provided for @adminChatFaqQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get adminChatFaqQuestion;

  /// No description provided for @adminChatFaqQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the question'**
  String get adminChatFaqQuestionHint;

  /// No description provided for @adminChatFaqQuestionRequired.
  ///
  /// In en, this message translates to:
  /// **'Question is required'**
  String get adminChatFaqQuestionRequired;

  /// No description provided for @adminChatFaqSearch.
  ///
  /// In en, this message translates to:
  /// **'Search FAQs...'**
  String get adminChatFaqSearch;

  /// No description provided for @adminChatFaqShowInactive.
  ///
  /// In en, this message translates to:
  /// **'Show Inactive'**
  String get adminChatFaqShowInactive;

  /// No description provided for @adminChatFaqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage FAQ entries for the chatbot'**
  String get adminChatFaqSubtitle;

  /// No description provided for @adminChatFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ Management'**
  String get adminChatFaqTitle;

  /// No description provided for @adminChatFaqUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update FAQ'**
  String get adminChatFaqUpdate;

  /// No description provided for @adminChatFaqUpdated.
  ///
  /// In en, this message translates to:
  /// **'FAQ updated successfully'**
  String get adminChatFaqUpdated;

  /// No description provided for @adminChatFaqUses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get adminChatFaqUses;

  /// No description provided for @adminChatFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get adminChatFilter;

  /// No description provided for @adminChatFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminChatFilterAll;

  /// No description provided for @adminChatFlag.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get adminChatFlag;

  /// No description provided for @adminChatLiveActiveFiveMin.
  ///
  /// In en, this message translates to:
  /// **'Active in last 5 minutes'**
  String get adminChatLiveActiveFiveMin;

  /// No description provided for @adminChatLiveAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto-refresh'**
  String get adminChatLiveAutoRefresh;

  /// No description provided for @adminChatLiveLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get adminChatLiveLive;

  /// No description provided for @adminChatLiveLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load live chats'**
  String get adminChatLiveLoadFailed;

  /// No description provided for @adminChatLiveNoActive.
  ///
  /// In en, this message translates to:
  /// **'No active chats at the moment'**
  String get adminChatLiveNoActive;

  /// No description provided for @adminChatLivePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get adminChatLivePaused;

  /// No description provided for @adminChatLiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor active chat sessions in real-time'**
  String get adminChatLiveSubtitle;

  /// No description provided for @adminChatLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Chat Monitor'**
  String get adminChatLiveTitle;

  /// No description provided for @adminChatNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations found'**
  String get adminChatNoConversations;

  /// No description provided for @adminChatQueueAllPriorities.
  ///
  /// In en, this message translates to:
  /// **'All Priorities'**
  String get adminChatQueueAllPriorities;

  /// No description provided for @adminChatQueueAllStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get adminChatQueueAllStatus;

  /// No description provided for @adminChatQueueAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get adminChatQueueAssigned;

  /// No description provided for @adminChatQueueAssignedToYou.
  ///
  /// In en, this message translates to:
  /// **'Assigned to you'**
  String get adminChatQueueAssignedToYou;

  /// No description provided for @adminChatQueueAssignToMe.
  ///
  /// In en, this message translates to:
  /// **'Assign to me'**
  String get adminChatQueueAssignToMe;

  /// No description provided for @adminChatQueueEscalatedHint.
  ///
  /// In en, this message translates to:
  /// **'This conversation has been escalated'**
  String get adminChatQueueEscalatedHint;

  /// No description provided for @adminChatQueueHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get adminChatQueueHigh;

  /// No description provided for @adminChatQueueInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get adminChatQueueInProgress;

  /// No description provided for @adminChatQueueLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load queue'**
  String get adminChatQueueLoadFailed;

  /// No description provided for @adminChatQueueLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get adminChatQueueLow;

  /// No description provided for @adminChatQueueNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in queue'**
  String get adminChatQueueNoItems;

  /// No description provided for @adminChatQueueNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get adminChatQueueNormal;

  /// No description provided for @adminChatQueueOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get adminChatQueueOpen;

  /// No description provided for @adminChatQueuePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminChatQueuePending;

  /// No description provided for @adminChatQueueReasonAutoEscalation.
  ///
  /// In en, this message translates to:
  /// **'Auto-escalation due to wait time'**
  String get adminChatQueueReasonAutoEscalation;

  /// No description provided for @adminChatQueueReasonLowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Low confidence AI response'**
  String get adminChatQueueReasonLowConfidence;

  /// No description provided for @adminChatQueueReasonNegativeFeedback.
  ///
  /// In en, this message translates to:
  /// **'Negative user feedback'**
  String get adminChatQueueReasonNegativeFeedback;

  /// No description provided for @adminChatQueueReasonUserRequest.
  ///
  /// In en, this message translates to:
  /// **'User requested human support'**
  String get adminChatQueueReasonUserRequest;

  /// No description provided for @adminChatQueueStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminChatQueueStatus;

  /// No description provided for @adminChatQueueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage escalated conversations requiring attention'**
  String get adminChatQueueSubtitle;

  /// No description provided for @adminChatQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Queue'**
  String get adminChatQueueTitle;

  /// No description provided for @adminChatQueueUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get adminChatQueueUrgent;

  /// No description provided for @adminChatQuickReplies.
  ///
  /// In en, this message translates to:
  /// **'Quick Replies'**
  String get adminChatQuickReplies;

  /// No description provided for @adminChatRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminChatRefresh;

  /// No description provided for @adminChatRefreshNow.
  ///
  /// In en, this message translates to:
  /// **'Refresh Now'**
  String get adminChatRefreshNow;

  /// No description provided for @adminChatReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Type your reply...'**
  String get adminChatReplyHint;

  /// No description provided for @adminChatReplySentResolved.
  ///
  /// In en, this message translates to:
  /// **'Reply sent and conversation resolved'**
  String get adminChatReplySentResolved;

  /// No description provided for @adminChatRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get adminChatRestore;

  /// No description provided for @adminChatRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminChatRetry;

  /// No description provided for @adminChatSearchConversations.
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get adminChatSearchConversations;

  /// No description provided for @adminChatSendAndResolve.
  ///
  /// In en, this message translates to:
  /// **'Send & Resolve'**
  String get adminChatSendAndResolve;

  /// No description provided for @adminChatSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get adminChatSendReply;

  /// No description provided for @adminChatStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminChatStatusActive;

  /// No description provided for @adminChatStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get adminChatStatusArchived;

  /// No description provided for @adminChatStatusEscalated.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get adminChatStatusEscalated;

  /// No description provided for @adminChatStatusFlagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged'**
  String get adminChatStatusFlagged;

  /// No description provided for @adminChatSupportAgent.
  ///
  /// In en, this message translates to:
  /// **'Support Agent'**
  String get adminChatSupportAgent;

  /// No description provided for @adminChatUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get adminChatUnknownUser;

  /// No description provided for @adminFinanceActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get adminFinanceActionCannotBeUndone;

  /// No description provided for @adminFinanceAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminFinanceAll;

  /// No description provided for @adminFinanceAllCompletedPayments.
  ///
  /// In en, this message translates to:
  /// **'All Completed Payments'**
  String get adminFinanceAllCompletedPayments;

  /// No description provided for @adminFinanceAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get adminFinanceAllLevels;

  /// No description provided for @adminFinanceAllRefundTransactions.
  ///
  /// In en, this message translates to:
  /// **'All Refund Transactions'**
  String get adminFinanceAllRefundTransactions;

  /// No description provided for @adminFinanceAllStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get adminFinanceAllStatus;

  /// No description provided for @adminFinanceAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get adminFinanceAllTime;

  /// No description provided for @adminFinanceAllTransactionsNormal.
  ///
  /// In en, this message translates to:
  /// **'All transactions appear normal'**
  String get adminFinanceAllTransactionsNormal;

  /// No description provided for @adminFinanceAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get adminFinanceAllTypes;

  /// No description provided for @adminFinanceAlreadyReviewed.
  ///
  /// In en, this message translates to:
  /// **'Already Reviewed'**
  String get adminFinanceAlreadyReviewed;

  /// No description provided for @adminFinanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get adminFinanceAmount;

  /// No description provided for @adminFinanceAvgSettlement.
  ///
  /// In en, this message translates to:
  /// **'Avg. Settlement'**
  String get adminFinanceAvgSettlement;

  /// No description provided for @adminFinanceAwaitingProcessing.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Processing'**
  String get adminFinanceAwaitingProcessing;

  /// No description provided for @adminFinanceCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminFinanceCancel;

  /// No description provided for @adminFinanceChooseTransaction.
  ///
  /// In en, this message translates to:
  /// **'Choose a transaction'**
  String get adminFinanceChooseTransaction;

  /// No description provided for @adminFinanceClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get adminFinanceClose;

  /// No description provided for @adminFinanceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get adminFinanceCompleted;

  /// No description provided for @adminFinanceConfirmRefund.
  ///
  /// In en, this message translates to:
  /// **'Confirm Refund'**
  String get adminFinanceConfirmRefund;

  /// No description provided for @adminFinanceCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get adminFinanceCritical;

  /// No description provided for @adminFinanceCriticalHighRisk.
  ///
  /// In en, this message translates to:
  /// **'Critical/High Risk'**
  String get adminFinanceCriticalHighRisk;

  /// No description provided for @adminFinanceCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get adminFinanceCurrency;

  /// No description provided for @adminFinanceDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get adminFinanceDate;

  /// No description provided for @adminFinanceDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get adminFinanceDateRange;

  /// No description provided for @adminFinanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminFinanceDescription;

  /// No description provided for @adminFinanceDownloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get adminFinanceDownloadReceipt;

  /// No description provided for @adminFinanceEligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible'**
  String get adminFinanceEligible;

  /// No description provided for @adminFinanceExportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get adminFinanceExportReport;

  /// No description provided for @adminFinanceFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get adminFinanceFailed;

  /// No description provided for @adminFinanceFlaggedTransactions.
  ///
  /// In en, this message translates to:
  /// **'Flagged Transactions'**
  String get adminFinanceFlaggedTransactions;

  /// No description provided for @adminFinanceFraudDetectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor suspicious activity and flagged transactions'**
  String get adminFinanceFraudDetectionSubtitle;

  /// No description provided for @adminFinanceFraudDetectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Fraud Detection'**
  String get adminFinanceFraudDetectionTitle;

  /// No description provided for @adminFinanceHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get adminFinanceHigh;

  /// No description provided for @adminFinanceHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get adminFinanceHighRisk;

  /// No description provided for @adminFinanceItemType.
  ///
  /// In en, this message translates to:
  /// **'Item Type'**
  String get adminFinanceItemType;

  /// No description provided for @adminFinanceLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get adminFinanceLast30Days;

  /// No description provided for @adminFinanceLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get adminFinanceLast7Days;

  /// No description provided for @adminFinanceLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get adminFinanceLow;

  /// No description provided for @adminFinanceMarkReviewed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Reviewed'**
  String get adminFinanceMarkReviewed;

  /// No description provided for @adminFinanceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get adminFinanceMedium;

  /// No description provided for @adminFinanceNewRefund.
  ///
  /// In en, this message translates to:
  /// **'New Refund'**
  String get adminFinanceNewRefund;

  /// No description provided for @adminFinanceNoEligibleTransactions.
  ///
  /// In en, this message translates to:
  /// **'No eligible transactions for refund'**
  String get adminFinanceNoEligibleTransactions;

  /// No description provided for @adminFinanceNoMatchingAlerts.
  ///
  /// In en, this message translates to:
  /// **'No matching alerts found'**
  String get adminFinanceNoMatchingAlerts;

  /// No description provided for @adminFinanceNoSettlementsFound.
  ///
  /// In en, this message translates to:
  /// **'No settlements found'**
  String get adminFinanceNoSettlementsFound;

  /// No description provided for @adminFinanceNoSuspiciousActivity.
  ///
  /// In en, this message translates to:
  /// **'No suspicious activity detected'**
  String get adminFinanceNoSuspiciousActivity;

  /// No description provided for @adminFinanceOriginalTxn.
  ///
  /// In en, this message translates to:
  /// **'Original Transaction'**
  String get adminFinanceOriginalTxn;

  /// No description provided for @adminFinancePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get adminFinancePayment;

  /// No description provided for @adminFinancePaymentsEligibleForRefund.
  ///
  /// In en, this message translates to:
  /// **'Payments Eligible for Refund'**
  String get adminFinancePaymentsEligibleForRefund;

  /// No description provided for @adminFinancePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminFinancePending;

  /// No description provided for @adminFinancePendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get adminFinancePendingReview;

  /// No description provided for @adminFinancePendingSettlement.
  ///
  /// In en, this message translates to:
  /// **'Pending Settlement'**
  String get adminFinancePendingSettlement;

  /// No description provided for @adminFinanceProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get adminFinanceProcessing;

  /// No description provided for @adminFinanceProcessNewRefund.
  ///
  /// In en, this message translates to:
  /// **'Process New Refund'**
  String get adminFinanceProcessNewRefund;

  /// No description provided for @adminFinanceProcessRefund.
  ///
  /// In en, this message translates to:
  /// **'Process Refund'**
  String get adminFinanceProcessRefund;

  /// No description provided for @adminFinanceReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get adminFinanceReason;

  /// No description provided for @adminFinanceReasonForRefund.
  ///
  /// In en, this message translates to:
  /// **'Reason for Refund'**
  String get adminFinanceReasonForRefund;

  /// No description provided for @adminFinanceRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminFinanceRefresh;

  /// No description provided for @adminFinanceRefreshTransactions.
  ///
  /// In en, this message translates to:
  /// **'Refresh Transactions'**
  String get adminFinanceRefreshTransactions;

  /// No description provided for @adminFinanceRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get adminFinanceRefund;

  /// No description provided for @adminFinanceRefundDetails.
  ///
  /// In en, this message translates to:
  /// **'Refund Details'**
  String get adminFinanceRefundDetails;

  /// No description provided for @adminFinanceRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get adminFinanceRefunded;

  /// No description provided for @adminFinanceRefundedAmount.
  ///
  /// In en, this message translates to:
  /// **'Refunded Amount'**
  String get adminFinanceRefundedAmount;

  /// No description provided for @adminFinanceRefundFailed.
  ///
  /// In en, this message translates to:
  /// **'Refund Failed'**
  String get adminFinanceRefundFailed;

  /// No description provided for @adminFinanceRefundId.
  ///
  /// In en, this message translates to:
  /// **'Refund ID'**
  String get adminFinanceRefundId;

  /// No description provided for @adminFinanceRefundProcessedFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to process refund'**
  String get adminFinanceRefundProcessedFail;

  /// No description provided for @adminFinanceRefundProcessedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Refund processed successfully'**
  String get adminFinanceRefundProcessedSuccess;

  /// No description provided for @adminFinanceRefundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Process and manage customer refunds'**
  String get adminFinanceRefundsSubtitle;

  /// No description provided for @adminFinanceRefundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get adminFinanceRefundsTitle;

  /// No description provided for @adminFinanceRefundSuccess.
  ///
  /// In en, this message translates to:
  /// **'Refund Successful'**
  String get adminFinanceRefundSuccess;

  /// No description provided for @adminFinanceRescanTransactions.
  ///
  /// In en, this message translates to:
  /// **'Rescan Transactions'**
  String get adminFinanceRescanTransactions;

  /// No description provided for @adminFinanceRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminFinanceRetry;

  /// No description provided for @adminFinanceReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get adminFinanceReviewed;

  /// No description provided for @adminFinanceRiskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get adminFinanceRiskLevel;

  /// No description provided for @adminFinanceSearchRefundsHint.
  ///
  /// In en, this message translates to:
  /// **'Search refunds...'**
  String get adminFinanceSearchRefundsHint;

  /// No description provided for @adminFinanceSearchSettlementsHint.
  ///
  /// In en, this message translates to:
  /// **'Search settlements...'**
  String get adminFinanceSearchSettlementsHint;

  /// No description provided for @adminFinanceSearchTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get adminFinanceSearchTransactionsHint;

  /// No description provided for @adminFinanceSelectTransactionToRefund.
  ///
  /// In en, this message translates to:
  /// **'Select a transaction to refund'**
  String get adminFinanceSelectTransactionToRefund;

  /// No description provided for @adminFinanceSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get adminFinanceSettled;

  /// No description provided for @adminFinanceSettlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get adminFinanceSettlement;

  /// No description provided for @adminFinanceSettlementBatches.
  ///
  /// In en, this message translates to:
  /// **'Settlement Batches'**
  String get adminFinanceSettlementBatches;

  /// No description provided for @adminFinanceSettlementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage payment settlements'**
  String get adminFinanceSettlementsSubtitle;

  /// No description provided for @adminFinanceSettlementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get adminFinanceSettlementsTitle;

  /// No description provided for @adminFinanceShowReviewed.
  ///
  /// In en, this message translates to:
  /// **'Show Reviewed'**
  String get adminFinanceShowReviewed;

  /// No description provided for @adminFinanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminFinanceStatus;

  /// No description provided for @adminFinanceSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get adminFinanceSuccessful;

  /// No description provided for @adminFinanceSuccessfullyRefunded.
  ///
  /// In en, this message translates to:
  /// **'Successfully refunded'**
  String get adminFinanceSuccessfullyRefunded;

  /// No description provided for @adminFinanceToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get adminFinanceToday;

  /// No description provided for @adminFinanceTotalFlags.
  ///
  /// In en, this message translates to:
  /// **'Total Flags'**
  String get adminFinanceTotalFlags;

  /// No description provided for @adminFinanceTotalRefunds.
  ///
  /// In en, this message translates to:
  /// **'Total Refunds'**
  String get adminFinanceTotalRefunds;

  /// No description provided for @adminFinanceTotalSettled.
  ///
  /// In en, this message translates to:
  /// **'Total Settled'**
  String get adminFinanceTotalSettled;

  /// No description provided for @adminFinanceTotalVolume.
  ///
  /// In en, this message translates to:
  /// **'Total Volume'**
  String get adminFinanceTotalVolume;

  /// No description provided for @adminFinanceTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get adminFinanceTransactionDetails;

  /// No description provided for @adminFinanceTransactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get adminFinanceTransactionId;

  /// No description provided for @adminFinanceTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage all financial transactions'**
  String get adminFinanceTransactionsSubtitle;

  /// No description provided for @adminFinanceTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get adminFinanceTransactionsTitle;

  /// No description provided for @adminFinanceType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get adminFinanceType;

  /// No description provided for @adminFinanceUnreviewed.
  ///
  /// In en, this message translates to:
  /// **'Unreviewed'**
  String get adminFinanceUnreviewed;

  /// No description provided for @adminFinanceUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get adminFinanceUser;

  /// No description provided for @adminFinanceUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get adminFinanceUserId;

  /// No description provided for @adminFinanceViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get adminFinanceViewDetails;

  /// No description provided for @adminFinanceYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get adminFinanceYesterday;

  /// No description provided for @adminReportActivated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get adminReportActivated;

  /// No description provided for @adminReportAllReports.
  ///
  /// In en, this message translates to:
  /// **'All Reports'**
  String get adminReportAllReports;

  /// No description provided for @adminReportBuilderHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Builder Help'**
  String get adminReportBuilderHelpTitle;

  /// No description provided for @adminReportBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Builder'**
  String get adminReportBuilderTitle;

  /// No description provided for @adminReportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminReportCancel;

  /// No description provided for @adminReportCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Report'**
  String get adminReportCreate;

  /// No description provided for @adminReportCreateAutomatedReports.
  ///
  /// In en, this message translates to:
  /// **'Create automated reports that run on a schedule'**
  String get adminReportCreateAutomatedReports;

  /// No description provided for @adminReportCreateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create Schedule'**
  String get adminReportCreateSchedule;

  /// No description provided for @adminReportCsvDescription.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet format for Excel'**
  String get adminReportCsvDescription;

  /// No description provided for @adminReportCsvSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'CSV Spreadsheet'**
  String get adminReportCsvSpreadsheet;

  /// No description provided for @adminReportDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get adminReportDaily;

  /// No description provided for @adminReportDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get adminReportDateRange;

  /// No description provided for @adminReportDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminReportDelete;

  /// No description provided for @adminReportDeleteScheduledReport.
  ///
  /// In en, this message translates to:
  /// **'Delete Scheduled Report'**
  String get adminReportDeleteScheduledReport;

  /// No description provided for @adminReportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter report description'**
  String get adminReportDescriptionHint;

  /// No description provided for @adminReportDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get adminReportDescriptionOptional;

  /// No description provided for @adminReportEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminReportEdit;

  /// No description provided for @adminReportEditScheduledReport.
  ///
  /// In en, this message translates to:
  /// **'Edit Scheduled Report'**
  String get adminReportEditScheduledReport;

  /// No description provided for @adminReportEmailRecipients.
  ///
  /// In en, this message translates to:
  /// **'Email Recipients'**
  String get adminReportEmailRecipients;

  /// No description provided for @adminReportEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get adminReportEndDate;

  /// No description provided for @adminReportExportFormat.
  ///
  /// In en, this message translates to:
  /// **'Export Format'**
  String get adminReportExportFormat;

  /// No description provided for @adminReportFeature1.
  ///
  /// In en, this message translates to:
  /// **'Select metrics and data points'**
  String get adminReportFeature1;

  /// No description provided for @adminReportFeature2.
  ///
  /// In en, this message translates to:
  /// **'Choose date ranges'**
  String get adminReportFeature2;

  /// No description provided for @adminReportFeature3.
  ///
  /// In en, this message translates to:
  /// **'Export in multiple formats'**
  String get adminReportFeature3;

  /// No description provided for @adminReportFeature4.
  ///
  /// In en, this message translates to:
  /// **'Schedule automated reports'**
  String get adminReportFeature4;

  /// No description provided for @adminReportFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get adminReportFeatures;

  /// No description provided for @adminReportFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get adminReportFrequency;

  /// No description provided for @adminReportGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get adminReportGenerate;

  /// No description provided for @adminReportGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report generated successfully'**
  String get adminReportGeneratedSuccess;

  /// No description provided for @adminReportGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get adminReportGenerating;

  /// No description provided for @adminReportGenerationStarted.
  ///
  /// In en, this message translates to:
  /// **'Report generation started'**
  String get adminReportGenerationStarted;

  /// No description provided for @adminReportGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get adminReportGotIt;

  /// No description provided for @adminReportHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get adminReportHelp;

  /// No description provided for @adminReportHelpPresetsInfo.
  ///
  /// In en, this message translates to:
  /// **'Use presets for quick report generation'**
  String get adminReportHelpPresetsInfo;

  /// No description provided for @adminReportHelpStep1.
  ///
  /// In en, this message translates to:
  /// **'Select metrics you want to include'**
  String get adminReportHelpStep1;

  /// No description provided for @adminReportHelpStep2.
  ///
  /// In en, this message translates to:
  /// **'Choose a date range'**
  String get adminReportHelpStep2;

  /// No description provided for @adminReportHelpStep3.
  ///
  /// In en, this message translates to:
  /// **'Select export format'**
  String get adminReportHelpStep3;

  /// No description provided for @adminReportHelpStep4.
  ///
  /// In en, this message translates to:
  /// **'Click Generate to create report'**
  String get adminReportHelpStep4;

  /// No description provided for @adminReportHelpStep5.
  ///
  /// In en, this message translates to:
  /// **'Download or share the report'**
  String get adminReportHelpStep5;

  /// No description provided for @adminReportHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get adminReportHowToUse;

  /// No description provided for @adminReportHowToUseScheduled.
  ///
  /// In en, this message translates to:
  /// **'How to Use Scheduled Reports'**
  String get adminReportHowToUseScheduled;

  /// No description provided for @adminReportInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get adminReportInformation;

  /// No description provided for @adminReportJsonData.
  ///
  /// In en, this message translates to:
  /// **'JSON Data'**
  String get adminReportJsonData;

  /// No description provided for @adminReportJsonDescription.
  ///
  /// In en, this message translates to:
  /// **'Raw data format for developers'**
  String get adminReportJsonDescription;

  /// No description provided for @adminReportLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get adminReportLast30Days;

  /// No description provided for @adminReportLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get adminReportLast7Days;

  /// No description provided for @adminReportLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get adminReportLastMonth;

  /// No description provided for @adminReportMetricAcceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get adminReportMetricAcceptanceRate;

  /// No description provided for @adminReportMetricActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get adminReportMetricActiveSessions;

  /// No description provided for @adminReportMetricConversion.
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate'**
  String get adminReportMetricConversion;

  /// No description provided for @adminReportMetricEngagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get adminReportMetricEngagement;

  /// No description provided for @adminReportMetricNewRegistrations.
  ///
  /// In en, this message translates to:
  /// **'New Registrations'**
  String get adminReportMetricNewRegistrations;

  /// No description provided for @adminReportMetricRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get adminReportMetricRevenue;

  /// No description provided for @adminReportMetricTotalApplications.
  ///
  /// In en, this message translates to:
  /// **'Total Applications'**
  String get adminReportMetricTotalApplications;

  /// No description provided for @adminReportMetricTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get adminReportMetricTotalUsers;

  /// No description provided for @adminReportMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get adminReportMonthly;

  /// No description provided for @adminReportNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'New Schedule'**
  String get adminReportNewSchedule;

  /// No description provided for @adminReportNewScheduledReport.
  ///
  /// In en, this message translates to:
  /// **'New Scheduled Report'**
  String get adminReportNewScheduledReport;

  /// No description provided for @adminReportNextRun.
  ///
  /// In en, this message translates to:
  /// **'Next Run'**
  String get adminReportNextRun;

  /// No description provided for @adminReportNoScheduledReports.
  ///
  /// In en, this message translates to:
  /// **'No scheduled reports'**
  String get adminReportNoScheduledReports;

  /// No description provided for @adminReportPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get adminReportPaused;

  /// No description provided for @adminReportPdfDescription.
  ///
  /// In en, this message translates to:
  /// **'Formatted document for printing'**
  String get adminReportPdfDescription;

  /// No description provided for @adminReportPdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get adminReportPdfDocument;

  /// No description provided for @adminReportQuickPresets.
  ///
  /// In en, this message translates to:
  /// **'Quick Presets'**
  String get adminReportQuickPresets;

  /// No description provided for @adminReportRecipientsRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one recipient is required'**
  String get adminReportRecipientsRequired;

  /// No description provided for @adminReportReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate and download reports'**
  String get adminReportReportsSubtitle;

  /// No description provided for @adminReportReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get adminReportReportsTitle;

  /// No description provided for @adminReportRunNow.
  ///
  /// In en, this message translates to:
  /// **'Run Now'**
  String get adminReportRunNow;

  /// No description provided for @adminReportSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adminReportSave;

  /// No description provided for @adminReportScheduledCreated.
  ///
  /// In en, this message translates to:
  /// **'Scheduled report created'**
  String get adminReportScheduledCreated;

  /// No description provided for @adminReportScheduledReportDeleted.
  ///
  /// In en, this message translates to:
  /// **'Scheduled report deleted'**
  String get adminReportScheduledReportDeleted;

  /// No description provided for @adminReportScheduledReports.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Reports'**
  String get adminReportScheduledReports;

  /// No description provided for @adminReportScheduledReportsHelp.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Reports Help'**
  String get adminReportScheduledReportsHelp;

  /// No description provided for @adminReportScheduledStep1.
  ///
  /// In en, this message translates to:
  /// **'Create a new scheduled report'**
  String get adminReportScheduledStep1;

  /// No description provided for @adminReportScheduledStep2.
  ///
  /// In en, this message translates to:
  /// **'Select frequency (daily, weekly, monthly)'**
  String get adminReportScheduledStep2;

  /// No description provided for @adminReportScheduledStep3.
  ///
  /// In en, this message translates to:
  /// **'Choose metrics to include'**
  String get adminReportScheduledStep3;

  /// No description provided for @adminReportScheduledStep4.
  ///
  /// In en, this message translates to:
  /// **'Add email recipients'**
  String get adminReportScheduledStep4;

  /// No description provided for @adminReportScheduledStep5.
  ///
  /// In en, this message translates to:
  /// **'Reports will be sent automatically'**
  String get adminReportScheduledStep5;

  /// No description provided for @adminReportScheduledUpdated.
  ///
  /// In en, this message translates to:
  /// **'Scheduled report updated'**
  String get adminReportScheduledUpdated;

  /// No description provided for @adminReportSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get adminReportSelectAll;

  /// No description provided for @adminReportSelectAtLeastOneMetric.
  ///
  /// In en, this message translates to:
  /// **'Select at least one metric'**
  String get adminReportSelectAtLeastOneMetric;

  /// No description provided for @adminReportSelectMetrics.
  ///
  /// In en, this message translates to:
  /// **'Select Metrics'**
  String get adminReportSelectMetrics;

  /// No description provided for @adminReportStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get adminReportStartDate;

  /// No description provided for @adminReportThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get adminReportThisMonth;

  /// No description provided for @adminReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Title'**
  String get adminReportTitle;

  /// No description provided for @adminReportTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter report title'**
  String get adminReportTitleHint;

  /// No description provided for @adminReportTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get adminReportTitleRequired;

  /// No description provided for @adminReportTo.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get adminReportTo;

  /// No description provided for @adminReportToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get adminReportToday;

  /// No description provided for @adminReportTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get adminReportTomorrow;

  /// No description provided for @adminReportWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get adminReportWeekly;

  /// No description provided for @adminSupportAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get adminSupportAcademic;

  /// No description provided for @adminSupportAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get adminSupportAccount;

  /// No description provided for @adminSupportActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminSupportActive;

  /// No description provided for @adminSupportAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get adminSupportAllCategories;

  /// No description provided for @adminSupportAllStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get adminSupportAllStatus;

  /// No description provided for @adminSupportAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get adminSupportAnswer;

  /// No description provided for @adminSupportBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get adminSupportBilling;

  /// No description provided for @adminSupportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminSupportCancel;

  /// No description provided for @adminSupportCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminSupportCategory;

  /// No description provided for @adminSupportCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get adminSupportCreateAction;

  /// No description provided for @adminSupportCreateFaq.
  ///
  /// In en, this message translates to:
  /// **'Create FAQ'**
  String get adminSupportCreateFaq;

  /// No description provided for @adminSupportDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminSupportDelete;

  /// No description provided for @adminSupportDeleteFaq.
  ///
  /// In en, this message translates to:
  /// **'Delete FAQ'**
  String get adminSupportDeleteFaq;

  /// No description provided for @adminSupportDraftArticles.
  ///
  /// In en, this message translates to:
  /// **'Draft Articles'**
  String get adminSupportDraftArticles;

  /// No description provided for @adminSupportEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminSupportEdit;

  /// No description provided for @adminSupportEditFaq.
  ///
  /// In en, this message translates to:
  /// **'Edit FAQ'**
  String get adminSupportEditFaq;

  /// No description provided for @adminSupportFaqCreated.
  ///
  /// In en, this message translates to:
  /// **'FAQ created successfully'**
  String get adminSupportFaqCreated;

  /// No description provided for @adminSupportFaqDeleted.
  ///
  /// In en, this message translates to:
  /// **'FAQ deleted successfully'**
  String get adminSupportFaqDeleted;

  /// No description provided for @adminSupportFaqEntries.
  ///
  /// In en, this message translates to:
  /// **'FAQ Entries'**
  String get adminSupportFaqEntries;

  /// No description provided for @adminSupportFaqUpdated.
  ///
  /// In en, this message translates to:
  /// **'FAQ updated successfully'**
  String get adminSupportFaqUpdated;

  /// No description provided for @adminSupportGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get adminSupportGeneral;

  /// No description provided for @adminSupportHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get adminSupportHelpful;

  /// No description provided for @adminSupportHighestHelpfulVotes.
  ///
  /// In en, this message translates to:
  /// **'Highest Helpful Votes'**
  String get adminSupportHighestHelpfulVotes;

  /// No description provided for @adminSupportInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminSupportInactive;

  /// No description provided for @adminSupportKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get adminSupportKeywords;

  /// No description provided for @adminSupportKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get adminSupportKnowledgeBase;

  /// No description provided for @adminSupportKnowledgeBaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage FAQ entries and help articles'**
  String get adminSupportKnowledgeBaseSubtitle;

  /// No description provided for @adminSupportMostHelpful.
  ///
  /// In en, this message translates to:
  /// **'Most Helpful'**
  String get adminSupportMostHelpful;

  /// No description provided for @adminSupportNotHelpful.
  ///
  /// In en, this message translates to:
  /// **'Not Helpful'**
  String get adminSupportNotHelpful;

  /// No description provided for @adminSupportPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get adminSupportPriority;

  /// No description provided for @adminSupportPublishedArticles.
  ///
  /// In en, this message translates to:
  /// **'Published Articles'**
  String get adminSupportPublishedArticles;

  /// No description provided for @adminSupportQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get adminSupportQuestion;

  /// No description provided for @adminSupportRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminSupportRefresh;

  /// No description provided for @adminSupportSearchFaqHint.
  ///
  /// In en, this message translates to:
  /// **'Search FAQs...'**
  String get adminSupportSearchFaqHint;

  /// No description provided for @adminSupportStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminSupportStatus;

  /// No description provided for @adminSupportTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get adminSupportTechnical;

  /// No description provided for @adminSupportToggleActive.
  ///
  /// In en, this message translates to:
  /// **'Toggle Active'**
  String get adminSupportToggleActive;

  /// No description provided for @adminSupportTotalArticles.
  ///
  /// In en, this message translates to:
  /// **'Total Articles'**
  String get adminSupportTotalArticles;

  /// No description provided for @adminSupportUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get adminSupportUpdate;

  /// No description provided for @adminSupportUses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get adminSupportUses;

  /// No description provided for @adminUserAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get adminUserAcademic;

  /// No description provided for @adminUserAcademicCounseling.
  ///
  /// In en, this message translates to:
  /// **'Academic Counseling'**
  String get adminUserAcademicCounseling;

  /// No description provided for @adminUserAccountActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Account is active and can access the platform'**
  String get adminUserAccountActiveDesc;

  /// No description provided for @adminUserAccountInactiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Account is inactive and cannot access the platform'**
  String get adminUserAccountInactiveDesc;

  /// No description provided for @adminUserAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get adminUserAccountSettings;

  /// No description provided for @adminUserAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get adminUserAccountStatus;

  /// No description provided for @adminUserAccountUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully'**
  String get adminUserAccountUpdatedSuccess;

  /// No description provided for @adminUserActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get adminUserActivate;

  /// No description provided for @adminUserActivateCounselors.
  ///
  /// In en, this message translates to:
  /// **'Activate Counselors'**
  String get adminUserActivateCounselors;

  /// No description provided for @adminUserActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminUserActive;

  /// No description provided for @adminUserAddCounselor.
  ///
  /// In en, this message translates to:
  /// **'Add Counselor'**
  String get adminUserAddCounselor;

  /// No description provided for @adminUserAddNewCounselor.
  ///
  /// In en, this message translates to:
  /// **'Add New Counselor'**
  String get adminUserAddNewCounselor;

  /// No description provided for @adminUserAdminColumn.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminUserAdminColumn;

  /// No description provided for @adminUserAdminInformation.
  ///
  /// In en, this message translates to:
  /// **'Admin Information'**
  String get adminUserAdminInformation;

  /// No description provided for @adminUserAdminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin Role'**
  String get adminUserAdminRole;

  /// No description provided for @adminUserAdmins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get adminUserAdmins;

  /// No description provided for @adminUserAdminUsers.
  ///
  /// In en, this message translates to:
  /// **'Admin Users'**
  String get adminUserAdminUsers;

  /// No description provided for @adminUserAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminUserAll;

  /// No description provided for @adminUserAllRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get adminUserAllRoles;

  /// No description provided for @adminUserAllSpecialties.
  ///
  /// In en, this message translates to:
  /// **'All Specialties'**
  String get adminUserAllSpecialties;

  /// No description provided for @adminUserAllStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get adminUserAllStatus;

  /// No description provided for @adminUserAnalyticsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Analytics Admin'**
  String get adminUserAnalyticsAdmin;

  /// No description provided for @adminUserAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get adminUserAvailability;

  /// No description provided for @adminUserAvailabilityHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Mon-Fri 9am-5pm'**
  String get adminUserAvailabilityHint;

  /// No description provided for @adminUserBackToCounselors.
  ///
  /// In en, this message translates to:
  /// **'Back to Counselors'**
  String get adminUserBackToCounselors;

  /// No description provided for @adminUserCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminUserCancel;

  /// No description provided for @adminUserCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get adminUserCareer;

  /// No description provided for @adminUserCareerGuidance.
  ///
  /// In en, this message translates to:
  /// **'Career Guidance'**
  String get adminUserCareerGuidance;

  /// No description provided for @adminUserChooseRoleHelperText.
  ///
  /// In en, this message translates to:
  /// **'Choose the admin role for this user'**
  String get adminUserChooseRoleHelperText;

  /// No description provided for @adminUserCollege.
  ///
  /// In en, this message translates to:
  /// **'College'**
  String get adminUserCollege;

  /// No description provided for @adminUserCollegeAdmissions.
  ///
  /// In en, this message translates to:
  /// **'College Admissions'**
  String get adminUserCollegeAdmissions;

  /// No description provided for @adminUserConfirmDeactivation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deactivation'**
  String get adminUserConfirmDeactivation;

  /// No description provided for @adminUserConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get adminUserConfirmPassword;

  /// No description provided for @adminUserContactAndAvailability.
  ///
  /// In en, this message translates to:
  /// **'Contact & Availability'**
  String get adminUserContactAndAvailability;

  /// No description provided for @adminUserContentAdmin.
  ///
  /// In en, this message translates to:
  /// **'Content Admin'**
  String get adminUserContentAdmin;

  /// No description provided for @adminUserCounselorColumn.
  ///
  /// In en, this message translates to:
  /// **'Counselor'**
  String get adminUserCounselorColumn;

  /// No description provided for @adminUserCounselorCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Counselor created successfully'**
  String get adminUserCounselorCreatedSuccess;

  /// No description provided for @adminUserCounselorId.
  ///
  /// In en, this message translates to:
  /// **'Counselor ID'**
  String get adminUserCounselorId;

  /// No description provided for @adminUserCounselors.
  ///
  /// In en, this message translates to:
  /// **'Counselors'**
  String get adminUserCounselors;

  /// No description provided for @adminUserCounselorUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Counselor updated successfully'**
  String get adminUserCounselorUpdatedSuccess;

  /// No description provided for @adminUserCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get adminUserCreate;

  /// No description provided for @adminUserCreateAdmin.
  ///
  /// In en, this message translates to:
  /// **'Create Admin'**
  String get adminUserCreateAdmin;

  /// No description provided for @adminUserCreateAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Admin Account'**
  String get adminUserCreateAdminAccount;

  /// No description provided for @adminUserCreateAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new admin user account'**
  String get adminUserCreateAdminSubtitle;

  /// No description provided for @adminUserCreateCounselor.
  ///
  /// In en, this message translates to:
  /// **'Create Counselor'**
  String get adminUserCreateCounselor;

  /// No description provided for @adminUserCreateCounselorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new counselor account'**
  String get adminUserCreateCounselorSubtitle;

  /// No description provided for @adminUserCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get adminUserCreated;

  /// No description provided for @adminUserCredentials.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get adminUserCredentials;

  /// No description provided for @adminUserCredentialsHint.
  ///
  /// In en, this message translates to:
  /// **'Professional certifications and licenses'**
  String get adminUserCredentialsHint;

  /// No description provided for @adminUserDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminUserDashboard;

  /// No description provided for @adminUserDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get adminUserDeactivate;

  /// No description provided for @adminUserDeactivateAccount.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get adminUserDeactivateAccount;

  /// No description provided for @adminUserDeactivateCounselors.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Counselors'**
  String get adminUserDeactivateCounselors;

  /// No description provided for @adminUserDeactivationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Deactivation feature coming soon'**
  String get adminUserDeactivationComingSoon;

  /// No description provided for @adminUserEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminUserEdit;

  /// No description provided for @adminUserEditAdmin.
  ///
  /// In en, this message translates to:
  /// **'Edit Admin'**
  String get adminUserEditAdmin;

  /// No description provided for @adminUserEditAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Admin Account'**
  String get adminUserEditAdminAccount;

  /// No description provided for @adminUserEditCounselor.
  ///
  /// In en, this message translates to:
  /// **'Edit Counselor'**
  String get adminUserEditCounselor;

  /// No description provided for @adminUserEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminUserEmail;

  /// No description provided for @adminUserEmailCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get adminUserEmailCannotBeChanged;

  /// No description provided for @adminUserEmailLoginHelper.
  ///
  /// In en, this message translates to:
  /// **'This email will be used to log in'**
  String get adminUserEmailLoginHelper;

  /// No description provided for @adminUserExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get adminUserExport;

  /// No description provided for @adminUserExportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon'**
  String get adminUserExportComingSoon;

  /// No description provided for @adminUserExportCounselors.
  ///
  /// In en, this message translates to:
  /// **'Export Counselors'**
  String get adminUserExportCounselors;

  /// No description provided for @adminUserFailedCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to create account'**
  String get adminUserFailedCreateAccount;

  /// No description provided for @adminUserFailedLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get adminUserFailedLoadData;

  /// No description provided for @adminUserFailedUpdateAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to update account'**
  String get adminUserFailedUpdateAccount;

  /// No description provided for @adminUserFinanceAdmin.
  ///
  /// In en, this message translates to:
  /// **'Finance Admin'**
  String get adminUserFinanceAdmin;

  /// No description provided for @adminUserFinancialAid.
  ///
  /// In en, this message translates to:
  /// **'Financial Aid'**
  String get adminUserFinancialAid;

  /// No description provided for @adminUserFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get adminUserFirstName;

  /// No description provided for @adminUserFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get adminUserFullName;

  /// No description provided for @adminUserInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminUserInactive;

  /// No description provided for @adminUserInstitutionCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Institution created successfully'**
  String get adminUserInstitutionCreatedSuccess;

  /// No description provided for @adminUserInstitutionInformation.
  ///
  /// In en, this message translates to:
  /// **'Institution Information'**
  String get adminUserInstitutionInformation;

  /// No description provided for @adminUserInstitutionName.
  ///
  /// In en, this message translates to:
  /// **'Institution Name'**
  String get adminUserInstitutionName;

  /// No description provided for @adminUserInstitutionUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Institution updated successfully'**
  String get adminUserInstitutionUpdatedSuccess;

  /// No description provided for @adminUserInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get adminUserInvalidEmail;

  /// No description provided for @adminUserJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get adminUserJoined;

  /// No description provided for @adminUserLanguageSchool.
  ///
  /// In en, this message translates to:
  /// **'Language School'**
  String get adminUserLanguageSchool;

  /// No description provided for @adminUserLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get adminUserLastLogin;

  /// No description provided for @adminUserLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get adminUserLastName;

  /// No description provided for @adminUserLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get adminUserLicenseNumber;

  /// No description provided for @adminUserManageAdminAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage Admin Accounts'**
  String get adminUserManageAdminAccounts;

  /// No description provided for @adminUserManageCounselorAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage Counselor Accounts'**
  String get adminUserManageCounselorAccounts;

  /// No description provided for @adminUserMentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get adminUserMentalHealth;

  /// No description provided for @adminUserNoPermissionDeactivate.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to deactivate this account'**
  String get adminUserNoPermissionDeactivate;

  /// No description provided for @adminUserNoPermissionEdit.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to edit this account'**
  String get adminUserNoPermissionEdit;

  /// No description provided for @adminUserOfficeLocation.
  ///
  /// In en, this message translates to:
  /// **'Office Location'**
  String get adminUserOfficeLocation;

  /// No description provided for @adminUserOfficeLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Building and room number'**
  String get adminUserOfficeLocationHint;

  /// No description provided for @adminUserPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get adminUserPassword;

  /// No description provided for @adminUserPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get adminUserPasswordHelper;

  /// No description provided for @adminUserPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get adminUserPasswordsDoNotMatch;

  /// No description provided for @adminUserPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminUserPending;

  /// No description provided for @adminUserPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get adminUserPendingApproval;

  /// No description provided for @adminUserPendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get adminUserPendingVerification;

  /// No description provided for @adminUserPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get adminUserPersonalInformation;

  /// No description provided for @adminUserPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get adminUserPhone;

  /// No description provided for @adminUserPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Include country code'**
  String get adminUserPhoneHelper;

  /// No description provided for @adminUserPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get adminUserPhoneNumber;

  /// No description provided for @adminUserPleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get adminUserPleaseConfirmPassword;

  /// No description provided for @adminUserProfessionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get adminUserProfessionalInformation;

  /// No description provided for @adminUserRegionalAdmin.
  ///
  /// In en, this message translates to:
  /// **'Regional Admin'**
  String get adminUserRegionalAdmin;

  /// No description provided for @adminUserRegionalScope.
  ///
  /// In en, this message translates to:
  /// **'Regional Scope'**
  String get adminUserRegionalScope;

  /// No description provided for @adminUserRegionalScopeHelper.
  ///
  /// In en, this message translates to:
  /// **'Select the regions this admin can manage'**
  String get adminUserRegionalScopeHelper;

  /// No description provided for @adminUserRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get adminUserRejected;

  /// No description provided for @adminUserRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get adminUserRequired;

  /// No description provided for @adminUserRequiredForRegional.
  ///
  /// In en, this message translates to:
  /// **'Required for regional admin role'**
  String get adminUserRequiredForRegional;

  /// No description provided for @adminUserRoleColumn.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminUserRoleColumn;

  /// No description provided for @adminUserSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get adminUserSaveChanges;

  /// No description provided for @adminUserSearchByNameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get adminUserSearchByNameOrEmail;

  /// No description provided for @adminUserSearchCounselors.
  ///
  /// In en, this message translates to:
  /// **'Search counselors...'**
  String get adminUserSearchCounselors;

  /// No description provided for @adminUserSecuritySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get adminUserSecuritySettings;

  /// No description provided for @adminUserSelectAdminRole.
  ///
  /// In en, this message translates to:
  /// **'Select Admin Role'**
  String get adminUserSelectAdminRole;

  /// No description provided for @adminUserSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get adminUserSessions;

  /// No description provided for @adminUserSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get adminUserSpecialty;

  /// No description provided for @adminUserStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminUserStatus;

  /// No description provided for @adminUserStatusColumn.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminUserStatusColumn;

  /// No description provided for @adminUserStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get adminUserStudents;

  /// No description provided for @adminUserStudySkills.
  ///
  /// In en, this message translates to:
  /// **'Study Skills'**
  String get adminUserStudySkills;

  /// No description provided for @adminUserSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get adminUserSuperAdmin;

  /// No description provided for @adminUserSupportAdmin.
  ///
  /// In en, this message translates to:
  /// **'Support Admin'**
  String get adminUserSupportAdmin;

  /// No description provided for @adminUserSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get adminUserSuspended;

  /// No description provided for @adminUserType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get adminUserType;

  /// No description provided for @adminUserUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get adminUserUniversity;

  /// No description provided for @adminUserUpdateAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update admin account information'**
  String get adminUserUpdateAdminSubtitle;

  /// No description provided for @adminUserUpdateCounselor.
  ///
  /// In en, this message translates to:
  /// **'Update Counselor'**
  String get adminUserUpdateCounselor;

  /// No description provided for @adminUserUpdateCounselorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update counselor account information'**
  String get adminUserUpdateCounselorSubtitle;

  /// No description provided for @adminUserVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get adminUserVerified;

  /// No description provided for @adminUserViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get adminUserViewDetails;

  /// No description provided for @adminUserVocationalSchool.
  ///
  /// In en, this message translates to:
  /// **'Vocational School'**
  String get adminUserVocationalSchool;

  /// No description provided for @adminUserWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get adminUserWebsite;

  /// No description provided for @adminUserYearsOfExperience.
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get adminUserYearsOfExperience;

  /// No description provided for @adminAnalyticsShowingRows.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total} rows'**
  String adminAnalyticsShowingRows(Object count, Object total);

  /// No description provided for @adminAnalyticsColumnsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} columns'**
  String adminAnalyticsColumnsCount(Object count);

  /// No description provided for @adminChatFailedSendReply.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reply: {error}'**
  String adminChatFailedSendReply(Object error);

  /// No description provided for @adminChatRole.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String adminChatRole(Object role);

  /// No description provided for @adminChatMessageCount.
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String adminChatMessageCount(Object count);

  /// No description provided for @adminChatStarted.
  ///
  /// In en, this message translates to:
  /// **'Started: {date}'**
  String adminChatStarted(Object date);

  /// No description provided for @adminChatLastMessage.
  ///
  /// In en, this message translates to:
  /// **'Last message: {date}'**
  String adminChatLastMessage(Object date);

  /// No description provided for @adminChatDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String adminChatDuration(Object duration);

  /// No description provided for @adminChatFaqDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{question}\"?'**
  String adminChatFaqDeleteConfirm(Object question);

  /// No description provided for @adminChatFaqDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete FAQ: {error}'**
  String adminChatFaqDeleteFailed(Object error);

  /// No description provided for @adminChatFaqUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update FAQ: {error}'**
  String adminChatFaqUpdateFailed(Object error);

  /// No description provided for @adminChatFaqSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save FAQ: {error}'**
  String adminChatFaqSaveFailed(Object error);

  /// No description provided for @adminChatQueueAssignFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to assign conversation: {error}'**
  String adminChatQueueAssignFailed(Object error);

  /// No description provided for @adminReportGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate report: {error}'**
  String adminReportGenerateFailed(Object error);

  /// No description provided for @adminReportNameGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} generated successfully'**
  String adminReportNameGeneratedSuccess(Object name);

  /// No description provided for @adminReportInDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String adminReportInDays(Object days);

  /// No description provided for @adminUserErrorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String adminUserErrorLoadingData(Object error);

  /// No description provided for @adminUserAccountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account {email} created successfully'**
  String adminUserAccountCreatedSuccess(Object email);

  /// No description provided for @adminUserError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminUserError(Object error);

  /// No description provided for @adminUserCannotActivateInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Cannot activate {count} admins: insufficient permissions'**
  String adminUserCannotActivateInsufficient(Object count);

  /// No description provided for @adminUserAdminsActivated.
  ///
  /// In en, this message translates to:
  /// **'{count} admins activated'**
  String adminUserAdminsActivated(Object count);

  /// No description provided for @adminUserCannotDeactivateInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Cannot deactivate {count} admins: insufficient permissions'**
  String adminUserCannotDeactivateInsufficient(Object count);

  /// No description provided for @adminUserConfirmDeactivateAdmins.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate {count} admins?'**
  String adminUserConfirmDeactivateAdmins(Object count);

  /// No description provided for @adminUserAdminsDeactivated.
  ///
  /// In en, this message translates to:
  /// **'{count} admins deactivated'**
  String adminUserAdminsDeactivated(Object count);

  /// No description provided for @adminUserConfirmActivateCounselors.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to activate {count} counselors?'**
  String adminUserConfirmActivateCounselors(Object count);

  /// No description provided for @adminUserConfirmDeactivateCounselors.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate {count} counselors?'**
  String adminUserConfirmDeactivateCounselors(Object count);
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
