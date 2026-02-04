// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flow - African EdTech Platform';

  @override
  String get loading => 'Loading...';

  @override
  String get backToTop => 'Back to Top';

  @override
  String get navHome => 'Home';

  @override
  String get navUniversities => 'Universities';

  @override
  String get navAbout => 'About';

  @override
  String get navContact => 'Contact';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navSignIn => 'Sign In';

  @override
  String get navGetStarted => 'Get Started';

  @override
  String get loginTitle => 'Flow';

  @override
  String get loginSubtitle => 'African EdTech Platform';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordEmpty => 'Please enter your password';

  @override
  String get loginPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Login';

  @override
  String get loginOr => 'OR';

  @override
  String get loginCreateAccount => 'Create Account';

  @override
  String get loginResetPassword => 'Reset Password';

  @override
  String get loginAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerTitle => 'Join Flow';

  @override
  String get registerSubtitle => 'Start your educational journey';

  @override
  String get registerAppBarTitle => 'Create Account';

  @override
  String get registerFullNameLabel => 'Full Name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerRoleLabel => 'I am a...';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm Password';

  @override
  String get registerConfirmPasswordEmpty => 'Please confirm your password';

  @override
  String get registerPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registerLoginInstead => 'Login Instead';

  @override
  String get registerResetPassword => 'Reset Password';

  @override
  String get registerLogin => 'Login';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordReq8Chars => '8+ characters';

  @override
  String get passwordReqUppercase => 'Uppercase';

  @override
  String get passwordReqLowercase => 'Lowercase';

  @override
  String get passwordReqNumber => 'Number';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we\'ll send you instructions to reset your password.';

  @override
  String get forgotPasswordEmailLabel => 'Email Address';

  @override
  String get forgotPasswordEmailHint => 'Enter your email';

  @override
  String get forgotPasswordSendButton => 'Send Reset Link';

  @override
  String get forgotPasswordBackToLogin => 'Back to Login';

  @override
  String get forgotPasswordCheckEmail => 'Check Your Email';

  @override
  String get forgotPasswordSentTo =>
      'We\'ve sent password reset instructions to:';

  @override
  String get forgotPasswordDidntReceive => 'Didn\'t receive the email?';

  @override
  String get forgotPasswordCheckSpam => 'Check your spam/junk folder';

  @override
  String get forgotPasswordCheckCorrect =>
      'Make sure the email address is correct';

  @override
  String get forgotPasswordWait => 'Wait a few minutes for the email to arrive';

  @override
  String get forgotPasswordResend => 'Resend Email';

  @override
  String get emailVerifyTitle => 'Verify Your Email';

  @override
  String get emailVerifyAppBarTitle => 'Verify Email';

  @override
  String get emailVerifySentTo => 'We\'ve sent a verification link to:';

  @override
  String get emailVerifyNextSteps => 'Next Steps';

  @override
  String get emailVerifyStep1 => 'Check your email inbox';

  @override
  String get emailVerifyStep2 => 'Click the verification link';

  @override
  String get emailVerifyStep3 => 'Return here to continue';

  @override
  String get emailVerifyCheckButton => 'I\'ve Verified My Email';

  @override
  String get emailVerifyChecking => 'Checking...';

  @override
  String get emailVerifyResend => 'Resend Email';

  @override
  String emailVerifyResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get emailVerifyNotYet =>
      'Email not verified yet. Please check your inbox.';

  @override
  String emailVerifyCheckError(String error) {
    return 'Error checking verification: $error';
  }

  @override
  String get emailVerifySent => 'Verification email sent! Check your inbox.';

  @override
  String emailVerifySendFailed(String error) {
    return 'Failed to send email: $error';
  }

  @override
  String get emailVerifySuccess => 'Email Verified!';

  @override
  String get emailVerifySuccessMessage =>
      'Your email has been successfully verified.';

  @override
  String get emailVerifyDidntReceive => 'Didn\'t receive the email?';

  @override
  String get emailVerifySpamTip => 'Check your spam/junk folder';

  @override
  String get emailVerifyCorrectTip => 'Make sure the email is correct';

  @override
  String get emailVerifyWaitTip => 'Wait a few minutes and try resending';

  @override
  String get emailVerifyAutoCheck => 'Auto-checking every 5 seconds';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Flow';

  @override
  String get onboardingWelcomeDesc =>
      'Your comprehensive platform for educational opportunities across Africa';

  @override
  String get onboardingCoursesTitle => 'Discover Courses';

  @override
  String get onboardingCoursesDesc =>
      'Browse and enroll in courses from top institutions across the continent';

  @override
  String get onboardingProgressTitle => 'Track Your Progress';

  @override
  String get onboardingProgressDesc =>
      'Monitor your academic journey with detailed analytics and insights';

  @override
  String get onboardingConnectTitle => 'Connect & Collaborate';

  @override
  String get onboardingConnectDesc =>
      'Engage with counselors, get recommendations, and manage applications';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingFeatureCourseSelection => 'Wide selection of courses';

  @override
  String get onboardingFeatureFilter => 'Filter by category and level';

  @override
  String get onboardingFeatureDetails => 'Detailed course information';

  @override
  String get onboardingFeatureProgress => 'Real-time progress tracking';

  @override
  String get onboardingFeatureAnalytics => 'Performance analytics';

  @override
  String get onboardingFeatureAchievements => 'Achievement system';

  @override
  String get heroTrustBadge => 'Trusted by 200+ Universities';

  @override
  String get heroHeadline => 'Find Your Perfect\nUniversity Match';

  @override
  String get heroSubheadline =>
      'Discover, compare, and apply to 18,000+ universities\nwith personalized recommendations powered by AI';

  @override
  String get heroStartFreeTrial => 'Start Free Trial';

  @override
  String get heroTakeATour => 'Take a Tour';

  @override
  String get heroStatActiveUsers => 'Active Users';

  @override
  String get heroStatUniversities => 'Universities';

  @override
  String get heroStatCountries => 'Countries';

  @override
  String get whyChooseTitle => 'Why Choose Flow?';

  @override
  String get whyChooseSubtitle => 'Built for Africa, designed for everyone';

  @override
  String get valueOfflineTitle => 'Offline-First';

  @override
  String get valueOfflineDesc =>
      'Access your content anytime, anywhere—even without internet connectivity';

  @override
  String get valueMobileMoneyTitle => 'Mobile Money';

  @override
  String get valueMobileMoneyDesc =>
      'Pay with M-Pesa, MTN Money, and other local payment methods you trust';

  @override
  String get valueMultiLangTitle => 'Multi-Language';

  @override
  String get valueMultiLangDesc =>
      'Platform available in multiple African languages for your convenience';

  @override
  String get socialProofTitle =>
      'Trusted by Leading Institutions Across Africa';

  @override
  String get testimonialsTitle => 'What Our Users Say';

  @override
  String get testimonialsSubtitle =>
      'Success stories from students, institutions, and educators';

  @override
  String get quizBadge => 'Find Your Path';

  @override
  String get quizTitle => 'Not Sure Where\nto Start?';

  @override
  String get quizDescription =>
      'Take our quick quiz to discover universities and programs that match your interests, goals, and academic profile.';

  @override
  String get quizDuration => '2 minutes';

  @override
  String get quizAIPowered => 'AI-Powered';

  @override
  String get featuresTitle => 'Features';

  @override
  String get featuresSubtitle =>
      'A complete educational ecosystem designed for modern Africa';

  @override
  String get featureLearningTitle => 'Comprehensive Learning';

  @override
  String get featureLearningDesc =>
      'Access courses, track progress, and manage applications all in one place';

  @override
  String get featureCollabTitle => 'Built for Collaboration';

  @override
  String get featureCollabDesc =>
      'Connect students, parents, counselors, and institutions seamlessly';

  @override
  String get featureSecurityTitle => 'Enterprise-Grade Security';

  @override
  String get featureSecurityDesc =>
      'Bank-level encryption and GDPR-compliant data protection';

  @override
  String get featuresWorksOnAllDevices => 'Works on all devices';

  @override
  String get builtForEveryoneTitle => 'Built for Everyone';

  @override
  String get builtForEveryoneSubtitle =>
      'Choose your role and get started with a personalized experience';

  @override
  String get roleStudents => 'Students';

  @override
  String get roleStudentsDesc =>
      'Track courses, manage applications, and achieve your educational goals';

  @override
  String get roleInstitutions => 'Institutions';

  @override
  String get roleInstitutionsDesc =>
      'Streamline admissions, manage programs, and engage with students';

  @override
  String get roleParents => 'Parents';

  @override
  String get roleParentsDesc =>
      'Monitor progress, communicate with teachers, and support your children';

  @override
  String get roleCounselors => 'Counselors';

  @override
  String get roleCounselorsDesc =>
      'Guide students, manage sessions, and track counseling outcomes';

  @override
  String getStartedAs(String role) {
    return 'Get Started as $role';
  }

  @override
  String get ctaTitle => 'Ready to Transform\nYour Educational Journey?';

  @override
  String get ctaSubtitle =>
      'Join 50,000+ students, institutions, and educators who trust Flow';

  @override
  String get ctaButton => 'Start Your Free Trial';

  @override
  String get ctaNoCreditCard => 'No credit card required';

  @override
  String get cta14DayTrial => '14-day free trial';

  @override
  String get footerTagline =>
      'Africa\'s Leading EdTech Platform\nEmpowering education without boundaries.';

  @override
  String get footerProducts => 'Products';

  @override
  String get footerStudentPortal => 'Student Portal';

  @override
  String get footerInstitutionDashboard => 'Institution Dashboard';

  @override
  String get footerParentApp => 'Parent App';

  @override
  String get footerCounselorTools => 'Counselor Tools';

  @override
  String get footerMobileApps => 'Mobile Apps';

  @override
  String get footerCompany => 'Company';

  @override
  String get footerAboutUs => 'About Us';

  @override
  String get footerCareers => 'Careers';

  @override
  String get footerPressKit => 'Press Kit';

  @override
  String get footerPartners => 'Partners';

  @override
  String get footerContact => 'Contact';

  @override
  String get footerResources => 'Resources';

  @override
  String get footerHelpCenter => 'Help Center';

  @override
  String get footerDocumentation => 'Documentation';

  @override
  String get footerApiReference => 'API Reference';

  @override
  String get footerCommunity => 'Community';

  @override
  String get footerBlog => 'Blog';

  @override
  String get footerLegal => 'Legal';

  @override
  String get footerPrivacyPolicy => 'Privacy Policy';

  @override
  String get footerTermsOfService => 'Terms of Service';

  @override
  String get footerCookiePolicy => 'Cookie Policy';

  @override
  String get footerDataProtection => 'Data Protection';

  @override
  String get footerCompliance => 'Compliance';

  @override
  String get footerCopyright => '© 2025 Flow EdTech. All rights reserved.';

  @override
  String get footerSoc2 => 'SOC 2 Certified';

  @override
  String get footerIso27001 => 'ISO 27001';

  @override
  String get footerGdpr => 'GDPR Compliant';

  @override
  String get searchHint =>
      'Search universities by name, country, or program...';

  @override
  String get searchUniversitiesCount => 'Search 18,000+ Universities';

  @override
  String get searchPlaceholder => 'Search universities...';

  @override
  String get searchBadge => '18K+';

  @override
  String get searchSuggestionGhana => 'University of Ghana';

  @override
  String get searchSuggestionGhanaLocation => 'Accra, Ghana';

  @override
  String get searchSuggestionCapeTown => 'University of Cape Town';

  @override
  String get searchSuggestionCapeTownLocation => 'Cape Town, South Africa';

  @override
  String get searchSuggestionAshesi => 'Ashesi University';

  @override
  String get searchSuggestionAshesiLocation => 'Berekuso, Ghana';

  @override
  String get searchSuggestionPublicUniversity => 'Public University';

  @override
  String get searchSuggestionPrivateUniversity => 'Private University';

  @override
  String get filterEngineering => 'Engineering';

  @override
  String get filterBusiness => 'Business';

  @override
  String get filterMedicine => 'Medicine';

  @override
  String get filterArts => 'Arts';

  @override
  String get filterScience => 'Science';

  @override
  String get quizFindYourPath => 'Find Your Path';

  @override
  String get quizQuickPreview => 'Quick Preview';

  @override
  String get quizFieldQuestion => 'What field interests you most?';

  @override
  String get quizFieldTechEngineering => 'Technology & Engineering';

  @override
  String get quizFieldBusinessFinance => 'Business & Finance';

  @override
  String get quizFieldHealthcareMedicine => 'Healthcare & Medicine';

  @override
  String get quizFieldArtsHumanities => 'Arts & Humanities';

  @override
  String get quizLocationQuestion => 'Where would you prefer to study?';

  @override
  String get quizLocationWestAfrica => 'West Africa';

  @override
  String get quizLocationEastAfrica => 'East Africa';

  @override
  String get quizLocationSouthernAfrica => 'Southern Africa';

  @override
  String get quizLocationAnywhereAfrica => 'Anywhere in Africa';

  @override
  String get quizGetRecommendations => 'Get Your Recommendations';

  @override
  String get quizTakeTheQuiz => 'Take the quiz';

  @override
  String get tourTitle => 'See Flow in Action';

  @override
  String get tourSubtitle => 'A guided tour of the platform';

  @override
  String get tourClose => 'Close';

  @override
  String get tourBack => 'Back';

  @override
  String get tourNext => 'Next';

  @override
  String get tourGetStarted => 'Get Started';

  @override
  String get tourSlide1Title => 'Discover Universities';

  @override
  String get tourSlide1Desc =>
      'Search and compare universities across Africa with detailed profiles, rankings, and program information.';

  @override
  String get tourSlide1H1 => 'Browse 500+ institutions';

  @override
  String get tourSlide1H2 => 'Filter by country, program & tuition';

  @override
  String get tourSlide1H3 => 'View detailed university profiles';

  @override
  String get tourSlide2Title => 'Find Your Path';

  @override
  String get tourSlide2Desc =>
      'Take our guided quiz to get personalized university and program recommendations matched to your goals.';

  @override
  String get tourSlide2H1 => 'AI-powered recommendations';

  @override
  String get tourSlide2H2 => 'Personality & interest matching';

  @override
  String get tourSlide2H3 => 'Tailored program suggestions';

  @override
  String get tourSlide3Title => 'Role-Based Dashboards';

  @override
  String get tourSlide3Desc =>
      'Purpose-built dashboards for students, parents, counselors, and institutions — each with the tools they need.';

  @override
  String get tourSlide3H1 => 'Track applications & progress';

  @override
  String get tourSlide3H2 => 'Monitor student performance';

  @override
  String get tourSlide3H3 => 'Manage institutional data';

  @override
  String get tourSlide4Title => 'AI Study Assistant';

  @override
  String get tourSlide4Desc =>
      'Get instant help with admissions questions, application guidance, and academic planning from our AI chatbot.';

  @override
  String get tourSlide4H1 => 'Available 24/7';

  @override
  String get tourSlide4H2 => 'Context-aware answers';

  @override
  String get tourSlide4H3 => 'Application deadline reminders';

  @override
  String get tourSlide5Title => 'Connected Ecosystem';

  @override
  String get tourSlide5Desc =>
      'Students, parents, counselors, and institutions collaborate seamlessly on one platform.';

  @override
  String get tourSlide5H1 => 'Real-time notifications';

  @override
  String get tourSlide5H2 => 'Shared progress tracking';

  @override
  String get tourSlide5H3 => 'Secure messaging';

  @override
  String get uniSearchTitle => 'Search Universities';

  @override
  String get uniSearchClearAll => 'Clear all';

  @override
  String get uniSearchHint => 'Search by university name...';

  @override
  String get uniSearchFilters => 'Filters';

  @override
  String uniSearchResultCount(int count) {
    return '$count universities found';
  }

  @override
  String get uniSearchNoMatchFilters => 'No universities match your filters';

  @override
  String get uniSearchNoResults => 'No universities found';

  @override
  String get uniSearchAdjustFilters =>
      'Try adjusting your filters to see more results';

  @override
  String get uniSearchTrySearching => 'Try searching for a university name';

  @override
  String get uniSearchError => 'Something went wrong';

  @override
  String get uniSearchRetry => 'Retry';

  @override
  String get uniSearchFilterReset => 'Reset';

  @override
  String get uniSearchFilterCountry => 'Country';

  @override
  String get uniSearchFilterSelectCountry => 'Select country';

  @override
  String get uniSearchFilterAllCountries => 'All Countries';

  @override
  String get uniSearchFilterUniType => 'University Type';

  @override
  String get uniSearchFilterSelectType => 'Select type';

  @override
  String get uniSearchFilterAllTypes => 'All Types';

  @override
  String get uniSearchFilterLocationType => 'Location Type';

  @override
  String get uniSearchFilterSelectLocation => 'Select location type';

  @override
  String get uniSearchFilterAllLocations => 'All Locations';

  @override
  String get uniSearchFilterMaxTuition => 'Maximum Tuition (USD/year)';

  @override
  String get uniSearchFilterNoLimit => 'No limit';

  @override
  String get uniSearchFilterAny => 'Any';

  @override
  String get uniSearchFilterAcceptanceRate => 'Acceptance Rate';

  @override
  String get uniSearchFilterAnyRate => 'Any rate';

  @override
  String get uniSearchFilterApply => 'Apply Filters';

  @override
  String uniSearchAcceptance(String rate) {
    return '$rate% acceptance';
  }

  @override
  String uniSearchStudents(String count) {
    return '$count students';
  }

  @override
  String get uniDetailNotFound => 'This university could not be found.';

  @override
  String uniDetailError(String error) {
    return 'Error loading university: $error';
  }

  @override
  String get uniDetailVisitWebsite => 'Visit Website';

  @override
  String get uniDetailLocation => 'Location';

  @override
  String get uniDetailAddress => 'Address';

  @override
  String get uniDetailSetting => 'Setting';

  @override
  String get uniDetailKeyStats => 'Key Statistics';

  @override
  String get uniDetailTotalStudents => 'Total Students';

  @override
  String get uniDetailAcceptanceRate => 'Acceptance Rate';

  @override
  String get uniDetailGradRate => '4-Year Graduation Rate';

  @override
  String get uniDetailAvgGPA => 'Average GPA';

  @override
  String get uniDetailTuitionCosts => 'Tuition & Costs';

  @override
  String get uniDetailTuitionOutState => 'Tuition (Out-of-State)';

  @override
  String get uniDetailTotalCost => 'Total Cost';

  @override
  String get uniDetailMedianEarnings => 'Median Earnings (10 yr)';

  @override
  String get uniDetailTestScores => 'Test Scores (25th-75th Percentile)';

  @override
  String get uniDetailSATMath => 'SAT Math';

  @override
  String get uniDetailSATEBRW => 'SAT EBRW';

  @override
  String get uniDetailACTComposite => 'ACT Composite';

  @override
  String get uniDetailRankings => 'Rankings';

  @override
  String get uniDetailGlobalRank => 'Global Rank';

  @override
  String get uniDetailNationalRank => 'National Rank';

  @override
  String get uniDetailAbout => 'About';

  @override
  String get uniDetailType => 'Type';

  @override
  String get uniDetailWebsite => 'Website';

  @override
  String get uniDetailDescription => 'Description';

  @override
  String get dashCommonBack => 'Back';

  @override
  String get dashCommonHome => 'Home';

  @override
  String get dashCommonProfile => 'Profile';

  @override
  String get dashCommonSettings => 'Settings';

  @override
  String get dashCommonOverview => 'Overview';

  @override
  String get dashCommonRetry => 'Retry';

  @override
  String get dashCommonViewAll => 'View All';

  @override
  String get dashCommonClose => 'Close';

  @override
  String get dashCommonCancel => 'Cancel';

  @override
  String get dashCommonPending => 'Pending';

  @override
  String get dashCommonLoadingOverview => 'Loading overview...';

  @override
  String get dashCommonNotifications => 'Notifications';

  @override
  String get dashCommonMessages => 'Messages';

  @override
  String get dashCommonQuickActions => 'Quick Actions';

  @override
  String get dashCommonWelcomeBack => 'Welcome Back!';

  @override
  String get dashCommonRecentActivity => 'Recent Activity';

  @override
  String get dashCommonNoRecentActivity => 'No recent activity';

  @override
  String get dashCommonSwitchRole => 'Switch Role';

  @override
  String get dashCommonLogout => 'Logout';

  @override
  String get dashCommonRecommendedForYou => 'Recommended for You';

  @override
  String get dashCommonApplications => 'Applications';

  @override
  String get dashCommonAccepted => 'Accepted';

  @override
  String get dashCommonRejected => 'Rejected';

  @override
  String get dashCommonUnderReview => 'Under Review';

  @override
  String get dashCommonRequests => 'Requests';

  @override
  String get dashCommonUpcoming => 'Upcoming';

  @override
  String get dashCommonMeetings => 'Meetings';

  @override
  String get dashCommonSubmitted => 'Submitted';

  @override
  String get dashCommonDraft => 'Draft';

  @override
  String dashCommonDays(int count) {
    return '$count days';
  }

  @override
  String dashCommonMin(int count) {
    return '$count min';
  }

  @override
  String get dashCommonNoDataAvailable => 'No data available';

  @override
  String get dashStudentTitle => 'Student Dashboard';

  @override
  String get dashStudentMyApplications => 'My Applications';

  @override
  String get dashStudentMyCourses => 'My Courses';

  @override
  String get dashStudentProgress => 'Progress';

  @override
  String get dashStudentEditProfile => 'Edit Profile';

  @override
  String get dashStudentCourses => 'Courses';

  @override
  String get dashStudentContinueJourney => 'Continue your learning journey';

  @override
  String get dashStudentSuccessRate => 'Application Success Rate';

  @override
  String get dashStudentLetters => 'Letters';

  @override
  String get dashStudentParentLink => 'Parent Link';

  @override
  String get dashStudentCounseling => 'Counseling';

  @override
  String get dashStudentSchedule => 'Schedule';

  @override
  String get dashStudentResources => 'Resources';

  @override
  String get dashStudentHelp => 'Help';

  @override
  String get dashStudentTotalApplications => 'Total Applications';

  @override
  String get dashStudentInReview => 'In Review';

  @override
  String get dashStudentFindYourPath => 'Find Your Path';

  @override
  String get dashStudentNew => 'NEW';

  @override
  String get dashStudentFindYourPathDesc =>
      'Discover universities that match your profile, goals, and preferences with AI-powered recommendations';

  @override
  String get dashStudentStartJourney => 'Start Your Journey';

  @override
  String get dashStudentFailedActivities => 'Failed to load activities';

  @override
  String get dashStudentActivityHistory => 'Activity History';

  @override
  String get dashStudentActivityHistoryMsg =>
      'A comprehensive activity history view with filters and search capabilities is coming soon.';

  @override
  String get dashStudentAchievement => 'Achievement';

  @override
  String get dashStudentPaymentHistory => 'Payment History';

  @override
  String get dashStudentPaymentHistoryMsg =>
      'View detailed payment history and transaction records.';

  @override
  String get dashStudentFailedRecommendations =>
      'Failed to load recommendations';

  @override
  String get dashParentTitle => 'Parent Dashboard';

  @override
  String get dashParentMyChildren => 'My Children';

  @override
  String get dashParentAlerts => 'Alerts';

  @override
  String get dashParentChildren => 'Children';

  @override
  String get dashParentAvgGrade => 'Avg Grade';

  @override
  String get dashParentUpcomingMeetings => 'Upcoming Meetings';

  @override
  String get dashParentNoUpcomingMeetings => 'No Upcoming Meetings';

  @override
  String get dashParentScheduleMeetingsHint =>
      'Schedule meetings with teachers or counselors';

  @override
  String get dashParentScheduleMeeting => 'Schedule Meeting';

  @override
  String dashParentViewMoreMeetings(int count) {
    return 'View $count more meetings';
  }

  @override
  String get dashParentChildrenOverview => 'Children Overview';

  @override
  String get dashParentNoChildren => 'No Children Added';

  @override
  String get dashParentNoChildrenHint =>
      'Add your children to track their progress';

  @override
  String dashParentCourseCount(int count) {
    return '$count courses';
  }

  @override
  String dashParentAppCount(int count) {
    return '$count apps';
  }

  @override
  String get dashParentViewAllReports => 'View All Reports';

  @override
  String get dashParentAcademicReports => 'Academic performance reports';

  @override
  String get dashParentWithTeachersOrCounselors =>
      'With teachers or counselors';

  @override
  String get dashParentNotificationSettings => 'Notification Settings';

  @override
  String get dashParentManageAlerts => 'Manage alerts and updates';

  @override
  String get dashParentMeetWith => 'Who would you like to meet with?';

  @override
  String get dashParentTeacher => 'Teacher';

  @override
  String get dashParentTeacherConference =>
      'Schedule a parent-teacher conference';

  @override
  String get dashParentCounselor => 'Counselor';

  @override
  String get dashParentCounselorMeeting => 'Meet with a guidance counselor';

  @override
  String get dashParentStatusPending => 'PENDING';

  @override
  String get dashParentStatusApproved => 'APPROVED';

  @override
  String get dashParentStatusDeclined => 'DECLINED';

  @override
  String get dashParentStatusCancelled => 'CANCELLED';

  @override
  String get dashParentStatusCompleted => 'COMPLETED';

  @override
  String get dashCounselorTitle => 'Counselor Dashboard';

  @override
  String get dashCounselorMyStudents => 'My Students';

  @override
  String get dashCounselorSessions => 'Sessions';

  @override
  String get dashCounselorStudents => 'Students';

  @override
  String get dashCounselorToday => 'Today';

  @override
  String get dashCounselorMeetingRequests => 'Meeting Requests';

  @override
  String get dashCounselorManageAvailability => 'Manage Availability';

  @override
  String get dashCounselorSetMeetingHours => 'Set your meeting hours';

  @override
  String dashCounselorPendingApproval(int count) {
    return '$count pending approval';
  }

  @override
  String dashCounselorViewMoreRequests(int count) {
    return 'View $count more requests';
  }

  @override
  String get dashCounselorTodaySessions => 'Today\'s Sessions';

  @override
  String get dashCounselorNoStudents => 'No Students Assigned';

  @override
  String get dashCounselorNoStudentsHint =>
      'Your students will appear here when assigned';

  @override
  String get dashCounselorPendingRecommendations => 'Pending Recommendations';

  @override
  String dashCounselorDraftRecommendations(int count) {
    return 'You have $count draft recommendations';
  }

  @override
  String get dashCounselorSessionIndividual => 'Individual';

  @override
  String get dashCounselorSessionGroup => 'Group';

  @override
  String get dashCounselorSessionCareer => 'Career';

  @override
  String get dashCounselorSessionAcademic => 'Academic';

  @override
  String get dashCounselorSessionPersonal => 'Personal';

  @override
  String get dashCounselorStatusPending => 'PENDING';

  @override
  String get dashAdminNotAuthenticated => 'Not authenticated';

  @override
  String get dashAdminDashboard => 'Dashboard';

  @override
  String dashAdminWelcomeBack(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get dashAdminQuickAction => 'Quick Action';

  @override
  String get dashAdminAddUser => 'Add User';

  @override
  String get dashAdminCreateAnnouncement => 'Create Announcement';

  @override
  String get dashAdminGenerateReport => 'Generate Report';

  @override
  String get dashAdminBulkActions => 'Bulk Actions';

  @override
  String get dashAdminTotalUsers => 'Total Users';

  @override
  String get dashAdminStudents => 'Students';

  @override
  String get dashAdminInstitutions => 'Institutions';

  @override
  String get dashAdminRecommenders => 'Recommenders';

  @override
  String dashAdminCountStudents(int count) {
    return '$count students';
  }

  @override
  String dashAdminCountParents(int count) {
    return '$count parents';
  }

  @override
  String dashAdminCountCounselors(int count) {
    return '$count counselors';
  }

  @override
  String dashAdminCountAdmins(int count) {
    return '$count admins';
  }

  @override
  String get dashAdminJustNow => 'Just now';

  @override
  String dashAdminMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String dashAdminHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String dashAdminDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get dashAdminRefresh => 'Refresh';

  @override
  String get dashAdminQuickStats => 'Quick Stats';

  @override
  String get dashAdminActive30d => 'Active (30d)';

  @override
  String get dashAdminNewUsers7d => 'New Users (7d)';

  @override
  String get dashAdminApplications7d => 'Applications (7d)';

  @override
  String get dashAdminUserGrowth => 'User Growth';

  @override
  String get dashAdminUserGrowthDesc =>
      'New user registrations over the past 6 months';

  @override
  String get dashAdminUserDistribution => 'User Distribution';

  @override
  String get dashAdminByUserType => 'By user type';

  @override
  String get dashInstTitle => 'Institution Dashboard';

  @override
  String get dashInstDebugPanel => 'Debug Panel';

  @override
  String get dashInstApplicants => 'Applicants';

  @override
  String get dashInstPrograms => 'Programs';

  @override
  String get dashInstCourses => 'Courses';

  @override
  String get dashInstCounselors => 'Counselors';

  @override
  String get dashInstNewProgram => 'New Program';

  @override
  String get dashInstNewCourse => 'New Course';

  @override
  String get dashInstTotalApplicants => 'Total Applicants';

  @override
  String get dashInstPendingReview => 'Pending Review';

  @override
  String get dashInstActivePrograms => 'Active Programs';

  @override
  String get dashInstTotalStudents => 'Total Students';

  @override
  String get dashInstReviewPending => 'Review Pending Applications';

  @override
  String dashInstApplicationsWaiting(int count) {
    return '$count applications waiting';
  }

  @override
  String dashInstApplicationsInProgress(int count) {
    return '$count applications in progress';
  }

  @override
  String get dashInstAcceptedApplicants => 'Accepted Applicants';

  @override
  String dashInstApplicationsApproved(int count) {
    return '$count applications approved';
  }

  @override
  String get dashInstCreateNewProgram => 'Create New Program';

  @override
  String get dashInstAddProgramHint => 'Add a new course or program';

  @override
  String get dashInstApplicationSummary => 'Application Summary';

  @override
  String get dashInstProgramsOverview => 'Programs Overview';

  @override
  String get dashInstTotalPrograms => 'Total Programs';

  @override
  String get dashInstInactivePrograms => 'Inactive Programs';

  @override
  String get dashInstTotalEnrollments => 'Total Enrollments';

  @override
  String get dashInstApplicationFunnel => 'Application Funnel';

  @override
  String dashInstConversionRate(String rate) {
    return 'Overall Conversion Rate: $rate%';
  }

  @override
  String get dashInstApplicantDemographics => 'Applicant Demographics';

  @override
  String dashInstTotalApplicantsCount(int count) {
    return 'Total Applicants: $count';
  }

  @override
  String get dashInstByLocation => 'By Location';

  @override
  String get dashInstByAgeGroup => 'By Age Group';

  @override
  String get dashInstByAcademicBackground => 'By Academic Background';

  @override
  String get dashInstProgramPopularity => 'Program Popularity';

  @override
  String get dashInstTopPrograms => 'Top Programs by Applications';

  @override
  String dashInstAppsCount(int count) {
    return '$count apps';
  }

  @override
  String get dashInstProcessingTime => 'Application Processing Time';

  @override
  String get dashInstAverageTime => 'Average Time';

  @override
  String dashInstDaysValue(String count) {
    return '$count days';
  }

  @override
  String get dashRecTitle => 'Recommender Dashboard';

  @override
  String get dashRecRecommendations => 'Recommendations';

  @override
  String get dashRecTotal => 'Total';

  @override
  String get dashRecUrgent => 'Urgent';

  @override
  String get dashRecUrgentRecommendations => 'Urgent Recommendations';

  @override
  String dashRecPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'You have $count pending recommendation$_temp0';
  }

  @override
  String get dashRecUnknownStudent => 'Unknown Student';

  @override
  String get dashRecInstitutionNotSpecified => 'Institution not specified';

  @override
  String get dashRecRecentRequests => 'Recent Requests';

  @override
  String get dashRecNoRequests => 'No Recommendation Requests';

  @override
  String get dashRecNoRequestsHint =>
      'Requests will appear here when students request recommendations';

  @override
  String get dashRecQuickTips => 'Quick Tips';

  @override
  String get dashRecTip1 => 'Write specific examples of student achievements';

  @override
  String get dashRecTip2 =>
      'Submit recommendations at least 2 weeks before deadline';

  @override
  String get dashRecTip3 =>
      'Personalize each recommendation for the institution';

  @override
  String get chatViewDetails => 'View Details';

  @override
  String get chatApply => 'Apply';

  @override
  String get chatLearnMore => 'Learn More';

  @override
  String get chatEnroll => 'Enroll';

  @override
  String get chatContinue => 'Continue';

  @override
  String chatRankLabel(int rank) {
    return 'Rank: #$rank';
  }

  @override
  String chatAcceptanceLabel(String rate) {
    return 'Acceptance: $rate%';
  }

  @override
  String chatDeadlineLabel(String deadline) {
    return 'Deadline: $deadline';
  }

  @override
  String get chatRecommendedUniversities => 'Recommended Universities';

  @override
  String get chatRecommendedCourses => 'Recommended Courses';

  @override
  String get chatDetails => 'Details';

  @override
  String chatAcceptanceRateLabel(String rate) {
    return '$rate% acceptance';
  }

  @override
  String get chatHiNeedHelp => 'Hi! Need help? 👋';

  @override
  String get chatTalkToHuman => 'Talk to a Human';

  @override
  String get chatConnectWithAgent =>
      'Would you like to connect with a support agent?';

  @override
  String get chatAgentWillJoin =>
      'A member of our team will join this conversation to assist you.';

  @override
  String get chatCancel => 'Cancel';

  @override
  String get chatConnect => 'Connect';

  @override
  String get chatYourAccount => 'Your Account';

  @override
  String get chatSignIn => 'Sign In';

  @override
  String get chatSignedInAs => 'Signed in as:';

  @override
  String get chatDefaultUserName => 'User';

  @override
  String get chatConversationsSynced =>
      'Your conversations are being synced to your account.';

  @override
  String get chatSignInDescription =>
      'Sign in to sync your conversations across devices and get personalized assistance.';

  @override
  String get chatHistorySaved =>
      'Your chat history will be saved to your account.';

  @override
  String get chatClose => 'Close';

  @override
  String get chatViewProfile => 'View Profile';

  @override
  String get chatHumanSupport => 'Human Support';

  @override
  String get chatFlowAssistant => 'Flow Assistant';

  @override
  String get chatWaitingForAgent => 'Waiting for agent...';

  @override
  String get chatOnline => 'Online';

  @override
  String get chatStartConversation => 'Start a conversation';

  @override
  String get chatUserRequestedHumanSupport => 'User requested human support';

  @override
  String get chatRankStat => 'Rank';

  @override
  String get chatAcceptStat => 'Accept';

  @override
  String get chatMatchStat => 'Match';

  @override
  String chatLessonsCount(int count) {
    return '$count lessons';
  }

  @override
  String get chatProgress => 'Progress';

  @override
  String get chatToDo => 'To Do:';

  @override
  String get chatFailedToLoadImage => 'Failed to load image';

  @override
  String chatImageCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String get chatTypeYourMessage => 'Type your message...';

  @override
  String get chatSupportAgent => 'Support Agent';

  @override
  String get chatSystem => 'System';

  @override
  String get chatConfidenceHigh => 'High';

  @override
  String get chatConfidenceMedium => 'Medium';

  @override
  String get chatConfidenceLow => 'Low';

  @override
  String get chatHelpful => 'Helpful';

  @override
  String get chatNotHelpful => 'Not helpful';

  @override
  String get chatWasThisHelpful => 'Was this helpful?';

  @override
  String get chatRateThisResponse => 'Rate this response';

  @override
  String get chatCopied => 'Copied!';

  @override
  String get chatCopy => 'Copy';

  @override
  String get chatViewRecommendations => 'View Recommendations';

  @override
  String get chatUpdateProfile => 'Update Profile';

  @override
  String get chatMyApplications => 'My Applications';

  @override
  String get chatCompareSchools => 'Compare Schools';

  @override
  String get chatFilterResults => 'Filter Results';

  @override
  String get chatWhyTheseSchools => 'Why These Schools?';

  @override
  String get chatViewDeadlines => 'View Deadlines';

  @override
  String get chatEssayTips => 'Essay Tips';

  @override
  String get chatApplicationChecklist => 'Application Checklist';

  @override
  String get chatHelpWithQuestions => 'Help with Questions';

  @override
  String get chatCanISkipSections => 'Can I Skip Sections?';

  @override
  String get chatStartApplication => 'Start Application';

  @override
  String get chatSaveToFavorites => 'Save to Favorites';

  @override
  String get chatSimilarSchools => 'Similar Schools';

  @override
  String get chatEssayWritingHelp => 'Essay Writing Help';

  @override
  String get chatSetDeadlineReminder => 'Set Deadline Reminder';

  @override
  String get chatLetterRequestTips => 'Letter Request Tips';

  @override
  String get chatTranscriptGuide => 'Transcript Guide';

  @override
  String get chatStartQuestionnaire => 'Start Questionnaire';

  @override
  String get chatHowItWorks => 'How It Works';

  @override
  String get chatBrowseUniversities => 'Browse Universities';

  @override
  String get chatHowCanYouHelp => 'How can you help?';

  @override
  String get chatGetRecommendations => 'Get Recommendations';

  @override
  String get chatContactSupport => 'Contact Support';

  @override
  String chatCompleteProfile(int completeness) {
    return 'Complete Profile ($completeness%)';
  }

  @override
  String get chatWhyCompleteProfile => 'Why Complete Profile?';

  @override
  String chatViewSchools(int count) {
    return 'View $count Schools';
  }

  @override
  String chatMyFavorites(int count) {
    return 'My Favorites ($count)';
  }

  @override
  String get chatStartApplying => 'Start Applying';

  @override
  String get fypTitle => 'Find Your Path';

  @override
  String get fypHeroTitle => 'Find Your Perfect University';

  @override
  String get fypHeroSubtitle =>
      'Get personalized university recommendations based on your academic profile, preferences, and goals';

  @override
  String get fypHowItWorks => 'How It Works';

  @override
  String get fypStep1Title => 'Answer Questions';

  @override
  String get fypStep1Description =>
      'Tell us about your academic profile, intended major, and preferences';

  @override
  String get fypStep2Title => 'Get Matched';

  @override
  String get fypStep2Description =>
      'Our algorithm analyzes your profile against hundreds of universities';

  @override
  String get fypStep3Title => 'Review Results';

  @override
  String get fypStep3Description =>
      'See your personalized recommendations ranked as safety, match, and reach schools';

  @override
  String get fypWhatYoullGet => 'What You\'ll Get';

  @override
  String get fypFeatureMatchScore => 'Match Score';

  @override
  String get fypFeatureSafetyMatchReach => 'Safety/Match/Reach';

  @override
  String get fypFeatureCostAnalysis => 'Cost Analysis';

  @override
  String get fypFeatureDetailedInsights => 'Detailed Insights';

  @override
  String get fypFeatureSaveFavorites => 'Save Favorites';

  @override
  String get fypFeatureCompareOptions => 'Compare Options';

  @override
  String get fypGetStarted => 'Get Started';

  @override
  String get fypViewMyRecommendations => 'View My Recommendations';

  @override
  String get fypDisclaimer =>
      'Recommendations are based on your profile and preferences. Always do thorough research on universities and consult with guidance counselors before making final decisions.';

  @override
  String get fypQuestionnaireTitle => 'University Questionnaire';

  @override
  String fypStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get fypStepBackgroundInfo => 'Background Information';

  @override
  String get fypStepAcademicAchievements => 'Academic Achievements';

  @override
  String get fypStepAcademicInterests => 'Academic Interests';

  @override
  String get fypStepLocationPreferences => 'Location Preferences';

  @override
  String get fypStepUniversityPreferences => 'University Preferences';

  @override
  String get fypStepFinancialInfo => 'Financial Information';

  @override
  String get fypTellUsAboutYourself => 'Tell us about yourself';

  @override
  String get fypBackgroundHelper =>
      'This helps us understand your educational background';

  @override
  String get fypNationalityLabel => 'Nationality *';

  @override
  String get fypNationalityHelper => 'Your country of citizenship';

  @override
  String get fypSelectNationality => 'Please select your nationality';

  @override
  String get fypCurrentStudyingLabel => 'Where are you currently studying? *';

  @override
  String get fypCurrentStudyingHelper =>
      'Your current location (not where you want to study)';

  @override
  String get fypSelectCurrentCountry => 'Please select your current country';

  @override
  String get fypCurrentRegionLabel => 'Current Region/State (Optional)';

  @override
  String get fypSelectRegionHelper => 'Select your region if available';

  @override
  String get fypYourAcademicAchievements => 'Your academic achievements';

  @override
  String get fypAcademicMatchHelper =>
      'This helps us match you with universities where you\'ll be competitive';

  @override
  String get fypGradingSystemLabel => 'Your Grading System *';

  @override
  String get fypSelectGradingSystem => 'Please select your grading system';

  @override
  String get fypYourGradeLabel => 'Your Grade *';

  @override
  String get fypEnterGrade => 'Please enter your grade';

  @override
  String get fypStandardizedTestLabel => 'Standardized Test (if applicable)';

  @override
  String get fypStandardizedTestHelper =>
      'Leave blank if you haven\'t taken any';

  @override
  String get fypSatTotalScoreLabel => 'SAT Total Score';

  @override
  String get fypSatScoreHint => 'e.g. 1400';

  @override
  String get fypSatValidation => 'SAT must be between 400-1600';

  @override
  String get fypActCompositeLabel => 'ACT Composite Score';

  @override
  String get fypActScoreHint => 'e.g. 28';

  @override
  String get fypActValidation => 'ACT must be between 1-36';

  @override
  String get fypIbScoreLabel => 'IB Predicted/Final Score';

  @override
  String get fypIbScoreHint => 'e.g. 38';

  @override
  String get fypIbValidation => 'IB score must be between 0-45';

  @override
  String get fypTestScoresOptional =>
      'Standardized test scores are optional. If you haven\'t taken these tests yet, you can skip this section.';

  @override
  String get fypWhatStudy => 'What do you want to study?';

  @override
  String get fypInterestsHelper =>
      'Tell us about your academic interests and career goals';

  @override
  String get fypIntendedMajorLabel => 'Intended Major *';

  @override
  String get fypIntendedMajorHint => 'Select your intended major';

  @override
  String get fypSelectIntendedMajor => 'Please select your intended major';

  @override
  String get fypFieldOfStudyLabel => 'Field of Study *';

  @override
  String get fypSelectFieldOfStudy => 'Please select a field of study';

  @override
  String get fypCareerFocused => 'I am career-focused';

  @override
  String get fypCareerFocusedSubtitle =>
      'I want to find universities with strong job placement and career services';

  @override
  String get fypResearchInterest => 'Interested in research opportunities';

  @override
  String get fypResearchInterestSubtitle =>
      'I want to participate in research projects during my studies';

  @override
  String get fypWhereStudy => 'Where do you want to study?';

  @override
  String get fypLocationHelper => 'Select your preferred countries and regions';

  @override
  String get fypWhereStudyRequired => 'Where do you want to study? *';

  @override
  String get fypSelectCountriesHelper =>
      'Select the countries where you\'d like to attend university (can be different from your current location)';

  @override
  String get fypCampusSetting => 'Campus Setting';

  @override
  String get fypUniversityCharacteristics => 'University characteristics';

  @override
  String get fypUniversityEnvironmentHelper =>
      'What type of university environment do you prefer?';

  @override
  String get fypPreferredSizeLabel => 'Preferred University Size';

  @override
  String get fypPreferredTypeLabel => 'Preferred University Type';

  @override
  String get fypSportsInterest => 'Interested in athletics/sports';

  @override
  String get fypSportsInterestSubtitle =>
      'I want to participate in or attend university sports';

  @override
  String get fypDesiredFeatures => 'Desired Campus Features (optional)';

  @override
  String get fypFinancialConsiderations => 'Financial Considerations';

  @override
  String get fypFinancialHelper =>
      'Help us recommend universities within your budget';

  @override
  String get fypBudgetRangeLabel => 'Annual Budget Range (USD)';

  @override
  String get fypBudgetRangeHelper => 'Approximate annual tuition budget';

  @override
  String get fypNeedFinancialAid => 'I will need financial aid';

  @override
  String get fypFinancialAidSubtitle =>
      'We\'ll prioritize universities with strong financial aid programs';

  @override
  String get fypInStateTuitionLabel => 'Eligible for In-State Tuition? (US)';

  @override
  String get fypNotApplicable => 'Not Applicable';

  @override
  String get fypBack => 'Back';

  @override
  String get fypNext => 'Next';

  @override
  String get fypGetRecommendations => 'Get Recommendations';

  @override
  String fypErrorSavingProfile(String error) {
    return 'Error saving profile: $error';
  }

  @override
  String fypErrorGeneratingRecs(String error) {
    return 'Error generating recommendations: $error';
  }

  @override
  String get fypRetry => 'Retry';

  @override
  String get fypSignUpToSave => 'Sign up to save your recommendations!';

  @override
  String get fypSignUp => 'Sign Up';

  @override
  String fypUnexpectedError(String error) {
    return 'Unexpected error: $error';
  }

  @override
  String get fypGeneratingRecommendations => 'Generating Recommendations';

  @override
  String get fypGeneratingPleaseWait =>
      'Please wait while we analyze universities\nand create personalized matches for you...';

  @override
  String get fypYourRecommendations => 'Your Recommendations';

  @override
  String get fypRefresh => 'Refresh';

  @override
  String get fypErrorLoadingRecs => 'Error loading recommendations';

  @override
  String get fypTryAgain => 'Try Again';

  @override
  String get fypNoRecsYet => 'No recommendations yet';

  @override
  String get fypCompleteQuestionnaire =>
      'Complete the questionnaire to get personalized recommendations';

  @override
  String get fypStartQuestionnaire => 'Start Questionnaire';

  @override
  String get fypFoundPerfectMatches => 'We found your perfect matches!';

  @override
  String get fypStatTotal => 'Total';

  @override
  String get fypStatSafety => 'Safety';

  @override
  String get fypStatMatch => 'Match';

  @override
  String get fypStatReach => 'Reach';

  @override
  String fypFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String fypFilterSafety(int count) {
    return 'Safety ($count)';
  }

  @override
  String fypFilterMatch(int count) {
    return 'Match ($count)';
  }

  @override
  String fypFilterReach(int count) {
    return 'Reach ($count)';
  }

  @override
  String get fypNoFilterMatch => 'No universities match the selected filter';

  @override
  String fypPercentMatch(String score) {
    return '$score% Match';
  }

  @override
  String get fypLoadingDetails => 'Loading university details...';

  @override
  String get fypLocationNotAvailable => 'Location not available';

  @override
  String get fypStatAcceptance => 'Acceptance';

  @override
  String get fypStatTuition => 'Tuition';

  @override
  String get fypStatStudents => 'Students';

  @override
  String get fypStatRank => 'Rank';

  @override
  String get fypWhyGoodMatch => 'Why it\'s a good match:';

  @override
  String get fypViewDetails => 'View Details';

  @override
  String get fypUniversityDetails => 'University Details';

  @override
  String get fypVisitWebsite => 'Visit Website';

  @override
  String get fypUniversityNotFound => 'University not found';

  @override
  String get fypErrorLoadingUniversity => 'Error loading university';

  @override
  String get fypUnknownError => 'Unknown error';

  @override
  String fypKStudents(String count) {
    return '${count}k Students';
  }

  @override
  String get fypNationalRank => 'National Rank';

  @override
  String get fypAcceptanceRate => 'Acceptance Rate';

  @override
  String get fypAbout => 'About';

  @override
  String get fypAdmissions => 'Admissions';

  @override
  String get fypCostsFinancialAid => 'Costs & Financial Aid';

  @override
  String get fypStudentOutcomes => 'Student Outcomes';

  @override
  String get fypProgramsOffered => 'Programs Offered';

  @override
  String get fypAverageGPA => 'Average GPA';

  @override
  String get fypSatMathRange => 'SAT Math Range';

  @override
  String get fypSatEbrwRange => 'SAT EBRW Range';

  @override
  String get fypActRange => 'ACT Range';

  @override
  String get fypOutOfStateTuition => 'Out-of-State Tuition';

  @override
  String get fypTotalCostEst => 'Total Cost (est.)';

  @override
  String get fypFinancialAidNote =>
      'Financial aid may be available. Contact the university for details.';

  @override
  String get fypGraduationRate => '4-Year Graduation Rate';

  @override
  String get fypMedianEarnings => 'Median Earnings (10 years)';

  @override
  String get appListTitle => 'My Applications';

  @override
  String appTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String appTabPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String appTabUnderReview(int count) {
    return 'Under Review ($count)';
  }

  @override
  String appTabAccepted(int count) {
    return 'Accepted ($count)';
  }

  @override
  String get appLoadingMessage => 'Loading applications...';

  @override
  String get appRetry => 'Retry';

  @override
  String get appNewApplication => 'New Application';

  @override
  String get appEmptyTitle => 'No Applications';

  @override
  String get appEmptyMessage => 'You haven\'t submitted any applications yet.';

  @override
  String get appCreateApplication => 'Create Application';

  @override
  String get appToday => 'Today';

  @override
  String get appYesterday => 'Yesterday';

  @override
  String appDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get appFeePaid => 'Fee Paid';

  @override
  String get appPaymentPending => 'Payment Pending';

  @override
  String appReviewedDaysAgo(int days) {
    return 'Reviewed $days days ago';
  }

  @override
  String get appDetailTitle => 'Application Details';

  @override
  String get appDetailShare => 'Share';

  @override
  String get appDetailStatus => 'Application Status';

  @override
  String get appStatusPendingReview => 'Pending Review';

  @override
  String get appStatusUnderReview => 'Under Review';

  @override
  String get appStatusAccepted => 'Accepted';

  @override
  String get appStatusRejected => 'Rejected';

  @override
  String get appStatusUnknown => 'Unknown';

  @override
  String get appDetailInfo => 'Application Information';

  @override
  String get appDetailInstitution => 'Institution';

  @override
  String get appDetailProgram => 'Program';

  @override
  String get appDetailSubmitted => 'Submitted';

  @override
  String get appDetailReviewed => 'Reviewed';

  @override
  String get appDetailPaymentInfo => 'Payment Information';

  @override
  String get appDetailApplicationFee => 'Application Fee';

  @override
  String get appDetailPaymentStatus => 'Payment Status';

  @override
  String get appDetailPaid => 'Paid';

  @override
  String get appDetailPendingPayment => 'Pending';

  @override
  String get appDetailPayFee => 'Pay Application Fee';

  @override
  String get appPaymentDialogTitle => 'Payment';

  @override
  String appPaymentDialogContent(String fee) {
    return 'Pay application fee of \$$fee?';
  }

  @override
  String get appCancel => 'Cancel';

  @override
  String get appPayNow => 'Pay Now';

  @override
  String get appPaymentSuccess => 'Payment successful!';

  @override
  String get appPaymentFailed => 'Payment failed. Please try again.';

  @override
  String appErrorPayment(String error) {
    return 'Error processing payment: $error';
  }

  @override
  String get appDetailReviewNotes => 'Review Notes';

  @override
  String get appDetailDocuments => 'Documents';

  @override
  String get appDetailTranscript => 'Transcript';

  @override
  String get appDetailUploaded => 'Uploaded';

  @override
  String get appDetailIdDocument => 'ID Document';

  @override
  String get appDetailPersonalStatement => 'Personal Statement';

  @override
  String get appDetailWithdraw => 'Withdraw';

  @override
  String get appDetailEdit => 'Edit';

  @override
  String get appWithdrawTitle => 'Withdraw Application';

  @override
  String get appWithdrawConfirmation =>
      'Are you sure you want to withdraw this application? This action cannot be undone.';

  @override
  String get appWithdrawSuccess => 'Application withdrawn successfully';

  @override
  String get appWithdrawFailed => 'Failed to withdraw application';

  @override
  String appErrorWithdraw(String error) {
    return 'Error withdrawing application: $error';
  }

  @override
  String get appCreateTitle => 'New Application';

  @override
  String get appStepProgramSelection => 'Program Selection';

  @override
  String get appSelectUniversity => 'Select University';

  @override
  String get appBrowseInstitutions => 'Browse Institutions';

  @override
  String get appNoProgramsYet =>
      'This institution has no active programs yet. Please select another institution.';

  @override
  String get appSelectProgramLabel => 'Select a Program *';

  @override
  String appProgramsAvailable(int count) {
    return '$count programs available';
  }

  @override
  String get appStepPersonalInfo => 'Personal Information';

  @override
  String get appFullNameLabel => 'Full Name';

  @override
  String get appEmailLabel => 'Email Address';

  @override
  String get appPhoneLabel => 'Phone Number';

  @override
  String get appStreetAddressLabel => 'Street Address *';

  @override
  String get appCityLabel => 'City/Town *';

  @override
  String get appCountryLabel => 'Country *';

  @override
  String get appStateLabel => 'State/Province *';

  @override
  String get appSelectCountryFirst => 'Select a country first';

  @override
  String get appStepAcademicInfo => 'Academic Information';

  @override
  String get appPreviousSchoolLabel => 'Previous School/Institution';

  @override
  String get appGpaLabel => 'GPA / Grade Average';

  @override
  String get appPersonalStatementLabel => 'Personal Statement';

  @override
  String get appPersonalStatementHint =>
      'Why are you interested in this program?';

  @override
  String get appStepDocuments => 'Documents (Required)';

  @override
  String get appUploadRequiredDocs => 'Upload Required Documents';

  @override
  String get appDocTranscriptTitle => 'Academic Transcript';

  @override
  String get appDocTranscriptSubtitle =>
      'Official transcript from your previous school (PDF, DOC, or DOCX format, max 5MB)';

  @override
  String get appDocIdTitle => 'ID Document';

  @override
  String get appDocIdSubtitle =>
      'Valid government-issued ID: passport, national ID card, or driver\'s license (PDF, JPG, or PNG)';

  @override
  String get appDocPhotoTitle => 'Passport Photo';

  @override
  String get appDocPhotoSubtitle =>
      'Recent passport-sized photo with a plain background (JPG or PNG format)';

  @override
  String get appDocRequiredWarning =>
      'All three documents are required. Please upload the transcript, ID document, and passport photo before submitting.';

  @override
  String get appSubmit => 'Submit';

  @override
  String get appContinue => 'Continue';

  @override
  String get appBack => 'Back';

  @override
  String get courseListTitle => 'Courses';

  @override
  String get courseFiltersTooltip => 'Filters';

  @override
  String get courseBrowseAll => 'Browse All';

  @override
  String get courseAssignedToMe => 'Assigned to Me';

  @override
  String get courseSearchHint => 'Search courses...';

  @override
  String get courseNoAvailable => 'No courses available';

  @override
  String get courseCheckBackLater => 'Check back later for new courses';

  @override
  String get courseRetry => 'Retry';

  @override
  String get courseFailedLoadAssigned => 'Failed to load assigned courses';

  @override
  String get courseNoAssignedYet => 'No courses assigned yet';

  @override
  String get courseAssignedDescription =>
      'Courses assigned by your admin or institution will appear here.';

  @override
  String get courseRequired => 'Required';

  @override
  String courseLessonsLabel(int count) {
    return '$count lessons';
  }

  @override
  String coursePercentComplete(int percent) {
    return '$percent% complete';
  }

  @override
  String get courseNoRatingsYet => 'No ratings yet';

  @override
  String courseEnrolledCount(int count) {
    return '$count enrolled';
  }

  @override
  String get courseFiltersTitle => 'Filters';

  @override
  String get courseLevelLabel => 'Level';

  @override
  String get courseAllLevels => 'All Levels';

  @override
  String get courseLevelBeginner => 'Beginner';

  @override
  String get courseLevelIntermediate => 'Intermediate';

  @override
  String get courseLevelAdvanced => 'Advanced';

  @override
  String get courseLevelExpert => 'Expert';

  @override
  String get courseClearAll => 'Clear All';

  @override
  String get courseApplyFilters => 'Apply';

  @override
  String get courseDescription => 'Description';

  @override
  String get courseWhatYoullLearn => 'What You\'ll Learn';

  @override
  String get coursePrerequisites => 'Prerequisites';

  @override
  String get coursePrice => 'Price';

  @override
  String get courseCourseFull => 'Course Full';

  @override
  String get courseRequestPermission => 'Request Permission';

  @override
  String get coursePermissionPending => 'Permission Pending';

  @override
  String get coursePermissionDenied => 'Permission Denied';

  @override
  String get courseRequestPermissionAgain => 'Request Permission Again';

  @override
  String get courseEnrollNow => 'Enroll Now';

  @override
  String get courseRequestEnrollmentTitle => 'Request Enrollment Permission';

  @override
  String courseRequestEnrollmentContent(String title) {
    return 'Request permission to enroll in \"$title\"?';
  }

  @override
  String get courseInstitutionReview =>
      'The institution will review your request.';

  @override
  String get courseMessageToInstitution => 'Message to institution (optional)';

  @override
  String get courseMessageHint => 'Why do you want to take this course?';

  @override
  String get courseCancel => 'Cancel';

  @override
  String get courseRequest => 'Request';

  @override
  String get coursePermissionRequestSent => 'Permission request sent!';

  @override
  String courseFailedRequestPermission(String error) {
    return 'Failed to request permission: $error';
  }

  @override
  String get courseEnrolledSuccess => 'Successfully enrolled in course!';

  @override
  String get courseFailedEnroll => 'Failed to enroll';

  @override
  String courseContinueLearning(String progress) {
    return 'Continue Learning ($progress%)';
  }

  @override
  String get courseStartLearning => 'Start Learning';

  @override
  String courseLessonsCompleted(int completed, int total) {
    return '$completed/$total lessons completed';
  }

  @override
  String get courseCollapseSidebar => 'Collapse sidebar';

  @override
  String get courseExpandSidebar => 'Expand sidebar';

  @override
  String courseErrorLoadingModules(String error) {
    return 'Error loading modules:\n$error';
  }

  @override
  String get courseNoContentYet => 'No content available yet';

  @override
  String get courseNoLessonsAdded => 'The instructor hasn\'t added any lessons';

  @override
  String courseLessonsCount(int completed, int total) {
    return '$completed/$total lessons';
  }

  @override
  String courseWelcomeTo(String title) {
    return 'Welcome to $title';
  }

  @override
  String get courseCompleted => 'Completed';

  @override
  String get coursePrevious => 'Previous';

  @override
  String get courseMarkAsComplete => 'Mark as Complete';

  @override
  String get courseNext => 'Next';

  @override
  String get courseMyCourses => 'My Courses';

  @override
  String get courseFilterByStatus => 'Filter by status';

  @override
  String courseTabAssigned(int count) {
    return 'Assigned ($count)';
  }

  @override
  String courseTabEnrolled(int count) {
    return 'Enrolled ($count)';
  }

  @override
  String get courseNoAssigned => 'No assigned courses';

  @override
  String get courseAssignedByInstitution =>
      'Courses assigned to you by your institution will appear here';

  @override
  String get courseREQUIRED => 'REQUIRED';

  @override
  String get courseProgress => 'Progress';

  @override
  String courseDuePrefix(String date) {
    return 'Due: $date';
  }

  @override
  String get courseStatusCompleted => 'Completed';

  @override
  String get courseStatusInProgress => 'In Progress';

  @override
  String get courseStatusOverdue => 'Overdue';

  @override
  String get courseStatusAssigned => 'Assigned';

  @override
  String get courseDueToday => 'Today';

  @override
  String get courseDueTomorrow => 'Tomorrow';

  @override
  String courseDueDays(int days) {
    return '$days days';
  }

  @override
  String get courseNoEnrolled => 'No enrolled courses';

  @override
  String get courseBrowseToStart => 'Browse courses to get started';

  @override
  String get courseBrowseCourses => 'Browse Courses';

  @override
  String get courseFilterAll => 'All';

  @override
  String get courseStatusActive => 'Active';

  @override
  String get courseStatusDropped => 'Dropped';

  @override
  String get courseStatusSuspended => 'Suspended';

  @override
  String get homeNewFeature => 'NEW FEATURE';

  @override
  String get homeFindYourPathTitle => 'Find Your Path';

  @override
  String get homeFindYourPathDesc =>
      'Discover universities that match your goals, budget, and aspirations.\nLet our intelligent recommendation system guide you to the perfect fit.';

  @override
  String get homePersonalizedRecs => 'Personalized Recommendations';

  @override
  String get homeTopUniversities => '12+ Top Universities';

  @override
  String get homeSmartMatching => 'Smart Matching Algorithm';

  @override
  String get homeStartYourJourney => 'Start Your Journey';

  @override
  String get homeNoAccountRequired =>
      'No account required - get started instantly';

  @override
  String get homeSearchUniversitiesDesc =>
      'Explore 18,000+ universities from around the world.\nFilter by country, tuition, acceptance rate, and more.';

  @override
  String get homeFilters => 'Filters';

  @override
  String get homeBrowseUniversities => 'Browse Universities';

  @override
  String get helpBack => 'Back';

  @override
  String get helpContactSupport => 'Contact Support';

  @override
  String get helpWeAreHereToHelp => 'We\'re here to help!';

  @override
  String get helpSupportResponseTime =>
      'Our support team typically responds within 24 hours';

  @override
  String get helpSubject => 'Subject';

  @override
  String get helpSubjectHint => 'Brief description of your issue';

  @override
  String get helpSubjectRequired => 'Please enter a subject';

  @override
  String get helpSubjectMinLength => 'Subject must be at least 5 characters';

  @override
  String get helpCategory => 'Category';

  @override
  String get helpCategoryGeneral => 'General Inquiry';

  @override
  String get helpCategoryTechnical => 'Technical Issue';

  @override
  String get helpCategoryBilling => 'Billing & Payments';

  @override
  String get helpCategoryAccount => 'Account Management';

  @override
  String get helpCategoryCourse => 'Course Content';

  @override
  String get helpCategoryOther => 'Other';

  @override
  String get helpPriority => 'Priority';

  @override
  String get helpPriorityLow => 'Low';

  @override
  String get helpPriorityMedium => 'Medium';

  @override
  String get helpPriorityHigh => 'High';

  @override
  String get helpPriorityUrgent => 'Urgent';

  @override
  String get helpDescription => 'Description';

  @override
  String get helpDescriptionHint =>
      'Please provide detailed information about your issue...';

  @override
  String get helpDescriptionRequired => 'Please describe your issue';

  @override
  String get helpDescriptionMinLength =>
      'Description must be at least 20 characters';

  @override
  String get helpAttachments => 'Attachments';

  @override
  String get helpNoFilesAttached => 'No files attached';

  @override
  String get helpAddAttachment => 'Add Attachment';

  @override
  String get helpAttachmentTypes => 'Images, PDFs, documents (max 10MB each)';

  @override
  String get helpPreferredContactMethod => 'Preferred Contact Method';

  @override
  String get helpEmail => 'Email';

  @override
  String get helpRespondViaEmail => 'We\'ll respond via email';

  @override
  String get helpPhone => 'Phone';

  @override
  String get helpCallYouBack => 'We\'ll call you back';

  @override
  String get helpSubmitting => 'Submitting...';

  @override
  String get helpSubmitRequest => 'Submit Request';

  @override
  String get helpOtherWaysToReachUs => 'Other Ways to Reach Us';

  @override
  String get helpEmailCopied => 'Email copied to clipboard';

  @override
  String get helpPhoneCopied => 'Phone number copied to clipboard';

  @override
  String get helpBusinessHours => 'Business Hours';

  @override
  String get helpBusinessHoursDetails =>
      'Monday - Friday\n9:00 AM - 6:00 PM EST';

  @override
  String get helpAverageResponseTime => 'Average Response Time';

  @override
  String get helpTypicallyRespond24h => 'We typically respond within 24 hours';

  @override
  String get helpRequestSubmitted => 'Request Submitted';

  @override
  String get helpRequestSubmittedSuccess =>
      'Your support request has been submitted successfully!';

  @override
  String get helpTrackRequestInfo =>
      'We\'ll respond to your email within 24 hours. You can track your request in the Support Tickets section.';

  @override
  String get helpOk => 'OK';

  @override
  String get helpViewTicketInSupport => 'View your ticket in Support Tickets';

  @override
  String get helpViewTickets => 'View Tickets';

  @override
  String get helpFaqTitle => 'Frequently Asked Questions';

  @override
  String get helpFaqAll => 'All';

  @override
  String get helpFaqGettingStarted => 'Getting Started';

  @override
  String get helpFaqAccount => 'Account';

  @override
  String get helpFaqCourses => 'Courses';

  @override
  String get helpFaqPayments => 'Payments';

  @override
  String get helpFaqTechnical => 'Technical';

  @override
  String get helpSearchFaqs => 'Search FAQs...';

  @override
  String get helpNoFaqsFound => 'No FAQs found';

  @override
  String get helpTryDifferentSearch => 'Try a different search term';

  @override
  String get helpThanksForFeedback => 'Thanks for your feedback!';

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get helpHowCanWeHelp => 'How can we help you?';

  @override
  String get helpSearchOrBrowse => 'Search for answers or browse help topics';

  @override
  String get helpSearchForHelp => 'Search for help...';

  @override
  String get helpQuickHelp => 'Quick Help';

  @override
  String get helpBrowseFaqs => 'Browse FAQs';

  @override
  String get helpBrowseFaqsDesc => 'Quick answers to common questions';

  @override
  String get helpContactSupportDesc => 'Get help from our support team';

  @override
  String get helpMySupportTickets => 'My Support Tickets';

  @override
  String get helpMySupportTicketsDesc => 'View your open and closed tickets';

  @override
  String get helpBrowseByTopic => 'Browse by Topic';

  @override
  String get helpViewAll => 'View All';

  @override
  String get helpPopularArticles => 'Popular Articles';

  @override
  String get helpRemovedFromBookmarks => 'Removed from bookmarks';

  @override
  String get helpAddedToBookmarks => 'Added to bookmarks';

  @override
  String get helpStillNeedHelp => 'Still need help?';

  @override
  String get helpSupportTeamHere => 'Our support team is here to help you';

  @override
  String get helpWasArticleHelpful => 'Was this article helpful?';

  @override
  String get helpYes => 'Yes';

  @override
  String get helpNo => 'No';

  @override
  String get helpThanksWeWillImprove => 'Thanks! We\'ll improve this article.';

  @override
  String get helpSupportTickets => 'Support Tickets';

  @override
  String get helpTicketActive => 'Active';

  @override
  String get helpTicketWaiting => 'Waiting';

  @override
  String get helpTicketResolved => 'Resolved';

  @override
  String get helpNewTicket => 'New Ticket';

  @override
  String get helpNoTickets => 'No tickets';

  @override
  String get helpCreateTicketToGetSupport => 'Create a ticket to get support';

  @override
  String get helpTypeYourMessage => 'Type your message...';

  @override
  String get helpMessageSent => 'Message sent!';

  @override
  String get helpCreateSupportTicket => 'Create Support Ticket';

  @override
  String get helpDescribeIssueDetail => 'Describe your issue in detail...';

  @override
  String get helpCancel => 'Cancel';

  @override
  String get helpSubmit => 'Submit';

  @override
  String get helpTicketCreatedSuccess => 'Support ticket created successfully!';

  @override
  String get cookiePreferencesSaved => 'Cookie preferences saved';

  @override
  String get cookieEssentialOnly => 'Essential Only';

  @override
  String get cookieWeUseCookies => 'We use cookies';

  @override
  String get cookieBannerDescription =>
      'We use cookies to enhance your experience, analyze site usage, and provide personalized content. By clicking \"Accept All\", you consent to our use of cookies.';

  @override
  String get cookieAcceptAll => 'Accept All';

  @override
  String get cookieCustomize => 'Customize';

  @override
  String get cookiePrivacyPolicy => 'Privacy Policy';

  @override
  String get cookiePreferencesTitle => 'Cookie Preferences';

  @override
  String get cookieCustomizeDescription =>
      'Customize your cookie preferences. Essential cookies are always enabled.';

  @override
  String get cookiePreferencesSavedSuccess =>
      'Cookie preferences saved successfully';

  @override
  String get cookieFailedToSave =>
      'Failed to save preferences. Please try again.';

  @override
  String get cookieRejectAll => 'Reject All';

  @override
  String get cookieSavePreferences => 'Save Preferences';

  @override
  String get cookieAlwaysActive => 'Always Active';

  @override
  String get cookieSettingsTitle => 'Cookie Settings';

  @override
  String get cookieNoConsentData => 'No consent data available';

  @override
  String get cookieSetPreferences => 'Set Preferences';

  @override
  String get cookieConsentActive => 'Consent Active';

  @override
  String get cookieNoConsentGiven => 'No Consent Given';

  @override
  String get cookieCurrentPreferences => 'Current Preferences';

  @override
  String get cookieChangePreferences => 'Change Preferences';

  @override
  String get cookieExportMyData => 'Export My Data';

  @override
  String get cookieDeleteMyData => 'Delete My Data';

  @override
  String get cookieAboutCookies => 'About Cookies';

  @override
  String get cookieAboutDescription =>
      'Cookies help us provide you with a better experience. You can change your preferences at any time. Essential cookies are always active for security and functionality.';

  @override
  String get cookieReadPrivacyPolicy => 'Read Privacy Policy';

  @override
  String get cookieExportData => 'Export Data';

  @override
  String get cookieExportDataDescription =>
      'This will create a file with all your cookie and consent data. The file will be saved to your downloads folder.';

  @override
  String get cookieCancel => 'Cancel';

  @override
  String get cookieExport => 'Export';

  @override
  String get cookieDeleteData => 'Delete Data';

  @override
  String get cookieDeleteDataDescription =>
      'This will permanently delete all your cookie data. Essential cookies required for the app to function will remain. This action cannot be undone.';

  @override
  String get cookieDelete => 'Delete';

  @override
  String get cookieDataDeletedSuccess => 'Data deleted successfully';

  @override
  String get careerCounselingTitle => 'Career Counseling';

  @override
  String get careerFindCounselor => 'Find Counselor';

  @override
  String get careerUpcoming => 'Upcoming';

  @override
  String get careerPastSessions => 'Past Sessions';

  @override
  String get careerSearchCounselors =>
      'Search by name, specialization, or expertise...';

  @override
  String get careerAvailableNow => 'Available Now';

  @override
  String get careerHighestRated => 'Highest Rated';

  @override
  String get careerMostExperienced => 'Most Experienced';

  @override
  String get careerNoCounselorsFound => 'No counselors found';

  @override
  String get careerTryAdjustingSearch => 'Try adjusting your search';

  @override
  String get careerReschedule => 'Reschedule';

  @override
  String get careerJoinSession => 'Join Session';

  @override
  String get careerNoPastSessions => 'No past sessions';

  @override
  String get careerCompletedSessionsAppearHere =>
      'Your completed sessions will appear here';

  @override
  String get careerAbout => 'About';

  @override
  String get careerAreasOfExpertise => 'Areas of Expertise';

  @override
  String get careerBookSession => 'Book Session';

  @override
  String get careerCurrentlyUnavailable => 'Currently Unavailable';

  @override
  String get careerBookCounselingSession => 'Book Counseling Session';

  @override
  String get careerSessionType => 'Session Type';

  @override
  String get careerPreferredDate => 'Preferred Date';

  @override
  String get careerSelectDate => 'Select Date';

  @override
  String get careerSessionNotesOptional => 'Session Notes (Optional)';

  @override
  String get careerWhatToDiscuss => 'What would you like to discuss?';

  @override
  String get careerCancel => 'Cancel';

  @override
  String get careerConfirmBooking => 'Confirm Booking';

  @override
  String get careerSessionBookedSuccess => 'Session booked successfully!';

  @override
  String get careerResourcesTitle => 'Career Resources';

  @override
  String get careerAll => 'All';

  @override
  String get careerArticles => 'Articles';

  @override
  String get careerVideos => 'Videos';

  @override
  String get careerCourses => 'Courses';

  @override
  String get careerSearchResources => 'Search resources...';

  @override
  String get careerRemovedFromBookmarks => 'Removed from bookmarks';

  @override
  String get careerAddedToBookmarks => 'Added to bookmarks';

  @override
  String get careerCategories => 'Categories';

  @override
  String get careerNoResourcesFound => 'No resources found';

  @override
  String get careerWhatYoullLearn => 'What You\'ll Learn';

  @override
  String get careerSaved => 'Saved';

  @override
  String get careerSave => 'Save';

  @override
  String get careerOpeningResource => 'Opening resource...';

  @override
  String get careerStartLearning => 'Start Learning';

  @override
  String get careerBrowseCategories => 'Browse Categories';

  @override
  String get jobDetailsTitle => 'Job Details';

  @override
  String get jobSavedSuccessfully => 'Job saved successfully';

  @override
  String get jobRemovedFromSaved => 'Job removed from saved';

  @override
  String get jobShareComingSoon => 'Share functionality coming soon';

  @override
  String get jobApplyNow => 'Apply Now';

  @override
  String get jobSalaryRange => 'Salary Range';

  @override
  String get jobLocation => 'Location';

  @override
  String get jobApplicationDeadline => 'Application Deadline';

  @override
  String get jobDescription => 'Job Description';

  @override
  String get jobRequirements => 'Requirements';

  @override
  String get jobResponsibilities => 'Responsibilities';

  @override
  String get jobBenefits => 'Benefits';

  @override
  String get jobRequiredSkills => 'Required Skills';

  @override
  String get jobAboutTheCompany => 'About the Company';

  @override
  String get jobCompanyProfileComingSoon => 'Company profile coming soon';

  @override
  String get jobViewCompanyProfile => 'View Company Profile';

  @override
  String get jobSimilarJobs => 'Similar Jobs';

  @override
  String get jobApplyForThisJob => 'Apply for this Job';

  @override
  String get jobYouAreApplyingFor => 'You are applying for:';

  @override
  String get jobCoverLetter => 'Cover Letter';

  @override
  String get jobCoverLetterHint => 'Tell us why you\'re a great fit...';

  @override
  String get jobUploadResume => 'Upload Resume';

  @override
  String get jobCancel => 'Cancel';

  @override
  String get jobSubmitApplication => 'Submit Application';

  @override
  String get jobApplicationSubmittedSuccess =>
      'Application submitted successfully!';

  @override
  String get jobOpportunitiesTitle => 'Job Opportunities';

  @override
  String get jobAllJobs => 'All Jobs';

  @override
  String get jobSaved => 'Saved';

  @override
  String get jobApplied => 'Applied';

  @override
  String get jobSearchHint => 'Search jobs, companies, or skills...';

  @override
  String get jobRemoteOnly => 'Remote Only';

  @override
  String get jobNoApplicationsYet => 'No applications yet';

  @override
  String get jobStartApplyingToSee => 'Start applying to jobs to see them here';

  @override
  String get jobNoJobsFound => 'No jobs found';

  @override
  String get jobTryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get jobDetailComingSoon => 'Job detail screen coming soon';

  @override
  String get jobFilterJobs => 'Filter Jobs';

  @override
  String get jobClearAll => 'Clear All';

  @override
  String get jobJobType => 'Job Type';

  @override
  String get jobExperienceLevel => 'Experience Level';

  @override
  String get jobApplyFilters => 'Apply Filters';

  @override
  String get jobSortBy => 'Sort By';

  @override
  String get jobRelevance => 'Relevance';

  @override
  String get jobNewestFirst => 'Newest First';

  @override
  String get jobHighestSalary => 'Highest Salary';

  @override
  String get msgFailedToSendMessage => 'Failed to send message';

  @override
  String get msgPhotoFromGallery => 'Photo from Gallery';

  @override
  String get msgTakePhoto => 'Take Photo';

  @override
  String get msgOpensCameraOnMobile => 'Opens camera on mobile devices';

  @override
  String get msgDocument => 'Document';

  @override
  String get msgCameraNotAvailable =>
      'Camera not available in browser. Use \"Photo from Gallery\" to select an image.';

  @override
  String get msgNoMessagesYet => 'No messages yet';

  @override
  String get msgSendMessageToStart =>
      'Send a message to start the conversation';

  @override
  String get msgConversation => 'Conversation';

  @override
  String get msgOnline => 'Online';

  @override
  String get msgConnecting => 'Connecting...';

  @override
  String get msgTypeAMessage => 'Type a message...';

  @override
  String get msgMessages => 'Messages';

  @override
  String get msgSearchMessages => 'Search Messages';

  @override
  String get msgSearchConversations => 'Search conversations...';

  @override
  String get msgRetry => 'Retry';

  @override
  String get msgCheckDatabaseSetup => 'Check Database Setup';

  @override
  String get msgDatabaseSetupStatus => 'Database Setup Status';

  @override
  String get msgTestInsertResult => 'Test Insert Result';

  @override
  String get msgTestInsert => 'Test Insert';

  @override
  String get msgNoConversationsYet => 'No conversations yet';

  @override
  String get msgFailedToCreateConversation => 'Failed to create conversation';

  @override
  String get msgNewConversation => 'New Conversation';

  @override
  String get msgSearchByNameOrEmail => 'Search by name or email...';

  @override
  String get msgNoUsersFound => 'No users found';

  @override
  String msgNoUsersMatch(String query) {
    return 'No users match \"$query\"';
  }

  @override
  String get progressAchievementsTitle => 'Achievements';

  @override
  String get progressNoAchievementsYet => 'No achievements yet';

  @override
  String get progressClose => 'Close';

  @override
  String get progressMyProgress => 'My Progress';

  @override
  String get progressKeepUpGreatWork => 'Keep up the great work!';

  @override
  String get progressMakingExcellentProgress =>
      'You\'re making excellent progress';

  @override
  String get progressCoursesCompleted => 'Courses Completed';

  @override
  String get progressStudyTime => 'Study Time';

  @override
  String get progressTotalLearningTime => 'Total learning time';

  @override
  String get progressAverageScore => 'Average Score';

  @override
  String get progressCertificates => 'Certificates';

  @override
  String get progressLearningActivity => 'Learning Activity';

  @override
  String get progressStudyTimeMinutes => 'Study Time (minutes)';

  @override
  String get progressCourseProgress => 'Course Progress';

  @override
  String get progressViewAll => 'View All';

  @override
  String get progressStudyGoalsTitle => 'Study Goals';

  @override
  String get progressYourGoals => 'Your Goals';

  @override
  String get progressCreateGoalComingSoon => 'Create goal coming soon';

  @override
  String get progressNewGoal => 'New Goal';

  @override
  String get instApplicantDetails => 'Applicant Details';

  @override
  String get instApplicantMarkUnderReview => 'Mark as Under Review';

  @override
  String get instApplicantAcceptApplication => 'Accept Application';

  @override
  String get instApplicantRejectApplication => 'Reject Application';

  @override
  String get instApplicantApplicationStatus => 'Application Status';

  @override
  String get instApplicantStudentInfo => 'Student Information';

  @override
  String get instApplicantFullName => 'Full Name';

  @override
  String get instApplicantEmail => 'Email';

  @override
  String get instApplicantPhone => 'Phone';

  @override
  String get instApplicantPreviousSchool => 'Previous School';

  @override
  String get instApplicantGpa => 'GPA';

  @override
  String get instApplicantProgramApplied => 'Program Applied';

  @override
  String get instApplicantSubmitted => 'Submitted';

  @override
  String get instApplicantStatementOfPurpose => 'Statement of Purpose';

  @override
  String get instApplicantDocuments => 'Documents';

  @override
  String get instApplicantDocViewerComingSoon => 'Document viewer coming soon';

  @override
  String instApplicantDownloading(String name) {
    return 'Downloading $name...';
  }

  @override
  String get instApplicantReviewInfo => 'Review Information';

  @override
  String get instApplicantReviewedBy => 'Reviewed By';

  @override
  String get instApplicantUnknown => 'Unknown';

  @override
  String get instApplicantReviewDate => 'Review Date';

  @override
  String get instApplicantReviewNotes => 'Review Notes';

  @override
  String get instApplicantReject => 'Reject';

  @override
  String get instApplicantAccept => 'Accept';

  @override
  String get instApplicantStatusPending => 'Pending Review';

  @override
  String get instApplicantStatusUnderReview => 'Under Review';

  @override
  String get instApplicantStatusAccepted => 'Accepted';

  @override
  String get instApplicantStatusRejected => 'Rejected';

  @override
  String get instApplicantDocTranscript => 'Academic Transcript';

  @override
  String get instApplicantDocId => 'ID Document';

  @override
  String get instApplicantDocPhoto => 'Photo';

  @override
  String get instApplicantDocRecommendation => 'Recommendation Letter';

  @override
  String get instApplicantDocGeneric => 'Document';

  @override
  String get instApplicantRecommendationLetters => 'Recommendation Letters';

  @override
  String instApplicantReceivedCount(int count) {
    return '$count received';
  }

  @override
  String get instApplicantNoRecommendations => 'No Recommendation Letters Yet';

  @override
  String get instApplicantNoRecommendationsDesc =>
      'The applicant has not submitted any recommendation letters with this application.';

  @override
  String get instApplicantType => 'Type';

  @override
  String get instApplicantLetterPreview => 'Letter Preview';

  @override
  String get instApplicantClickViewFull =>
      'Click \"View Full\" to open the complete recommendation letter.';

  @override
  String get instApplicantLetterPreviewUnavailable =>
      'Letter content preview not available.';

  @override
  String get instApplicantClose => 'Close';

  @override
  String get instApplicantViewFull => 'View Full';

  @override
  String get instApplicantDownloadNotAvailable => 'Download not available';

  @override
  String instApplicantOpeningLetter(String url) {
    return 'Opening letter: $url';
  }

  @override
  String get instApplicantMarkedUnderReview => 'Marked as Under Review';

  @override
  String get instApplicantFailedUpdateStatus => 'Failed to update status';

  @override
  String instApplicantErrorUpdatingStatus(String error) {
    return 'Error updating status: $error';
  }

  @override
  String get instApplicantConfirmAccept =>
      'Are you sure you want to accept this application?';

  @override
  String get instApplicantConfirmReject =>
      'Are you sure you want to reject this application?';

  @override
  String get instApplicantReviewNotesOptional => 'Review Notes (Optional)';

  @override
  String get instApplicantReviewNotesRequired => 'Review Notes (Required)';

  @override
  String get instApplicantAddComments => 'Add comments about your decision...';

  @override
  String get instApplicantCancel => 'Cancel';

  @override
  String get instApplicantNotesRequiredRejection =>
      'Review notes are required for rejection';

  @override
  String get instApplicantAcceptedSuccess =>
      'Application accepted successfully';

  @override
  String get instApplicantRejectedSuccess => 'Application rejected';

  @override
  String instApplicantErrorProcessingReview(String error) {
    return 'Error processing review: $error';
  }

  @override
  String get instApplicantReceived => 'RECEIVED';

  @override
  String get instApplicantViewLetter => 'View Letter';

  @override
  String get instApplicantDownload => 'Download';

  @override
  String get instApplicantRetry => 'Retry';

  @override
  String get instApplicantSearchHint => 'Search applicants...';

  @override
  String instApplicantTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String instApplicantTabPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String instApplicantTabUnderReview(int count) {
    return 'Under Review ($count)';
  }

  @override
  String instApplicantTabAccepted(int count) {
    return 'Accepted ($count)';
  }

  @override
  String instApplicantTabRejected(int count) {
    return 'Rejected ($count)';
  }

  @override
  String get instApplicantLoading => 'Loading applicants...';

  @override
  String get instApplicantNoApplicantsFound => 'No Applicants Found';

  @override
  String get instApplicantTryAdjustingSearch => 'Try adjusting your search';

  @override
  String get instApplicantNoAppsInCategory =>
      'No applications in this category';

  @override
  String instApplicantGpaValue(String gpa) {
    return 'GPA: $gpa';
  }

  @override
  String instApplicantSubmittedDate(String date) {
    return 'Submitted: $date';
  }

  @override
  String get instApplicantChipPending => 'Pending';

  @override
  String get instApplicantChipReviewing => 'Reviewing';

  @override
  String get instCourseEditCourse => 'Edit Course';

  @override
  String get instCourseCreateCourse => 'Create Course';

  @override
  String get instCourseBasicInfo => 'Basic Information';

  @override
  String get instCourseTitleLabel => 'Course Title *';

  @override
  String get instCourseTitleHint => 'e.g., Introduction to Programming';

  @override
  String get instCourseTitleRequired => 'Title is required';

  @override
  String get instCourseTitleMinLength => 'Title must be at least 3 characters';

  @override
  String get instCourseTitleMaxLength =>
      'Title must be less than 200 characters';

  @override
  String get instCourseDescriptionLabel => 'Description *';

  @override
  String get instCourseDescriptionHint =>
      'Describe what students will learn...';

  @override
  String get instCourseDescriptionRequired => 'Description is required';

  @override
  String get instCourseDescriptionMinLength =>
      'Description must be at least 10 characters';

  @override
  String get instCourseCourseDetails => 'Course Details';

  @override
  String get instCourseCourseType => 'Course Type *';

  @override
  String get instCourseDifficultyLevel => 'Difficulty Level *';

  @override
  String get instCourseDurationHours => 'Duration (hours)';

  @override
  String get instCourseCategory => 'Category';

  @override
  String get instCourseCategoryHint => 'Computer Science';

  @override
  String get instCoursePricing => 'Pricing';

  @override
  String get instCoursePriceLabel => 'Price *';

  @override
  String get instCoursePriceRequired => 'Price is required';

  @override
  String get instCourseInvalidPrice => 'Invalid price';

  @override
  String get instCourseCurrency => 'Currency';

  @override
  String get instCourseMaxStudents => 'Max Students (optional)';

  @override
  String get instCourseMaxStudentsHint => 'Leave empty for unlimited';

  @override
  String get instCourseMedia => 'Media';

  @override
  String get instCourseThumbnailUrl => 'Thumbnail URL (optional)';

  @override
  String get instCourseTags => 'Tags';

  @override
  String get instCourseAddTagHint => 'Add tag (e.g., programming, python)';

  @override
  String get instCourseLearningOutcomes => 'Learning Outcomes';

  @override
  String get instCourseOutcomeHint => 'What will students learn?';

  @override
  String get instCoursePrerequisites => 'Prerequisites';

  @override
  String get instCoursePrerequisiteHint => 'What do students need to know?';

  @override
  String get instCourseUpdateCourse => 'Update Course';

  @override
  String get instCourseCreatedSuccess => 'Course created successfully!';

  @override
  String get instCourseUpdatedSuccess => 'Course updated successfully!';

  @override
  String get instCourseFailedToSave =>
      'Failed to save course. Please try again.';

  @override
  String get instCourseCourseRoster => 'Course Roster';

  @override
  String get instCourseRefresh => 'Refresh';

  @override
  String get instCourseRetry => 'Retry';

  @override
  String get instCourseNoEnrolledStudents => 'No enrolled students yet';

  @override
  String get instCourseApprovedStudentsAppearHere =>
      'Students with approved permissions will appear here';

  @override
  String get instCourseEnrolledStudents => 'Enrolled Students';

  @override
  String get instCourseMaxCapacity => 'Max Capacity';

  @override
  String instCourseEnrolledDate(String date) {
    return 'Enrolled: $date';
  }

  @override
  String get instCourseEnrollmentPermissions => 'Enrollment Permissions';

  @override
  String get instCoursePendingRequests => 'Pending Requests';

  @override
  String get instCourseApproved => 'Approved';

  @override
  String get instCourseAllStudents => 'All Students';

  @override
  String get instCourseGrantPermission => 'Grant Permission';

  @override
  String get instCourseSelectAtLeastOne => 'Please select at least one student';

  @override
  String instCourseGrantedPermission(int count) {
    return 'Granted permission to $count student(s)';
  }

  @override
  String instCourseFailedGrantPermission(int count) {
    return 'Failed to grant permission to $count student(s)';
  }

  @override
  String get instCourseGrantEnrollmentPermission =>
      'Grant Enrollment Permission';

  @override
  String get instCourseSelectStudentsGrant =>
      'Select students to grant access to this course';

  @override
  String get instCourseSearchStudents => 'Search students...';

  @override
  String instCourseSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get instCourseClear => 'Clear';

  @override
  String get instCourseCancel => 'Cancel';

  @override
  String get instCourseSelectStudents => 'Select Students';

  @override
  String instCourseGrantToStudents(int count) {
    return 'Grant to $count Student(s)';
  }

  @override
  String get instCourseNoStudentsAvailable => 'No students available';

  @override
  String get instCourseAllStudentsHavePermissions =>
      'All admitted students already have permissions';

  @override
  String get instCourseNoMatchingStudents => 'No matching students';

  @override
  String get instCourseNoPendingRequests => 'No pending requests';

  @override
  String get instCourseStudentsCanRequest =>
      'Students can request enrollment permission';

  @override
  String get instCourseMessage => 'Message:';

  @override
  String instCourseRequested(String date) {
    return 'Requested: $date';
  }

  @override
  String get instCourseDeny => 'Deny';

  @override
  String get instCourseApprove => 'Approve';

  @override
  String instCourseApprovedStudent(String name) {
    return 'Approved $name';
  }

  @override
  String get instCourseFailedToApprove => 'Failed to approve';

  @override
  String get instCourseDenyPermissionRequest => 'Deny Permission Request';

  @override
  String instCourseDenyStudent(String name) {
    return 'Deny $name?';
  }

  @override
  String get instCourseReasonForDenial => 'Reason for denial';

  @override
  String get instCourseEnterReason => 'Enter reason...';

  @override
  String get instCoursePleaseProvideReason => 'Please provide a reason';

  @override
  String instCourseDeniedStudent(String name) {
    return 'Denied $name';
  }

  @override
  String get instCourseNoApprovedPermissions => 'No approved permissions yet';

  @override
  String get instCourseGrantToAllowEnroll =>
      'Grant permissions to allow students to enroll';

  @override
  String get instCourseRevokePermission => 'Revoke Permission';

  @override
  String instCourseRevokePermissionFor(String name) {
    return 'Revoke permission for $name?';
  }

  @override
  String get instCourseReasonOptional => 'Reason (optional)';

  @override
  String get instCourseRevoke => 'Revoke';

  @override
  String instCourseRevokedPermissionFor(String name) {
    return 'Revoked permission for $name';
  }

  @override
  String get instCourseNoAdmittedStudents => 'No admitted students';

  @override
  String get instCourseAcceptedStudentsAppearHere =>
      'Students with accepted applications will appear here';

  @override
  String get instCourseRequestPending => 'Request Pending';

  @override
  String get instCourseAccessGranted => 'Access Granted';

  @override
  String get instCourseDenied => 'Denied';

  @override
  String get instCourseRevoked => 'Revoked';

  @override
  String get instCourseGrantAccess => 'Grant Access';

  @override
  String instCourseGrantStudentPermission(String name) {
    return 'Grant $name permission to enroll in this course?';
  }

  @override
  String get instCourseNotesOptional => 'Notes (optional)';

  @override
  String get instCourseAddNotes => 'Add any notes...';

  @override
  String get instCourseGrant => 'Grant';

  @override
  String instCourseGrantedPermissionTo(String name) {
    return 'Granted permission to $name';
  }

  @override
  String get instCourseFailedToGrantPermission => 'Failed to grant permission';

  @override
  String get instCourseRequestApproved => 'Request approved';

  @override
  String get instCourseFailedToApproveRequest => 'Failed to approve request';

  @override
  String get instCourseContentBuilder => 'Course Content Builder';

  @override
  String get instCoursePreviewCourse => 'Preview Course';

  @override
  String get instCourseAddModule => 'Add Module';

  @override
  String get instCourseCourseTitle => 'Course Title';

  @override
  String get instCourseEditInfo => 'Edit Info';

  @override
  String get instCourseCourseModules => 'Course Modules';

  @override
  String get instCourseNoModulesYet => 'No modules yet';

  @override
  String get instCourseStartBuildingModules =>
      'Start building your course by adding modules';

  @override
  String instCourseModuleIndex(int index) {
    return 'Module $index';
  }

  @override
  String instCourseLessonsCount(int count) {
    return '$count lessons';
  }

  @override
  String get instCourseEditModule => 'Edit Module';

  @override
  String get instCourseDeleteModule => 'Delete Module';

  @override
  String get instCourseLearningObjectives => 'Learning Objectives:';

  @override
  String get instCourseLessons => 'Lessons';

  @override
  String get instCourseAddLesson => 'Add Lesson';

  @override
  String get instCourseNoLessonsInModule => 'No lessons in this module';

  @override
  String get instCourseEditLesson => 'Edit Lesson';

  @override
  String get instCourseDeleteLesson => 'Delete Lesson';

  @override
  String get instCourseError => 'Error';

  @override
  String instCourseModuleCreatedSuccess(String title) {
    return 'Module \"$title\" created successfully';
  }

  @override
  String instCourseModuleUpdatedSuccess(String title) {
    return 'Module \"$title\" updated successfully';
  }

  @override
  String get instCourseAddNewLesson => 'Add New Lesson';

  @override
  String get instCourseLessonType => 'Lesson Type';

  @override
  String get instCourseLessonTitle => 'Lesson Title';

  @override
  String get instCoursePleaseEnterTitle => 'Please enter a title';

  @override
  String get instCourseDescription => 'Description';

  @override
  String get instCourseLessonCreatedSuccess => 'Lesson created successfully';

  @override
  String get instCourseCreate => 'Create';

  @override
  String get instCourseDeleteModuleConfirm =>
      'Are you sure you want to delete this module? This will also delete all lessons in the module.';

  @override
  String get instCourseDelete => 'Delete';

  @override
  String get instCourseModuleDeletedSuccess => 'Module deleted successfully';

  @override
  String get instCourseDeleteLessonConfirm =>
      'Are you sure you want to delete this lesson?';

  @override
  String get instCourseLessonDeletedSuccess => 'Lesson deleted successfully';

  @override
  String get instCourseEditCourseInfo => 'Edit Course Info';

  @override
  String get instCourseEnterTitle => 'Enter course title';

  @override
  String get instCourseEnterDescription => 'Enter course description';

  @override
  String get instCourseLevel => 'Level';

  @override
  String get instCourseInfoUpdatedSuccess => 'Course info updated successfully';

  @override
  String get instCourseSaving => 'Saving...';

  @override
  String get instCourseSaveChanges => 'Save Changes';

  @override
  String get instProgramCreateProgram => 'Create Program';

  @override
  String get instProgramNameLabel => 'Program Name *';

  @override
  String get instProgramNameHint => 'e.g., Bachelor of Computer Science';

  @override
  String get instProgramDescriptionLabel => 'Description *';

  @override
  String get instProgramDescriptionHint => 'Describe the program...';

  @override
  String get instProgramCategoryLabel => 'Category *';

  @override
  String get instProgramLevelLabel => 'Level *';

  @override
  String get instProgramDuration => 'Duration';

  @override
  String get instProgramFeeLabel => 'Program Fee (USD) *';

  @override
  String get instProgramMaxStudentsLabel => 'Maximum Students *';

  @override
  String get instProgramMaxStudentsHint => 'e.g., 100';

  @override
  String get instProgramStartDate => 'Start Date';

  @override
  String get instProgramApplicationDeadline => 'Application Deadline';

  @override
  String get instProgramRequirements => 'Requirements';

  @override
  String get instProgramAddRequirementHint => 'Add a requirement...';

  @override
  String get instProgramAddAtLeastOneRequirement =>
      'Please add at least one requirement';

  @override
  String get instProgramDeadlineBeforeStart =>
      'Application deadline must be before start date';

  @override
  String get instProgramCreatedSuccess => 'Program created successfully!';

  @override
  String get instProgramFailedToCreate => 'Failed to create program';

  @override
  String instProgramErrorCreating(String error) {
    return 'Error creating program: $error';
  }

  @override
  String get instProgramDetails => 'Program Details';

  @override
  String get instProgramBack => 'Back';

  @override
  String get instProgramEditComingSoon => 'Edit feature coming soon';

  @override
  String get instProgramEditProgram => 'Edit Program';

  @override
  String get instProgramDeactivate => 'Deactivate';

  @override
  String get instProgramActivate => 'Activate';

  @override
  String get instProgramDeleteProgram => 'Delete Program';

  @override
  String get instProgramInactiveMessage =>
      'This program is currently inactive and not accepting applications';

  @override
  String get instProgramEnrolled => 'Enrolled';

  @override
  String get instProgramAvailable => 'Available';

  @override
  String get instProgramFee => 'Fee';

  @override
  String get instProgramDescription => 'Description';

  @override
  String get instProgramProgramDetails => 'Program Details';

  @override
  String get instProgramCategory => 'Category';

  @override
  String get instProgramInstitution => 'Institution';

  @override
  String get instProgramMaxStudents => 'Maximum Students';

  @override
  String get instProgramEnrollmentStatus => 'Enrollment Status';

  @override
  String get instProgramFillRate => 'Fill Rate';

  @override
  String get instProgramIsFull => 'Program is full';

  @override
  String instProgramSlotsRemaining(int count) {
    return '$count slots remaining';
  }

  @override
  String get instProgramDeactivateQuestion => 'Deactivate Program?';

  @override
  String get instProgramActivateQuestion => 'Activate Program?';

  @override
  String get instProgramStopAccepting =>
      'This program will stop accepting new applications.';

  @override
  String get instProgramStartAccepting =>
      'This program will start accepting new applications.';

  @override
  String get instProgramCancel => 'Cancel';

  @override
  String get instProgramConfirm => 'Confirm';

  @override
  String get instProgramActivated => 'Program activated';

  @override
  String get instProgramDeactivated => 'Program deactivated';

  @override
  String instProgramErrorUpdatingStatus(String error) {
    return 'Error updating program status: $error';
  }

  @override
  String get instProgramDeleteProgramQuestion => 'Delete Program?';

  @override
  String get instProgramDeleteConfirm =>
      'This action cannot be undone. All data associated with this program will be permanently deleted.';

  @override
  String get instProgramDelete => 'Delete';

  @override
  String get instProgramDeletedSuccess => 'Program deleted successfully';

  @override
  String get instProgramFailedToDelete => 'Failed to delete program';

  @override
  String instProgramErrorDeleting(String error) {
    return 'Error deleting program: $error';
  }

  @override
  String get instProgramPrograms => 'Programs';

  @override
  String get instProgramRetry => 'Retry';

  @override
  String get instProgramLoading => 'Loading programs...';

  @override
  String get instProgramActiveOnly => 'Active Only';

  @override
  String get instProgramShowAll => 'Show All';

  @override
  String get instProgramSearchHint => 'Search programs...';

  @override
  String get instProgramNewProgram => 'New Program';

  @override
  String get instProgramNoProgramsFound => 'No Programs Found';

  @override
  String get instProgramTryAdjustingSearch => 'Try adjusting your search';

  @override
  String get instProgramCreateFirstProgram => 'Create your first program';

  @override
  String get instProgramInactive => 'INACTIVE';

  @override
  String get instProgramEnrollment => 'Enrollment';

  @override
  String get instProgramFull => 'Full';

  @override
  String instProgramSlotsAvailable(int count) {
    return '$count slots available';
  }

  @override
  String get instCounselorSearchHint => 'Search counselors...';

  @override
  String get instCounselorRetry => 'Retry';

  @override
  String get instCounselorNoCounselorsFound => 'No Counselors Found';

  @override
  String get instCounselorNoMatchSearch => 'No counselors match your search';

  @override
  String get instCounselorAddToInstitution =>
      'Add counselors to your institution';

  @override
  String instCounselorPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get instCounselorCounselingOverview => 'Counseling Overview';

  @override
  String get instCounselorCounselors => 'Counselors';

  @override
  String get instCounselorStudents => 'Students';

  @override
  String get instCounselorSessions => 'Sessions';

  @override
  String get instCounselorCompleted => 'Completed';

  @override
  String get instCounselorUpcoming => 'Upcoming';

  @override
  String get instCounselorAvgRating => 'Avg Rating';

  @override
  String get instCounselorStudentAssigned => 'Student assigned successfully';

  @override
  String get instCounselorAssign => 'Assign';

  @override
  String get instCounselorTotalSessions => 'Total Sessions';

  @override
  String get instCounselorAssignStudents => 'Assign Students';

  @override
  String instCounselorAssignStudentTo(String name) {
    return 'Assign Student to $name';
  }

  @override
  String get instCounselorSearchStudents => 'Search students...';

  @override
  String get instCounselorNoStudentsFound => 'No students found';

  @override
  String get instCounselorCancel => 'Cancel';

  @override
  String get studentCounselingBookSession => 'Book Session';

  @override
  String get studentCounselingSelectDate => 'Select Date';

  @override
  String get studentCounselingSelectTime => 'Select Time';

  @override
  String get studentCounselingSessionType => 'Session Type';

  @override
  String get studentCounselingTopicOptional => 'Topic (Optional)';

  @override
  String get studentCounselingTopicHint => 'What would you like to discuss?';

  @override
  String get studentCounselingDetailsOptional =>
      'Additional Details (Optional)';

  @override
  String get studentCounselingDetailsHint =>
      'Any additional information for your counselor...';

  @override
  String get studentCounselingSessionSummary => 'Session Summary';

  @override
  String get studentCounselingCounselor => 'Counselor';

  @override
  String get studentCounselingDate => 'Date';

  @override
  String get studentCounselingTime => 'Time';

  @override
  String get studentCounselingType => 'Type';

  @override
  String get studentCounselingTopic => 'Topic';

  @override
  String get studentCounselingBookedSuccess => 'Session booked successfully!';

  @override
  String get studentCounselingBookFailed => 'Failed to book session';

  @override
  String studentCounselingUpcomingTab(int count) {
    return 'Upcoming ($count)';
  }

  @override
  String studentCounselingPastTab(int count) {
    return 'Past ($count)';
  }

  @override
  String get studentCounselingContactAdmin =>
      'Please contact your institution administrator for counselor assignment.';

  @override
  String get studentCounselingTotal => 'Total';

  @override
  String get studentCounselingCompleted => 'Completed';

  @override
  String get studentCounselingUpcoming => 'Upcoming';

  @override
  String get studentCounselingRating => 'Rating';

  @override
  String get studentCounselingNoUpcoming => 'No upcoming sessions scheduled';

  @override
  String get studentCounselingNoPast => 'No past sessions yet';

  @override
  String get studentCounselingCancelSession => 'Cancel Session';

  @override
  String get studentCounselingCancelConfirm =>
      'Are you sure you want to cancel this session? This action cannot be undone.';

  @override
  String get studentCounselingKeepIt => 'No, Keep It';

  @override
  String get studentCounselingSessionCancelled => 'Session cancelled';

  @override
  String get studentCounselingYesCancel => 'Yes, Cancel';

  @override
  String get studentCounselingRateSession => 'Rate Your Session';

  @override
  String get studentCounselingHowWasSession =>
      'How was your counseling session?';

  @override
  String get studentCounselingCommentsOptional => 'Comments (optional)';

  @override
  String get studentCounselingCancel => 'Cancel';

  @override
  String get studentCounselingFeedbackThanks => 'Thank you for your feedback!';

  @override
  String get studentCounselingSubmit => 'Submit';

  @override
  String get studentCounselingSessions => 'Sessions';

  @override
  String get studentCounselingAvailability => 'Availability';

  @override
  String get studentCounselingBookASession => 'Book a Session';

  @override
  String get studentCounselingDuration => 'Duration';

  @override
  String studentCounselingMinutes(int count) {
    return '$count minutes';
  }

  @override
  String get studentCounselingNotes => 'Notes';

  @override
  String get studentCounselingYourFeedback => 'Your Feedback';

  @override
  String get studentCounselingLeaveFeedback => 'Leave Feedback';

  @override
  String get studentHelpTitle => 'Help & Support';

  @override
  String get studentHelpSearchHint => 'Search for help...';

  @override
  String get studentHelpQuickHelp => 'Quick Help';

  @override
  String get studentHelpLiveChat => 'Live Chat';

  @override
  String get studentHelpChatWithSupport => 'Chat with support';

  @override
  String get studentHelpEmailUs => 'Email Us';

  @override
  String get studentHelpEmailAddress => 'support@flow.edu';

  @override
  String get studentHelpTutorials => 'Tutorials';

  @override
  String get studentHelpVideoGuides => 'Video guides';

  @override
  String get studentHelpUserGuide => 'User Guide';

  @override
  String get studentHelpFullDocumentation => 'Full documentation';

  @override
  String get studentHelpFaq => 'Frequently Asked Questions';

  @override
  String get studentHelpSearchResults => 'Search Results';

  @override
  String get studentHelpNoResults => 'No results found';

  @override
  String get studentHelpTryDifferentKeywords =>
      'Try different keywords or contact support';

  @override
  String get studentHelpContactSupport => 'Contact Support';

  @override
  String studentHelpQuestionsCount(int count) {
    return '$count questions';
  }

  @override
  String studentHelpComingSoon(String feature) {
    return '$feature coming soon!';
  }

  @override
  String get studentHelpReachOut =>
      'Need help? Reach out to us through any of these channels:';

  @override
  String get studentHelpEmail => 'Email';

  @override
  String get studentHelpPhone => 'Phone';

  @override
  String get studentHelpHours => 'Hours';

  @override
  String get studentHelpBusinessHours => 'Mon-Fri, 9 AM - 6 PM EST';

  @override
  String get studentHelpClose => 'Close';

  @override
  String get studentHelpOpeningEmail => 'Opening email client...';

  @override
  String get studentHelpSendEmail => 'Send Email';

  @override
  String get parentLinkTitle => 'Parent Linking';

  @override
  String get parentLinkLinkedTab => 'Linked';

  @override
  String get parentLinkRequestsTab => 'Requests';

  @override
  String get parentLinkInviteCodesTab => 'Invite Codes';

  @override
  String get parentLinkLoadingLinked => 'Loading linked parents...';

  @override
  String get parentLinkNoLinkedParents => 'No Linked Parents';

  @override
  String get parentLinkNoLinkedMessage =>
      'When a parent links their account to yours, they will appear here.';

  @override
  String get parentLinkRefresh => 'Refresh';

  @override
  String parentLinkManagePermissionsFor(String name) {
    return 'Manage Permissions for $name';
  }

  @override
  String get parentLinkControlPermissions =>
      'Control what this parent can see:';

  @override
  String get parentLinkViewGrades => 'View Grades';

  @override
  String get parentLinkAllowViewGrades => 'Allow viewing your academic grades';

  @override
  String get parentLinkViewActivity => 'View Activity';

  @override
  String get parentLinkAllowViewActivity => 'Allow viewing your app activity';

  @override
  String get parentLinkViewMessages => 'View Messages';

  @override
  String get parentLinkAllowViewMessages =>
      'Allow viewing your messages (private)';

  @override
  String get parentLinkReceiveAlerts => 'Receive Alerts';

  @override
  String get parentLinkSendAlerts => 'Send alerts about important updates';

  @override
  String get parentLinkCancel => 'Cancel';

  @override
  String get parentLinkSave => 'Save';

  @override
  String get parentLinkPermissionsUpdated => 'Permissions updated';

  @override
  String get parentLinkUnlinkParent => 'Unlink Parent';

  @override
  String parentLinkUnlinkConfirm(String name) {
    return 'Are you sure you want to unlink $name? They will no longer be able to view your information.';
  }

  @override
  String get parentLinkUnlink => 'Unlink';

  @override
  String parentLinkUnlinked(String name) {
    return '$name has been unlinked';
  }

  @override
  String get parentLinkLinked => 'Linked';

  @override
  String get parentLinkPermissions => 'Permissions:';

  @override
  String get parentLinkManage => 'Manage';

  @override
  String get parentLinkLoadingRequests => 'Loading requests...';

  @override
  String get parentLinkNoPendingRequests => 'No Pending Requests';

  @override
  String get parentLinkNoPendingMessage =>
      'You don\'t have any parent link requests to review.';

  @override
  String parentLinkApproved(String name) {
    return '$name has been linked to your account';
  }

  @override
  String get parentLinkDeclineRequest => 'Decline Request';

  @override
  String parentLinkDeclineConfirm(String name) {
    return 'Are you sure you want to decline the link request from $name?';
  }

  @override
  String get parentLinkDecline => 'Decline';

  @override
  String get parentLinkRequestDeclined => 'Request declined';

  @override
  String get parentLinkRequestedPermissions => 'Requested Permissions:';

  @override
  String get parentLinkApprove => 'Approve';

  @override
  String get parentLinkGenerateNewCode => 'Generate New Invite Code';

  @override
  String get parentLinkShareCodeInfo =>
      'Share your invite code with your parent so they can link their account to yours.';

  @override
  String get parentLinkNoInviteCodes => 'No Invite Codes';

  @override
  String get parentLinkNoCodesMessage =>
      'Generate an invite code to share with your parent.';

  @override
  String get parentLinkGenerateInviteCode => 'Generate Invite Code';

  @override
  String get parentLinkConfigureCode => 'Configure your invite code settings:';

  @override
  String get parentLinkGenerate => 'Generate';

  @override
  String get parentLinkCodeGenerated => 'Code Generated!';

  @override
  String get parentLinkShareCode => 'Share this code with your parent:';

  @override
  String get parentLinkCodeCopied => 'Code copied to clipboard';

  @override
  String get parentLinkDone => 'Done';

  @override
  String get parentLinkDeleteCode => 'Delete Invite Code';

  @override
  String get parentLinkDeleteCodeConfirm =>
      'Are you sure you want to delete this invite code?';

  @override
  String get parentLinkDelete => 'Delete';

  @override
  String get studentProgressLoading => 'Loading progress...';

  @override
  String get studentProgressTitle => 'My Progress';

  @override
  String get studentProgressError => 'Error Loading Progress';

  @override
  String get studentProgressRetry => 'Retry';

  @override
  String get studentProgressNoData => 'No Progress Data';

  @override
  String get studentProgressEnrollMessage =>
      'Enroll in courses to start tracking your progress.';

  @override
  String get studentProgressOverview => 'Overview';

  @override
  String get studentProgressCourses => 'Courses';

  @override
  String get studentProgressAvgGrade => 'Average Grade';

  @override
  String get studentProgressCompletion => 'Completion';

  @override
  String get studentProgressAssignments => 'Assignments';

  @override
  String get studentProgressGradeTrend => 'Grade Trend';

  @override
  String get studentProgressStudyTime => 'Study Time (Hours)';

  @override
  String get studentProgressCourseCompletion => 'Course Completion';

  @override
  String get studentProgressCompleted => 'Completed';

  @override
  String get studentProgressInProgress => 'In Progress';

  @override
  String get studentProgressProgress => 'Progress';

  @override
  String get studentProgressAppSuccessRate => 'Application Success Rate';

  @override
  String get studentProgressNoAppData => 'No application data available';

  @override
  String get studentProgressNoAppsYet => 'No applications yet';

  @override
  String get studentProgressAcceptanceRate => 'Acceptance Rate';

  @override
  String get studentProgressGpaTrend => 'GPA Trend';

  @override
  String get studentProgressNoGpaData => 'No GPA data available';

  @override
  String get studentProgressCurrentGpa => 'Current GPA';

  @override
  String get studentProgressGoalGpa => 'Goal GPA';

  @override
  String get studentProgressTrend => 'Trend';

  @override
  String get studentProgressHistoricalGpa =>
      'Historical GPA data will appear here as you progress through semesters';

  @override
  String get studentProgressCurrentGrade => 'Current Grade';

  @override
  String get studentProgressTimeSpent => 'Time Spent';

  @override
  String get studentProgressModules => 'Modules';

  @override
  String get studentProgressRecentGrades => 'Recent Grades';

  @override
  String get studentProgressFeedback => 'Feedback';

  @override
  String get studentRecTitle => 'Recommendation Letters';

  @override
  String studentRecAllTab(int count) {
    return 'All ($count)';
  }

  @override
  String studentRecPendingTab(int count) {
    return 'Pending ($count)';
  }

  @override
  String studentRecInProgressTab(int count) {
    return 'In Progress ($count)';
  }

  @override
  String studentRecCompletedTab(int count) {
    return 'Completed ($count)';
  }

  @override
  String get studentRecRetry => 'Retry';

  @override
  String get studentRecLoadingRequests => 'Loading requests...';

  @override
  String get studentRecRequestLetter => 'Request Letter';

  @override
  String get studentRecNoPending => 'No pending recommendation requests';

  @override
  String get studentRecNoInProgress => 'No letters being written';

  @override
  String get studentRecNoCompleted => 'No completed recommendation letters yet';

  @override
  String get studentRecNoRequests =>
      'No recommendation requests yet.\nTap + to request a letter.';

  @override
  String get studentRecNoRequestsTitle => 'No Requests';

  @override
  String get studentRecRequestSent =>
      'Recommendation request sent! The recommender will receive an email invitation.';

  @override
  String get studentRecFailedToSend => 'Failed to send request';

  @override
  String get studentRecStatus => 'Status';

  @override
  String get studentRecType => 'Type';

  @override
  String get studentRecPurpose => 'Purpose';

  @override
  String get studentRecInstitution => 'Institution';

  @override
  String get studentRecDeadline => 'Deadline';

  @override
  String get studentRecRequested => 'Requested';

  @override
  String get studentRecDeclineReason => 'Decline Reason';

  @override
  String get studentRecClose => 'Close';

  @override
  String get studentRecCancelRequest => 'Cancel Request';

  @override
  String get studentRecSendReminder => 'Send Reminder';

  @override
  String get studentRecCancelRequestTitle => 'Cancel Request?';

  @override
  String get studentRecCancelRequestConfirm =>
      'Are you sure you want to cancel this recommendation request?';

  @override
  String get studentRecNo => 'No';

  @override
  String get studentRecYesCancel => 'Yes, Cancel';

  @override
  String get studentRecRequestCancelled => 'Request cancelled';

  @override
  String get studentRecFailedToCancel => 'Failed to cancel request';

  @override
  String get studentRecReminderSent => 'Reminder sent!';

  @override
  String get studentRecFailedReminder => 'Failed to send reminder';

  @override
  String get studentRecCompleted => 'Completed';

  @override
  String get studentRecOverdue => 'Overdue!';

  @override
  String get studentRecDueToday => 'Due today';

  @override
  String studentRecDaysLeft(int count) {
    return '$count days left';
  }

  @override
  String get studentRecEdit => 'Edit';

  @override
  String get studentRecCancel => 'Cancel';

  @override
  String get studentRecRemind => 'Remind';

  @override
  String get studentRecRequestRecLetter => 'Request Recommendation Letter';

  @override
  String get studentRecRecommenderEmail => 'Recommender Email *';

  @override
  String get studentRecEmailHelperText =>
      'They will receive an invitation to submit the recommendation';

  @override
  String get studentRecEnterEmail => 'Please enter recommender email';

  @override
  String get studentRecValidEmail => 'Please enter a valid email address';

  @override
  String get studentRecRecommenderName => 'Recommender Name *';

  @override
  String get studentRecNameHint => 'Dr. John Smith';

  @override
  String get studentRecEnterName => 'Please enter recommender name';

  @override
  String get studentRecTypeRequired => 'Type *';

  @override
  String get studentRecAcademic => 'Academic';

  @override
  String get studentRecProfessional => 'Professional';

  @override
  String get studentRecCharacter => 'Character';

  @override
  String get studentRecScholarship => 'Scholarship';

  @override
  String get studentRecPurposeRequired => 'Purpose *';

  @override
  String get studentRecPurposeHint =>
      'e.g., Graduate school application, Job application';

  @override
  String get studentRecPurposeValidation =>
      'Please describe the purpose (min 10 characters)';

  @override
  String get studentRecTargetInstitutions => 'Target Institutions *';

  @override
  String get studentRecNoAppsWarning =>
      'You have no applications yet. Please submit applications first to request recommendations.';

  @override
  String studentRecSelectInstitutions(int count) {
    return 'Select institutions ($count selected)';
  }

  @override
  String get studentRecSelectAtLeastOne =>
      'Please select at least one institution';

  @override
  String get studentRecDeadlineRequired => 'Deadline *';

  @override
  String get studentRecPriority => 'Priority';

  @override
  String get studentRecLow => 'Low';

  @override
  String get studentRecNormal => 'Normal';

  @override
  String get studentRecHigh => 'High';

  @override
  String get studentRecUrgent => 'Urgent';

  @override
  String get studentRecMessageToRecommender => 'Message to Recommender';

  @override
  String get studentRecMessageHint =>
      'Any specific points you\'d like them to highlight?';

  @override
  String get studentRecYourAchievements => 'Your Achievements';

  @override
  String get studentRecAchievementsHint =>
      'List relevant achievements to help the recommender';

  @override
  String get studentRecYourGoals => 'Your Goals';

  @override
  String get studentRecGoalsHint => 'What are your career/academic goals?';

  @override
  String get studentRecSendRequest => 'Send Request';

  @override
  String get studentRecEditRequest => 'Edit Request';

  @override
  String get studentRecTargetInstitution => 'Target Institution';

  @override
  String get studentRecInstitutionHint => 'Institution name';

  @override
  String get studentRecSaveChanges => 'Save Changes';

  @override
  String get studentRecRequestUpdated => 'Request updated successfully!';

  @override
  String get studentRecFailedToUpdate => 'Failed to update request';

  @override
  String get studentResourcesTitle => 'Resources';

  @override
  String get studentResourcesAllResources => 'All Resources';

  @override
  String get studentResourcesFavorites => 'Favorites';

  @override
  String get studentResourcesSearchHint => 'Search resources...';

  @override
  String get studentResourcesAll => 'All';

  @override
  String get studentResourcesNoResults => 'No resources found';

  @override
  String get studentResourcesTryAdjusting =>
      'Try adjusting your search or filters';

  @override
  String get studentResourcesRemovedFavorite => 'Removed from favorites';

  @override
  String get studentResourcesAddedFavorite => 'Added to favorites';

  @override
  String get studentResourcesOpenLink => 'Open Link';

  @override
  String get studentResourcesDownload => 'Download';

  @override
  String get studentScheduleTitle => 'My Schedule';

  @override
  String get studentScheduleGoToToday => 'Go to today';

  @override
  String get studentScheduleAddEventSoon => 'Add event feature coming soon!';

  @override
  String get studentScheduleAddEvent => 'Add Event';

  @override
  String get studentScheduleEnjoyFreeTime => 'Enjoy your free time!';

  @override
  String get studentScheduleDate => 'Date';

  @override
  String get studentScheduleTime => 'Time';

  @override
  String get studentScheduleLocation => 'Location';

  @override
  String get studentScheduleEditSoon => 'Edit feature coming soon!';

  @override
  String get studentScheduleEdit => 'Edit';

  @override
  String get studentScheduleReminderSet => 'Reminder set!';

  @override
  String get studentScheduleRemindMe => 'Remind Me';

  @override
  String get parentChildAddChild => 'Add Child';

  @override
  String get parentChildByEmail => 'By Email';

  @override
  String get parentChildByCode => 'By Code';

  @override
  String get parentChildEmailDescription =>
      'Enter your child\'s email address to send them a link request.';

  @override
  String get parentChildStudentEmail => 'Student Email';

  @override
  String get parentChildStudentEmailHint => 'student@example.com';

  @override
  String get parentChildEnterEmail => 'Please enter an email address';

  @override
  String get parentChildValidEmail => 'Please enter a valid email address';

  @override
  String get parentChildSendLinkRequest => 'Send Link Request';

  @override
  String get parentChildApprovalNotice =>
      'Your child will receive a notification to approve this request.';

  @override
  String get parentChildCodeDescription =>
      'Enter the invite code your child shared with you.';

  @override
  String get parentChildInviteCode => 'Invite Code';

  @override
  String get parentChildInviteCodeHint => 'ABCD1234';

  @override
  String get parentChildEnterInviteCode => 'Please enter the invite code';

  @override
  String get parentChildCodeMinLength => 'Code must be at least 6 characters';

  @override
  String get parentChildUseInviteCode => 'Use Invite Code';

  @override
  String get parentChildInviteCodeInfo =>
      'Ask your child to generate an invite code from their app settings.';

  @override
  String get parentChildRelationship => 'Relationship';

  @override
  String get parentChildBack => 'Back';

  @override
  String get parentChildOverview => 'Overview';

  @override
  String get parentChildCourses => 'Courses';

  @override
  String get parentChildApplications => 'Applications';

  @override
  String get parentChildCounseling => 'Counseling';

  @override
  String get parentChildAcademicPerformance => 'Academic Performance';

  @override
  String get parentChildAverageGrade => 'Average Grade';

  @override
  String get parentChildActiveCourses => 'Active Courses';

  @override
  String get parentChildSchool => 'School';

  @override
  String get parentChildNotSet => 'Not Set';

  @override
  String get parentChildRecentActivity => 'Recent Activity';

  @override
  String get parentChildCompletedAssignment => 'Completed Assignment';

  @override
  String get parentChildMathChapter5 => 'Mathematics - Chapter 5 Test';

  @override
  String parentChildHoursAgo(String count) {
    return '$count hours ago';
  }

  @override
  String get parentChildSubmittedProject => 'Submitted Project';

  @override
  String get parentChildCsFinalProject => 'Computer Science - Final Project';

  @override
  String parentChildDaysAgo(String count) {
    return '$count days ago';
  }

  @override
  String get parentChildReceivedGrade => 'Received Grade';

  @override
  String get parentChildPhysicsLabReport => 'Physics - Lab Report (92/100)';

  @override
  String get parentChildRetry => 'Retry';

  @override
  String get parentChildLoadingCourses => 'Loading courses...';

  @override
  String get parentChildNoCourseData => 'No Course Data';

  @override
  String get parentChildNoCourseProgress => 'No course progress data available';

  @override
  String get parentChildCourseProgress => 'Course Progress';

  @override
  String parentChildAssignments(String completed, String total) {
    return 'Assignments: $completed/$total';
  }

  @override
  String get parentChildNoApplications => 'No Applications';

  @override
  String get parentChildNoApplicationsYet =>
      'Your child hasn\'t submitted any applications yet';

  @override
  String parentChildSubmitted(String date) {
    return 'Submitted: $date';
  }

  @override
  String get parentChildStatusPending => 'Pending';

  @override
  String get parentChildStatusUnderReview => 'Under Review';

  @override
  String get parentChildStatusAccepted => 'Accepted';

  @override
  String get parentChildStatusRejected => 'Rejected';

  @override
  String get parentChildLoadingChildren => 'Loading children...';

  @override
  String get parentChildNoChildren => 'No Children';

  @override
  String get parentChildAddToMonitor =>
      'Add your children to monitor their progress';

  @override
  String get parentChildAvg => 'AVG';

  @override
  String get parentChildLastActive => 'Last Active';

  @override
  String get parentChildPendingLinkRequests => 'Pending Link Requests';

  @override
  String get parentChildWaitingApproval => 'Waiting for student approval';

  @override
  String get parentChildAwaitingApproval => 'Awaiting approval';

  @override
  String get parentChildNoCounselor => 'No Counselor Assigned';

  @override
  String parentChildNoCounselorDescription(String childName) {
    return '$childName doesn\'t have a counselor assigned yet.';
  }

  @override
  String parentChildChildCounselor(String childName) {
    return '$childName\'s Counselor';
  }

  @override
  String parentChildAssigned(String date) {
    return 'Assigned: $date';
  }

  @override
  String get parentChildTotal => 'Total';

  @override
  String get parentChildUpcoming => 'Upcoming';

  @override
  String get parentChildCompleted => 'Completed';

  @override
  String get parentChildUpcomingSessions => 'Upcoming Sessions';

  @override
  String get parentChildNoUpcomingSessions => 'No upcoming sessions';

  @override
  String get parentChildPastSessions => 'Past Sessions';

  @override
  String get parentChildNoPastSessions => 'No past sessions';

  @override
  String parentChildMinutes(String count) {
    return '$count min';
  }

  @override
  String get parentReportBack => 'Back';

  @override
  String get parentReportAcademicReports => 'Academic Reports';

  @override
  String get parentReportProgress => 'Progress';

  @override
  String get parentReportGrades => 'Grades';

  @override
  String get parentReportAttendance => 'Attendance';

  @override
  String get parentReportStudentProgressReports => 'Student Progress Reports';

  @override
  String get parentReportTrackProgress =>
      'Track academic progress and course completion';

  @override
  String get parentReportNoProgressData => 'No Progress Data';

  @override
  String get parentReportAddChildrenProgress =>
      'Add children to view their progress reports';

  @override
  String get parentReportCoursesEnrolled => 'Courses Enrolled';

  @override
  String get parentReportApplications => 'Applications';

  @override
  String get parentReportOverallProgress => 'Overall Progress';

  @override
  String get parentReportGradeReports => 'Grade Reports';

  @override
  String get parentReportGradeBreakdown =>
      'Detailed breakdown of grades by subject';

  @override
  String get parentReportNoGradeData => 'No Grade Data';

  @override
  String get parentReportAddChildrenGrades =>
      'Add children to view their grade reports';

  @override
  String get parentReportAttendanceReports => 'Attendance Reports';

  @override
  String get parentReportTrackAttendance =>
      'Track attendance and participation';

  @override
  String get parentReportNoAttendanceData => 'No Attendance Data';

  @override
  String get parentReportAddChildrenAttendance =>
      'Add children to view their attendance reports';

  @override
  String get parentReportPresent => 'Present';

  @override
  String get parentReportLate => 'Late';

  @override
  String get parentReportAbsent => 'Absent';

  @override
  String parentReportThisMonth(String present, String total) {
    return 'This Month: $present of $total days present';
  }

  @override
  String get parentReportMathematics => 'Mathematics';

  @override
  String get parentReportEnglish => 'English';

  @override
  String get parentReportScience => 'Science';

  @override
  String get parentReportHistory => 'History';

  @override
  String get parentMeetingBack => 'Back';

  @override
  String get parentMeetingScheduleCounselor => 'Schedule Counselor Meeting';

  @override
  String get parentMeetingScheduleTeacher => 'Schedule Teacher Meeting';

  @override
  String get parentMeetingCounselorMeeting => 'Counselor Meeting';

  @override
  String get parentMeetingParentTeacherConference =>
      'Parent-Teacher Conference';

  @override
  String get parentMeetingCounselorDescription =>
      'Discuss guidance and academic planning';

  @override
  String get parentMeetingTeacherDescription =>
      'Discuss student progress and performance';

  @override
  String get parentMeetingSelectStudent => 'Select Student';

  @override
  String get parentMeetingNoChildren =>
      'No children added. Please add children to schedule meetings.';

  @override
  String get parentMeetingSelectCounselor => 'Select Counselor';

  @override
  String get parentMeetingSelectTeacher => 'Select Teacher';

  @override
  String get parentMeetingNoCounselors =>
      'No counselors available at this time.';

  @override
  String get parentMeetingNoTeachers => 'No teachers available at this time.';

  @override
  String get parentMeetingCounselor => 'Counselor';

  @override
  String get parentMeetingTeacher => 'Teacher';

  @override
  String get parentMeetingSelectDateTime => 'Select Date & Time';

  @override
  String get parentMeetingDate => 'Date';

  @override
  String get parentMeetingSelectDate => 'Select date';

  @override
  String get parentMeetingTime => 'Time';

  @override
  String get parentMeetingSelectTime => 'Select time';

  @override
  String get parentMeetingMode => 'Meeting Mode';

  @override
  String get parentMeetingVideoCall => 'Video Call';

  @override
  String get parentMeetingInPerson => 'In Person';

  @override
  String get parentMeetingPhone => 'Phone';

  @override
  String get parentMeetingDuration => 'Duration';

  @override
  String get parentMeetingDurationLabel => 'Meeting duration';

  @override
  String get parentMeeting15Min => '15 minutes';

  @override
  String get parentMeeting30Min => '30 minutes';

  @override
  String get parentMeeting45Min => '45 minutes';

  @override
  String get parentMeeting1Hour => '1 hour';

  @override
  String get parentMeeting1Point5Hours => '1.5 hours';

  @override
  String get parentMeeting2Hours => '2 hours';

  @override
  String get parentMeetingSubject => 'Meeting Subject';

  @override
  String get parentMeetingSubjectLabel => 'Subject';

  @override
  String get parentMeetingSubjectHint => 'e.g., Math progress discussion';

  @override
  String get parentMeetingAdditionalNotes => 'Additional Notes (Optional)';

  @override
  String get parentMeetingNotesLabel => 'Notes';

  @override
  String get parentMeetingNotesHint => 'Any additional information...';

  @override
  String get parentMeetingRequesting => 'Requesting...';

  @override
  String get parentMeetingRequestMeeting => 'Request Meeting';

  @override
  String get parentMeetingRequestSent => 'Meeting Request Sent';

  @override
  String parentMeetingRequestSentDescription(String staffName) {
    return 'Your meeting request has been sent to $staffName. You will be notified once they respond.';
  }

  @override
  String get parentMeetingOk => 'OK';

  @override
  String get parentMeetingRequestFailed =>
      'Failed to request meeting. Please try again.';

  @override
  String get parentMeetingError => 'Error';

  @override
  String get counselorMeetingBack => 'Back';

  @override
  String get counselorMeetingRefresh => 'Refresh';

  @override
  String get counselorMeetingManageAvailability => 'Manage Availability';

  @override
  String get counselorMeetingWeeklyAvailability => 'Weekly Availability';

  @override
  String get counselorMeetingSetAvailableHours =>
      'Set your available hours for parent meetings';

  @override
  String get counselorMeetingAddAvailabilitySlot => 'Add Availability Slot';

  @override
  String get counselorMeetingAddNewAvailability => 'Add New Availability';

  @override
  String get counselorMeetingDayOfWeek => 'Day of Week';

  @override
  String get counselorMeetingStartTime => 'Start Time';

  @override
  String get counselorMeetingEndTime => 'End Time';

  @override
  String counselorMeetingStartWithTime(String time) {
    return 'Start: $time';
  }

  @override
  String counselorMeetingEndWithTime(String time) {
    return 'End: $time';
  }

  @override
  String get counselorMeetingCancel => 'Cancel';

  @override
  String get counselorMeetingSave => 'Save';

  @override
  String get counselorMeetingNotAvailable => 'Not available';

  @override
  String get counselorMeetingInactive => 'Inactive';

  @override
  String get counselorMeetingDeactivate => 'Deactivate';

  @override
  String get counselorMeetingActivate => 'Activate';

  @override
  String get counselorMeetingDelete => 'Delete';

  @override
  String get counselorMeetingAvailabilityAdded =>
      'Availability added successfully';

  @override
  String get counselorMeetingFailedToAddAvailability =>
      'Failed to add availability';

  @override
  String get counselorMeetingSlotDeactivated => 'Slot deactivated';

  @override
  String get counselorMeetingSlotActivated => 'Slot activated';

  @override
  String get counselorMeetingFailedToUpdateAvailability =>
      'Failed to update availability';

  @override
  String get counselorMeetingDeleteAvailability => 'Delete Availability';

  @override
  String counselorMeetingConfirmDeleteSlot(String dayName) {
    return 'Are you sure you want to delete the $dayName slot?';
  }

  @override
  String get counselorMeetingAvailabilityDeleted =>
      'Availability deleted successfully';

  @override
  String get counselorMeetingFailedToDeleteAvailability =>
      'Failed to delete availability';

  @override
  String get counselorMeetingSunday => 'Sunday';

  @override
  String get counselorMeetingMonday => 'Monday';

  @override
  String get counselorMeetingTuesday => 'Tuesday';

  @override
  String get counselorMeetingWednesday => 'Wednesday';

  @override
  String get counselorMeetingThursday => 'Thursday';

  @override
  String get counselorMeetingFriday => 'Friday';

  @override
  String get counselorMeetingSaturday => 'Saturday';

  @override
  String get counselorMeetingRequests => 'Meeting Requests';

  @override
  String get counselorMeetingPending => 'Pending';

  @override
  String get counselorMeetingToday => 'Today';

  @override
  String get counselorMeetingUpcoming => 'Upcoming';

  @override
  String get counselorMeetingNoPendingRequests => 'No Pending Requests';

  @override
  String get counselorMeetingNoPendingRequestsMessage =>
      'You have no meeting requests at this time.';

  @override
  String get counselorMeetingNoMeetingsToday => 'No Meetings Today';

  @override
  String get counselorMeetingNoMeetingsTodayMessage =>
      'You have no scheduled meetings for today.';

  @override
  String get counselorMeetingNoUpcomingMeetings => 'No Upcoming Meetings';

  @override
  String get counselorMeetingNoUpcomingMeetingsMessage =>
      'You have no scheduled meetings.';

  @override
  String get counselorMeetingParent => 'Parent';

  @override
  String get counselorMeetingUnknown => 'Unknown';

  @override
  String counselorMeetingStudentLabel(String name) {
    return 'Student: $name';
  }

  @override
  String get counselorMeetingPendingBadge => 'PENDING';

  @override
  String counselorMeetingRequested(String dateTime) {
    return 'Requested: $dateTime';
  }

  @override
  String counselorMeetingMinutes(String count) {
    return '$count minutes';
  }

  @override
  String get counselorMeetingDecline => 'Decline';

  @override
  String get counselorMeetingApprove => 'Approve';

  @override
  String get counselorMeetingSoon => 'Soon';

  @override
  String get counselorMeetingCancelMeeting => 'Cancel Meeting';

  @override
  String counselorMeetingTimeWithDuration(String time, String minutes) {
    return '$time ($minutes min)';
  }

  @override
  String get counselorMeetingApproveMeeting => 'Approve Meeting';

  @override
  String counselorMeetingApproveWith(String parentName) {
    return 'Approve meeting with $parentName';
  }

  @override
  String get counselorMeetingSelectDate => 'Select Date';

  @override
  String get counselorMeetingSelectTime => 'Select Time';

  @override
  String get counselorMeetingDuration => 'Duration';

  @override
  String get counselorMeeting1Hour => '1 hour';

  @override
  String get counselorMeeting1Point5Hours => '1.5 hours';

  @override
  String get counselorMeeting2Hours => '2 hours';

  @override
  String get counselorMeetingMeetingLink => 'Meeting Link';

  @override
  String get counselorMeetingLocation => 'Location';

  @override
  String get counselorMeetingLocationHint => 'Room 101, Main Building';

  @override
  String get counselorMeetingNotesOptional => 'Notes (Optional)';

  @override
  String get counselorMeetingApprovedSuccessfully =>
      'Meeting approved successfully';

  @override
  String get counselorMeetingFailedToApprove => 'Failed to approve meeting';

  @override
  String get counselorMeetingDeclineMeeting => 'Decline Meeting';

  @override
  String counselorMeetingDeclineFrom(String parentName) {
    return 'Decline meeting request from $parentName?';
  }

  @override
  String get counselorMeetingReasonForDeclining => 'Reason for declining';

  @override
  String get counselorMeetingProvideReason => 'Please provide a reason...';

  @override
  String get counselorMeetingPleaseProvideReason =>
      'Please provide a reason for declining';

  @override
  String get counselorMeetingDeclined => 'Meeting declined';

  @override
  String get counselorMeetingFailedToDecline => 'Failed to decline meeting';

  @override
  String counselorMeetingCancelWith(String parentName) {
    return 'Cancel this meeting with $parentName?';
  }

  @override
  String get counselorMeetingCancellationReasonOptional =>
      'Cancellation reason (Optional)';

  @override
  String get counselorMeetingBackButton => 'Back';

  @override
  String get counselorMeetingCancelled => 'Meeting cancelled';

  @override
  String get counselorMeetingFailedToCancel => 'Failed to cancel meeting';

  @override
  String get counselorSessionPleaseSelectStudent => 'Please select a student';

  @override
  String get counselorSessionScheduledSuccessfully =>
      'Session scheduled successfully!';

  @override
  String counselorSessionErrorScheduling(String error) {
    return 'Error scheduling session: $error';
  }

  @override
  String get counselorSessionScheduleSession => 'Schedule Session';

  @override
  String get counselorSessionSave => 'SAVE';

  @override
  String get counselorSessionStudent => 'Student';

  @override
  String get counselorSessionNoStudentsFound =>
      'No students found. Please add students first.';

  @override
  String get counselorSessionSelectStudent => 'Select a student';

  @override
  String get counselorSessionTitle => 'Session Title';

  @override
  String get counselorSessionTitleHint => 'e.g., Career Planning Discussion';

  @override
  String get counselorSessionPleaseEnterTitle => 'Please enter a session title';

  @override
  String get counselorSessionType => 'Session Type';

  @override
  String get counselorSessionDate => 'Date';

  @override
  String get counselorSessionTime => 'Time';

  @override
  String get counselorSessionDuration => 'Duration';

  @override
  String counselorSessionDurationMin(String count) {
    return '$count min';
  }

  @override
  String get counselorSessionLocation => 'Location';

  @override
  String get counselorSessionNotesOptional => 'Notes (Optional)';

  @override
  String get counselorSessionNotesHint =>
      'Add any additional notes or agenda items...';

  @override
  String get counselorSessionCancel => 'Cancel';

  @override
  String get counselorSessionSelectStudentDialog => 'Select Student';

  @override
  String counselorSessionGradeAndGpa(String grade, String gpa) {
    return '$grade • GPA: $gpa';
  }

  @override
  String get counselorSessionRetry => 'Retry';

  @override
  String get counselorSessionLoadingSessions => 'Loading sessions...';

  @override
  String counselorSessionTodayTab(String count) {
    return 'Today ($count)';
  }

  @override
  String counselorSessionUpcomingTab(String count) {
    return 'Upcoming ($count)';
  }

  @override
  String counselorSessionCompletedTab(String count) {
    return 'Completed ($count)';
  }

  @override
  String get counselorSessionNoSessionsTitle => 'No Sessions';

  @override
  String get counselorSessionNoSessionsToday =>
      'No sessions scheduled for today';

  @override
  String get counselorSessionNoUpcomingSessions => 'No upcoming sessions';

  @override
  String get counselorSessionNoCompletedSessions => 'No completed sessions yet';

  @override
  String get counselorSessionNoSessions => 'No sessions';

  @override
  String get counselorSessionStudentLabel => 'Student';

  @override
  String get counselorSessionDateTime => 'Date & Time';

  @override
  String get counselorSessionDurationLabel => 'Duration';

  @override
  String counselorSessionMinutesValue(String count) {
    return '$count minutes';
  }

  @override
  String get counselorSessionStatusLabel => 'Status';

  @override
  String get counselorSessionNotes => 'Notes';

  @override
  String get counselorSessionSummary => 'Summary';

  @override
  String get counselorSessionActionItems => 'Action Items';

  @override
  String get counselorSessionStartSession => 'Start Session';

  @override
  String get counselorSessionCancelSession => 'Cancel Session';

  @override
  String get counselorSessionIndividualCounseling => 'Individual Counseling';

  @override
  String get counselorSessionGroupSession => 'Group Session';

  @override
  String get counselorSessionCareerCounseling => 'Career Counseling';

  @override
  String get counselorSessionAcademicAdvising => 'Academic Advising';

  @override
  String get counselorSessionPersonalCounseling => 'Personal Counseling';

  @override
  String counselorSessionStartSessionWith(String studentName) {
    return 'Start counseling session with $studentName?';
  }

  @override
  String get counselorSessionStart => 'Start';

  @override
  String counselorSessionStarted(String studentName) {
    return 'Session with $studentName started';
  }

  @override
  String counselorSessionCancelSessionWith(String studentName) {
    return 'Cancel session with $studentName?';
  }

  @override
  String get counselorSessionReasonForCancellation =>
      'Reason for cancellation:';

  @override
  String get counselorSessionStudentUnavailable => 'Student unavailable';

  @override
  String get counselorSessionCounselorUnavailable => 'Counselor unavailable';

  @override
  String get counselorSessionRescheduled => 'Rescheduled';

  @override
  String get counselorSessionOther => 'Other';

  @override
  String get counselorSessionBack => 'Back';

  @override
  String counselorSessionCancelled(String studentName) {
    return 'Session with $studentName cancelled';
  }

  @override
  String get counselorSessionTodayBadge => 'TODAY';

  @override
  String get counselorSessionIndividual => 'Individual';

  @override
  String get counselorSessionGroup => 'Group';

  @override
  String get counselorSessionCareer => 'Career';

  @override
  String get counselorSessionAcademic => 'Academic';

  @override
  String get counselorSessionPersonal => 'Personal';

  @override
  String get counselorSessionScheduled => 'Scheduled';

  @override
  String get counselorSessionCompleted => 'Completed';

  @override
  String get counselorSessionCancelledStatus => 'Cancelled';

  @override
  String get counselorSessionNoShow => 'No Show';

  @override
  String get counselorStudentBack => 'Back';

  @override
  String get counselorStudentAddNotesComingSoon =>
      'Add notes feature coming soon';

  @override
  String get counselorStudentOverview => 'Overview';

  @override
  String get counselorStudentSessions => 'Sessions';

  @override
  String get counselorStudentNotes => 'Notes';

  @override
  String get counselorStudentScheduleSession => 'Schedule Session';

  @override
  String get counselorStudentAcademicPerformance => 'Academic Performance';

  @override
  String get counselorStudentGpa => 'GPA';

  @override
  String get counselorStudentInterests => 'Interests';

  @override
  String get counselorStudentStrengths => 'Strengths';

  @override
  String get counselorStudentAreasForGrowth => 'Areas for Growth';

  @override
  String get counselorStudentNoSessionsYet => 'No Sessions Yet';

  @override
  String get counselorStudentScheduleSessionPrompt =>
      'Schedule a session with this student';

  @override
  String get counselorStudentNoNotesYet => 'No Notes Yet';

  @override
  String get counselorStudentAddPrivateNotes =>
      'Add private notes about this student';

  @override
  String get counselorStudentAddNote => 'Add Note';

  @override
  String get counselorStudentIndividualCounseling => 'Individual Counseling';

  @override
  String get counselorStudentGroupSession => 'Group Session';

  @override
  String get counselorStudentCareerCounseling => 'Career Counseling';

  @override
  String get counselorStudentAcademicAdvising => 'Academic Advising';

  @override
  String get counselorStudentPersonalCounseling => 'Personal Counseling';

  @override
  String get counselorStudentScheduleFeatureComingSoon =>
      'Session scheduling feature will be implemented with calendar integration.';

  @override
  String get counselorStudentClose => 'Close';

  @override
  String get counselorStudentScheduled => 'Scheduled';

  @override
  String get counselorStudentCompleted => 'Completed';

  @override
  String get counselorStudentCancelled => 'Cancelled';

  @override
  String get counselorStudentNoShow => 'No Show';

  @override
  String get counselorStudentRetry => 'Retry';

  @override
  String get counselorStudentLoadingStudents => 'Loading students...';

  @override
  String get counselorStudentSearchStudents => 'Search students...';

  @override
  String get counselorStudentNoStudentsFound => 'No Students Found';

  @override
  String get counselorStudentTryAdjustingSearch => 'Try adjusting your search';

  @override
  String get counselorStudentNoStudentsAssigned => 'No students assigned yet';

  @override
  String counselorStudentGradeAndGpa(String grade, String gpa) {
    return '$grade • GPA: $gpa';
  }

  @override
  String counselorStudentSessionsCount(String count) {
    return '$count sessions';
  }

  @override
  String get counselorStudentToday => 'Today';

  @override
  String get counselorStudentYesterday => 'Yesterday';

  @override
  String counselorStudentDaysAgo(String count) {
    return '${count}d ago';
  }

  @override
  String counselorStudentWeeksAgo(String count) {
    return '${count}w ago';
  }

  @override
  String get recRetry => 'Retry';

  @override
  String get recLoadingRequests => 'Loading requests...';

  @override
  String recTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String recTabPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String recTabInProgress(int count) {
    return 'In Progress ($count)';
  }

  @override
  String recTabCompleted(int count) {
    return 'Completed ($count)';
  }

  @override
  String get recNoPendingRequests => 'No pending recommendation requests';

  @override
  String get recNoLettersInProgress => 'No letters in progress';

  @override
  String get recNoCompletedRecommendations =>
      'No completed recommendations yet';

  @override
  String get recNoRecommendationRequests => 'No recommendation requests';

  @override
  String get recNoRequests => 'No Requests';

  @override
  String get recStudent => 'Student';

  @override
  String get recInstitution => 'Institution';

  @override
  String get recOverdue => 'Overdue!';

  @override
  String get recDueToday => 'Due today';

  @override
  String recDaysLeft(int count) {
    return '$count days left';
  }

  @override
  String get recUrgent => 'URGENT';

  @override
  String get recStatusOverdue => 'OVERDUE';

  @override
  String get recStatusPending => 'PENDING';

  @override
  String get recStatusAccepted => 'ACCEPTED';

  @override
  String get recStatusInProgress => 'IN PROGRESS';

  @override
  String get recStatusCompleted => 'COMPLETED';

  @override
  String get recStatusDeclined => 'DECLINED';

  @override
  String get recStatusCancelled => 'CANCELLED';

  @override
  String get recRecommendationLetter => 'Recommendation Letter';

  @override
  String get recSaveDraft => 'Save Draft';

  @override
  String recApplyingTo(String institution) {
    return 'Applying to $institution';
  }

  @override
  String get recPurpose => 'Purpose';

  @override
  String get recType => 'Type';

  @override
  String get recDeadline => 'Deadline';

  @override
  String get recStatus => 'Status';

  @override
  String get recMessageFromStudent => 'Message from Student';

  @override
  String get recAchievements => 'Achievements';

  @override
  String get recDecline => 'Decline';

  @override
  String get recAccept => 'Accept';

  @override
  String get recQuickStartTemplates => 'Quick Start Templates';

  @override
  String get recProfessionalTemplate => 'Professional Template';

  @override
  String get recProfessionalTemplateDesc =>
      'Formal business-style recommendation';

  @override
  String get recAcademicTemplate => 'Academic Template';

  @override
  String get recAcademicTemplateDesc => 'Focus on academic achievements';

  @override
  String get recPersonalTemplate => 'Personal Template';

  @override
  String get recPersonalTemplateDesc => 'Emphasize personal qualities';

  @override
  String get recWriteHint =>
      'Write your recommendation here or use a template above...';

  @override
  String get recPleaseWriteRecommendation => 'Please write a recommendation';

  @override
  String get recMinCharacters =>
      'Recommendation should be at least 100 characters';

  @override
  String get recSubmitRecommendation => 'Submit Recommendation';

  @override
  String get recTheStudent => 'the student';

  @override
  String get recYourInstitution => 'your institution';

  @override
  String get recRequestAccepted =>
      'Request accepted! You can now write the letter.';

  @override
  String get recFailedToAcceptRequest => 'Failed to accept request';

  @override
  String recErrorAcceptingRequest(String error) {
    return 'Error accepting request: $error';
  }

  @override
  String get recDeclineRequest => 'Decline Request';

  @override
  String get recDeclineReason =>
      'Please provide a reason for declining this request.';

  @override
  String get recReasonLabel => 'Reason';

  @override
  String get recReasonHint => 'Enter at least 10 characters';

  @override
  String get recCancel => 'Cancel';

  @override
  String get recReasonMinCharacters => 'Reason must be at least 10 characters';

  @override
  String get recRequestDeclined => 'Request declined';

  @override
  String get recFailedToDeclineRequest => 'Failed to decline request';

  @override
  String recErrorDecliningRequest(String error) {
    return 'Error declining request: $error';
  }

  @override
  String get recLetterMinCharacters =>
      'Letter content must be at least 100 characters';

  @override
  String get recDraftSaved => 'Draft saved successfully';

  @override
  String recErrorSavingDraft(String error) {
    return 'Error saving draft: $error';
  }

  @override
  String get recSubmitConfirmTitle => 'Submit Recommendation?';

  @override
  String get recSubmitConfirmMessage =>
      'Once submitted, you will not be able to edit this recommendation. Are you sure you want to submit?';

  @override
  String get recSubmit => 'Submit';

  @override
  String get recSubmittedSuccessfully =>
      'Recommendation submitted successfully!';

  @override
  String get recFailedToSubmit => 'Failed to submit recommendation';

  @override
  String recErrorSubmitting(String error) {
    return 'Error submitting recommendation: $error';
  }

  @override
  String get notifPrefTitle => 'Notification Preferences';

  @override
  String get notifPrefDefaultCreated =>
      'Default notification preferences created successfully!';

  @override
  String notifPrefErrorCreating(String error) {
    return 'Error creating preferences: $error';
  }

  @override
  String get notifPrefNotFound => 'No notification preferences found';

  @override
  String get notifPrefCreateDefaults => 'Create Default Preferences';

  @override
  String get notifPrefWaitingAuth => 'Waiting for authentication...';

  @override
  String get notifPrefSettings => 'Notification Settings';

  @override
  String get notifPrefDescription =>
      'Control which notifications you want to receive. Changes are saved automatically.';

  @override
  String get notifPrefCollegeApplications => 'College Applications';

  @override
  String get notifPrefAcademic => 'Academic';

  @override
  String get notifPrefCommunication => 'Communication';

  @override
  String get notifPrefMeetingsEvents => 'Meetings & Events';

  @override
  String get notifPrefAchievements => 'Achievements';

  @override
  String get notifPrefSystem => 'System';

  @override
  String notifPrefErrorLoading(String error) {
    return 'Error loading preferences: $error';
  }

  @override
  String get notifPrefRetry => 'Retry';

  @override
  String get notifPrefEmail => 'Email';

  @override
  String get notifPrefPush => 'Push';

  @override
  String get notifPrefSoon => '(soon)';

  @override
  String get notifPrefDescApplicationStatus =>
      'Get notified when your application status changes';

  @override
  String get notifPrefDescGradePosted =>
      'Receive notifications when new grades are posted';

  @override
  String get notifPrefDescMessageReceived => 'Get notified about new messages';

  @override
  String get notifPrefDescMeetingScheduled =>
      'Receive notifications for scheduled meetings';

  @override
  String get notifPrefDescMeetingReminder =>
      'Get reminders before your meetings';

  @override
  String get notifPrefDescAchievementEarned =>
      'Celebrate when you earn new achievements';

  @override
  String get notifPrefDescDeadlineReminder =>
      'Get reminded about upcoming deadlines';

  @override
  String get notifPrefDescRecommendationReady =>
      'Receive notifications for new recommendations';

  @override
  String get notifPrefDescSystemAnnouncement =>
      'Stay updated with system announcements';

  @override
  String get notifPrefDescCommentReceived =>
      'Get notified when someone comments on your posts';

  @override
  String get notifPrefDescMention =>
      'Receive notifications when you are mentioned';

  @override
  String get notifPrefDescEventReminder =>
      'Get reminders about upcoming events';

  @override
  String get notifPrefDescApprovalNew =>
      'Get notified about new approval requests';

  @override
  String get notifPrefDescApprovalActionNeeded =>
      'Receive reminders about pending approval actions';

  @override
  String get notifPrefDescApprovalStatusChanged =>
      'Get notified when your request status changes';

  @override
  String get notifPrefDescApprovalEscalated =>
      'Receive notifications when requests are escalated to you';

  @override
  String get notifPrefDescApprovalExpiring =>
      'Get reminders about expiring approval requests';

  @override
  String get notifPrefDescApprovalComment =>
      'Get notified about new comments on requests';

  @override
  String get notifPrefUpdated => 'Preferences updated';

  @override
  String notifPrefErrorUpdating(String error) {
    return 'Error updating preferences: $error';
  }

  @override
  String get biometricSetupTitle => 'Setup Biometric';

  @override
  String get biometricSettingsTitle => 'Biometric Settings';

  @override
  String biometricErrorChecking(String error) {
    return 'Error checking biometrics: $error';
  }

  @override
  String get biometricEnabledSuccess =>
      'Biometric authentication enabled successfully';

  @override
  String get biometricAuthFailed => 'Authentication failed. Please try again.';

  @override
  String biometricError(String error) {
    return 'Error: $error';
  }

  @override
  String get biometricDisabledSuccess => 'Biometric authentication disabled';

  @override
  String get biometricEnableLogin => 'Enable Biometric Login';

  @override
  String get biometricAuthentication => 'Biometric Authentication';

  @override
  String biometricUseType(String type) {
    return 'Use $type';
  }

  @override
  String get biometricEnabled => 'Enabled';

  @override
  String get biometricDisabled => 'Disabled';

  @override
  String get biometricWhyUse => 'Why use biometric?';

  @override
  String get biometricBenefitFaster => 'Faster login experience';

  @override
  String get biometricBenefitSecure => 'More secure than passwords';

  @override
  String get biometricBenefitUnique => 'Unique to you - cannot be copied';

  @override
  String get biometricSecurityNote => 'Security Note';

  @override
  String get biometricSecurityNoteDesc =>
      'Your biometric data stays on your device and is never shared with Flow or third parties.';

  @override
  String get biometricSkipForNow => 'Skip for now';

  @override
  String get biometricNotSupported => 'Not Supported';

  @override
  String get biometricNotSupportedDesc =>
      'Your device does not support biometric authentication.';

  @override
  String get biometricGoBack => 'Go Back';

  @override
  String get biometricNotEnrolled => 'No Biometrics Enrolled';

  @override
  String get biometricNotEnrolledDesc =>
      'Please enroll your fingerprint or face ID in your device settings first.';

  @override
  String get biometricOpenSettingsHint =>
      'Please open Settings > Security > Biometrics';

  @override
  String get biometricOpenSettings => 'Open Settings';

  @override
  String get biometricTypeFace => 'Face ID';

  @override
  String get biometricTypeFingerprint => 'Fingerprint';

  @override
  String get biometricTypeIris => 'Iris Recognition';

  @override
  String get biometricTypeGeneric => 'Biometric';

  @override
  String biometricDescEnabled(String type) {
    return 'Your $type is currently being used to secure your account. You can sign in quickly and securely.';
  }

  @override
  String biometricDescDisabled(String type) {
    return 'Use your $type to sign in quickly and securely without entering your password.';
  }

  @override
  String get adminChatDashTitle => 'Chatbot Dashboard';

  @override
  String get adminChatDashSubtitle => 'Monitor and manage chatbot interactions';

  @override
  String get adminChatDashRefresh => 'Refresh';

  @override
  String get adminChatDashTotalConversations => 'Total Conversations';

  @override
  String get adminChatDashActiveNow => 'Active Now';

  @override
  String get adminChatDashTotalMessages => 'Total Messages';

  @override
  String get adminChatDashAvgMessagesPerChat => 'Avg Messages/Chat';

  @override
  String get adminChatDashQuickActions => 'Quick Actions';

  @override
  String get adminChatDashManageFaqs => 'Manage FAQs';

  @override
  String get adminChatDashManageFaqsDesc =>
      'Create and organize frequently asked questions';

  @override
  String get adminChatDashConversationHistory => 'Conversation History';

  @override
  String get adminChatDashConversationHistoryDesc =>
      'Browse and review past conversations';

  @override
  String get adminChatDashSupportQueue => 'Support Queue';

  @override
  String get adminChatDashSupportQueueDesc =>
      'Review escalated conversations needing attention';

  @override
  String get adminChatDashLiveMonitoring => 'Live Monitoring';

  @override
  String get adminChatDashLiveMonitoringDesc =>
      'Monitor active chatbot conversations in real-time';

  @override
  String get adminChatDashRecentConversations => 'Recent Conversations';

  @override
  String get adminChatDashViewAll => 'View All';

  @override
  String get adminChatDashNoConversations => 'No conversations yet';

  @override
  String get adminChatDashNoConversationsDesc =>
      'Chatbot conversations will appear here once users start interacting';

  @override
  String adminChatDashMessagesCount(int count) {
    return '$count messages';
  }

  @override
  String get adminChatDashStatusActive => 'Active';

  @override
  String get adminChatDashStatusArchived => 'Archived';

  @override
  String get adminChatDashStatusFlagged => 'Flagged';

  @override
  String get adminChatDashJustNow => 'Just now';

  @override
  String adminChatDashMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String adminChatDashHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String adminChatDashDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get adminFeeConfigTitle => 'Fee Configuration';

  @override
  String get adminFeeConfigSubtitle => 'Manage platform fees and pricing';

  @override
  String get adminFeeConfigUnsavedChanges => 'Unsaved changes';

  @override
  String get adminFeeConfigReset => 'Reset';

  @override
  String get adminFeeConfigSaveChanges => 'Save Changes';

  @override
  String get adminFeeConfigSavedSuccess =>
      'Fee configuration saved successfully';

  @override
  String get adminFeeConfigFeeSummary => 'Fee Summary';

  @override
  String get adminFeeConfigCategoriesActive => 'categories active';

  @override
  String get adminFeeConfigActiveFees => 'Active Fees';

  @override
  String get adminFeeConfigAvgRate => 'Avg Rate';

  @override
  String get adminFeeConfigDisabled => 'Disabled';

  @override
  String get adminFeeConfigPercentage => 'Percentage';

  @override
  String get adminFeeConfigFixedAmount => 'Fixed Amount';

  @override
  String get adminFeeConfigExample => 'Example on KES 10,000';

  @override
  String get adminSettingsTitle => 'Settings';

  @override
  String get adminSettingsSubtitle =>
      'Manage your account and system preferences';

  @override
  String get adminSettingsProfile => 'Profile';

  @override
  String get adminSettingsDefaultUser => 'Admin';

  @override
  String get adminSettingsEdit => 'Edit';

  @override
  String get adminSettingsRole => 'Role';

  @override
  String get adminSettingsSuperAdmin => 'Super Admin';

  @override
  String get adminSettingsNotifications => 'Notifications';

  @override
  String get adminSettingsEmailNotifications => 'Email Notifications';

  @override
  String get adminSettingsEmailNotificationsDesc =>
      'Receive important updates via email';

  @override
  String get adminSettingsPushNotifications => 'Push Notifications';

  @override
  String get adminSettingsPushNotificationsDesc =>
      'Get real-time push notifications on your device';

  @override
  String get adminSettingsUserActivityAlerts => 'User Activity Alerts';

  @override
  String get adminSettingsUserActivityAlertsDesc =>
      'Get notified about unusual user activity';

  @override
  String get adminSettingsSystemAlerts => 'System Alerts';

  @override
  String get adminSettingsSystemAlertsDesc =>
      'Receive alerts about system health and issues';

  @override
  String get adminSettingsDisplay => 'Display';

  @override
  String get adminSettingsDarkMode => 'Dark Mode';

  @override
  String get adminSettingsDarkModeDesc => 'Switch to a darker color scheme';

  @override
  String get adminSettingsLanguage => 'Language';

  @override
  String get adminSettingsLangEnglish => 'English';

  @override
  String get adminSettingsLangSwahili => 'Swahili';

  @override
  String get adminSettingsLangFrench => 'French';

  @override
  String get adminSettingsTimezone => 'Timezone';

  @override
  String get adminSettingsSecurity => 'Security';

  @override
  String get adminSettingsChangePassword => 'Change Password';

  @override
  String get adminSettingsChangePasswordDesc => 'Update your account password';

  @override
  String get adminSettingsTwoFactor => 'Two-Factor Authentication';

  @override
  String get adminSettingsTwoFactorDesc =>
      'Add an extra layer of security to your account';

  @override
  String get adminSettingsActiveSessions => 'Active Sessions';

  @override
  String get adminSettingsActiveSessionsDesc =>
      'View and manage your active login sessions';

  @override
  String get adminSettingsPrivacy => 'Privacy';

  @override
  String get adminSettingsActivityLogging => 'Activity Logging';

  @override
  String get adminSettingsActivityLoggingDesc =>
      'Log admin actions for audit purposes';

  @override
  String get adminSettingsAnalyticsTracking => 'Analytics Tracking';

  @override
  String get adminSettingsAnalyticsTrackingDesc =>
      'Help improve the platform with usage analytics';

  @override
  String get adminSettingsDownloadData => 'Download My Data';

  @override
  String get adminSettingsDownloadDataDesc => 'Export all your personal data';

  @override
  String get adminSettingsDangerZone => 'Danger Zone';

  @override
  String get adminSettingsSignOut => 'Sign Out';

  @override
  String get adminSettingsSignOutDesc => 'Sign out of your admin account';

  @override
  String get adminSettingsSignOutConfirm =>
      'Are you sure you want to sign out?';

  @override
  String get adminSettingsCancel => 'Cancel';

  @override
  String get adminSettingsDeleteAccount => 'Delete Account';

  @override
  String get adminSettingsDeleteAccountDesc =>
      'Permanently delete your account and all data';

  @override
  String get notifPrefScreenTitle => 'Notification Preferences';

  @override
  String get notifPrefScreenNoPreferences =>
      'No notification preferences found';

  @override
  String get notifPrefScreenCreateDefaults => 'Create Default Preferences';

  @override
  String get notifPrefScreenSettingsTitle => 'Notification Settings';

  @override
  String get notifPrefScreenDescription =>
      'Control which notifications you want to receive. Changes are saved automatically.';

  @override
  String get notifPrefScreenCollegeApplications => 'College Applications';

  @override
  String get notifPrefScreenAcademic => 'Academic';

  @override
  String get notifPrefScreenCommunication => 'Communication';

  @override
  String get notifPrefScreenMeetingsEvents => 'Meetings & Events';

  @override
  String get notifPrefScreenAchievements => 'Achievements';

  @override
  String get notifPrefScreenSystem => 'System';

  @override
  String get notifPrefScreenEmail => 'Email';

  @override
  String get notifPrefScreenPush => 'Push';

  @override
  String get notifPrefScreenSoon => '(soon)';

  @override
  String get notifPrefScreenErrorLoading => 'Error loading preferences';

  @override
  String get notifPrefScreenRetry => 'Retry';

  @override
  String get notifPrefScreenErrorCreating => 'Error creating preferences';

  @override
  String get notifPrefScreenErrorUpdating => 'Error updating preferences';

  @override
  String get notifPrefScreenPreferencesUpdated => 'Preferences updated';

  @override
  String get notifPrefScreenDescApplicationStatus =>
      'Get notified when your application status changes';

  @override
  String get notifPrefScreenDescGradePosted =>
      'Receive notifications when new grades are posted';

  @override
  String get notifPrefScreenDescMessageReceived =>
      'Get notified about new messages';

  @override
  String get notifPrefScreenDescMeetingScheduled =>
      'Receive notifications for scheduled meetings';

  @override
  String get notifPrefScreenDescMeetingReminder =>
      'Get reminders before your meetings';

  @override
  String get notifPrefScreenDescAchievementEarned =>
      'Celebrate when you earn new achievements';

  @override
  String get notifPrefScreenDescDeadlineReminder =>
      'Get reminded about upcoming deadlines';

  @override
  String get notifPrefScreenDescRecommendationReady =>
      'Receive notifications for new recommendations';

  @override
  String get notifPrefScreenDescSystemAnnouncement =>
      'Stay updated with system announcements';

  @override
  String get notifPrefScreenDescCommentReceived =>
      'Get notified when someone comments on your posts';

  @override
  String get notifPrefScreenDescMention =>
      'Receive notifications when you are mentioned';

  @override
  String get notifPrefScreenDescEventReminder =>
      'Get reminders about upcoming events';

  @override
  String get notifPrefScreenDescApprovalRequestNew =>
      'Get notified about new approval requests';

  @override
  String get notifPrefScreenDescApprovalRequestActionNeeded =>
      'Get notified when an approval request needs your action';

  @override
  String get notifPrefScreenDescApprovalRequestStatusChanged =>
      'Get notified when your approval request status changes';

  @override
  String get notifPrefScreenDescApprovalRequestEscalated =>
      'Get notified when an approval request is escalated';

  @override
  String get notifPrefScreenDescApprovalRequestExpiring =>
      'Get notified when an approval request is about to expire';

  @override
  String get notifPrefScreenDescApprovalRequestComment =>
      'Get notified about comments on approval requests';

  @override
  String get homeNavFeatures => 'Features';

  @override
  String get homeNavAbout => 'About';

  @override
  String get homeNavContact => 'Contact';

  @override
  String get homeNavLogin => 'Login';

  @override
  String get homeNavSignUp => 'Sign Up';

  @override
  String get homeNavAccountTypes => 'Account Types';

  @override
  String get homeNavStudents => 'Students';

  @override
  String get homeNavInstitutions => 'Institutions';

  @override
  String get homeNavParents => 'Parents';

  @override
  String get homeNavCounselors => 'Counselors';

  @override
  String get homeNavRecommenders => 'Recommenders';

  @override
  String get homeNavBadge => 'Africa\'s Premier EdTech Platform';

  @override
  String get homeNavWelcome => 'Welcome to Flow';

  @override
  String get homeNavSubtitle =>
      'Connect students, institutions, parents, counselors across Africa. Offline-first with mobile money.';

  @override
  String get homeNavGetStarted => 'Get Started';

  @override
  String get homeNavSignIn => 'Sign In';

  @override
  String get homeNavActiveUsers => 'Active Users';

  @override
  String get homeNavCountries => 'Countries';

  @override
  String get homeNavNew => 'NEW';

  @override
  String get homeNavFindYourPath => 'Find Your Path';

  @override
  String get homeNavFindYourPathDesc =>
      'Answer a few questions and get personalized university recommendations.';

  @override
  String get homeNavPersonalizedRec => 'Personalized Recommendations';

  @override
  String get homeNavTopUniversities => '12+ Top Universities';

  @override
  String get homeNavSmartMatching => 'Smart Matching Algorithm';

  @override
  String get homeNavStartNow => 'Start Now';

  @override
  String get homeNavPlatformFeatures => 'Platform Features';

  @override
  String get homeNavOfflineFirst => 'Offline-First Design';

  @override
  String get homeNavOfflineFirstDesc =>
      'Access your content even without internet connectivity';

  @override
  String get homeNavMobileMoney => 'Mobile Money Integration';

  @override
  String get homeNavMobileMoneyDesc =>
      'Pay with M-Pesa, MTN, and other mobile money services';

  @override
  String get homeNavMultiLang => 'Multi-Language Support';

  @override
  String get homeNavMultiLangDesc =>
      'Available in English, French, Swahili, and more';

  @override
  String get homeNavSecure => 'Secure & Private';

  @override
  String get homeNavSecureDesc => 'End-to-end encryption for all your data';

  @override
  String get homeNavUssd => 'USSD Support';

  @override
  String get homeNavUssdDesc =>
      'Access features via basic phones without internet';

  @override
  String get homeNavCloudSync => 'Cloud Sync';

  @override
  String get homeNavCloudSyncDesc =>
      'Automatically sync across all your devices';

  @override
  String get homeNavHowItWorks => 'How It Works';

  @override
  String get homeNavCreateAccount => 'Create Account';

  @override
  String get homeNavCreateAccountDesc =>
      'Sign up with your role - student, institution, parent, counselor, or recommender';

  @override
  String get homeNavAccessDashboard => 'Access Dashboard';

  @override
  String get homeNavAccessDashboardDesc =>
      'Get a personalized dashboard tailored to your needs';

  @override
  String get homeNavExploreFeatures => 'Explore Features';

  @override
  String get homeNavExploreFeaturesDesc =>
      'Browse courses, applications, or manage your responsibilities';

  @override
  String get homeNavAchieveGoals => 'Achieve Goals';

  @override
  String get homeNavAchieveGoalsDesc =>
      'Track progress, collaborate, and reach your educational objectives';

  @override
  String get homeNavTrustedAcrossAfrica => 'Trusted Across Africa';

  @override
  String get homeNavTestimonialRole1 => 'Student, University of Ghana';

  @override
  String get homeNavTestimonialQuote1 =>
      'Flow made my application process so much easier. I could track everything in one place!';

  @override
  String get homeNavTestimonialRole2 => 'Dean, Ashesi University';

  @override
  String get homeNavTestimonialQuote2 =>
      'Managing applications has never been this efficient. Flow is a game-changer for institutions.';

  @override
  String get homeNavTestimonialRole3 => 'Parent, Nigeria';

  @override
  String get homeNavTestimonialQuote3 =>
      'I can now monitor my children\'s academic progress even when I\'m traveling. Peace of mind!';

  @override
  String get homeNavWhoCanUse => 'Who Can Use Flow?';

  @override
  String get homeNavForStudents => 'For Students';

  @override
  String get homeNavForStudentsSubtitle => 'Your gateway to academic success';

  @override
  String get homeNavForStudentsDesc =>
      'Flow empowers students to take control of their educational journey with comprehensive tools designed for modern learners across Africa.';

  @override
  String get homeNavCourseAccess => 'Course Access';

  @override
  String get homeNavCourseAccessDesc =>
      'Browse and enroll in thousands of courses from top institutions across Africa';

  @override
  String get homeNavAppManagement => 'Application Management';

  @override
  String get homeNavAppManagementDesc =>
      'Apply to multiple institutions, track application status, and manage deadlines in one place';

  @override
  String get homeNavProgressTracking => 'Progress Tracking';

  @override
  String get homeNavProgressTrackingDesc =>
      'Monitor your academic progress with detailed analytics and performance insights';

  @override
  String get homeNavDocManagement => 'Document Management';

  @override
  String get homeNavDocManagementDesc =>
      'Store and share transcripts, certificates, and other academic documents securely';

  @override
  String get homeNavEasyPayments => 'Easy Payments';

  @override
  String get homeNavEasyPaymentsDesc =>
      'Pay tuition and fees using mobile money services like M-Pesa, MTN Money, and more';

  @override
  String get homeNavOfflineAccess => 'Offline Access';

  @override
  String get homeNavOfflineAccessDesc =>
      'Download course materials and access them without internet connectivity';

  @override
  String get homeNavForInstitutions => 'For Institutions';

  @override
  String get homeNavForInstitutionsSubtitle =>
      'Streamline admissions and student management';

  @override
  String get homeNavForInstitutionsDesc =>
      'Transform your institution\'s operations with powerful tools for admissions, student management, and program delivery.';

  @override
  String get homeNavApplicantMgmt => 'Applicant Management';

  @override
  String get homeNavApplicantMgmtDesc =>
      'Review, process, and track applications efficiently with automated workflows';

  @override
  String get homeNavProgramMgmt => 'Program Management';

  @override
  String get homeNavProgramMgmtDesc =>
      'Create and manage academic programs, set requirements, and track enrollments';

  @override
  String get homeNavAnalyticsDash => 'Analytics Dashboard';

  @override
  String get homeNavAnalyticsDashDesc =>
      'Get insights into application trends, student performance, and institutional metrics';

  @override
  String get homeNavCommHub => 'Communication Hub';

  @override
  String get homeNavCommHubDesc =>
      'Engage with students, parents, and staff through integrated messaging';

  @override
  String get homeNavDocVerification => 'Document Verification';

  @override
  String get homeNavDocVerificationDesc =>
      'Verify student documents and credentials securely';

  @override
  String get homeNavFinancialMgmt => 'Financial Management';

  @override
  String get homeNavFinancialMgmtDesc =>
      'Track payments, manage scholarships, and generate financial reports';

  @override
  String get homeNavForParents => 'For Parents';

  @override
  String get homeNavForParentsSubtitle =>
      'Stay connected to your child\'s education';

  @override
  String get homeNavForParentsDesc =>
      'Stay informed and engaged in your children\'s educational journey with real-time updates and comprehensive monitoring tools.';

  @override
  String get homeNavProgressMonitoring => 'Progress Monitoring';

  @override
  String get homeNavProgressMonitoringDesc =>
      'Track your children\'s academic performance, attendance, and achievements';

  @override
  String get homeNavRealtimeUpdates => 'Real-time Updates';

  @override
  String get homeNavRealtimeUpdatesDesc =>
      'Receive instant notifications about grades, assignments, and school events';

  @override
  String get homeNavTeacherComm => 'Teacher Communication';

  @override
  String get homeNavTeacherCommDesc =>
      'Connect directly with teachers and counselors about your child\'s progress';

  @override
  String get homeNavFeeMgmt => 'Fee Management';

  @override
  String get homeNavFeeMgmtDesc =>
      'View and pay school fees conveniently using mobile money';

  @override
  String get homeNavScheduleAccess => 'Schedule Access';

  @override
  String get homeNavScheduleAccessDesc =>
      'View class schedules, exam dates, and school calendar events';

  @override
  String get homeNavReportCards => 'Report Cards';

  @override
  String get homeNavReportCardsDesc =>
      'Access detailed report cards and performance summaries';

  @override
  String get homeNavForCounselors => 'For Counselors';

  @override
  String get homeNavForCounselorsSubtitle =>
      'Guide students to their best future';

  @override
  String get homeNavForCounselorsDesc =>
      'Empower your counseling practice with tools to manage sessions, track student progress, and provide personalized guidance.';

  @override
  String get homeNavSessionMgmt => 'Session Management';

  @override
  String get homeNavSessionMgmtDesc =>
      'Schedule, track, and document counseling sessions with students';

  @override
  String get homeNavStudentPortfolio => 'Student Portfolio';

  @override
  String get homeNavStudentPortfolioDesc =>
      'Maintain comprehensive profiles and notes for each student you counsel';

  @override
  String get homeNavActionPlans => 'Action Plans';

  @override
  String get homeNavActionPlansDesc =>
      'Create and monitor personalized action plans and goals for students';

  @override
  String get homeNavCollegeGuidance => 'College Guidance';

  @override
  String get homeNavCollegeGuidanceDesc =>
      'Help students explore programs and navigate the application process';

  @override
  String get homeNavCareerAssessment => 'Career Assessment';

  @override
  String get homeNavCareerAssessmentDesc =>
      'Provide career assessments and recommend suitable paths';

  @override
  String get homeNavParentCollab => 'Parent Collaboration';

  @override
  String get homeNavParentCollabDesc =>
      'Coordinate with parents to support student success';

  @override
  String get homeNavForRecommenders => 'For Recommenders';

  @override
  String get homeNavForRecommendersSubtitle =>
      'Support students with powerful recommendations';

  @override
  String get homeNavForRecommendersDesc =>
      'Write, manage, and submit recommendation letters efficiently while maintaining your professional network.';

  @override
  String get homeNavLetterMgmt => 'Letter Management';

  @override
  String get homeNavLetterMgmtDesc =>
      'Write, edit, and store recommendation letters with templates';

  @override
  String get homeNavEasySubmission => 'Easy Submission';

  @override
  String get homeNavEasySubmissionDesc =>
      'Submit recommendations directly to institutions securely';

  @override
  String get homeNavRequestTracking => 'Request Tracking';

  @override
  String get homeNavRequestTrackingDesc =>
      'Track all recommendation requests and deadlines in one place';

  @override
  String get homeNavLetterTemplates => 'Letter Templates';

  @override
  String get homeNavLetterTemplatesDesc =>
      'Use customizable templates to streamline your writing process';

  @override
  String get homeNavDigitalSignature => 'Digital Signature';

  @override
  String get homeNavDigitalSignatureDesc =>
      'Sign and verify letters digitally with secure authentication';

  @override
  String get homeNavStudentHistory => 'Student History';

  @override
  String get homeNavStudentHistoryDesc =>
      'Maintain records of students you\'ve recommended over time';

  @override
  String get homeNavReadyToStart => 'Ready to Get Started?';

  @override
  String get homeNavJoinThousands =>
      'Join thousands transforming education with Flow.';

  @override
  String get homeNavFlowEdTech => 'Flow EdTech';

  @override
  String get homeNavPrivacy => 'Privacy';

  @override
  String get homeNavTerms => 'Terms';

  @override
  String get homeNavCopyright => '© 2025 Flow EdTech';

  @override
  String get homeNavTop => 'Top';

  @override
  String homeNavGetStartedAs(String role) {
    return 'Get Started as $role';
  }

  @override
  String get homeNavForPrefix => 'For ';

  @override
  String get aboutPageTitle => 'About Flow';

  @override
  String get aboutPageFlowEdTech => 'Flow EdTech';

  @override
  String get aboutPagePremierPlatform => 'Africa\'s Premier Education Platform';

  @override
  String get aboutPageOurMission => 'Our Mission';

  @override
  String get aboutPageMissionContent =>
      'Flow is dedicated to transforming education across Africa by connecting students with universities, counselors, and resources they need to succeed.';

  @override
  String get aboutPageOurVision => 'Our Vision';

  @override
  String get aboutPageVisionContent =>
      'We envision a future where every African student has the tools, information, and support needed to achieve their educational dreams.';

  @override
  String get aboutPageOurStory => 'Our Story';

  @override
  String get aboutPageOurValues => 'Our Values';

  @override
  String get aboutPageGetInTouch => 'Get in Touch';

  @override
  String get privacyPageTitle => 'Privacy Policy';

  @override
  String get privacyPageLastUpdated => 'Last updated: January 2026';

  @override
  String get privacyPageSection1Title => '1. Information We Collect';

  @override
  String get privacyPageSection1Content =>
      'We collect information you provide directly to us, such as when you create an account, fill out a form, or communicate with us. This may include:\n\n- Personal information (name, email, phone number)\n- Educational information (grades, test scores, preferences)\n- Account credentials\n- Communication preferences\n- Usage data and analytics';

  @override
  String get privacyPageSection2Title => '2. How We Use Your Information';

  @override
  String get privacyPageSection2Content =>
      'We use the information we collect to:\n\n- Provide, maintain, and improve our services\n- Match you with suitable universities and programs\n- Send you relevant notifications and updates\n- Respond to your inquiries and support requests\n- Analyze usage patterns to improve user experience\n- Comply with legal obligations';

  @override
  String get privacyPageSection3Title => '3. Information Sharing';

  @override
  String get privacyPageSection3Content =>
      'We may share your information with:\n\n- Universities and institutions you express interest in\n- Counselors you choose to connect with\n- Parents/guardians (with your consent)\n- Service providers who assist our operations\n- Legal authorities when required by law\n\nWe do not sell your personal information to third parties.';

  @override
  String get privacyPageSection4Title => '4. Data Security';

  @override
  String get privacyPageSection4Content =>
      'We implement industry-standard security measures to protect your data:\n\n- Encryption of data in transit and at rest\n- Regular security audits and assessments\n- Access controls and authentication\n- Secure data centers with SOC 2 compliance';

  @override
  String get privacyPageSection5Title => '5. Your Rights';

  @override
  String get privacyPageSection5Content =>
      'You have the right to:\n\n- Access your personal data\n- Correct inaccurate information\n- Delete your account and data\n- Export your data in a portable format\n- Opt out of marketing communications\n- Withdraw consent at any time';

  @override
  String get privacyPageSection6Title => '6. Contact Us';

  @override
  String get privacyPageSection6Content =>
      'If you have questions about this privacy policy, please contact us at:\n\nEmail: privacy@flowedtech.com\nAddress: Accra, Ghana';

  @override
  String get privacyPageContactTeam => 'Contact Privacy Team';

  @override
  String privacyPageLastUpdatedLabel(String date) {
    return 'Last updated: $date';
  }

  @override
  String get termsPageTitle => 'Terms of Service';

  @override
  String get termsPageLastUpdated => 'Last updated: January 2026';

  @override
  String get termsPageSection1Title => '1. Acceptance of Terms';

  @override
  String get termsPageSection1Content =>
      'By accessing or using Flow EdTech (\"the Service\"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our Service.';

  @override
  String get termsPageSection2Title => '2. User Accounts';

  @override
  String get termsPageSection2Content =>
      'To use certain features, you must create an account. You agree to provide accurate and complete information, maintain the security of your account credentials, and take responsibility for all activities under your account.';

  @override
  String get termsPageSection3Title => '3. User Conduct';

  @override
  String get termsPageSection3Content =>
      'You agree not to use the Service for any unlawful purpose, harass other users, submit false information, or attempt to gain unauthorized access to systems.';

  @override
  String get termsPageSection4Title => '4. Limitation of Liability';

  @override
  String get termsPageSection4Content =>
      'THE SERVICE IS PROVIDED \"AS IS\" WITHOUT WARRANTIES OF ANY KIND. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED.';

  @override
  String get termsPageSection5Title => '5. Contact';

  @override
  String get termsPageSection5Content =>
      'For questions about these terms, contact us at: legal@flowedtech.com';

  @override
  String get termsPageAgreement => 'By using Flow, you agree to these terms';

  @override
  String get contactPageTitle => 'Contact Us';

  @override
  String get contactPageGetInTouch => 'Get in Touch';

  @override
  String get contactPageSubtitle =>
      'Have questions? We\'d love to hear from you.';

  @override
  String get contactPageEmail => 'Email';

  @override
  String get contactPageEmailValue => 'support@flowedtech.com';

  @override
  String get contactPageEmailReply => 'We reply within 24 hours';

  @override
  String get contactPageOffice => 'Office';

  @override
  String get contactPageOfficeValue => 'Accra, Ghana';

  @override
  String get contactPageOfficeRegion => 'West Africa';

  @override
  String get contactPageHours => 'Hours';

  @override
  String get contactPageHoursValue => 'Mon - Fri: 9AM - 6PM';

  @override
  String get contactPageHoursTimezone => 'GMT timezone';

  @override
  String get contactPageSendMessage => 'Send us a message';

  @override
  String get contactPageYourName => 'Your Name';

  @override
  String get contactPageEmailAddress => 'Email Address';

  @override
  String get contactPageSubject => 'Subject';

  @override
  String get contactPageMessage => 'Message';

  @override
  String get contactPageSendButton => 'Send Message';

  @override
  String get contactPageNameRequired => 'Please enter your name';

  @override
  String get contactPageEmailRequired => 'Please enter your email';

  @override
  String get contactPageEmailInvalid => 'Please enter a valid email';

  @override
  String get contactPageSubjectRequired => 'Please enter a subject';

  @override
  String get contactPageMessageRequired => 'Please enter your message';

  @override
  String get contactPageSuccessMessage =>
      'Thank you for your message! We will get back to you soon.';

  @override
  String get blogPageTitle => 'Flow Blog';

  @override
  String get blogPageSubtitle =>
      'Insights, tips, and stories about education in Africa';

  @override
  String get blogPageCategories => 'Categories';

  @override
  String get blogPageAll => 'All';

  @override
  String get blogPageRecentPosts => 'Recent Posts';

  @override
  String get blogPageFeatured => 'Featured';

  @override
  String get blogPageSubscribeTitle => 'Subscribe to Our Newsletter';

  @override
  String get blogPageSubscribeSubtitle =>
      'Get the latest articles and resources delivered to your inbox';

  @override
  String get blogPageEnterEmail => 'Enter your email';

  @override
  String get blogPageSubscribeButton => 'Subscribe';

  @override
  String get careersPageTitle => 'Careers';

  @override
  String get careersPageJoinMission => 'Join Our Mission';

  @override
  String get careersPageHeroSubtitle =>
      'Help us transform education across Africa';

  @override
  String get careersPageWhyJoin => 'Why Join Flow?';

  @override
  String get careersPageGlobalImpact => 'Global Impact';

  @override
  String get careersPageGlobalImpactDesc =>
      'Work on solutions that affect millions of students across Africa';

  @override
  String get careersPageGrowth => 'Growth';

  @override
  String get careersPageGrowthDesc =>
      'Continuous learning and career development opportunities';

  @override
  String get careersPageGreatTeam => 'Great Team';

  @override
  String get careersPageGreatTeamDesc =>
      'Collaborate with passionate and talented individuals';

  @override
  String get careersPageFlexibility => 'Flexibility';

  @override
  String get careersPageFlexibilityDesc =>
      'Remote-friendly culture with flexible working hours';

  @override
  String get careersPageOpenPositions => 'Open Positions';

  @override
  String get careersPageApply => 'Apply';

  @override
  String get careersPageNoFit => 'Don\'t see a perfect fit?';

  @override
  String get careersPageNoFitDesc =>
      'We\'re always looking for talented individuals. Send your resume to careers@flowedtech.com';

  @override
  String get careersPageContactUs => 'Contact Us';

  @override
  String get communityPageTitle => 'Join Our Community';

  @override
  String get communityPageSubtitle =>
      'Connect with students, counselors, and educators';

  @override
  String get communityPageMembers => 'Members';

  @override
  String get communityPageGroups => 'Groups';

  @override
  String get communityPageDiscussions => 'Discussions';

  @override
  String get communityPageFeaturedGroups => 'Featured Groups';

  @override
  String get communityPagePopularDiscussions => 'Popular Discussions';

  @override
  String get communityPageUpcomingEvents => 'Upcoming Events';

  @override
  String get communityPageAttending => 'attending';

  @override
  String get communityPageJoin => 'Join';

  @override
  String get communityPageReadyToJoin => 'Ready to Join?';

  @override
  String get communityPageCreateAccount =>
      'Create an account to join the community';

  @override
  String get communityPageSignUpFree => 'Sign Up Free';

  @override
  String communityPageBy(String author) {
    return 'by $author';
  }

  @override
  String get compliancePageTitle => 'Compliance';

  @override
  String get compliancePageHeadline => 'Compliance & Certifications';

  @override
  String get compliancePageSubtitle =>
      'Our commitment to security, privacy, and regulatory compliance';

  @override
  String get compliancePageCertifications => 'Certifications';

  @override
  String get compliancePageSoc2 => 'SOC 2 Type II';

  @override
  String get compliancePageSoc2Desc =>
      'Certified for security, availability, and confidentiality';

  @override
  String get compliancePageIso => 'ISO 27001';

  @override
  String get compliancePageIsoDesc =>
      'Information security management certification';

  @override
  String get compliancePageGdpr => 'GDPR Compliant';

  @override
  String get compliancePageGdprDesc => 'EU General Data Protection Regulation';

  @override
  String get compliancePageDataProtection => 'Data Protection';

  @override
  String get compliancePageDataProtectionContent =>
      'We implement comprehensive data protection measures to safeguard your information:\n\n• End-to-end encryption for data in transit\n• AES-256 encryption for data at rest\n• Regular security audits and penetration testing\n• Multi-factor authentication support\n• Role-based access control\n• Automated backup and disaster recovery';

  @override
  String get compliancePagePrivacyPractices => 'Privacy Practices';

  @override
  String get compliancePagePrivacyContent =>
      'Our privacy practices are designed to protect your rights:\n\n• Transparent data collection and usage policies\n• User consent management for data processing\n• Data minimization principles\n• Right to access, rectify, and delete personal data\n• Data portability support\n• Regular privacy impact assessments';

  @override
  String get compliancePageRegulatory => 'Regulatory Compliance';

  @override
  String get compliancePageRegulatoryContent =>
      'Flow adheres to international and regional regulations:\n\n• General Data Protection Regulation (GDPR) - EU\n• Protection of Personal Information Act (POPIA) - South Africa\n• Data Protection Act - Ghana, Kenya, Nigeria\n• Children\'s Online Privacy Protection Act (COPPA)\n• California Consumer Privacy Act (CCPA)';

  @override
  String get compliancePageThirdParty => 'Third-Party Security';

  @override
  String get compliancePageThirdPartyContent =>
      'We carefully vet and monitor our third-party service providers:\n\n• Vendor security assessments\n• Data processing agreements\n• Subprocessor transparency\n• Regular compliance reviews\n• Incident response coordination';

  @override
  String get compliancePageSecurityPractices => 'Security Practices';

  @override
  String get compliancePageRegularUpdates => 'Regular Updates';

  @override
  String get compliancePageRegularUpdatesDesc =>
      'Security patches and updates deployed continuously';

  @override
  String get compliancePageBugBounty => 'Bug Bounty Program';

  @override
  String get compliancePageBugBountyDesc =>
      'Responsible disclosure program for security researchers';

  @override
  String get compliancePageMonitoring => 'Monitoring';

  @override
  String get compliancePageMonitoringDesc =>
      '24/7 security monitoring and threat detection';

  @override
  String get compliancePageAuditLogs => 'Audit Logs';

  @override
  String get compliancePageAuditLogsDesc =>
      'Comprehensive logging of all security events';

  @override
  String get compliancePageQuestions => 'Compliance Questions?';

  @override
  String get compliancePageContactTeam =>
      'Contact our compliance team for inquiries';

  @override
  String compliancePageLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get cookiesPageTitle => 'Cookie Policy';

  @override
  String get cookiesPageLastUpdated => 'Last updated: January 2026';

  @override
  String get cookiesPageWhatAreCookies => 'What Are Cookies?';

  @override
  String get cookiesPageWhatAreCookiesContent =>
      'Cookies are small text files that are stored on your device when you visit a website. They help the website remember information about your visit, like your preferred language and other settings, which can make your next visit easier.\n\nWe use cookies and similar technologies to provide, protect, and improve our services.';

  @override
  String get cookiesPageHowWeUse => 'How We Use Cookies';

  @override
  String get cookiesPageHowWeUseContent =>
      'We use different types of cookies for various purposes:\n\n**Essential Cookies**\nThese cookies are necessary for the website to function properly. They enable basic features like page navigation, secure access to protected areas, and remembering your login state.\n\n**Performance Cookies**\nThese cookies help us understand how visitors interact with our website. They collect information about page visits, time spent on pages, and any error messages encountered.\n\n**Functionality Cookies**\nThese cookies enable enhanced functionality and personalization, such as remembering your preferences, language settings, and customizations.\n\n**Analytics Cookies**\nWe use analytics cookies to analyze website traffic and optimize the user experience. This data helps us improve our services.';

  @override
  String get cookiesPageTypesTitle => 'Types of Cookies We Use';

  @override
  String get cookiesPageCookieType => 'Cookie Type';

  @override
  String get cookiesPagePurpose => 'Purpose';

  @override
  String get cookiesPageDuration => 'Duration';

  @override
  String get cookiesPageSession => 'Session';

  @override
  String get cookiesPageAuthentication => 'Authentication';

  @override
  String get cookiesPagePreferences => 'Preferences';

  @override
  String get cookiesPageUserSettings => 'User settings';

  @override
  String get cookiesPageAnalytics => 'Analytics';

  @override
  String get cookiesPageUsageStatistics => 'Usage statistics';

  @override
  String get cookiesPageSecurity => 'Security';

  @override
  String get cookiesPageFraudPrevention => 'Fraud prevention';

  @override
  String get cookiesPageManaging => 'Managing Your Cookie Preferences';

  @override
  String get cookiesPageManagingContent =>
      'You have several options for managing cookies:\n\n**Browser Settings**\nMost web browsers allow you to control cookies through their settings. You can set your browser to refuse cookies, delete existing cookies, or alert you when cookies are being sent.\n\n**Our Cookie Settings**\nYou can manage your cookie preferences for our platform by visiting Settings > Cookie Preferences in your account.\n\n**Opt-Out Links**\nFor analytics and advertising cookies, you can opt out through industry opt-out mechanisms.\n\nNote: Disabling certain cookies may impact your experience and limit some features of our platform.';

  @override
  String get cookiesPageThirdParty => 'Third-Party Cookies';

  @override
  String get cookiesPageThirdPartyContent =>
      'Some cookies are placed by third-party services that appear on our pages. We do not control these cookies.\n\nThird-party services we use that may place cookies include:\n• Supabase (Authentication)\n• Sentry (Error Tracking)\n• Analytics services\n\nPlease refer to the privacy policies of these services for more information about their cookie practices.';

  @override
  String get cookiesPageUpdates => 'Updates to This Policy';

  @override
  String get cookiesPageUpdatesContent =>
      'We may update this Cookie Policy from time to time. When we make changes, we will update the \"Last updated\" date at the top of this page.\n\nWe encourage you to review this policy periodically to stay informed about our use of cookies.';

  @override
  String get cookiesPageManagePreferences => 'Manage Cookie Preferences';

  @override
  String get cookiesPageCustomize => 'Customize which cookies you allow';

  @override
  String get cookiesPageManageButton => 'Manage';

  @override
  String get cookiesPageQuestionsTitle => 'Questions about cookies?';

  @override
  String get cookiesPageQuestionsContact =>
      'Contact us at privacy@flowedtech.com';

  @override
  String get dataProtPageTitle => 'Data Protection';

  @override
  String get dataProtPageSubtitle =>
      'How we protect and manage your personal data';

  @override
  String get dataProtPageYourRights => 'Your Data Rights';

  @override
  String get dataProtPageRightsIntro =>
      'Under data protection laws, you have the following rights:';

  @override
  String get dataProtPageRightAccess => 'Right to Access';

  @override
  String get dataProtPageRightAccessDesc =>
      'You can request a copy of all personal data we hold about you. We will provide this within 30 days.';

  @override
  String get dataProtPageRightRectification => 'Right to Rectification';

  @override
  String get dataProtPageRightRectificationDesc =>
      'You can request correction of inaccurate or incomplete personal data.';

  @override
  String get dataProtPageRightErasure => 'Right to Erasure';

  @override
  String get dataProtPageRightErasureDesc =>
      'You can request deletion of your personal data in certain circumstances.';

  @override
  String get dataProtPageRightPortability => 'Right to Data Portability';

  @override
  String get dataProtPageRightPortabilityDesc =>
      'You can request your data in a structured, machine-readable format.';

  @override
  String get dataProtPageRightObject => 'Right to Object';

  @override
  String get dataProtPageRightObjectDesc =>
      'You can object to processing of your personal data for certain purposes.';

  @override
  String get dataProtPageRightRestrict => 'Right to Restrict Processing';

  @override
  String get dataProtPageRightRestrictDesc =>
      'You can request that we limit how we use your data.';

  @override
  String get dataProtPageHowWeProtect => 'How We Protect Your Data';

  @override
  String get dataProtPageHowWeProtectContent =>
      'We implement robust security measures to protect your personal data:\n\n**Technical Measures**\n• End-to-end encryption for data transmission\n• AES-256 encryption for stored data\n• Regular security audits and penetration testing\n• Intrusion detection systems\n• Secure data centers with physical security\n\n**Organizational Measures**\n• Staff training on data protection\n• Access controls and authentication\n• Data protection impact assessments\n• Incident response procedures\n• Regular compliance reviews';

  @override
  String get dataProtPageStorage => 'Data Storage & Retention';

  @override
  String get dataProtPageStorageContent =>
      '**Where We Store Your Data**\nYour data is stored on secure servers located in regions with strong data protection laws. We use industry-leading cloud providers with SOC 2 and ISO 27001 certifications.\n\n**How Long We Keep Your Data**\n• Account data: Until you delete your account\n• Application data: 7 years for compliance\n• Analytics data: 2 years\n• Communication logs: 3 years\n\nAfter these periods, data is securely deleted or anonymized.';

  @override
  String get dataProtPageSharing => 'Data Sharing';

  @override
  String get dataProtPageSharingContent =>
      'We only share your data when necessary:\n\n• **With your consent**: When you explicitly agree\n• **Service providers**: Partners who help us deliver services\n• **Legal requirements**: When required by law\n• **Business transfers**: In case of merger or acquisition\n\nWe never sell your personal data to third parties.';

  @override
  String get dataProtPageExerciseRights => 'Exercise Your Rights';

  @override
  String get dataProtPageExerciseRightsDesc =>
      'To make a data request or exercise any of your rights, contact our Data Protection Officer:';

  @override
  String get dataProtPageContactUs => 'Contact Us';

  @override
  String get dataProtPageManageData => 'Manage Data';

  @override
  String get dataProtPageRelatedInfo => 'Related Information';

  @override
  String get dataProtPagePrivacyPolicy => 'Privacy Policy';

  @override
  String get dataProtPageCookiePolicy => 'Cookie Policy';

  @override
  String get dataProtPageTermsOfService => 'Terms of Service';

  @override
  String get dataProtPageCompliance => 'Compliance';

  @override
  String get docsPageTitle => 'Documentation';

  @override
  String get docsPageSubtitle => 'Everything you need to know about using Flow';

  @override
  String get docsPageGettingStarted => 'Getting Started';

  @override
  String get docsPageGettingStartedDesc => 'Learn the basics of Flow';

  @override
  String get docsPageForStudents => 'For Students';

  @override
  String get docsPageForStudentsDesc => 'Guides for student users';

  @override
  String get docsPageForParents => 'For Parents';

  @override
  String get docsPageForParentsDesc => 'Guides for parent users';

  @override
  String get docsPageForCounselors => 'For Counselors';

  @override
  String get docsPageForCounselorsDesc => 'Guides for education counselors';

  @override
  String get docsPageForInstitutions => 'For Institutions';

  @override
  String get docsPageForInstitutionsDesc =>
      'Guides for universities and colleges';

  @override
  String get docsPageCantFind => 'Can\'t find what you\'re looking for?';

  @override
  String get docsPageCheckHelpCenter =>
      'Check out our Help Center or contact support';

  @override
  String get docsPageHelpCenter => 'Help Center';

  @override
  String get helpCenterPageTitle => 'Help Center';

  @override
  String get helpCenterPageHowCanWeHelp => 'How can we help?';

  @override
  String get helpCenterPageSearchHint => 'Search for help...';

  @override
  String get helpCenterPageQuickLinks => 'Quick Links';

  @override
  String get helpCenterPageUniversitySearch => 'University Search';

  @override
  String get helpCenterPageMyProfile => 'My Profile';

  @override
  String get helpCenterPageSettings => 'Settings';

  @override
  String get helpCenterPageContactSupport => 'Contact Support';

  @override
  String get helpCenterPageCategories => 'Categories';

  @override
  String get helpCenterPageFaq => 'Frequently Asked Questions';

  @override
  String get helpCenterPageNoResults => 'No results found';

  @override
  String get helpCenterPageStillNeedHelp => 'Still need help?';

  @override
  String get helpCenterPageSupportTeam =>
      'Our support team is here to assist you';

  @override
  String get mobileAppsPageTitle => 'Flow on Mobile';

  @override
  String get mobileAppsPageSubtitle =>
      'Take your education journey with you.\nDownload the Flow app on your favorite platform.';

  @override
  String get mobileAppsPageDownloadNow => 'Download Now';

  @override
  String get mobileAppsPageDownloadOnThe => 'Download on the';

  @override
  String get mobileAppsPageFeatures => 'Mobile App Features';

  @override
  String get mobileAppsPageOfflineMode => 'Offline Mode';

  @override
  String get mobileAppsPageOfflineModeDesc =>
      'Access key features without internet';

  @override
  String get mobileAppsPagePushNotifications => 'Push Notifications';

  @override
  String get mobileAppsPagePushNotificationsDesc =>
      'Stay updated on applications';

  @override
  String get mobileAppsPageBiometricLogin => 'Biometric Login';

  @override
  String get mobileAppsPageBiometricLoginDesc => 'Secure and fast access';

  @override
  String get mobileAppsPageRealtimeSync => 'Real-time Sync';

  @override
  String get mobileAppsPageRealtimeSyncDesc => 'Always up-to-date data';

  @override
  String get mobileAppsPageDarkMode => 'Dark Mode';

  @override
  String get mobileAppsPageDarkModeDesc => 'Easy on the eyes';

  @override
  String get mobileAppsPageFastLight => 'Fast & Light';

  @override
  String get mobileAppsPageFastLightDesc => 'Optimized for performance';

  @override
  String get mobileAppsPageAppPreview => 'App Preview';

  @override
  String get mobileAppsPageSystemRequirements => 'System Requirements';

  @override
  String get mobileAppsPageScanToDownload => 'Scan to Download';

  @override
  String get mobileAppsPageScanDesc =>
      'Scan this QR code with your phone camera to download the app';

  @override
  String get partnersPageTitle => 'Partners';

  @override
  String get partnersPageHeroTitle => 'Partner With Flow';

  @override
  String get partnersPageHeroSubtitle =>
      'Join us in transforming education across Africa';

  @override
  String get partnersPageOpportunities => 'Partnership Opportunities';

  @override
  String get partnersPageUniversities => 'Universities & Institutions';

  @override
  String get partnersPageUniversitiesDesc =>
      'List your programs, connect with prospective students, and streamline your admissions process.';

  @override
  String get partnersPageCounselors => 'Education Counselors';

  @override
  String get partnersPageCounselorsDesc =>
      'Join our network of counselors and help guide students to their perfect educational fit.';

  @override
  String get partnersPageCorporate => 'Corporate Partners';

  @override
  String get partnersPageCorporateDesc =>
      'Support education initiatives through scholarships, internships, and mentorship programs.';

  @override
  String get partnersPageNgo => 'NGOs & Government';

  @override
  String get partnersPageNgoDesc =>
      'Collaborate on initiatives to improve education access and outcomes across regions.';

  @override
  String get partnersPageOurPartners => 'Our Partners';

  @override
  String get partnersPageReadyToPartner => 'Ready to Partner?';

  @override
  String get partnersPageLetsDiscuss =>
      'Let\'s discuss how we can work together';

  @override
  String get partnersPageContactTeam => 'Contact Partnership Team';

  @override
  String get pressPageTitle => 'Press Kit';

  @override
  String get pressPageSubtitle => 'Resources for media and press coverage';

  @override
  String get pressPageCompanyOverview => 'Company Overview';

  @override
  String get pressPageCompanyOverviewContent =>
      'Flow EdTech is Africa\'s leading education technology platform, connecting students with universities, counselors, and educational resources. Founded with the mission to democratize access to quality education guidance across the African continent.';

  @override
  String get pressPageKeyFacts => 'Key Facts';

  @override
  String get pressPageFounded => 'Founded';

  @override
  String get pressPageHeadquarters => 'Headquarters';

  @override
  String get pressPageActiveUsers => 'Active Users';

  @override
  String get pressPagePartnerInstitutions => 'Partner Institutions';

  @override
  String get pressPageCountries => 'Countries';

  @override
  String get pressPageUniversitiesInDb => 'Universities in Database';

  @override
  String get pressPageBrandAssets => 'Brand Assets';

  @override
  String get pressPageLogoPack => 'Logo Pack';

  @override
  String get pressPageLogoPackDesc => 'PNG, SVG, and vector formats';

  @override
  String get pressPageBrandGuidelines => 'Brand Guidelines';

  @override
  String get pressPageBrandGuidelinesDesc => 'Colors, typography, usage';

  @override
  String get pressPageScreenshots => 'Screenshots';

  @override
  String get pressPageScreenshotsDesc => 'App screenshots and demos';

  @override
  String get pressPageVideoAssets => 'Video Assets';

  @override
  String get pressPageVideoAssetsDesc => 'Product videos and B-roll';

  @override
  String get pressPageDownload => 'Download';

  @override
  String get pressPageRecentNews => 'Recent News';

  @override
  String get pressPageMediaContact => 'Media Contact';

  @override
  String get pressPageMediaContactDesc =>
      'For press inquiries, please contact:';

  @override
  String get apiDocsPageTitle => 'API Reference';

  @override
  String get apiDocsPageSubtitle => 'Integrate Flow into your applications';

  @override
  String get apiDocsPageQuickStart => 'Quick Start';

  @override
  String get apiDocsPageEndpoints => 'API Endpoints';

  @override
  String get apiDocsPageAuthentication => 'Authentication';

  @override
  String get apiDocsPageAuthDesc =>
      'All API requests require authentication using an API key.';

  @override
  String get apiDocsPageRateLimits => 'Rate Limits';

  @override
  String get apiDocsPageFreeTier => 'Free Tier';

  @override
  String get apiDocsPageBasic => 'Basic';

  @override
  String get apiDocsPagePro => 'Pro';

  @override
  String get apiDocsPageEnterprise => 'Enterprise';

  @override
  String get apiDocsPageUnlimited => 'Unlimited';

  @override
  String get apiDocsPageNeedAccess => 'Need API Access?';

  @override
  String get apiDocsPageContactCredentials =>
      'Contact us to get your API credentials';

  @override
  String get apiDocsPageContactUs => 'Contact Us';

  @override
  String get apiDocsPageUniversities => 'Universities';

  @override
  String get apiDocsPagePrograms => 'Programs';

  @override
  String get apiDocsPageRecommendations => 'Recommendations';

  @override
  String get apiDocsPageStudentsEndpoint => 'Students';

  @override
  String get apiDocsPageListAll => 'List all universities';

  @override
  String get apiDocsPageGetDetails => 'Get university details';

  @override
  String get apiDocsPageSearchUniversities => 'Search universities';

  @override
  String get apiDocsPageListPrograms => 'List programs';

  @override
  String get apiDocsPageListAllPrograms => 'List all programs';

  @override
  String get apiDocsPageGetProgramDetails => 'Get program details';

  @override
  String get apiDocsPageSearchPrograms => 'Search programs';

  @override
  String get apiDocsPageGenerateRec => 'Generate recommendations';

  @override
  String get apiDocsPageGetRecDetails => 'Get recommendation details';

  @override
  String get apiDocsPageGetStudentProfile => 'Get student profile';

  @override
  String get apiDocsPageUpdateStudentProfile => 'Update student profile';

  @override
  String get apiDocsPageListApplications => 'List applications';

  @override
  String get swErrorTechnicalDetails => 'Technical Details';

  @override
  String get swErrorRetry => 'Retry';

  @override
  String get swErrorConnectionTitle => 'Connection Error';

  @override
  String get swErrorConnectionMessage =>
      'Unable to connect to our servers. Please check your internet connection and try again.';

  @override
  String get swErrorConnectionHelp =>
      'Make sure you have a stable internet connection. If the problem persists, our servers might be temporarily unavailable.';

  @override
  String get swErrorAuthTitle => 'Authentication Required';

  @override
  String get swErrorAuthMessage =>
      'Your session has expired or you don\'t have permission to access this content.';

  @override
  String get swErrorAuthHelp =>
      'Try logging out and logging back in to refresh your session.';

  @override
  String get swErrorSignOut => 'Sign Out';

  @override
  String get swErrorNotFoundTitle => 'Content Not Found';

  @override
  String get swErrorNotFoundMessage =>
      'The content you\'re looking for doesn\'t exist or has been moved.';

  @override
  String get swErrorNotFoundHelp =>
      'The item may have been deleted or you may not have access to view it.';

  @override
  String get swErrorServerTitle => 'Server Error';

  @override
  String get swErrorServerMessage =>
      'Something went wrong on our end. We\'re working to fix it.';

  @override
  String get swErrorServerHelp =>
      'This is a temporary issue. Please try again in a few minutes.';

  @override
  String get swErrorRateLimitTitle => 'Too Many Requests';

  @override
  String get swErrorRateLimitMessage =>
      'You\'ve made too many requests. Please wait a moment before trying again.';

  @override
  String get swErrorRateLimitHelp =>
      'To prevent abuse, we limit the number of requests. Please wait a few seconds before retrying.';

  @override
  String get swErrorValidationTitle => 'Validation Error';

  @override
  String get swErrorValidationMessage =>
      'Some information appears to be incorrect or missing. Please check your input and try again.';

  @override
  String get swErrorValidationHelp =>
      'Make sure all required fields are filled correctly.';

  @override
  String get swErrorAccessDeniedTitle => 'Access Denied';

  @override
  String get swErrorAccessDeniedMessage =>
      'You don\'t have permission to access this content.';

  @override
  String get swErrorAccessDeniedHelp =>
      'Contact your administrator if you believe you should have access.';

  @override
  String get swErrorGenericTitle => 'Something Went Wrong';

  @override
  String get swErrorGenericMessage =>
      'An unexpected error occurred. Please try again.';

  @override
  String get swErrorGenericHelp =>
      'If this problem continues, please contact support.';

  @override
  String get swErrorFailedToLoad => 'Failed to load data';

  @override
  String get swEmptyStateNoApplicationsTitle => 'No Applications Yet';

  @override
  String get swEmptyStateNoApplicationsMessage =>
      'Start your journey by exploring programs and submitting your first application.';

  @override
  String get swEmptyStateBrowsePrograms => 'Browse Programs';

  @override
  String get swEmptyStateNoActivitiesTitle => 'No Recent Activities';

  @override
  String get swEmptyStateNoActivitiesMessage =>
      'Your recent activities and updates will appear here as you use the platform.';

  @override
  String get swEmptyStateNoRecommendationsTitle => 'No Recommendations';

  @override
  String get swEmptyStateNoRecommendationsMessage =>
      'Complete your profile to receive personalized recommendations based on your interests and goals.';

  @override
  String get swEmptyStateCompleteProfile => 'Complete Profile';

  @override
  String get swEmptyStateNoMessagesTitle => 'No Messages';

  @override
  String get swEmptyStateNoMessagesMessage =>
      'Your conversations and notifications will appear here.';

  @override
  String get swEmptyStateNoResultsTitle => 'No Results Found';

  @override
  String get swEmptyStateNoResultsMessage =>
      'Try adjusting your search criteria or filters to find what you\'re looking for.';

  @override
  String get swEmptyStateClearFilters => 'Clear Filters';

  @override
  String get swEmptyStateNoCoursesTitle => 'No Courses Available';

  @override
  String get swEmptyStateNoCoursesMessage =>
      'Check back later for new courses or explore other learning opportunities.';

  @override
  String get swEmptyStateExplorePrograms => 'Explore Programs';

  @override
  String get swEmptyStateNoStudentsTitle => 'No Students';

  @override
  String get swEmptyStateNoStudentsMessage =>
      'Students you\'re counseling will appear here once they\'re assigned or request your guidance.';

  @override
  String get swEmptyStateNoSessionsTitle => 'No Upcoming Sessions';

  @override
  String get swEmptyStateNoSessionsMessage =>
      'You don\'t have any counseling sessions scheduled.';

  @override
  String get swEmptyStateScheduleSession => 'Schedule Session';

  @override
  String get swEmptyStateNoDataTitle => 'No Data Available';

  @override
  String get swEmptyStateNoDataMessage =>
      'Data will appear here once there\'s activity to display.';

  @override
  String get swEmptyStateNoNotificationsTitle => 'No Notifications';

  @override
  String get swEmptyStateNoNotificationsMessage =>
      'You\'re all caught up! New notifications will appear here.';

  @override
  String get swEmptyStateComingSoonTitle => 'Coming Soon';

  @override
  String swEmptyStateComingSoonMessage(String feature) {
    return '$feature is currently under development and will be available soon.';
  }

  @override
  String get swEmptyStateAccessRestrictedTitle => 'Access Restricted';

  @override
  String get swEmptyStateAccessRestrictedMessage =>
      'You don\'t have permission to view this content. Contact your administrator if you need access.';

  @override
  String get swComingSoonTitle => 'Coming Soon';

  @override
  String swComingSoonMessage(String featureName) {
    return '$featureName is currently under development and will be available in a future update.';
  }

  @override
  String get swComingSoonStayTuned => 'Stay tuned for updates!';

  @override
  String get swComingSoonGotIt => 'Got it';

  @override
  String get swNotifCenterTitle => 'Notifications';

  @override
  String get swNotifCenterMarkAllRead => 'Mark all read';

  @override
  String swNotifCenterError(String error) {
    return 'Error: $error';
  }

  @override
  String get swNotifCenterRetry => 'Retry';

  @override
  String get swNotifCenterEmpty => 'No notifications yet';

  @override
  String get swNotifCenterEmptySubtitle =>
      'We\'ll notify you when something happens';

  @override
  String get swNotifCenterDeleteTitle => 'Delete Notification';

  @override
  String get swNotifCenterDeleteConfirm =>
      'Are you sure you want to delete this notification?';

  @override
  String get swNotifCenterCancel => 'Cancel';

  @override
  String get swNotifCenterDelete => 'Delete';

  @override
  String get swNotifCenterMarkAsRead => 'Mark as read';

  @override
  String get swNotifCenterMarkAsUnread => 'Mark as unread';

  @override
  String get swNotifCenterArchive => 'Archive';

  @override
  String get swNotifCenterFilterTitle => 'Filter Notifications';

  @override
  String get swNotifCenterFilterClear => 'Clear';

  @override
  String get swNotifCenterFilterStatus => 'Status';

  @override
  String get swNotifCenterFilterAll => 'All';

  @override
  String get swNotifCenterFilterUnread => 'Unread';

  @override
  String get swNotifCenterFilterRead => 'Read';

  @override
  String get swNotifCenterApplyFilter => 'Apply Filter';

  @override
  String get swNotifBellNoNew => 'No new notifications';

  @override
  String get swNotifBellViewAll => 'View All Notifications';

  @override
  String get swNotifBellNotifications => 'Notifications';

  @override
  String get swNotifWidgetMarkAsRead => 'Mark as read';

  @override
  String get swNotifWidgetDelete => 'Delete';

  @override
  String get swNotifWidgetJustNow => 'Just now';

  @override
  String swNotifWidgetMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String swNotifWidgetHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String swNotifWidgetDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String swNotifWidgetWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String swNotifWidgetMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String swNotifWidgetYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String get swNotifWidgetNoNotifications => 'No Notifications';

  @override
  String get swNotifWidgetAllCaughtUp =>
      'You\'re all caught up! Check back later for new updates.';

  @override
  String get swOfflineYouAreOffline => 'You are offline';

  @override
  String swOfflinePendingSync(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actions pending sync',
      one: '1 action pending sync',
    );
    return '$_temp0';
  }

  @override
  String get swOfflineDetails => 'Details';

  @override
  String swOfflineSyncing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Syncing $count actions...',
      one: 'Syncing 1 action...',
    );
    return '$_temp0';
  }

  @override
  String get swOfflineActionsTitle => 'Offline Actions';

  @override
  String get swOfflineNoPending => 'No pending actions';

  @override
  String get swOfflineClearAll => 'Clear All';

  @override
  String get swOfflineClose => 'Close';

  @override
  String get swOfflineSyncNow => 'Sync Now';

  @override
  String get swOfflineJustNow => 'Just now';

  @override
  String swOfflineMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String swOfflineHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String swOfflineDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String swOfflineError(String error) {
    return 'Error: $error';
  }

  @override
  String get swExportData => 'Export Data';

  @override
  String get swExportTooltip => 'Export';

  @override
  String get swExportAsPdf => 'Export as PDF';

  @override
  String get swExportAsCsv => 'Export as CSV';

  @override
  String get swExportAsJson => 'Export as JSON';

  @override
  String get swExportNoData => 'No data to export';

  @override
  String swExportSuccess(String format) {
    return 'Exported successfully as $format';
  }

  @override
  String get swExportOk => 'OK';

  @override
  String swExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get swExportRetry => 'Retry';

  @override
  String get swExportCancel => 'Cancel';

  @override
  String get swFilterTitle => 'Filters';

  @override
  String get swFilterResetAll => 'Reset All';

  @override
  String get swFilterCategories => 'Categories';

  @override
  String get swFilterPriceRange => 'Price Range (USD)';

  @override
  String get swFilterLevel => 'Level';

  @override
  String get swFilterCountry => 'Country';

  @override
  String get swFilterInstitutionType => 'Institution Type';

  @override
  String get swFilterMinimumRating => 'Minimum Rating';

  @override
  String get swFilterDuration => 'Duration (weeks)';

  @override
  String get swFilterSpecialOptions => 'Special Options';

  @override
  String get swFilterOnlineOnly => 'Online Only';

  @override
  String get swFilterOnlineOnlySubtitle => 'Show only online courses/programs';

  @override
  String get swFilterFinancialAid => 'Financial Aid Available';

  @override
  String get swFilterFinancialAidSubtitle =>
      'Show only items with financial aid';

  @override
  String get swFilterApply => 'Apply Filters';

  @override
  String get swFilterClearAll => 'Clear all';

  @override
  String swFilterStarsPlus(double rating) {
    return '$rating+ stars';
  }

  @override
  String swFilterWeeks(int count) {
    return '$count weeks';
  }

  @override
  String get swSearchHint => 'Search...';

  @override
  String get swSearchAll => 'All';

  @override
  String get swSearchRecentSearches => 'Recent Searches';

  @override
  String get swSearchClear => 'Clear';

  @override
  String get swSearchSuggestions => 'Suggestions';

  @override
  String get swSortByTitle => 'Sort By';

  @override
  String get swSortLabel => 'Sort';

  @override
  String get swSortFilterLabel => 'Filter';

  @override
  String get swSortRelevance => 'Relevance';

  @override
  String get swSortMostPopular => 'Most Popular';

  @override
  String get swSortHighestRated => 'Highest Rated';

  @override
  String get swSortNewestFirst => 'Newest First';

  @override
  String get swSortOldestFirst => 'Oldest First';

  @override
  String get swSortPriceLowToHigh => 'Price: Low to High';

  @override
  String get swSortPriceHighToLow => 'Price: High to Low';

  @override
  String get swSortNameAZ => 'Name: A to Z';

  @override
  String get swSortNameZA => 'Name: Z to A';

  @override
  String get swSortDurationShortest => 'Duration: Shortest';

  @override
  String get swSortDurationLongest => 'Duration: Longest';

  @override
  String get swStatusPending => 'Pending';

  @override
  String get swStatusApproved => 'Approved';

  @override
  String get swStatusRejected => 'Rejected';

  @override
  String get swStatusInProgress => 'In Progress';

  @override
  String get swStatusCompleted => 'Completed';

  @override
  String swRefreshLastUpdated(String timeAgo) {
    return 'Last updated: $timeAgo';
  }

  @override
  String get swRefreshJustNow => 'just now';

  @override
  String swRefreshSecondsAgo(int count) {
    return '${count}s ago';
  }

  @override
  String swRefreshMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String swRefreshHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get swRefreshYesterday => 'yesterday';

  @override
  String swRefreshDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get swRefreshSuccess => 'Dashboard refreshed successfully';

  @override
  String get swRefreshFailed => 'Failed to refresh dashboard';

  @override
  String get swFileUploadDropHere => 'Drop files here';

  @override
  String get swFileUploadClickToSelect =>
      'Click to select files or drag and drop';

  @override
  String swFileUploadTooLarge(String fileName, int maxSize) {
    return '$fileName is too large. Maximum size is ${maxSize}MB';
  }

  @override
  String swFileUploadInvalidType(String fileName, String allowedTypes) {
    return '$fileName has an invalid file type. Allowed: $allowedTypes';
  }

  @override
  String swFileUploadPickFailed(String error) {
    return 'Failed to pick files: $error';
  }

  @override
  String swFileUploadProgress(int percent) {
    return '$percent% uploaded';
  }

  @override
  String get swFileUploadLabel => 'Upload File';

  @override
  String swFileUploadPickImageFailed(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get swFileUploadTapToSelect => 'Tap to select image';

  @override
  String get swFileUploadImageFormats => 'JPG, PNG, GIF (max 5MB)';

  @override
  String swFileUploadAllowed(String formats) {
    return 'Allowed: $formats';
  }

  @override
  String swFileUploadMaxSize(int size) {
    return 'Max ${size}MB';
  }

  @override
  String swDocViewerLoading(String name) {
    return 'Loading $name...';
  }

  @override
  String get swDocViewerFailedToLoad => 'Failed to load document';

  @override
  String swDocViewerLoadError(String error) {
    return 'Failed to load document: $error';
  }

  @override
  String get swDocViewerRetry => 'Retry';

  @override
  String get swDocViewerPinchToZoom => 'Use pinch gesture to zoom';

  @override
  String get swDocViewerPreviewNotAvailable => 'Preview Not Available';

  @override
  String swDocViewerCannotPreview(String extension) {
    return 'This file type ($extension) cannot be previewed';
  }

  @override
  String swDocViewerDownloading(String name) {
    return 'Downloading $name...';
  }

  @override
  String get swDocViewerDownloadToView => 'Download to View';

  @override
  String get swDocViewerPdfViewer => 'PDF Viewer';

  @override
  String get swDocViewerPdfEnableMessage =>
      'To enable PDF viewing, add one of these packages to pubspec.yaml:';

  @override
  String get swDocViewerPdfOptionCommercial => 'Full-featured, commercial';

  @override
  String get swDocViewerPdfOptionOpenSource => 'Open source, native rendering';

  @override
  String get swDocViewerPdfOptionModern => 'Modern, good performance';

  @override
  String swDocViewerPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get swDocViewerFailedToLoadImage => 'Failed to load image';

  @override
  String get swScheduleHighPriority => 'High';

  @override
  String get swScheduleNow => 'Now';

  @override
  String get swScheduleCompleted => 'Completed';

  @override
  String get swScheduleMarkComplete => 'Mark Complete';

  @override
  String get swScheduleToday => 'Today';

  @override
  String get swScheduleTomorrow => 'Tomorrow';

  @override
  String get swScheduleYesterday => 'Yesterday';

  @override
  String get swScheduleMonthJan => 'Jan';

  @override
  String get swScheduleMonthFeb => 'Feb';

  @override
  String get swScheduleMonthMar => 'Mar';

  @override
  String get swScheduleMonthApr => 'Apr';

  @override
  String get swScheduleMonthMay => 'May';

  @override
  String get swScheduleMonthJun => 'Jun';

  @override
  String get swScheduleMonthJul => 'Jul';

  @override
  String get swScheduleMonthAug => 'Aug';

  @override
  String get swScheduleMonthSep => 'Sep';

  @override
  String get swScheduleMonthOct => 'Oct';

  @override
  String get swScheduleMonthNov => 'Nov';

  @override
  String get swScheduleMonthDec => 'Dec';

  @override
  String get swScheduleNoEvents => 'No events scheduled';

  @override
  String get swScheduleAddEvent => 'Add Event';

  @override
  String get swSettingsThemeLight => 'Light';

  @override
  String get swSettingsThemeLightSubtitle => 'Bright and clean interface';

  @override
  String get swSettingsThemeDark => 'Dark';

  @override
  String get swSettingsThemeDarkSubtitle => 'Easy on the eyes in low light';

  @override
  String get swSettingsThemeSystem => 'System';

  @override
  String get swSettingsThemeSystemSubtitle => 'Follow device settings';

  @override
  String get swSettingsTotalDataUsage => 'Total Data Usage';

  @override
  String get swSettingsDangerZone => 'Danger Zone';

  @override
  String get swSettingsVersion => 'Version';

  @override
  String get swSettingsFlowPlatform => 'Flow EdTech Platform';

  @override
  String get swSettingsCopyright => '© 2025 All rights reserved';

  @override
  String get swTaskToday => 'Today';

  @override
  String get swTaskTomorrow => 'Tomorrow';

  @override
  String get swTaskYesterday => 'Yesterday';

  @override
  String swTaskDaysAgo(String count) {
    return '$count days ago';
  }

  @override
  String swTaskInDays(String count) {
    return 'In $count days';
  }

  @override
  String get swTaskOverdue => 'Overdue';

  @override
  String get swTaskMonthJan => 'Jan';

  @override
  String get swTaskMonthFeb => 'Feb';

  @override
  String get swTaskMonthMar => 'Mar';

  @override
  String get swTaskMonthApr => 'Apr';

  @override
  String get swTaskMonthMay => 'May';

  @override
  String get swTaskMonthJun => 'Jun';

  @override
  String get swTaskMonthJul => 'Jul';

  @override
  String get swTaskMonthAug => 'Aug';

  @override
  String get swTaskMonthSep => 'Sep';

  @override
  String get swTaskMonthOct => 'Oct';

  @override
  String get swTaskMonthNov => 'Nov';

  @override
  String get swTaskMonthDec => 'Dec';

  @override
  String get swTaskNoTasks => 'No tasks yet';

  @override
  String get swTaskAddTask => 'Add Task';

  @override
  String get swUserProfileEditProfile => 'Edit Profile';

  @override
  String get swUserProfileSettings => 'Settings';

  @override
  String get swUserProfileJustNow => 'Just now';

  @override
  String swUserProfileMinutesAgo(String count) {
    return '${count}m ago';
  }

  @override
  String swUserProfileHoursAgo(String count) {
    return '${count}h ago';
  }

  @override
  String swUserProfileDaysAgo(String count) {
    return '${count}d ago';
  }

  @override
  String get swUserProfileMonthJan => 'Jan';

  @override
  String get swUserProfileMonthFeb => 'Feb';

  @override
  String get swUserProfileMonthMar => 'Mar';

  @override
  String get swUserProfileMonthApr => 'Apr';

  @override
  String get swUserProfileMonthMay => 'May';

  @override
  String get swUserProfileMonthJun => 'Jun';

  @override
  String get swUserProfileMonthJul => 'Jul';

  @override
  String get swUserProfileMonthAug => 'Aug';

  @override
  String get swUserProfileMonthSep => 'Sep';

  @override
  String get swUserProfileMonthOct => 'Oct';

  @override
  String get swUserProfileMonthNov => 'Nov';

  @override
  String get swUserProfileMonthDec => 'Dec';

  @override
  String get swUserProfileGetStarted => 'Get Started';

  @override
  String get swVideoCompleted => 'Completed';

  @override
  String get swVideoInProgress => 'In Progress';

  @override
  String get swVideoLike => 'Like';

  @override
  String get swVideoDownloaded => 'Downloaded';

  @override
  String get swVideoDownload => 'Download';

  @override
  String swVideoViewsMillions(String count) {
    return '${count}M views';
  }

  @override
  String swVideoViewsThousands(String count) {
    return '${count}K views';
  }

  @override
  String swVideoViewsCount(String count) {
    return '$count views';
  }

  @override
  String swVideoPercentWatched(String percent) {
    return '$percent% watched';
  }

  @override
  String swVideoPlaylistCompleted(String completed, String total) {
    return '$completed/$total completed';
  }

  @override
  String get swVideoNoVideos => 'No videos available';

  @override
  String get swVideoBrowseVideos => 'Browse Videos';

  @override
  String get swStatsCurrent => 'Current';

  @override
  String get connectionStatusLive => 'Live';

  @override
  String get connectionStatusConnecting => 'Connecting...';

  @override
  String get connectionStatusConnectingShort => 'Connecting';

  @override
  String get connectionStatusOffline => 'Offline';

  @override
  String get connectionStatusError => 'Error';

  @override
  String get connectionStatusTooltipConnected => 'Real-time updates are active';

  @override
  String get connectionStatusTooltipConnecting =>
      'Establishing real-time connection...';

  @override
  String get connectionStatusTooltipDisconnected =>
      'Real-time updates are not available. Data will refresh periodically.';

  @override
  String get connectionStatusTooltipError =>
      'Connection error. Please check your internet connection.';

  @override
  String get loadingIndicatorDefault => 'Loading...';

  @override
  String messageBadgeUnread(String count) {
    return '$count unread messages';
  }

  @override
  String get messageBadgeMessages => 'Messages';

  @override
  String notificationBadgeUnread(String count) {
    return '$count unread notifications';
  }

  @override
  String get notificationBadgeNotifications => 'Notifications';

  @override
  String typingIndicatorOneUser(String user) {
    return '$user is typing';
  }

  @override
  String typingIndicatorTwoUsers(String user1, String user2) {
    return '$user1 and $user2 are typing';
  }

  @override
  String typingIndicatorMultipleUsers(
    String user1,
    String user2,
    String count,
  ) {
    return '$user1, $user2 and $count others are typing';
  }

  @override
  String get lessonEditorEdit => 'Edit';

  @override
  String get lessonEditorSaveLesson => 'Save Lesson';

  @override
  String get lessonEditorBasicInfo => 'Basic Information';

  @override
  String get lessonEditorLessonTitle => 'Lesson Title *';

  @override
  String get lessonEditorLessonTitleHelper =>
      'Give your lesson a clear, descriptive title';

  @override
  String get lessonEditorLessonTitleError => 'Please enter a lesson title';

  @override
  String get lessonEditorDescription => 'Description';

  @override
  String get lessonEditorDescriptionHelper =>
      'Provide a brief overview of this lesson';

  @override
  String get lessonEditorDuration => 'Duration (minutes)';

  @override
  String get lessonEditorMandatory => 'Mandatory';

  @override
  String get lessonEditorMandatorySubtitle =>
      'Students must complete this lesson';

  @override
  String get lessonEditorPublished => 'Published';

  @override
  String get lessonEditorPublishedSubtitle => 'Visible to students';

  @override
  String get lessonEditorLessonContent => 'Lesson Content';

  @override
  String get lessonEditorSaveSuccess => 'Lesson saved successfully';

  @override
  String get lessonEditorSaveError => 'Error saving lesson';

  @override
  String get lessonEditorVideoSavePending =>
      'Video content will be saved (API integration pending)';

  @override
  String get lessonEditorTextSavePending =>
      'Text content will be saved (API integration pending)';

  @override
  String get lessonEditorQuizSavePending =>
      'Quiz content will be saved (API integration pending)';

  @override
  String get lessonEditorAssignmentSavePending =>
      'Assignment content will be saved (API integration pending)';

  @override
  String get adminApprovalConfiguration => 'Approval Configuration';

  @override
  String get adminApprovalRefresh => 'Refresh';

  @override
  String get adminApprovalFailedToLoadConfigurations =>
      'Failed to load configurations';

  @override
  String get adminApprovalRetry => 'Retry';

  @override
  String get adminApprovalNoConfigurationsFound => 'No configurations found';

  @override
  String get adminApprovalEditConfiguration => 'Edit configuration';

  @override
  String get adminApprovalType => 'Type';

  @override
  String get adminApprovalApprovalLevel => 'Approval Level';

  @override
  String get adminApprovalPriority => 'Priority';

  @override
  String get adminApprovalExpires => 'Expires';

  @override
  String get adminApprovalAutoExecute => 'Auto Execute';

  @override
  String get adminApprovalYes => 'Yes';

  @override
  String get adminApprovalNo => 'No';

  @override
  String get adminApprovalMfaRequired => 'MFA Required';

  @override
  String get adminApprovalSkipLevels => 'Skip Levels';

  @override
  String get adminApprovalAllowed => 'Allowed';

  @override
  String get adminApprovalInitiatorRoles => 'Initiator Roles';

  @override
  String get adminApprovalApproverRoles => 'Approver Roles';

  @override
  String get adminApprovalNotifications => 'Notifications';

  @override
  String get adminApprovalConfigurationUpdated => 'Configuration updated';

  @override
  String get adminApprovalFailedToUpdateConfiguration =>
      'Failed to update configuration';

  @override
  String get adminApprovalEdit => 'Edit';

  @override
  String get adminApprovalDescription => 'Description';

  @override
  String get adminApprovalDescribeWorkflow => 'Describe this approval workflow';

  @override
  String get adminApprovalDefaultPriority => 'Default Priority';

  @override
  String get adminApprovalPriorityLow => 'Low';

  @override
  String get adminApprovalPriorityNormal => 'Normal';

  @override
  String get adminApprovalPriorityHigh => 'High';

  @override
  String get adminApprovalPriorityUrgent => 'Urgent';

  @override
  String get adminApprovalExpirationHours => 'Expiration (hours)';

  @override
  String get adminApprovalLeaveEmptyNoExpiration =>
      'Leave empty for no expiration';

  @override
  String get adminApprovalSettings => 'Settings';

  @override
  String get adminApprovalActive => 'Active';

  @override
  String get adminApprovalEnableDisableWorkflow =>
      'Enable or disable this workflow';

  @override
  String get adminApprovalAutoExecuteTitle => 'Auto Execute';

  @override
  String get adminApprovalAutoExecuteSubtitle =>
      'Automatically execute action after final approval';

  @override
  String get adminApprovalRequireMfa => 'Require MFA';

  @override
  String get adminApprovalRequireMfaSubtitle =>
      'Require multi-factor auth for approval';

  @override
  String get adminApprovalAllowLevelSkipping => 'Allow Level Skipping';

  @override
  String get adminApprovalAllowLevelSkippingSubtitle =>
      'Allow higher-level admins to skip approval levels';

  @override
  String get adminApprovalNotificationChannels => 'Notification Channels';

  @override
  String get adminApprovalInApp => 'In-App';

  @override
  String get adminApprovalEmail => 'Email';

  @override
  String get adminApprovalPush => 'Push';

  @override
  String get adminApprovalSms => 'SMS';

  @override
  String get adminApprovalCancel => 'Cancel';

  @override
  String get adminApprovalSaveChanges => 'Save Changes';

  @override
  String get adminApprovalStatusActive => 'Active';

  @override
  String get adminApprovalStatusInactive => 'Inactive';

  @override
  String get adminApprovalWorkflow => 'Approval Workflow';

  @override
  String get adminApprovalViewAllRequests => 'View All Requests';

  @override
  String get adminApprovalOverview => 'Overview';

  @override
  String adminApprovalErrorLoadingStats(String error) {
    return 'Error loading statistics: $error';
  }

  @override
  String get adminApprovalYourPendingActions => 'Your Pending Actions';

  @override
  String adminApprovalErrorLoadingPending(String error) {
    return 'Error loading pending actions: $error';
  }

  @override
  String get adminApprovalQuickActions => 'Quick Actions';

  @override
  String get adminApprovalTotalRequests => 'Total Requests';

  @override
  String get adminApprovalPendingReview => 'Pending Review';

  @override
  String get adminApprovalUnderReview => 'Under Review';

  @override
  String get adminApprovalApproved => 'Approved';

  @override
  String get adminApprovalDenied => 'Denied';

  @override
  String get adminApprovalExecuted => 'Executed';

  @override
  String get adminApprovalAllCaughtUp => 'All caught up!';

  @override
  String get adminApprovalNoPendingActions => 'You have no pending actions.';

  @override
  String get adminApprovalPendingReviews => 'Pending Reviews';

  @override
  String get adminApprovalAwaitingYourResponse => 'Awaiting Your Response';

  @override
  String get adminApprovalDelegatedToYou => 'Delegated to You';

  @override
  String get adminApprovalNewRequest => 'New Request';

  @override
  String get adminApprovalAllRequests => 'All Requests';

  @override
  String get adminApprovalMyRequests => 'My Requests';

  @override
  String get adminApprovalConfigurationLabel => 'Configuration';

  @override
  String get adminApprovalRequest => 'Approval Request';

  @override
  String adminApprovalErrorWithMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get adminApprovalRequestNotFound => 'Request not found';

  @override
  String get adminApprovalDetails => 'Details';

  @override
  String get adminApprovalInitiatedBy => 'Initiated by';

  @override
  String get adminApprovalRole => 'Role';

  @override
  String get adminApprovalRequestType => 'Request Type';

  @override
  String get adminApprovalCreated => 'Created';

  @override
  String get adminApprovalExpiresLabel => 'Expires';

  @override
  String get adminApprovalJustification => 'Justification';

  @override
  String get adminApprovalChain => 'Approval Chain';

  @override
  String get adminApprovalActions => 'Actions';

  @override
  String get adminApprovalNotesOptional => 'Notes (optional)';

  @override
  String get adminApprovalAddNotesHint => 'Add notes for your action...';

  @override
  String get adminApprovalApprove => 'Approve';

  @override
  String get adminApprovalDeny => 'Deny';

  @override
  String get adminApprovalRequestInfo => 'Request Info';

  @override
  String get adminApprovalEscalate => 'Escalate';

  @override
  String get adminApprovalComments => 'Comments';

  @override
  String get adminApprovalAddCommentHint => 'Add a comment...';

  @override
  String get adminApprovalNoCommentsYet => 'No comments yet';

  @override
  String get adminApprovalStatusPending => 'Pending';

  @override
  String get adminApprovalEscalated => 'Escalated';

  @override
  String get adminApprovalLevelRegional => 'Regional';

  @override
  String get adminApprovalLevelSuper => 'Super';

  @override
  String get adminApprovalConfirmApproval => 'Confirm Approval';

  @override
  String get adminApprovalConfirmApproveMessage =>
      'Are you sure you want to approve this request?';

  @override
  String get adminApprovalDenyRequest => 'Deny Request';

  @override
  String get adminApprovalProvideReasonDenial =>
      'Please provide a reason for denial:';

  @override
  String get adminApprovalReason => 'Reason';

  @override
  String get adminApprovalRequestInformation => 'Request Information';

  @override
  String get adminApprovalWhatInfoNeeded =>
      'What information do you need from the requester?';

  @override
  String get adminApprovalQuestion => 'Question';

  @override
  String get adminApprovalSend => 'Send';

  @override
  String get adminApprovalEscalateRequest => 'Escalate Request';

  @override
  String get adminApprovalConfirmEscalateMessage =>
      'Are you sure you want to escalate this request to a higher level?';

  @override
  String get adminApprovalEscalatedForReview => 'Escalated for higher review';

  @override
  String get adminApprovalRequests => 'Approval Requests';

  @override
  String get adminApprovalFilter => 'Filter';

  @override
  String get adminApprovalFiltersApplied => 'Filters applied';

  @override
  String get adminApprovalClear => 'Clear';

  @override
  String adminApprovalRequestCount(int count) {
    return '$count requests';
  }

  @override
  String get adminApprovalNoRequestsFound => 'No approval requests found';

  @override
  String get adminApprovalCreateNewRequest => 'Create New Request';

  @override
  String get adminApprovalCreateRequest => 'Create Approval Request';

  @override
  String get adminApprovalCategory => 'Category';

  @override
  String get adminApprovalAction => 'Action';

  @override
  String get adminApprovalTargetResource => 'Target Resource';

  @override
  String get adminApprovalResourceType => 'Resource Type';

  @override
  String get adminApprovalResourceIdOptional => 'Resource ID (optional)';

  @override
  String get adminApprovalEnterResourceId =>
      'Enter the ID of the target resource';

  @override
  String get adminApprovalJustificationDescription =>
      'Please provide a detailed justification for this request.';

  @override
  String get adminApprovalJustificationHint =>
      'Explain why this action is needed and its expected impact...';

  @override
  String get adminApprovalPleaseProvideJustification =>
      'Please provide a justification';

  @override
  String get adminApprovalJustificationMinLength =>
      'Justification must be at least 20 characters';

  @override
  String get adminApprovalSubmitRequest => 'Submit Request';

  @override
  String get adminApprovalRequestSubmittedSuccess =>
      'Approval request submitted successfully';

  @override
  String get adminApprovalApply => 'Apply';

  @override
  String get adminApprovalFilterRequests => 'Filter Requests';

  @override
  String get adminApprovalSearch => 'Search';

  @override
  String get adminApprovalSearchHint =>
      'Search by request number or justification';

  @override
  String get adminApprovalStatus => 'Status';

  @override
  String get adminApprovalClearAll => 'Clear All';

  @override
  String get adminApprovalUnknown => 'Unknown';

  @override
  String get adminApprovalExpired => 'Expired';

  @override
  String adminApprovalExpiresInDays(int days) {
    return 'Expires in ${days}d';
  }

  @override
  String adminApprovalExpiresInHours(int hours) {
    return 'Expires in ${hours}h';
  }

  @override
  String adminApprovalExpiresInMinutes(int minutes) {
    return 'Expires in ${minutes}m';
  }

  @override
  String get adminApprovalStatusDraft => 'Draft';

  @override
  String get adminApprovalStatusUnderReview => 'Under Review';

  @override
  String get adminApprovalStatusInfoNeeded => 'Info Needed';

  @override
  String get adminApprovalStatusEscalated => 'Escalated';

  @override
  String get adminApprovalStatusApprovedLabel => 'Approved';

  @override
  String get adminApprovalStatusDeniedLabel => 'Denied';

  @override
  String get adminApprovalStatusWithdrawn => 'Withdrawn';

  @override
  String get adminApprovalStatusExpired => 'Expired';

  @override
  String get adminApprovalStatusExecuted => 'Executed';

  @override
  String get adminApprovalStatusFailed => 'Failed';

  @override
  String get adminApprovalStatusReviewing => 'Reviewing';

  @override
  String get adminApprovalNoItems => 'No items';

  @override
  String adminApprovalViewAllItems(int count) {
    return 'View all $count items';
  }

  @override
  String adminApprovalByName(String name) {
    return 'By: $name';
  }

  @override
  String get adminApprovalTypeUserManagement => 'User Management';

  @override
  String get adminApprovalTypeContent => 'Content';

  @override
  String get adminApprovalTypeFinancial => 'Financial';

  @override
  String get adminApprovalTypeSystem => 'System';

  @override
  String get adminApprovalTypeNotifications => 'Notifications';

  @override
  String get adminApprovalTypeDataExport => 'Data Export';

  @override
  String get adminApprovalTypeAdminManagement => 'Admin Management';

  @override
  String get adminApprovalActionCreateUser => 'Create User';

  @override
  String get adminApprovalActionDeleteUserAccount => 'Delete User Account';

  @override
  String get adminApprovalActionSuspendUserAccount => 'Suspend User Account';

  @override
  String get adminApprovalActionUnsuspendUserAccount =>
      'Unsuspend User Account';

  @override
  String get adminApprovalActionGrantAdminRole => 'Grant Admin Role';

  @override
  String get adminApprovalActionRevokeAdminRole => 'Revoke Admin Role';

  @override
  String get adminApprovalActionModifyUserPermissions =>
      'Modify User Permissions';

  @override
  String get adminApprovalActionPublishContent => 'Publish Content';

  @override
  String get adminApprovalActionUnpublishContent => 'Unpublish Content';

  @override
  String get adminApprovalActionDeleteContent => 'Delete Content';

  @override
  String get adminApprovalActionDeleteProgram => 'Delete Program';

  @override
  String get adminApprovalActionDeleteInstitutionContent =>
      'Delete Institution Content';

  @override
  String get adminApprovalActionProcessLargeRefund => 'Process Large Refund';

  @override
  String get adminApprovalActionModifyFeeStructure => 'Modify Fee Structure';

  @override
  String get adminApprovalActionVoidTransaction => 'Void Transaction';

  @override
  String get adminApprovalActionSendBulkNotification =>
      'Send Bulk Notification';

  @override
  String get adminApprovalActionSendPlatformAnnouncement =>
      'Send Platform Announcement';

  @override
  String get adminApprovalActionExportSensitiveData => 'Export Sensitive Data';

  @override
  String get adminApprovalActionExportUserData => 'Export User Data';

  @override
  String get adminApprovalActionModifySystemSettings =>
      'Modify System Settings';

  @override
  String get adminApprovalActionClearCache => 'Clear Cache';

  @override
  String get adminApprovalActionCreateAdmin => 'Create Admin';

  @override
  String get adminApprovalActionModifyAdmin => 'Modify Admin';

  @override
  String get adminContentAssessmentsManagement => 'Assessments Management';

  @override
  String get adminContentManageQuizzesAndAssignments =>
      'Manage quizzes and assignments across all courses';

  @override
  String get adminContentRefresh => 'Refresh';

  @override
  String get adminContentCreateAssessment => 'Create Assessment';

  @override
  String get adminContentCreateNewAssessment => 'Create New Assessment';

  @override
  String get adminContentAssessmentTypeRequired => 'Assessment Type *';

  @override
  String get adminContentQuiz => 'Quiz';

  @override
  String get adminContentAssignment => 'Assignment';

  @override
  String get adminContentCourseRequired => 'Course *';

  @override
  String get adminContentLoadingCourses => 'Loading courses...';

  @override
  String get adminContentSelectACourse => 'Select a course';

  @override
  String get adminContentModuleRequired => 'Module *';

  @override
  String get adminContentLoadingModules => 'Loading modules...';

  @override
  String get adminContentSelectACourseFirst => 'Select a course first';

  @override
  String get adminContentNoModulesInCourse => 'No modules in this course';

  @override
  String get adminContentSelectAModule => 'Select a module';

  @override
  String get adminContentLessonTitleRequired => 'Lesson Title *';

  @override
  String get adminContentEnterLessonTitle => 'Enter lesson title';

  @override
  String get adminContentTitleRequired => 'Title *';

  @override
  String get adminContentEnterTitle => 'Enter title';

  @override
  String get adminContentPassingScorePercent => 'Passing Score (%)';

  @override
  String get adminContentInstructionsRequired => 'Instructions *';

  @override
  String get adminContentEnterAssignmentInstructions =>
      'Enter assignment instructions';

  @override
  String get adminContentPointsPossible => 'Points Possible';

  @override
  String get adminContentQuizDraftNotice =>
      'Quiz will be created as a draft. Add questions in the Course Builder.';

  @override
  String get adminContentAssignmentDraftNotice =>
      'Assignment will be created as a draft. Configure details in the Course Builder.';

  @override
  String get adminContentCancel => 'Cancel';

  @override
  String get adminContentPleaseSelectCourseAndModule =>
      'Please select course and module';

  @override
  String get adminContentPleaseFillRequiredFields =>
      'Please fill in all required fields';

  @override
  String get adminContentPleaseEnterInstructions =>
      'Please enter assignment instructions';

  @override
  String adminContentAssessmentCreated(String type) {
    return '$type created';
  }

  @override
  String get adminContentFailedToCreateAssessment =>
      'Failed to create assessment';

  @override
  String get adminContentCreate => 'Create';

  @override
  String get adminContentTotalAssessments => 'Total Assessments';

  @override
  String get adminContentAllAssessments => 'All assessments';

  @override
  String get adminContentQuizzes => 'Quizzes';

  @override
  String get adminContentAutoGraded => 'Auto-graded';

  @override
  String get adminContentAssignments => 'Assignments';

  @override
  String get adminContentManualGrading => 'Manual grading';

  @override
  String get adminContentPendingGrading => 'Pending Grading';

  @override
  String get adminContentAwaitingReview => 'Awaiting review';

  @override
  String get adminContentSearchAssessments => 'Search assessments by title...';

  @override
  String get adminContentAssessmentType => 'Assessment Type';

  @override
  String get adminContentAllTypes => 'All Types';

  @override
  String get adminContentTitleLabel => 'Title';

  @override
  String get adminContentTypeLabel => 'Type';

  @override
  String get adminContentCourseLabel => 'Course';

  @override
  String get adminContentQuestionsSubmissions => 'Questions / Submissions';

  @override
  String adminContentQuestionsAttempts(int questions, int attempts) {
    return '$questions questions ($attempts attempts)';
  }

  @override
  String adminContentSubmissionsGraded(int submissions, int graded) {
    return '$submissions submissions ($graded graded)';
  }

  @override
  String get adminContentScoreGrade => 'Score / Grade';

  @override
  String adminContentPassRate(String rate) {
    return '$rate% pass';
  }

  @override
  String adminContentAvgGrade(String grade) {
    return '$grade% avg';
  }

  @override
  String get adminContentUpdated => 'Updated';

  @override
  String get adminContentViewStats => 'View Stats';

  @override
  String get adminContentEditInCourseBuilder => 'Edit in Course Builder';

  @override
  String get adminContentQuestions => 'Questions';

  @override
  String get adminContentAttempts => 'Attempts';

  @override
  String get adminContentAverageScore => 'Average Score';

  @override
  String get adminContentPassRateLabel => 'Pass Rate';

  @override
  String get adminContentSubmissions => 'Submissions';

  @override
  String get adminContentGraded => 'Graded';

  @override
  String get adminContentPending => 'Pending';

  @override
  String get adminContentAverageGrade => 'Average Grade';

  @override
  String get adminContentDueDate => 'Due Date';

  @override
  String get adminContentLastUpdated => 'Last Updated';

  @override
  String get adminContentClose => 'Close';

  @override
  String get adminContentToday => 'Today';

  @override
  String get adminContentYesterday => 'Yesterday';

  @override
  String adminContentDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String adminContentWeeksAgo(int weeks) {
    return '$weeks weeks ago';
  }

  @override
  String adminContentMonthsAgo(int months) {
    return '$months months ago';
  }

  @override
  String adminContentYearsAgo(int years) {
    return '$years years ago';
  }

  @override
  String get adminContentManagement => 'Content Management';

  @override
  String get adminContentManageVideoCourses =>
      'Manage video courses and tutorials';

  @override
  String get adminContentManageTextMaterials =>
      'Manage text-based learning materials';

  @override
  String get adminContentManageInteractive =>
      'Manage interactive learning content';

  @override
  String get adminContentManageLiveSessions =>
      'Manage live sessions and webinars';

  @override
  String get adminContentManageHybrid => 'Manage hybrid learning experiences';

  @override
  String get adminContentManageEducational =>
      'Manage educational content, courses, and curriculum';

  @override
  String get adminContentExportComingSoon => 'Export feature coming soon';

  @override
  String get adminContentExport => 'Export';

  @override
  String get adminContentCreateContent => 'Create Content';

  @override
  String get adminContentCreateNewContent => 'Create New Content';

  @override
  String get adminContentEnterContentTitle => 'Enter content title';

  @override
  String get adminContentDescription => 'Description';

  @override
  String get adminContentEnterDescription => 'Enter content description';

  @override
  String get adminContentDraftNotice =>
      'Content will be created as a draft. You can edit and publish it later.';

  @override
  String get adminContentPleaseEnterTitle => 'Please enter a title';

  @override
  String get adminContentCurriculumManagement => 'Curriculum Management';

  @override
  String get adminContentManageModulesAndLessons =>
      'Manage modules and lessons across all courses';

  @override
  String get adminContentCreateModule => 'Create Module';

  @override
  String get adminContentCreateNewModule => 'Create New Module';

  @override
  String get adminContentResourcesManagement => 'Resources Management';

  @override
  String get adminContentManageVideoAndText =>
      'Manage video and text content across all courses';

  @override
  String get adminContentCreateResource => 'Create Resource';

  @override
  String get adminContentCreateNewResource => 'Create New Resource';

  @override
  String get adminContentPageContentManagement => 'Page Content Management';

  @override
  String get adminContentManageFooterPages =>
      'Manage footer pages content (About, Privacy, Terms, etc.)';

  @override
  String get adminContentErrorLoadingPages => 'Error loading pages';

  @override
  String get adminContentRetry => 'Retry';

  @override
  String get adminContentNoPagesFound => 'No pages found';

  @override
  String get adminContentRunMigration =>
      'Run the database migration to seed initial page content.';

  @override
  String get adminContentAtLeastOneSection =>
      'At least one section is required';

  @override
  String get adminContentRemoveSection => 'Remove Section';

  @override
  String get adminContentConfirmRemoveSection =>
      'Are you sure you want to remove this section?';

  @override
  String get adminContentRemove => 'Remove';

  @override
  String get adminContentInvalidJson => 'Invalid JSON in content field';

  @override
  String get adminContentPageSavedSuccessfully => 'Page saved successfully';

  @override
  String get adminContentFailedToSavePage => 'Failed to save page';

  @override
  String get adminContentPagePublishedSuccessfully =>
      'Page published successfully';

  @override
  String get adminContentFailedToPublishPage => 'Failed to publish page';

  @override
  String get adminContentPageUnpublished => 'Page unpublished';

  @override
  String get adminContentFailedToUnpublishPage => 'Failed to unpublish page';

  @override
  String get adminContentUnsavedChanges => 'Unsaved Changes';

  @override
  String get adminContentDiscardChanges =>
      'You have unsaved changes. Do you want to discard them?';

  @override
  String get adminContentDiscard => 'Discard';

  @override
  String get adminContentStartTyping => 'Start typing your content here...';

  @override
  String get adminContentSupportsMarkdown => 'Supports Markdown formatting';

  @override
  String adminContentCharacterCount(int count) {
    return '$count characters';
  }

  @override
  String adminContentSectionIndex(int index) {
    return 'Section $index';
  }

  @override
  String get adminContentSectionTitle => 'Section Title';

  @override
  String get adminContentEnterSectionTitle => 'Enter section title';

  @override
  String get adminContentSectionContent => 'Section Content';

  @override
  String get adminContentEnterSectionContent => 'Enter section content...';

  @override
  String get swAchievementToday => 'Today';

  @override
  String get swAchievementYesterday => 'Yesterday';

  @override
  String swAchievementDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String swAchievementWeeksAgo(int count) {
    return '$count weeks ago';
  }

  @override
  String get swAchievementYou => 'You';

  @override
  String get swAchievementPoints => 'points';

  @override
  String get swChartNoDataAvailable => 'No data available';

  @override
  String get swCollabPublic => 'Public';

  @override
  String swCollabMembersCount(int current, int max) {
    return '$current/$max members';
  }

  @override
  String swCollabOnlineCount(int count) {
    return '$count online';
  }

  @override
  String get swCollabGroupFull => 'Group Full';

  @override
  String get swCollabJoinGroup => 'Join Group';

  @override
  String get swCollabNoGroupsYet => 'No groups yet';

  @override
  String get swCollabCreateGroup => 'Create Group';

  @override
  String swExamQuestionsCount(int count) {
    return '$count Questions';
  }

  @override
  String swExamMarksCount(int count) {
    return '$count Marks';
  }

  @override
  String swExamScoreDisplay(int score, int total) {
    return '$score/$total';
  }

  @override
  String get swExamStartExam => 'Start Exam';

  @override
  String get swExamToday => 'Today';

  @override
  String get swExamTomorrow => 'Tomorrow';

  @override
  String swExamDaysCount(int count) {
    return '$count days';
  }

  @override
  String get swExamWriteAnswerHint => 'Write your answer here...';

  @override
  String get swExamEnterAnswerHint => 'Enter your answer...';

  @override
  String get swExamExplanation => 'Explanation';

  @override
  String get swFocusFocusMode => 'Focus Mode';

  @override
  String get swFocusPaused => 'Paused';

  @override
  String get swFocusThisWeek => 'This Week';

  @override
  String swHelpSupportArticlesCount(int count) {
    return '$count articles';
  }

  @override
  String swHelpSupportViewsCount(int count) {
    return '$count views';
  }

  @override
  String swHelpSupportHelpfulCount(int count) {
    return '$count found helpful';
  }

  @override
  String get swHelpSupportWasThisHelpful => 'Was this helpful?';

  @override
  String get swHelpSupportYes => 'Yes';

  @override
  String get swHelpSupportToday => 'Today';

  @override
  String get swHelpSupportYesterday => 'Yesterday';

  @override
  String swHelpSupportDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get swHelpSupportJustNow => 'Just now';

  @override
  String swHelpSupportMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String swHelpSupportHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String swHelpSupportDaysShortAgo(int count) {
    return '${count}d ago';
  }

  @override
  String swInvoiceNumber(String number) {
    return 'Invoice #$number';
  }

  @override
  String swInvoiceIssued(String date) {
    return 'Issued: $date';
  }

  @override
  String swInvoiceDue(String date) {
    return 'Due: $date';
  }

  @override
  String get swInvoiceBillTo => 'BILL TO';

  @override
  String get swInvoiceDescription => 'DESCRIPTION';

  @override
  String get swInvoiceQty => 'QTY';

  @override
  String get swInvoiceRate => 'RATE';

  @override
  String get swInvoiceAmount => 'AMOUNT';

  @override
  String get swInvoiceSubtotal => 'Subtotal';

  @override
  String get swInvoiceDiscount => 'Discount';

  @override
  String get swInvoiceTax => 'Tax';

  @override
  String get swInvoiceTotal => 'TOTAL';

  @override
  String get swInvoiceTransactionId => 'Transaction ID';

  @override
  String get swInvoiceDownloadReceipt => 'Download Receipt';

  @override
  String get swJobCareerPostedToday => 'Posted today';

  @override
  String get swJobCareerPostedYesterday => 'Posted yesterday';

  @override
  String swJobCareerPostedDaysAgo(int count) {
    return 'Posted $count days ago';
  }

  @override
  String get swJobCareerRemote => 'Remote';

  @override
  String swJobCareerApplyBy(String date) {
    return 'Apply by $date';
  }

  @override
  String get swJobCareerExpired => 'Expired';

  @override
  String get swJobCareerToday => 'Today';

  @override
  String get swJobCareerTomorrow => 'Tomorrow';

  @override
  String swJobCareerInDays(int count) {
    return 'in $count days';
  }

  @override
  String get swJobCareerAvailable => 'Available';

  @override
  String swJobCareerSessionsCount(int count) {
    return '$count sessions';
  }

  @override
  String get swJobCareerBookSession => 'Book Session';

  @override
  String swJobCareerApplied(String time) {
    return 'Applied $time';
  }

  @override
  String swJobCareerUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String swJobCareerDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String swJobCareerHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String swJobCareerMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String get swJobCareerJustNow => 'Just now';

  @override
  String swJobCareerViewsCount(int count) {
    return '$count views';
  }

  @override
  String get swMessageNoMessagesYet => 'No messages yet';

  @override
  String get swMessageTypeMessage => 'Type a message...';

  @override
  String get swMessageToday => 'Today';

  @override
  String get swMessageYesterday => 'Yesterday';

  @override
  String get swNoteEdit => 'Edit';

  @override
  String get swNoteUnpin => 'Unpin';

  @override
  String get swNotePin => 'Pin';

  @override
  String get swNoteDelete => 'Delete';

  @override
  String get swNoteJustNow => 'Just now';

  @override
  String swNoteMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String swNoteHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String swNoteDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String swNoteNotesCount(int count) {
    return '$count notes';
  }

  @override
  String get swNoteNoNotesYet => 'No Notes Yet';

  @override
  String get swNoteStartTakingNotes =>
      'Start taking notes to remember important information';

  @override
  String get swNoteCreateNote => 'Create Note';

  @override
  String get swNoteSearchNotes => 'Search notes...';

  @override
  String swOnboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get swOnboardingSkipTutorial => 'Skip Tutorial';

  @override
  String get swOnboardingNext => 'Next';

  @override
  String get swOnboardingFinish => 'Finish';

  @override
  String get swPaymentPending => 'Pending';

  @override
  String get swPaymentProcessing => 'Processing';

  @override
  String get swPaymentCompleted => 'Completed';

  @override
  String get swPaymentFailed => 'Failed';

  @override
  String get swPaymentRefunded => 'Refunded';

  @override
  String get swPaymentCancelled => 'Cancelled';

  @override
  String get swPaymentDefault => 'Default';

  @override
  String get swPaymentCard => 'Card';

  @override
  String get swPaymentBankAccount => 'Bank Account';

  @override
  String get swPaymentPaypalAccount => 'PayPal Account';

  @override
  String get swPaymentStripePayment => 'Stripe Payment';

  @override
  String get swPaymentRemoveMethod => 'Remove payment method';

  @override
  String get swPaymentToday => 'Today';

  @override
  String get swPaymentYesterday => 'Yesterday';

  @override
  String swPaymentDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get swPaymentCardNumber => 'Card Number';

  @override
  String get swPaymentExpiryDate => 'Expiry Date';

  @override
  String get swPaymentCvv => 'CVV';

  @override
  String swQuizQuestionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String swQuizPointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pts',
      one: 'pt',
    );
    return '$count $_temp0';
  }

  @override
  String get swQuizTypeAnswerHint => 'Type your answer here...';

  @override
  String get swQuizExplanation => 'Explanation';

  @override
  String get swQuizCongratulations => 'Congratulations!';

  @override
  String get swQuizKeepPracticing => 'Keep Practicing!';

  @override
  String get swQuizYouScored => 'You scored';

  @override
  String swQuizScoreOutOf(int score, int total) {
    return '$score out of $total points';
  }

  @override
  String swQuizQuestionsCount(int count) {
    return '$count questions';
  }

  @override
  String swQuizDurationMin(int count) {
    return '$count min';
  }

  @override
  String swQuizAttemptsCount(int used, int max) {
    return '$used/$max attempts';
  }

  @override
  String swQuizBestScore(String score) {
    return 'Best Score: $score%';
  }

  @override
  String get swResourceRemoveBookmark => 'Remove bookmark';

  @override
  String get swResourceBookmark => 'Bookmark';

  @override
  String get swResourceDownloaded => 'Downloaded';

  @override
  String get swResourceDownload => 'Download';

  @override
  String get swResourceNoResourcesAvailable => 'No Resources Available';

  @override
  String get swResourceWillAppearHere =>
      'Resources will appear here when available';

  @override
  String get swResourceDownloading => 'Downloading';

  @override
  String swProgressLessonsCount(int completed, int total) {
    return '$completed/$total lessons';
  }

  @override
  String swProgressUnlocked(String date) {
    return 'Unlocked $date';
  }

  @override
  String get swProgressToday => 'Today';

  @override
  String get swProgressYesterday => 'Yesterday';

  @override
  String swProgressDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get swProgressCompleted => 'Completed';

  @override
  String get swProgressOverdue => 'Overdue';

  @override
  String swProgressDaysLeft(int count) {
    return '$count days left';
  }

  @override
  String get swProgressDayStreak => 'day streak';

  @override
  String swProgressLongestStreak(int count) {
    return 'Longest: $count days';
  }

  @override
  String get adminAnalytics30DayActiveChange => '30-day active change';

  @override
  String get adminAnalyticsActive30d => 'Active (30d)';

  @override
  String get adminAnalyticsActiveApplications => 'Active Applications';

  @override
  String get adminAnalyticsActiveChange => 'Active Change';

  @override
  String get adminAnalyticsActiveLast30Days => 'Active in last 30 days';

  @override
  String get adminAnalyticsActiveUsers => 'Active Users';

  @override
  String get adminAnalyticsActiveUsers30d => 'Active Users (30d)';

  @override
  String get adminAnalyticsAllRegisteredUsers => 'All Registered Users';

  @override
  String get adminAnalyticsAllTime => 'All Time';

  @override
  String get adminAnalyticsApplicationAnalytics => 'Application Analytics';

  @override
  String get adminAnalyticsApplications => 'Applications';

  @override
  String get adminAnalyticsApplicationSubmissions => 'Application Submissions';

  @override
  String get adminAnalyticsApproved => 'Approved';

  @override
  String get adminAnalyticsApps7d => 'Apps (7d)';

  @override
  String get adminAnalyticsAppTrendData => 'Application Trend Data';

  @override
  String get adminAnalyticsAverageTime => 'Average Time';

  @override
  String get adminAnalyticsAverageValue => 'Average Value';

  @override
  String get adminAnalyticsAvgCompletion => 'Avg. Completion';

  @override
  String get adminAnalyticsAvgTransaction => 'Avg. Transaction';

  @override
  String get adminAnalyticsAwaitingReview => 'Awaiting Review';

  @override
  String get adminAnalyticsBounceRate => 'Bounce Rate';

  @override
  String get adminAnalyticsByUserType => 'By User Type';

  @override
  String get adminAnalyticsClose => 'Close';

  @override
  String get adminAnalyticsContent => 'Content';

  @override
  String get adminAnalyticsContentAnalytics => 'Content Analytics';

  @override
  String get adminAnalyticsContentCompletionRate => 'Content Completion Rate';

  @override
  String get adminAnalyticsContentEngagement => 'Content Engagement';

  @override
  String get adminAnalyticsContentEngagementData => 'Content Engagement Data';

  @override
  String get adminAnalyticsCounselors => 'Counselors';

  @override
  String get adminAnalyticsCourses => 'Courses';

  @override
  String get adminAnalyticsCsv => 'CSV';

  @override
  String get adminAnalyticsCsvDesc => 'Download as CSV spreadsheet';

  @override
  String get adminAnalyticsCustomDashboards => 'Custom Dashboards';

  @override
  String get adminAnalyticsDailyActiveUserData => 'Daily Active User Data';

  @override
  String get adminAnalyticsDailyActiveUsers => 'Daily Active Users';

  @override
  String get adminAnalyticsDashboardSubtitle =>
      'View platform metrics and insights';

  @override
  String get adminAnalyticsDataExplorer => 'Data Explorer';

  @override
  String get adminAnalyticsDataExplorerSubtitle => 'Query and analyze raw data';

  @override
  String get adminAnalyticsDataExports => 'Data Exports';

  @override
  String get adminAnalyticsDataExportsSubtitle => 'Download reports and data';

  @override
  String get adminAnalyticsDistributionByRole => 'Distribution by Role';

  @override
  String get adminAnalyticsEngagement => 'Engagement';

  @override
  String get adminAnalyticsEngagementLabel => 'Engagement';

  @override
  String get adminAnalyticsExcel => 'Excel';

  @override
  String get adminAnalyticsExcelDesc => 'Download as Excel workbook';

  @override
  String get adminAnalyticsExportReport => 'Export Report';

  @override
  String get adminAnalyticsExportTitle => 'Export Analytics';

  @override
  String get adminAnalyticsFinancial => 'Financial';

  @override
  String get adminAnalyticsFinancialAnalytics => 'Financial Analytics';

  @override
  String get adminAnalyticsInstitutions => 'Institutions';

  @override
  String get adminAnalyticsKpi => 'KPI';

  @override
  String get adminAnalyticsLast30Days => 'Last 30 Days';

  @override
  String get adminAnalyticsLast7Days => 'Last 7 Days';

  @override
  String get adminAnalyticsLast7DaysShort => 'Last 7d';

  @override
  String get adminAnalyticsLast90Days => 'Last 90 Days';

  @override
  String get adminAnalyticsMonthToDate => 'Month to Date';

  @override
  String get adminAnalyticsMostViewedItems => 'Most Viewed Items';

  @override
  String get adminAnalyticsNew7d => 'New (7d)';

  @override
  String get adminAnalyticsNewAppsOverTime => 'New Applications Over Time';

  @override
  String get adminAnalyticsNewExport => 'New Export';

  @override
  String get adminAnalyticsNewRegOverTime => 'New Registrations Over Time';

  @override
  String get adminAnalyticsNewSignUpsOverTime => 'New Sign-ups Over Time';

  @override
  String get adminAnalyticsNewUsers => 'New Users';

  @override
  String get adminAnalyticsNewUsersThisWeek => 'New Users This Week';

  @override
  String get adminAnalyticsNoDataAvailable => 'No data available';

  @override
  String get adminAnalyticsNoMatchingRows => 'No matching rows found';

  @override
  String get adminAnalyticsNoRecentActivity => 'No recent activity';

  @override
  String get adminAnalyticsNoRoleDistData =>
      'No role distribution data available';

  @override
  String get adminAnalyticsNoUserGrowthData => 'No user growth data available';

  @override
  String get adminAnalyticsNoWidgets => 'No widgets configured';

  @override
  String get adminAnalyticsOverview => 'Overview';

  @override
  String get adminAnalyticsPageViews => 'Page Views';

  @override
  String get adminAnalyticsPdf => 'PDF';

  @override
  String get adminAnalyticsPdfDesc => 'Download as PDF document';

  @override
  String get adminAnalyticsPending => 'Pending';

  @override
  String get adminAnalyticsPlatformEngagement => 'Platform Engagement';

  @override
  String get adminAnalyticsPlatformUptime => 'Platform Uptime';

  @override
  String get adminAnalyticsPopularContent => 'Popular Content';

  @override
  String get adminAnalyticsPrograms => 'Programs';

  @override
  String get adminAnalyticsPublishedItems => 'Published Items';

  @override
  String get adminAnalyticsQuickStats => 'Quick Stats';

  @override
  String get adminAnalyticsRecentApplications => 'Recent Applications';

  @override
  String get adminAnalyticsRecommenders => 'Recommenders';

  @override
  String get adminAnalyticsRefreshAll => 'Refresh All';

  @override
  String get adminAnalyticsRefreshData => 'Refresh Data';

  @override
  String get adminAnalyticsRegionalDataNotAvailable =>
      'Regional data not available';

  @override
  String get adminAnalyticsRegionalDistribution => 'Regional Distribution';

  @override
  String get adminAnalyticsRejected => 'Rejected';

  @override
  String get adminAnalyticsRevenueBreakdown => 'Revenue Breakdown';

  @override
  String get adminAnalyticsRevenueMtd => 'Revenue MTD';

  @override
  String get adminAnalyticsRevenueTrend => 'Revenue Trend';

  @override
  String get adminAnalyticsRevenueTrendData => 'Revenue Trend Data';

  @override
  String get adminAnalyticsSearchColumns => 'Search columns...';

  @override
  String get adminAnalyticsSelectDataSource => 'Select Data Source';

  @override
  String get adminAnalyticsSelectFormat => 'Select Format';

  @override
  String get adminAnalyticsSessionDuration => 'Session Duration';

  @override
  String get adminAnalyticsSinglePageVisits => 'Single Page Visits';

  @override
  String get adminAnalyticsStudents => 'Students';

  @override
  String get adminAnalyticsSubtitle => 'Platform analytics and insights';

  @override
  String get adminAnalyticsSuccessRate => 'Success Rate';

  @override
  String get adminAnalyticsThisMonth => 'This Month';

  @override
  String get adminAnalyticsThisYear => 'This Year';

  @override
  String get adminAnalyticsTitle => 'Analytics Dashboard';

  @override
  String get adminAnalyticsToggleWidgets => 'Toggle Widgets';

  @override
  String get adminAnalyticsTotalApproved => 'Total Approved';

  @override
  String get adminAnalyticsTotalContent => 'Total Content';

  @override
  String get adminAnalyticsTotalCounselors => 'Total Counselors';

  @override
  String get adminAnalyticsTotalInstitutions => 'Total Institutions';

  @override
  String get adminAnalyticsTotalInteractions => 'Total Interactions';

  @override
  String get adminAnalyticsTotalRecommenders => 'Total Recommenders';

  @override
  String get adminAnalyticsTotalRejected => 'Total Rejected';

  @override
  String get adminAnalyticsTotalRevenue => 'Total Revenue';

  @override
  String get adminAnalyticsTotalStudents => 'Total Students';

  @override
  String get adminAnalyticsTotalTransactions => 'Total Transactions';

  @override
  String get adminAnalyticsTotalUsers => 'Total Users';

  @override
  String get adminAnalyticsTotalViews => 'Total Views';

  @override
  String get adminAnalyticsTransactions => 'Transactions';

  @override
  String get adminAnalyticsTransactionSuccess => 'Transaction Success';

  @override
  String get adminAnalyticsTrends => 'Trends';

  @override
  String get adminAnalyticsUniversities => 'Universities';

  @override
  String get adminAnalyticsUserActivityOverTime => 'User Activity Over Time';

  @override
  String get adminAnalyticsUserAnalytics => 'User Analytics';

  @override
  String get adminAnalyticsUserDistribution => 'User Distribution';

  @override
  String get adminAnalyticsUserGrowth => 'User Growth';

  @override
  String get adminAnalyticsUserGrowthVsPrevious =>
      'User Growth vs Previous Period';

  @override
  String get adminAnalyticsUserInteractionsOverTime =>
      'User Interactions Over Time';

  @override
  String get adminAnalyticsUserRegistrations => 'User Registrations';

  @override
  String get adminAnalyticsUsers => 'Users';

  @override
  String get adminAnalyticsUsersByRegion => 'Users by Region';

  @override
  String get adminAnalyticsUserTypes => 'User Types';

  @override
  String get adminAnalyticsVsLastPeriod => 'vs Last Period';

  @override
  String get adminAnalyticsWidgets => 'Widgets';

  @override
  String get adminChatArchive => 'Archive';

  @override
  String get adminChatCancel => 'Cancel';

  @override
  String get adminChatCannedClosingLabel => 'Closing';

  @override
  String get adminChatCannedClosingText =>
      'Thank you for contacting us. Have a great day!';

  @override
  String get adminChatCannedEscalatingLabel => 'Escalating';

  @override
  String get adminChatCannedEscalatingText =>
      'I\'ll escalate this to a specialist who can better assist you.';

  @override
  String get adminChatCannedFollowUpLabel => 'Follow-up';

  @override
  String get adminChatCannedFollowUpText =>
      'Is there anything else I can help you with?';

  @override
  String get adminChatCannedGreetingLabel => 'Greeting';

  @override
  String get adminChatCannedGreetingText =>
      'Hello! How can I assist you today?';

  @override
  String get adminChatCannedMoreInfoLabel => 'More Info';

  @override
  String get adminChatCannedMoreInfoText =>
      'Could you please provide more details about your issue?';

  @override
  String get adminChatCannedResolutionLabel => 'Resolution';

  @override
  String get adminChatCannedResolutionText =>
      'Your issue has been resolved. Please let me know if you need further assistance.';

  @override
  String get adminChatConvDetailsTitle => 'Conversation Details';

  @override
  String get adminChatConvHistorySubtitle =>
      'View past conversations and messages';

  @override
  String get adminChatConvHistoryTitle => 'Conversation History';

  @override
  String get adminChatConvNotFound => 'Conversation not found';

  @override
  String get adminChatDelete => 'Delete';

  @override
  String get adminChatDeleteConvConfirm =>
      'Are you sure you want to delete this conversation? This action cannot be undone.';

  @override
  String get adminChatDeleteConvTitle => 'Delete Conversation';

  @override
  String get adminChatFaqActivate => 'Activate';

  @override
  String get adminChatFaqAdd => 'Add FAQ';

  @override
  String get adminChatFaqAllCategories => 'All Categories';

  @override
  String get adminChatFaqAnswer => 'Answer';

  @override
  String get adminChatFaqAnswerHint => 'Enter the answer to this question';

  @override
  String get adminChatFaqAnswerRequired => 'Answer is required';

  @override
  String get adminChatFaqCategory => 'Category';

  @override
  String get adminChatFaqCreate => 'Create FAQ';

  @override
  String get adminChatFaqCreated => 'FAQ created successfully';

  @override
  String get adminChatFaqCreateFirst => 'Create your first FAQ entry';

  @override
  String get adminChatFaqCreateTitle => 'Create FAQ Entry';

  @override
  String get adminChatFaqDeactivate => 'Deactivate';

  @override
  String get adminChatFaqDeleted => 'FAQ deleted successfully';

  @override
  String get adminChatFaqDeleteTitle => 'Delete FAQ';

  @override
  String get adminChatFaqEdit => 'Edit';

  @override
  String get adminChatFaqEditTitle => 'Edit FAQ Entry';

  @override
  String get adminChatFaqHelpful => 'Helpful';

  @override
  String get adminChatFaqInactive => 'Inactive';

  @override
  String get adminChatFaqKeywords => 'Keywords';

  @override
  String get adminChatFaqKeywordsHelper =>
      'Keywords help the chatbot find this FAQ';

  @override
  String get adminChatFaqKeywordsHint => 'Enter keywords separated by commas';

  @override
  String get adminChatFaqLoadMore => 'Load More';

  @override
  String get adminChatFaqNoFaqs => 'No FAQs found';

  @override
  String get adminChatFaqNotHelpful => 'Not Helpful';

  @override
  String get adminChatFaqPriority => 'Priority';

  @override
  String get adminChatFaqQuestion => 'Question';

  @override
  String get adminChatFaqQuestionHint => 'Enter the question';

  @override
  String get adminChatFaqQuestionRequired => 'Question is required';

  @override
  String get adminChatFaqSearch => 'Search FAQs...';

  @override
  String get adminChatFaqShowInactive => 'Show Inactive';

  @override
  String get adminChatFaqSubtitle => 'Manage FAQ entries for the chatbot';

  @override
  String get adminChatFaqTitle => 'FAQ Management';

  @override
  String get adminChatFaqUpdate => 'Update FAQ';

  @override
  String get adminChatFaqUpdated => 'FAQ updated successfully';

  @override
  String get adminChatFaqUses => 'Uses';

  @override
  String get adminChatFilter => 'Filter';

  @override
  String get adminChatFilterAll => 'All';

  @override
  String get adminChatFlag => 'Flag';

  @override
  String get adminChatLiveActiveFiveMin => 'Active in last 5 minutes';

  @override
  String get adminChatLiveAutoRefresh => 'Auto-refresh';

  @override
  String get adminChatLiveLive => 'LIVE';

  @override
  String get adminChatLiveLoadFailed => 'Failed to load live chats';

  @override
  String get adminChatLiveNoActive => 'No active chats at the moment';

  @override
  String get adminChatLivePaused => 'Paused';

  @override
  String get adminChatLiveSubtitle =>
      'Monitor active chat sessions in real-time';

  @override
  String get adminChatLiveTitle => 'Live Chat Monitor';

  @override
  String get adminChatNoConversations => 'No conversations found';

  @override
  String get adminChatQueueAllPriorities => 'All Priorities';

  @override
  String get adminChatQueueAllStatus => 'All Status';

  @override
  String get adminChatQueueAssigned => 'Assigned';

  @override
  String get adminChatQueueAssignedToYou => 'Assigned to you';

  @override
  String get adminChatQueueAssignToMe => 'Assign to me';

  @override
  String get adminChatQueueEscalatedHint =>
      'This conversation has been escalated';

  @override
  String get adminChatQueueHigh => 'High';

  @override
  String get adminChatQueueInProgress => 'In Progress';

  @override
  String get adminChatQueueLoadFailed => 'Failed to load queue';

  @override
  String get adminChatQueueLow => 'Low';

  @override
  String get adminChatQueueNoItems => 'No items in queue';

  @override
  String get adminChatQueueNormal => 'Normal';

  @override
  String get adminChatQueueOpen => 'Open';

  @override
  String get adminChatQueuePending => 'Pending';

  @override
  String get adminChatQueueReasonAutoEscalation =>
      'Auto-escalation due to wait time';

  @override
  String get adminChatQueueReasonLowConfidence => 'Low confidence AI response';

  @override
  String get adminChatQueueReasonNegativeFeedback => 'Negative user feedback';

  @override
  String get adminChatQueueReasonUserRequest => 'User requested human support';

  @override
  String get adminChatQueueStatus => 'Status';

  @override
  String get adminChatQueueSubtitle =>
      'Manage escalated conversations requiring attention';

  @override
  String get adminChatQueueTitle => 'Support Queue';

  @override
  String get adminChatQueueUrgent => 'Urgent';

  @override
  String get adminChatQuickReplies => 'Quick Replies';

  @override
  String get adminChatRefresh => 'Refresh';

  @override
  String get adminChatRefreshNow => 'Refresh Now';

  @override
  String get adminChatReplyHint => 'Type your reply...';

  @override
  String get adminChatReplySentResolved =>
      'Reply sent and conversation resolved';

  @override
  String get adminChatRestore => 'Restore';

  @override
  String get adminChatRetry => 'Retry';

  @override
  String get adminChatSearchConversations => 'Search conversations...';

  @override
  String get adminChatSendAndResolve => 'Send & Resolve';

  @override
  String get adminChatSendReply => 'Send Reply';

  @override
  String get adminChatStatusActive => 'Active';

  @override
  String get adminChatStatusArchived => 'Archived';

  @override
  String get adminChatStatusEscalated => 'Escalated';

  @override
  String get adminChatStatusFlagged => 'Flagged';

  @override
  String get adminChatSupportAgent => 'Support Agent';

  @override
  String get adminChatUnknownUser => 'Unknown User';

  @override
  String get adminFinanceActionCannotBeUndone => 'This action cannot be undone';

  @override
  String get adminFinanceAll => 'All';

  @override
  String get adminFinanceAllCompletedPayments => 'All Completed Payments';

  @override
  String get adminFinanceAllLevels => 'All Levels';

  @override
  String get adminFinanceAllRefundTransactions => 'All Refund Transactions';

  @override
  String get adminFinanceAllStatus => 'All Status';

  @override
  String get adminFinanceAllTime => 'All Time';

  @override
  String get adminFinanceAllTransactionsNormal =>
      'All transactions appear normal';

  @override
  String get adminFinanceAllTypes => 'All Types';

  @override
  String get adminFinanceAlreadyReviewed => 'Already Reviewed';

  @override
  String get adminFinanceAmount => 'Amount';

  @override
  String get adminFinanceAvgSettlement => 'Avg. Settlement';

  @override
  String get adminFinanceAwaitingProcessing => 'Awaiting Processing';

  @override
  String get adminFinanceCancel => 'Cancel';

  @override
  String get adminFinanceChooseTransaction => 'Choose a transaction';

  @override
  String get adminFinanceClose => 'Close';

  @override
  String get adminFinanceCompleted => 'Completed';

  @override
  String get adminFinanceConfirmRefund => 'Confirm Refund';

  @override
  String get adminFinanceCritical => 'Critical';

  @override
  String get adminFinanceCriticalHighRisk => 'Critical/High Risk';

  @override
  String get adminFinanceCurrency => 'Currency';

  @override
  String get adminFinanceDate => 'Date';

  @override
  String get adminFinanceDateRange => 'Date Range';

  @override
  String get adminFinanceDescription => 'Description';

  @override
  String get adminFinanceDownloadReceipt => 'Download Receipt';

  @override
  String get adminFinanceEligible => 'Eligible';

  @override
  String get adminFinanceExportReport => 'Export Report';

  @override
  String get adminFinanceFailed => 'Failed';

  @override
  String get adminFinanceFlaggedTransactions => 'Flagged Transactions';

  @override
  String get adminFinanceFraudDetectionSubtitle =>
      'Monitor suspicious activity and flagged transactions';

  @override
  String get adminFinanceFraudDetectionTitle => 'Fraud Detection';

  @override
  String get adminFinanceHigh => 'High';

  @override
  String get adminFinanceHighRisk => 'High Risk';

  @override
  String get adminFinanceItemType => 'Item Type';

  @override
  String get adminFinanceLast30Days => 'Last 30 Days';

  @override
  String get adminFinanceLast7Days => 'Last 7 Days';

  @override
  String get adminFinanceLow => 'Low';

  @override
  String get adminFinanceMarkReviewed => 'Mark as Reviewed';

  @override
  String get adminFinanceMedium => 'Medium';

  @override
  String get adminFinanceNewRefund => 'New Refund';

  @override
  String get adminFinanceNoEligibleTransactions =>
      'No eligible transactions for refund';

  @override
  String get adminFinanceNoMatchingAlerts => 'No matching alerts found';

  @override
  String get adminFinanceNoSettlementsFound => 'No settlements found';

  @override
  String get adminFinanceNoSuspiciousActivity =>
      'No suspicious activity detected';

  @override
  String get adminFinanceOriginalTxn => 'Original Transaction';

  @override
  String get adminFinancePayment => 'Payment';

  @override
  String get adminFinancePaymentsEligibleForRefund =>
      'Payments Eligible for Refund';

  @override
  String get adminFinancePending => 'Pending';

  @override
  String get adminFinancePendingReview => 'Pending Review';

  @override
  String get adminFinancePendingSettlement => 'Pending Settlement';

  @override
  String get adminFinanceProcessing => 'Processing';

  @override
  String get adminFinanceProcessNewRefund => 'Process New Refund';

  @override
  String get adminFinanceProcessRefund => 'Process Refund';

  @override
  String get adminFinanceReason => 'Reason';

  @override
  String get adminFinanceReasonForRefund => 'Reason for Refund';

  @override
  String get adminFinanceRefresh => 'Refresh';

  @override
  String get adminFinanceRefreshTransactions => 'Refresh Transactions';

  @override
  String get adminFinanceRefund => 'Refund';

  @override
  String get adminFinanceRefundDetails => 'Refund Details';

  @override
  String get adminFinanceRefunded => 'Refunded';

  @override
  String get adminFinanceRefundedAmount => 'Refunded Amount';

  @override
  String get adminFinanceRefundFailed => 'Refund Failed';

  @override
  String get adminFinanceRefundId => 'Refund ID';

  @override
  String get adminFinanceRefundProcessedFail => 'Failed to process refund';

  @override
  String get adminFinanceRefundProcessedSuccess =>
      'Refund processed successfully';

  @override
  String get adminFinanceRefundsSubtitle =>
      'Process and manage customer refunds';

  @override
  String get adminFinanceRefundsTitle => 'Refunds';

  @override
  String get adminFinanceRefundSuccess => 'Refund Successful';

  @override
  String get adminFinanceRescanTransactions => 'Rescan Transactions';

  @override
  String get adminFinanceRetry => 'Retry';

  @override
  String get adminFinanceReviewed => 'Reviewed';

  @override
  String get adminFinanceRiskLevel => 'Risk Level';

  @override
  String get adminFinanceSearchRefundsHint => 'Search refunds...';

  @override
  String get adminFinanceSearchSettlementsHint => 'Search settlements...';

  @override
  String get adminFinanceSearchTransactionsHint => 'Search transactions...';

  @override
  String get adminFinanceSelectTransactionToRefund =>
      'Select a transaction to refund';

  @override
  String get adminFinanceSettled => 'Settled';

  @override
  String get adminFinanceSettlement => 'Settlement';

  @override
  String get adminFinanceSettlementBatches => 'Settlement Batches';

  @override
  String get adminFinanceSettlementsSubtitle =>
      'View and manage payment settlements';

  @override
  String get adminFinanceSettlementsTitle => 'Settlements';

  @override
  String get adminFinanceShowReviewed => 'Show Reviewed';

  @override
  String get adminFinanceStatus => 'Status';

  @override
  String get adminFinanceSuccessful => 'Successful';

  @override
  String get adminFinanceSuccessfullyRefunded => 'Successfully refunded';

  @override
  String get adminFinanceToday => 'Today';

  @override
  String get adminFinanceTotalFlags => 'Total Flags';

  @override
  String get adminFinanceTotalRefunds => 'Total Refunds';

  @override
  String get adminFinanceTotalSettled => 'Total Settled';

  @override
  String get adminFinanceTotalVolume => 'Total Volume';

  @override
  String get adminFinanceTransactionDetails => 'Transaction Details';

  @override
  String get adminFinanceTransactionId => 'Transaction ID';

  @override
  String get adminFinanceTransactionsSubtitle =>
      'View and manage all financial transactions';

  @override
  String get adminFinanceTransactionsTitle => 'Transactions';

  @override
  String get adminFinanceType => 'Type';

  @override
  String get adminFinanceUnreviewed => 'Unreviewed';

  @override
  String get adminFinanceUser => 'User';

  @override
  String get adminFinanceUserId => 'User ID';

  @override
  String get adminFinanceViewDetails => 'View Details';

  @override
  String get adminFinanceYesterday => 'Yesterday';

  @override
  String get adminReportActivated => 'Activated';

  @override
  String get adminReportAllReports => 'All Reports';

  @override
  String get adminReportBuilderHelpTitle => 'Report Builder Help';

  @override
  String get adminReportBuilderTitle => 'Report Builder';

  @override
  String get adminReportCancel => 'Cancel';

  @override
  String get adminReportCreate => 'Create Report';

  @override
  String get adminReportCreateAutomatedReports =>
      'Create automated reports that run on a schedule';

  @override
  String get adminReportCreateSchedule => 'Create Schedule';

  @override
  String get adminReportCsvDescription => 'Spreadsheet format for Excel';

  @override
  String get adminReportCsvSpreadsheet => 'CSV Spreadsheet';

  @override
  String get adminReportDaily => 'Daily';

  @override
  String get adminReportDateRange => 'Date Range';

  @override
  String get adminReportDelete => 'Delete';

  @override
  String get adminReportDeleteScheduledReport => 'Delete Scheduled Report';

  @override
  String get adminReportDescriptionHint => 'Enter report description';

  @override
  String get adminReportDescriptionOptional => 'Description (Optional)';

  @override
  String get adminReportEdit => 'Edit';

  @override
  String get adminReportEditScheduledReport => 'Edit Scheduled Report';

  @override
  String get adminReportEmailRecipients => 'Email Recipients';

  @override
  String get adminReportEndDate => 'End Date';

  @override
  String get adminReportExportFormat => 'Export Format';

  @override
  String get adminReportFeature1 => 'Select metrics and data points';

  @override
  String get adminReportFeature2 => 'Choose date ranges';

  @override
  String get adminReportFeature3 => 'Export in multiple formats';

  @override
  String get adminReportFeature4 => 'Schedule automated reports';

  @override
  String get adminReportFeatures => 'Features';

  @override
  String get adminReportFrequency => 'Frequency';

  @override
  String get adminReportGenerate => 'Generate';

  @override
  String get adminReportGeneratedSuccess => 'Report generated successfully';

  @override
  String get adminReportGenerating => 'Generating...';

  @override
  String get adminReportGenerationStarted => 'Report generation started';

  @override
  String get adminReportGotIt => 'Got it';

  @override
  String get adminReportHelp => 'Help';

  @override
  String get adminReportHelpPresetsInfo =>
      'Use presets for quick report generation';

  @override
  String get adminReportHelpStep1 => 'Select metrics you want to include';

  @override
  String get adminReportHelpStep2 => 'Choose a date range';

  @override
  String get adminReportHelpStep3 => 'Select export format';

  @override
  String get adminReportHelpStep4 => 'Click Generate to create report';

  @override
  String get adminReportHelpStep5 => 'Download or share the report';

  @override
  String get adminReportHowToUse => 'How to Use';

  @override
  String get adminReportHowToUseScheduled => 'How to Use Scheduled Reports';

  @override
  String get adminReportInformation => 'Information';

  @override
  String get adminReportJsonData => 'JSON Data';

  @override
  String get adminReportJsonDescription => 'Raw data format for developers';

  @override
  String get adminReportLast30Days => 'Last 30 Days';

  @override
  String get adminReportLast7Days => 'Last 7 Days';

  @override
  String get adminReportLastMonth => 'Last Month';

  @override
  String get adminReportMetricAcceptanceRate => 'Acceptance Rate';

  @override
  String get adminReportMetricActiveSessions => 'Active Sessions';

  @override
  String get adminReportMetricConversion => 'Conversion Rate';

  @override
  String get adminReportMetricEngagement => 'Engagement';

  @override
  String get adminReportMetricNewRegistrations => 'New Registrations';

  @override
  String get adminReportMetricRevenue => 'Revenue';

  @override
  String get adminReportMetricTotalApplications => 'Total Applications';

  @override
  String get adminReportMetricTotalUsers => 'Total Users';

  @override
  String get adminReportMonthly => 'Monthly';

  @override
  String get adminReportNewSchedule => 'New Schedule';

  @override
  String get adminReportNewScheduledReport => 'New Scheduled Report';

  @override
  String get adminReportNextRun => 'Next Run';

  @override
  String get adminReportNoScheduledReports => 'No scheduled reports';

  @override
  String get adminReportPaused => 'Paused';

  @override
  String get adminReportPdfDescription => 'Formatted document for printing';

  @override
  String get adminReportPdfDocument => 'PDF Document';

  @override
  String get adminReportQuickPresets => 'Quick Presets';

  @override
  String get adminReportRecipientsRequired =>
      'At least one recipient is required';

  @override
  String get adminReportReportsSubtitle => 'Generate and download reports';

  @override
  String get adminReportReportsTitle => 'Reports';

  @override
  String get adminReportRunNow => 'Run Now';

  @override
  String get adminReportSave => 'Save';

  @override
  String get adminReportScheduledCreated => 'Scheduled report created';

  @override
  String get adminReportScheduledReportDeleted => 'Scheduled report deleted';

  @override
  String get adminReportScheduledReports => 'Scheduled Reports';

  @override
  String get adminReportScheduledReportsHelp => 'Scheduled Reports Help';

  @override
  String get adminReportScheduledStep1 => 'Create a new scheduled report';

  @override
  String get adminReportScheduledStep2 =>
      'Select frequency (daily, weekly, monthly)';

  @override
  String get adminReportScheduledStep3 => 'Choose metrics to include';

  @override
  String get adminReportScheduledStep4 => 'Add email recipients';

  @override
  String get adminReportScheduledStep5 => 'Reports will be sent automatically';

  @override
  String get adminReportScheduledUpdated => 'Scheduled report updated';

  @override
  String get adminReportSelectAll => 'Select All';

  @override
  String get adminReportSelectAtLeastOneMetric => 'Select at least one metric';

  @override
  String get adminReportSelectMetrics => 'Select Metrics';

  @override
  String get adminReportStartDate => 'Start Date';

  @override
  String get adminReportThisMonth => 'This Month';

  @override
  String get adminReportTitle => 'Report Title';

  @override
  String get adminReportTitleHint => 'Enter report title';

  @override
  String get adminReportTitleRequired => 'Title is required';

  @override
  String get adminReportTo => 'to';

  @override
  String get adminReportToday => 'Today';

  @override
  String get adminReportTomorrow => 'Tomorrow';

  @override
  String get adminReportWeekly => 'Weekly';

  @override
  String get adminSupportAcademic => 'Academic';

  @override
  String get adminSupportAccount => 'Account';

  @override
  String get adminSupportActive => 'Active';

  @override
  String get adminSupportAllCategories => 'All Categories';

  @override
  String get adminSupportAllStatus => 'All Status';

  @override
  String get adminSupportAnswer => 'Answer';

  @override
  String get adminSupportBilling => 'Billing';

  @override
  String get adminSupportCancel => 'Cancel';

  @override
  String get adminSupportCategory => 'Category';

  @override
  String get adminSupportCreateAction => 'Create';

  @override
  String get adminSupportCreateFaq => 'Create FAQ';

  @override
  String get adminSupportDelete => 'Delete';

  @override
  String get adminSupportDeleteFaq => 'Delete FAQ';

  @override
  String get adminSupportDraftArticles => 'Draft Articles';

  @override
  String get adminSupportEdit => 'Edit';

  @override
  String get adminSupportEditFaq => 'Edit FAQ';

  @override
  String get adminSupportFaqCreated => 'FAQ created successfully';

  @override
  String get adminSupportFaqDeleted => 'FAQ deleted successfully';

  @override
  String get adminSupportFaqEntries => 'FAQ Entries';

  @override
  String get adminSupportFaqUpdated => 'FAQ updated successfully';

  @override
  String get adminSupportGeneral => 'General';

  @override
  String get adminSupportHelpful => 'Helpful';

  @override
  String get adminSupportHighestHelpfulVotes => 'Highest Helpful Votes';

  @override
  String get adminSupportInactive => 'Inactive';

  @override
  String get adminSupportKeywords => 'Keywords';

  @override
  String get adminSupportKnowledgeBase => 'Knowledge Base';

  @override
  String get adminSupportKnowledgeBaseSubtitle =>
      'Manage FAQ entries and help articles';

  @override
  String get adminSupportMostHelpful => 'Most Helpful';

  @override
  String get adminSupportNotHelpful => 'Not Helpful';

  @override
  String get adminSupportPriority => 'Priority';

  @override
  String get adminSupportPublishedArticles => 'Published Articles';

  @override
  String get adminSupportQuestion => 'Question';

  @override
  String get adminSupportRefresh => 'Refresh';

  @override
  String get adminSupportSearchFaqHint => 'Search FAQs...';

  @override
  String get adminSupportStatus => 'Status';

  @override
  String get adminSupportTechnical => 'Technical';

  @override
  String get adminSupportToggleActive => 'Toggle Active';

  @override
  String get adminSupportTotalArticles => 'Total Articles';

  @override
  String get adminSupportUpdate => 'Update';

  @override
  String get adminSupportUses => 'Uses';

  @override
  String get adminUserAcademic => 'Academic';

  @override
  String get adminUserAcademicCounseling => 'Academic Counseling';

  @override
  String get adminUserAccountActiveDesc =>
      'Account is active and can access the platform';

  @override
  String get adminUserAccountInactiveDesc =>
      'Account is inactive and cannot access the platform';

  @override
  String get adminUserAccountSettings => 'Account Settings';

  @override
  String get adminUserAccountStatus => 'Account Status';

  @override
  String get adminUserAccountUpdatedSuccess => 'Account updated successfully';

  @override
  String get adminUserActivate => 'Activate';

  @override
  String get adminUserActivateCounselors => 'Activate Counselors';

  @override
  String get adminUserActive => 'Active';

  @override
  String get adminUserAddCounselor => 'Add Counselor';

  @override
  String get adminUserAddNewCounselor => 'Add New Counselor';

  @override
  String get adminUserAdminColumn => 'Admin';

  @override
  String get adminUserAdminInformation => 'Admin Information';

  @override
  String get adminUserAdminRole => 'Admin Role';

  @override
  String get adminUserAdmins => 'Admins';

  @override
  String get adminUserAdminUsers => 'Admin Users';

  @override
  String get adminUserAll => 'All';

  @override
  String get adminUserAllRoles => 'All Roles';

  @override
  String get adminUserAllSpecialties => 'All Specialties';

  @override
  String get adminUserAllStatus => 'All Status';

  @override
  String get adminUserAnalyticsAdmin => 'Analytics Admin';

  @override
  String get adminUserAvailability => 'Availability';

  @override
  String get adminUserAvailabilityHint => 'E.g., Mon-Fri 9am-5pm';

  @override
  String get adminUserBackToCounselors => 'Back to Counselors';

  @override
  String get adminUserCancel => 'Cancel';

  @override
  String get adminUserCareer => 'Career';

  @override
  String get adminUserCareerGuidance => 'Career Guidance';

  @override
  String get adminUserChooseRoleHelperText =>
      'Choose the admin role for this user';

  @override
  String get adminUserCollege => 'College';

  @override
  String get adminUserCollegeAdmissions => 'College Admissions';

  @override
  String get adminUserConfirmDeactivation => 'Confirm Deactivation';

  @override
  String get adminUserConfirmPassword => 'Confirm Password';

  @override
  String get adminUserContactAndAvailability => 'Contact & Availability';

  @override
  String get adminUserContentAdmin => 'Content Admin';

  @override
  String get adminUserCounselorColumn => 'Counselor';

  @override
  String get adminUserCounselorCreatedSuccess =>
      'Counselor created successfully';

  @override
  String get adminUserCounselorId => 'Counselor ID';

  @override
  String get adminUserCounselors => 'Counselors';

  @override
  String get adminUserCounselorUpdatedSuccess =>
      'Counselor updated successfully';

  @override
  String get adminUserCreate => 'Create';

  @override
  String get adminUserCreateAdmin => 'Create Admin';

  @override
  String get adminUserCreateAdminAccount => 'Create Admin Account';

  @override
  String get adminUserCreateAdminSubtitle => 'Create a new admin user account';

  @override
  String get adminUserCreateCounselor => 'Create Counselor';

  @override
  String get adminUserCreateCounselorSubtitle =>
      'Create a new counselor account';

  @override
  String get adminUserCreated => 'Created';

  @override
  String get adminUserCredentials => 'Credentials';

  @override
  String get adminUserCredentialsHint =>
      'Professional certifications and licenses';

  @override
  String get adminUserDashboard => 'Dashboard';

  @override
  String get adminUserDeactivate => 'Deactivate';

  @override
  String get adminUserDeactivateAccount => 'Deactivate Account';

  @override
  String get adminUserDeactivateCounselors => 'Deactivate Counselors';

  @override
  String get adminUserDeactivationComingSoon =>
      'Deactivation feature coming soon';

  @override
  String get adminUserEdit => 'Edit';

  @override
  String get adminUserEditAdmin => 'Edit Admin';

  @override
  String get adminUserEditAdminAccount => 'Edit Admin Account';

  @override
  String get adminUserEditCounselor => 'Edit Counselor';

  @override
  String get adminUserEmail => 'Email';

  @override
  String get adminUserEmailCannotBeChanged => 'Email cannot be changed';

  @override
  String get adminUserEmailLoginHelper => 'This email will be used to log in';

  @override
  String get adminUserExport => 'Export';

  @override
  String get adminUserExportComingSoon => 'Export feature coming soon';

  @override
  String get adminUserExportCounselors => 'Export Counselors';

  @override
  String get adminUserFailedCreateAccount => 'Failed to create account';

  @override
  String get adminUserFailedLoadData => 'Failed to load data';

  @override
  String get adminUserFailedUpdateAccount => 'Failed to update account';

  @override
  String get adminUserFinanceAdmin => 'Finance Admin';

  @override
  String get adminUserFinancialAid => 'Financial Aid';

  @override
  String get adminUserFirstName => 'First Name';

  @override
  String get adminUserFullName => 'Full Name';

  @override
  String get adminUserInactive => 'Inactive';

  @override
  String get adminUserInstitutionCreatedSuccess =>
      'Institution created successfully';

  @override
  String get adminUserInstitutionInformation => 'Institution Information';

  @override
  String get adminUserInstitutionName => 'Institution Name';

  @override
  String get adminUserInstitutionUpdatedSuccess =>
      'Institution updated successfully';

  @override
  String get adminUserInvalidEmail => 'Invalid email address';

  @override
  String get adminUserJoined => 'Joined';

  @override
  String get adminUserLanguageSchool => 'Language School';

  @override
  String get adminUserLastLogin => 'Last Login';

  @override
  String get adminUserLastName => 'Last Name';

  @override
  String get adminUserLicenseNumber => 'License Number';

  @override
  String get adminUserManageAdminAccounts => 'Manage Admin Accounts';

  @override
  String get adminUserManageCounselorAccounts => 'Manage Counselor Accounts';

  @override
  String get adminUserMentalHealth => 'Mental Health';

  @override
  String get adminUserNoPermissionDeactivate =>
      'You don\'t have permission to deactivate this account';

  @override
  String get adminUserNoPermissionEdit =>
      'You don\'t have permission to edit this account';

  @override
  String get adminUserOfficeLocation => 'Office Location';

  @override
  String get adminUserOfficeLocationHint => 'Building and room number';

  @override
  String get adminUserPassword => 'Password';

  @override
  String get adminUserPasswordHelper => 'Minimum 8 characters';

  @override
  String get adminUserPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get adminUserPending => 'Pending';

  @override
  String get adminUserPendingApproval => 'Pending Approval';

  @override
  String get adminUserPendingVerification => 'Pending Verification';

  @override
  String get adminUserPersonalInformation => 'Personal Information';

  @override
  String get adminUserPhone => 'Phone';

  @override
  String get adminUserPhoneHelper => 'Include country code';

  @override
  String get adminUserPhoneNumber => 'Phone Number';

  @override
  String get adminUserPleaseConfirmPassword => 'Please confirm your password';

  @override
  String get adminUserProfessionalInformation => 'Professional Information';

  @override
  String get adminUserRegionalAdmin => 'Regional Admin';

  @override
  String get adminUserRegionalScope => 'Regional Scope';

  @override
  String get adminUserRegionalScopeHelper =>
      'Select the regions this admin can manage';

  @override
  String get adminUserRejected => 'Rejected';

  @override
  String get adminUserRequired => 'Required';

  @override
  String get adminUserRequiredForRegional => 'Required for regional admin role';

  @override
  String get adminUserRoleColumn => 'Role';

  @override
  String get adminUserSaveChanges => 'Save Changes';

  @override
  String get adminUserSearchByNameOrEmail => 'Search by name or email';

  @override
  String get adminUserSearchCounselors => 'Search counselors...';

  @override
  String get adminUserSecuritySettings => 'Security Settings';

  @override
  String get adminUserSelectAdminRole => 'Select Admin Role';

  @override
  String get adminUserSessions => 'Sessions';

  @override
  String get adminUserSpecialty => 'Specialty';

  @override
  String get adminUserStatus => 'Status';

  @override
  String get adminUserStatusColumn => 'Status';

  @override
  String get adminUserStudents => 'Students';

  @override
  String get adminUserStudySkills => 'Study Skills';

  @override
  String get adminUserSuperAdmin => 'Super Admin';

  @override
  String get adminUserSupportAdmin => 'Support Admin';

  @override
  String get adminUserSuspended => 'Suspended';

  @override
  String get adminUserType => 'Type';

  @override
  String get adminUserUniversity => 'University';

  @override
  String get adminUserUpdateAdminSubtitle => 'Update admin account information';

  @override
  String get adminUserUpdateCounselor => 'Update Counselor';

  @override
  String get adminUserUpdateCounselorSubtitle =>
      'Update counselor account information';

  @override
  String get adminUserVerified => 'Verified';

  @override
  String get adminUserViewDetails => 'View Details';

  @override
  String get adminUserVocationalSchool => 'Vocational School';

  @override
  String get adminUserWebsite => 'Website';

  @override
  String get adminUserYearsOfExperience => 'Years of Experience';

  @override
  String adminAnalyticsShowingRows(Object count, Object total) {
    return 'Showing $count of $total rows';
  }

  @override
  String adminAnalyticsColumnsCount(Object count) {
    return '$count columns';
  }

  @override
  String adminChatFailedSendReply(Object error) {
    return 'Failed to send reply: $error';
  }

  @override
  String adminChatRole(Object role) {
    return 'Role: $role';
  }

  @override
  String adminChatMessageCount(Object count) {
    return '$count messages';
  }

  @override
  String adminChatStarted(Object date) {
    return 'Started: $date';
  }

  @override
  String adminChatLastMessage(Object date) {
    return 'Last message: $date';
  }

  @override
  String adminChatDuration(Object duration) {
    return 'Duration: $duration';
  }

  @override
  String adminChatFaqDeleteConfirm(Object question) {
    return 'Are you sure you want to delete \"$question\"?';
  }

  @override
  String adminChatFaqDeleteFailed(Object error) {
    return 'Failed to delete FAQ: $error';
  }

  @override
  String adminChatFaqUpdateFailed(Object error) {
    return 'Failed to update FAQ: $error';
  }

  @override
  String adminChatFaqSaveFailed(Object error) {
    return 'Failed to save FAQ: $error';
  }

  @override
  String adminChatQueueAssignFailed(Object error) {
    return 'Failed to assign conversation: $error';
  }

  @override
  String adminReportGenerateFailed(Object error) {
    return 'Failed to generate report: $error';
  }

  @override
  String adminReportNameGeneratedSuccess(Object name) {
    return '$name generated successfully';
  }

  @override
  String adminReportInDays(Object days) {
    return 'in $days days';
  }

  @override
  String adminUserErrorLoadingData(Object error) {
    return 'Error loading data: $error';
  }

  @override
  String adminUserAccountCreatedSuccess(Object email) {
    return 'Account $email created successfully';
  }

  @override
  String adminUserError(Object error) {
    return 'Error: $error';
  }

  @override
  String adminUserCannotActivateInsufficient(Object count) {
    return 'Cannot activate $count admins: insufficient permissions';
  }

  @override
  String adminUserAdminsActivated(Object count) {
    return '$count admins activated';
  }

  @override
  String adminUserCannotDeactivateInsufficient(Object count) {
    return 'Cannot deactivate $count admins: insufficient permissions';
  }

  @override
  String adminUserConfirmDeactivateAdmins(Object count) {
    return 'Are you sure you want to deactivate $count admins?';
  }

  @override
  String adminUserAdminsDeactivated(Object count) {
    return '$count admins deactivated';
  }

  @override
  String adminUserConfirmActivateCounselors(Object count) {
    return 'Are you sure you want to activate $count counselors?';
  }

  @override
  String adminUserConfirmDeactivateCounselors(Object count) {
    return 'Are you sure you want to deactivate $count counselors?';
  }

  @override
  String get adminActivityTitle => 'Activity Logs';

  @override
  String get adminActivitySubtitle =>
      'Audit trail of all administrative actions';

  @override
  String get adminActivityExportLogs => 'Export Logs';

  @override
  String get adminActivityResetFilters => 'Reset Filters';

  @override
  String get adminActivitySearchHint => 'Search by admin, action, or target...';

  @override
  String get adminActivityActionType => 'Action Type';

  @override
  String get adminActivityAllTypes => 'All Types';

  @override
  String get adminActivityCreate => 'Create';

  @override
  String get adminActivityUpdate => 'Update';

  @override
  String get adminActivityDelete => 'Delete';

  @override
  String get adminActivityLogin => 'Login';

  @override
  String get adminActivityLogout => 'Logout';

  @override
  String get adminActivityExport => 'Export';

  @override
  String get adminActivityBulkOperation => 'Bulk Operation';

  @override
  String get adminActivitySeverity => 'Severity';

  @override
  String get adminActivityAllSeverity => 'All Severity';

  @override
  String get adminActivityInfo => 'Info';

  @override
  String get adminActivityWarning => 'Warning';

  @override
  String get adminActivityCritical => 'Critical';

  @override
  String get adminActivityDateRange => 'Date Range';

  @override
  String get adminActivityTimestamp => 'Timestamp';

  @override
  String get adminActivityAdmin => 'Admin';

  @override
  String get adminActivityAction => 'Action';

  @override
  String get adminActivityTarget => 'Target';

  @override
  String get adminActivityDetails => 'Details';

  @override
  String get adminActivityIpAddress => 'IP Address';

  @override
  String get adminActivityExportDialogTitle => 'Export Activity Logs';

  @override
  String get adminActivityLogsReport => 'Activity Logs Report';

  @override
  String get homePageApiDocsTitle => 'API Documentation';

  @override
  String get homePagePressKit => 'Press Kit';

  @override
  String get adminDashSystemUser => 'System';

  @override
  String adminDashErrorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String get adminSettingsTimezoneNairobi => 'Nairobi (EAT)';

  @override
  String get adminSettingsTimezoneLagos => 'Lagos (WAT)';

  @override
  String get adminSettingsTimezoneCairo => 'Cairo (EET)';

  @override
  String get adminRichTextBoldTooltip => 'Bold (**text**)';

  @override
  String get adminRichTextBoldPlaceholder => 'bold text';

  @override
  String get adminRichTextItalicTooltip => 'Italic (*text*)';

  @override
  String get adminRichTextItalicPlaceholder => 'italic text';

  @override
  String get adminRichTextUnderlineTooltip => 'Underline';

  @override
  String get adminRichTextUnderlinePlaceholder => 'underlined text';

  @override
  String get adminRichTextStrikethroughTooltip => 'Strikethrough (~~text~~)';

  @override
  String get adminRichTextStrikethroughPlaceholder => 'strikethrough';

  @override
  String get adminRichTextHeading1Tooltip => 'Heading 1';

  @override
  String get adminRichTextHeading2Tooltip => 'Heading 2';

  @override
  String get adminRichTextHeading3Tooltip => 'Heading 3';

  @override
  String get adminRichTextBulletListTooltip => 'Bullet list';

  @override
  String get adminRichTextNumberedListTooltip => 'Numbered list';

  @override
  String get adminRichTextQuoteTooltip => 'Quote';

  @override
  String get adminRichTextLinkTooltip => 'Insert link [text](url)';

  @override
  String get adminRichTextLinkPlaceholder => 'link text';

  @override
  String get adminRichTextCodeTooltip => 'Inline code';

  @override
  String get adminRichTextCodePlaceholder => 'code';

  @override
  String get adminRichTextHorizontalLineTooltip => 'Horizontal line';

  @override
  String get instCourseMarkdown => 'Markdown';

  @override
  String get instCourseRichText => 'Rich Text';

  @override
  String get studCourseRetry => 'Retry';

  @override
  String get studCourseSubmitAssignment => 'Submit Assignment';

  @override
  String get adminNotifTitle => 'Notifications Center';

  @override
  String get adminNotifSubtitle =>
      'Stay updated with system events and user activities';

  @override
  String get adminNotifMarkAllAsRead => 'Mark All as Read';

  @override
  String get adminNotifClearAll => 'Clear All';

  @override
  String adminNotifUnreadCount(Object count) {
    return '$count unread';
  }

  @override
  String get adminNotifPriority => 'Priority';

  @override
  String get adminNotifAllPriorities => 'All Priorities';

  @override
  String get adminNotifUnreadOnly => 'Unread only';

  @override
  String get adminNotifNotificationTypes => 'Notification Types';

  @override
  String get adminNotifAllNotifications => 'All Notifications';

  @override
  String get adminNotifMarkAsUnread => 'Mark as Unread';

  @override
  String get adminNotifMarkAsRead => 'Mark as Read';

  @override
  String get adminNotifDelete => 'Delete';

  @override
  String get adminNotifNoNotifications => 'No notifications';

  @override
  String get adminNotifAllCaughtUp => 'You\'re all caught up!';

  @override
  String get adminNotifJustNow => 'Just now';

  @override
  String adminNotifMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String adminNotifHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String adminNotifDaysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get adminNotifClearAllTitle => 'Clear All Notifications';

  @override
  String get adminNotifClearAllConfirmation =>
      'Are you sure you want to clear all notifications? This action cannot be undone.';

  @override
  String get adminNotifCancel => 'Cancel';

  @override
  String get adminCounselorsListUnknownCounselor => 'Unknown Counselor';

  @override
  String get adminCounselorsListNotSpecified => 'Not specified';

  @override
  String get adminCounselorsListToday => 'Today';

  @override
  String get adminCounselorsListYesterday => 'Yesterday';

  @override
  String adminCounselorsListDaysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String adminCounselorsListWeeksAgo(Object count) {
    return '$count weeks ago';
  }

  @override
  String adminCounselorsListMonthsAgo(Object count) {
    return '$count months ago';
  }

  @override
  String adminCounselorsListYearsAgo(Object count) {
    return '$count years ago';
  }

  @override
  String adminCounselorsListError(Object error) {
    return 'Error: $error';
  }

  @override
  String get homePageAboutTitle => 'About Us';

  @override
  String get homePageOurMission => 'Our Mission';

  @override
  String adminReportLastGenerated(Object date) {
    return 'Last: $date';
  }

  @override
  String get adminReportUserActivityReport => 'User Activity Report';

  @override
  String get adminReportUserActivityDescription =>
      'Comprehensive overview of user registrations, logins, and activity patterns';

  @override
  String get adminReportEngagementMetrics => 'Engagement Metrics';

  @override
  String get adminReportEngagementDescription =>
      'Track user engagement, course enrollments, and platform interactions';

  @override
  String get adminReportSystemPerformance => 'System Performance';

  @override
  String get adminReportSystemPerformanceDescription =>
      'API response times, throughput, and system performance metrics';

  @override
  String get adminReportRevenueReport => 'Revenue Report';

  @override
  String get adminReportRevenueDescription =>
      'Detailed breakdown of revenue, subscriptions, and transactions';

  @override
  String get adminReportPaymentAnalytics => 'Payment Analytics';

  @override
  String get adminReportPaymentAnalyticsDescription =>
      'Payment success rates, processing times, and transaction analysis';

  @override
  String get adminReportUserGrowthReport => 'User Growth Report';

  @override
  String get adminReportUserGrowthDescription =>
      'Track user acquisition, retention, and growth trends over time';

  @override
  String get adminReportSystemHealthReport => 'System Health Report';

  @override
  String get adminReportSystemHealthDescription =>
      'Infrastructure status, uptime, resource utilization, and health metrics';

  @override
  String get adminReportApplicationFunnel => 'Application Funnel';

  @override
  String get adminReportApplicationFunnelDescription =>
      'Track application submissions, conversions, and completion rates';

  @override
  String get adminReportAuditTrailReport => 'Audit Trail Report';

  @override
  String get adminReportAuditTrailDescription =>
      'Complete audit trail of admin actions and system changes';

  @override
  String get adminReportDataAccessReport => 'Data Access Report';

  @override
  String get adminReportDataAccessDescription =>
      'Track data access patterns and sensitive information requests';

  @override
  String get adminReportDefaultTitle => 'Analytics Report';

  @override
  String get adminReportMetricHeader => 'Metric';

  @override
  String get adminReportValueHeader => 'Value';

  @override
  String adminReportDeleteConfirmation(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String adminReportRecipientsCount(Object count) {
    return '$count recipients';
  }

  @override
  String get adminReportEmailRecipientsHint =>
      'admin@example.com, manager@example.com';

  @override
  String get adminSqlTitle => 'SQL Queries';

  @override
  String get adminSqlSubtitle => 'Run pre-built queries against platform data';

  @override
  String get adminSqlSearchHint => 'Search queries...';

  @override
  String get adminSqlRetry => 'Retry';

  @override
  String get adminSqlSelectQuery => 'Select a query to run';

  @override
  String get adminSqlSelectQueryHint =>
      'Choose from the query library on the left';

  @override
  String get adminSqlNoResults => 'No results';

  @override
  String adminSqlResultCount(Object columns, Object rows) {
    return '$rows rows  |  $columns columns';
  }

  @override
  String get adminSqlAllUsersName => 'All Users';

  @override
  String get adminSqlAllUsersDescription =>
      'List every registered user with profile data';

  @override
  String get adminSqlStudentsOnlyName => 'Students Only';

  @override
  String get adminSqlStudentsOnlyDescription =>
      'Filter users to show only students';

  @override
  String get adminSqlAdminUsersName => 'Admin Users';

  @override
  String get adminSqlAdminUsersDescription => 'List all administrator accounts';

  @override
  String get adminSqlRecentActivityName => 'Recent Activity';

  @override
  String get adminSqlRecentActivityDescription =>
      'Last 50 platform activities from the audit log';

  @override
  String get adminSqlActivityStatisticsName => 'Activity Statistics';

  @override
  String get adminSqlActivityStatisticsDescription =>
      'Aggregated activity counts by type';

  @override
  String get adminSqlPlatformMetricsName => 'Platform Metrics';

  @override
  String get adminSqlPlatformMetricsDescription =>
      'Key metrics: user counts, applications, growth rates';

  @override
  String get adminSqlFinanceOverviewName => 'Finance Overview';

  @override
  String get adminSqlFinanceOverviewDescription =>
      'Revenue, transactions, and financial KPIs';

  @override
  String get adminSqlContentStatisticsName => 'Content Statistics';

  @override
  String get adminSqlContentStatisticsDescription =>
      'Published, draft, and pending content counts';

  @override
  String get adminSqlOpenSupportTicketsName => 'Open Support Tickets';

  @override
  String get adminSqlOpenSupportTicketsDescription =>
      'All currently open support tickets';

  @override
  String get adminSqlRecentTransactionsName => 'Recent Transactions';

  @override
  String get adminSqlRecentTransactionsDescription =>
      'Financial transactions (last 100)';

  @override
  String get adminSqlUserGrowthName => 'User Growth (6 Months)';

  @override
  String get adminSqlUserGrowthDescription => 'Monthly user registration trend';

  @override
  String get adminSqlRoleDistributionName => 'Role Distribution';

  @override
  String get adminSqlRoleDistributionDescription =>
      'Breakdown of users by role type';

  @override
  String get adminInstitutionLocation => 'Location';

  @override
  String get adminInstitutionAddress => 'Address';

  @override
  String get adminInstitutionCity => 'City';

  @override
  String get adminInstitutionCountry => 'Country';

  @override
  String get adminInstitutionContactPerson => 'Contact Person';

  @override
  String get adminInstitutionFullName => 'Full Name';

  @override
  String get adminInstitutionPosition => 'Position';

  @override
  String get adminInstitutionContactEmail => 'Email';

  @override
  String get adminInstitutionContactPhone => 'Phone';

  @override
  String get adminInstitutionRequired => 'Required';

  @override
  String get adminInstitutionInvalidEmail => 'Invalid email';

  @override
  String get adminInstitutionBackToInstitutions => 'Back to Institutions';

  @override
  String get adminInstitutionEditInstitution => 'Edit Institution';

  @override
  String get adminInstitutionAddNewInstitution => 'Add New Institution';

  @override
  String get adminInstitutionUpdateAccountInfo =>
      'Update institution account information';

  @override
  String get adminInstitutionCreateAccountInfo =>
      'Create a new institution account';

  @override
  String get adminInstitutionCancel => 'Cancel';

  @override
  String get adminInstitutionUpdateInstitution => 'Update Institution';

  @override
  String get adminInstitutionCreateInstitution => 'Create Institution';

  @override
  String get adminMessagingTitle => 'Bulk Messaging';

  @override
  String get adminMessagingSubtitle =>
      'Send messages to multiple users at once';

  @override
  String get adminMessagingNewMessage => 'New Message';

  @override
  String get adminMessagingSubjectLabel => 'Subject';

  @override
  String get adminMessagingSubjectHint => 'Enter message subject';

  @override
  String get adminMessagingMessageLabel => 'Message';

  @override
  String get adminMessagingMessageHint => 'Enter your message here...';

  @override
  String get adminMessagingSaveDraft => 'Save Draft';

  @override
  String get adminMessagingPreview => 'Preview';

  @override
  String get adminMessagingSending => 'Sending...';

  @override
  String get adminMessagingSendMessage => 'Send Message';

  @override
  String get adminMessagingRecipients => 'Recipients';

  @override
  String get adminMessagingDeliveryChannel => 'Delivery Channel';

  @override
  String get adminMessagingSchedule => 'Schedule';

  @override
  String get adminMessagingTemplates => 'Message Templates';

  @override
  String get adminMessagingRecentMessages => 'Recent Messages';

  @override
  String adminMessagingSentCount(Object count) {
    return '$count sent';
  }

  @override
  String get adminMessagingFillAllFields => 'Please fill in all fields';

  @override
  String get adminMessagingSendMessageTitle => 'Send Message';

  @override
  String adminMessagingSendConfirmation(Object group) {
    return 'Are you sure you want to send this message to $group?';
  }

  @override
  String get adminMessagingCancel => 'Cancel';

  @override
  String get adminMessagingSend => 'Send';

  @override
  String get adminMessagingSentSuccess => 'Message sent successfully';

  @override
  String get adminMessagingDraftSaved => 'Draft saved';

  @override
  String get adminMessagingPreviewTitle => 'Message Preview';

  @override
  String adminMessagingPreviewSubject(Object subject) {
    return 'Subject: $subject';
  }

  @override
  String adminMessagingPreviewTo(Object recipient) {
    return 'To: $recipient';
  }

  @override
  String adminMessagingPreviewVia(Object channel) {
    return 'Via: $channel';
  }

  @override
  String get adminMessagingClose => 'Close';

  @override
  String get adminMessagingTemplateWelcomeName => 'Welcome Message';

  @override
  String get adminMessagingTemplateWelcomeSubject => 'Welcome to Flow!';

  @override
  String get adminMessagingTemplateWelcomeContent =>
      'Hello! Welcome to Flow, your educational journey starts here. We\'re excited to have you join our community.';

  @override
  String get adminMessagingTemplatePaymentName => 'Payment Reminder';

  @override
  String get adminMessagingTemplatePaymentSubject => 'Payment Due Reminder';

  @override
  String get adminMessagingTemplatePaymentContent =>
      'This is a friendly reminder that your payment is due soon. Please complete your payment to continue enjoying our services.';

  @override
  String get adminMessagingTemplateSystemName => 'System Update';

  @override
  String get adminMessagingTemplateSystemSubject => 'System Maintenance Notice';

  @override
  String get adminMessagingTemplateSystemContent =>
      'We will be performing scheduled maintenance on our systems. During this time, some features may be unavailable.';

  @override
  String get adminMessagingRecentWelcomeSubject => 'Welcome to New Semester';

  @override
  String get adminMessagingRecentWelcomeContent =>
      'We hope you had a great break! Get ready for an exciting semester ahead.';

  @override
  String get adminMessagingRecentPaymentSubject => 'Payment Due Reminder';

  @override
  String get adminMessagingRecentPaymentContent =>
      'This is a reminder that your payment is due by the end of this week.';

  @override
  String get adminMessagingRecentFeaturesSubject => 'New Features Released';

  @override
  String get adminMessagingRecentFeaturesContent =>
      'Check out our latest features and improvements to enhance your experience.';

  @override
  String get instCourseAdvancedModule => 'Advanced Module';

  @override
  String get instCourseImportQuiz => 'Import Quiz';

  @override
  String get adminLoginTitle => 'Admin Portal';

  @override
  String get adminLoginSubtitle => 'Secure Administrator Access';

  @override
  String get adminLoginEmailLabel => 'Admin Email';

  @override
  String get adminLoginEmailHint => 'admin@example.com';

  @override
  String get adminLoginEmailRequired => 'Please enter your email';

  @override
  String get adminLoginEmailInvalid => 'Please enter a valid email';

  @override
  String get adminLoginPasswordLabel => 'Password';

  @override
  String get adminLoginPasswordHint => 'Enter your password';

  @override
  String get adminLoginPasswordRequired => 'Please enter your password';

  @override
  String get adminLoginPasswordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get adminLoginSignInButton => 'Sign In Securely';

  @override
  String get adminLoginSecurityNotice =>
      'All admin activities are logged and monitored for security.';

  @override
  String get adminLoginBackToSite => 'Back to Main Site';

  @override
  String adminLoginFailed(Object error) {
    return 'Login failed: $error';
  }

  @override
  String get homePageBlogTitle => 'Blog';

  @override
  String get homePageSubscribe => 'Subscribe';

  @override
  String get adminKbRetry => 'Retry';

  @override
  String get adminKbKeywordsHint => 'e.g. login, password, reset';

  @override
  String get adminKbPriorityLow => '0 - Low';

  @override
  String get adminKbPriorityMedium => '1 - Medium';

  @override
  String get adminKbPriorityHigh => '2 - High';

  @override
  String get adminKbPriorityCritical => '3 - Critical';

  @override
  String adminKbDeleteConfirmMessage(Object question) {
    return 'Are you sure you want to delete \"$question\"?';
  }

  @override
  String get instCounselorsSearchHint => 'Search counselors...';

  @override
  String get instCounselorsRetry => 'Retry';

  @override
  String get instCounselorsNoCounselorsFound => 'No Counselors Found';

  @override
  String get instCounselorsNoMatchSearch => 'No counselors match your search';

  @override
  String get instCounselorsAddToInstitution =>
      'Add counselors to your institution';

  @override
  String instCounselorsPageOf(Object current, Object total) {
    return 'Page $current of $total';
  }

  @override
  String get instCounselorsCounselingOverview => 'Counseling Overview';

  @override
  String get instCounselorsCounselors => 'Counselors';

  @override
  String get instCounselorsStudents => 'Students';

  @override
  String get instCounselorsSessions => 'Sessions';

  @override
  String get instCounselorsCompleted => 'Completed';

  @override
  String get instCounselorsUpcoming => 'Upcoming';

  @override
  String get instCounselorsAvgRating => 'Avg Rating';

  @override
  String get instCounselorsStudentAssigned => 'Student assigned successfully';

  @override
  String get instCounselorsAssign => 'Assign';

  @override
  String get instCounselorsTotalSessions => 'Total Sessions';

  @override
  String get instCounselorsAssignStudents => 'Assign Students';

  @override
  String instCounselorsAssignStudentTo(Object name) {
    return 'Assign Student to $name';
  }

  @override
  String get instCounselorsSearchStudents => 'Search students...';

  @override
  String get instCounselorsNoStudentsFound => 'No students found';

  @override
  String get instCounselorsUnknown => 'Unknown';

  @override
  String instCounselorsError(Object error) {
    return 'Error: $error';
  }

  @override
  String get instCounselorsCancel => 'Cancel';

  @override
  String get adminAuditAction => 'Admin Audit Action';

  @override
  String get adminAuditActionType => 'Admin Audit Action Type';

  @override
  String get adminAuditAllActions => 'Admin Audit All Actions';

  @override
  String get adminAuditBackendIntegrationNote =>
      'Admin Audit Backend Integration Note';

  @override
  String get adminAuditClose => 'Admin Audit Close';

  @override
  String get adminAuditCreateRecord => 'Admin Audit Create Record';

  @override
  String get adminAuditCustomRange => 'Admin Audit Custom Range';

  @override
  String get adminAuditDateRange => 'Admin Audit Date Range';

  @override
  String get adminAuditDeleteRecord => 'Admin Audit Delete Record';

  @override
  String get adminAuditDetails => 'Admin Audit Details';

  @override
  String get adminAuditExportData => 'Admin Audit Export Data';

  @override
  String get adminAuditExportReport => 'Admin Audit Export Report';

  @override
  String get adminAuditIpAddress => 'Admin Audit Ip Address';

  @override
  String get adminAuditLast30Days => 'Admin Audit Last30 Days';

  @override
  String get adminAuditLast7Days => 'Admin Audit Last7 Days';

  @override
  String get adminAuditLogDetails => 'Admin Audit Log Details';

  @override
  String get adminAuditLogin => 'Admin Audit Login';

  @override
  String get adminAuditLogout => 'Admin Audit Logout';

  @override
  String get adminAuditRefreshLogs => 'Admin Audit Refresh Logs';

  @override
  String get adminAuditResource => 'Admin Audit Resource';

  @override
  String get adminAuditRole => 'Admin Audit Role';

  @override
  String get adminAuditSearchHint => 'Admin Audit Search Hint';

  @override
  String get adminAuditSubtitle => 'Admin Audit Subtitle';

  @override
  String get adminAuditTimestamp => 'Admin Audit Timestamp';

  @override
  String get adminAuditTitle => 'Admin Audit Title';

  @override
  String get adminAuditToday => 'Admin Audit Today';

  @override
  String get adminAuditUpdateRecord => 'Admin Audit Update Record';

  @override
  String get adminAuditUser => 'Admin Audit User';

  @override
  String get adminAuditViewDetails => 'Admin Audit View Details';

  @override
  String get adminAuditYesterday => 'Admin Audit Yesterday';

  @override
  String get adminCommActionDelete => 'Admin Comm Action Delete';

  @override
  String get adminCommActionDuplicate => 'Admin Comm Action Duplicate';

  @override
  String get adminCommActionSchedule => 'Admin Comm Action Schedule';

  @override
  String get adminCommActionSendNow => 'Admin Comm Action Send Now';

  @override
  String get adminCommActionViewDetails => 'Admin Comm Action View Details';

  @override
  String get adminCommCampaignDeleted => 'Admin Comm Campaign Deleted';

  @override
  String adminCommCampaignScheduledFor(String date) {
    return 'Admin Comm Campaign Scheduled For: $date';
  }

  @override
  String get adminCommCampaignTitleHint => 'Admin Comm Campaign Title Hint';

  @override
  String get adminCommCampaignTitleLabel => 'Admin Comm Campaign Title Label';

  @override
  String get adminCommCancel => 'Admin Comm Cancel';

  @override
  String get adminCommClose => 'Admin Comm Close';

  @override
  String get adminCommConfirm => 'Admin Comm Confirm';

  @override
  String get adminCommCreateCampaign => 'Admin Comm Create Campaign';

  @override
  String get adminCommCreateCampaignDialogTitle =>
      'Admin Comm Create Campaign Dialog Title';

  @override
  String adminCommDeleteCampaignMessage(String campaign) {
    return 'Admin Comm Delete Campaign Message: $campaign';
  }

  @override
  String get adminCommDeleteCampaignTitle => 'Admin Comm Delete Campaign Title';

  @override
  String get adminCommDetailCreated => 'Admin Comm Detail Created';

  @override
  String get adminCommDetailDelivered => 'Admin Comm Detail Delivered';

  @override
  String get adminCommDetailMessage => 'Admin Comm Detail Message';

  @override
  String get adminCommDetailOpened => 'Admin Comm Detail Opened';

  @override
  String get adminCommDetailRecipients => 'Admin Comm Detail Recipients';

  @override
  String get adminCommDetailScheduled => 'Admin Comm Detail Scheduled';

  @override
  String get adminCommDetailSent => 'Admin Comm Detail Sent';

  @override
  String get adminCommDetailStatus => 'Admin Comm Detail Status';

  @override
  String get adminCommDetailType => 'Admin Comm Detail Type';

  @override
  String get adminCommDuplicateCampaignDialogTitle =>
      'Admin Comm Duplicate Campaign Dialog Title';

  @override
  String get adminCommEmptySubtitle => 'Admin Comm Empty Subtitle';

  @override
  String get adminCommEmptyTitle => 'Admin Comm Empty Title';

  @override
  String get adminCommErrorTitle => 'Admin Comm Error Title';

  @override
  String get adminCommNewCampaign => 'Admin Comm New Campaign';

  @override
  String get adminCommNoMessageContent => 'Admin Comm No Message Content';

  @override
  String get adminCommRefresh => 'Admin Comm Refresh';

  @override
  String get adminCommRetry => 'Admin Comm Retry';

  @override
  String get adminCommScheduleCampaignTitle =>
      'Admin Comm Schedule Campaign Title';

  @override
  String get adminCommSearchHint => 'Admin Comm Search Hint';

  @override
  String adminCommSendCampaignMessage(String campaign) {
    return 'Admin Comm Send Campaign Message: $campaign';
  }

  @override
  String get adminCommSendCampaignTitle => 'Admin Comm Send Campaign Title';

  @override
  String get adminCommSendingCampaign => 'Admin Comm Sending Campaign';

  @override
  String get adminCommStatAllCampaigns => 'Admin Comm Stat All Campaigns';

  @override
  String get adminCommStatDraft => 'Admin Comm Stat Draft';

  @override
  String get adminCommStatNotSentYet => 'Admin Comm Stat Not Sent Yet';

  @override
  String get adminCommStatPendingDelivery => 'Admin Comm Stat Pending Delivery';

  @override
  String get adminCommStatScheduled => 'Admin Comm Stat Scheduled';

  @override
  String get adminCommStatSent => 'Admin Comm Stat Sent';

  @override
  String get adminCommStatSuccessfullySent =>
      'Admin Comm Stat Successfully Sent';

  @override
  String get adminCommStatTotalCampaigns => 'Admin Comm Stat Total Campaigns';

  @override
  String get adminCommSubtitle => 'Admin Comm Subtitle';

  @override
  String get adminCommTabAllCampaigns => 'Admin Comm Tab All Campaigns';

  @override
  String get adminCommTabAnnouncements => 'Admin Comm Tab Announcements';

  @override
  String get adminCommTabEmails => 'Admin Comm Tab Emails';

  @override
  String get adminCommTabPushNotifications =>
      'Admin Comm Tab Push Notifications';

  @override
  String get adminCommTitle => 'Admin Comm Title';

  @override
  String get adminContentAdvanced => 'Admin Content Advanced';

  @override
  String get adminContentAllCategories => 'Admin Content All Categories';

  @override
  String get adminContentAllContentItems => 'Admin Content All Content Items';

  @override
  String get adminContentAllStatus => 'Admin Content All Status';

  @override
  String get adminContentAllStudents => 'Admin Content All Students';

  @override
  String get adminContentArchive => 'Admin Content Archive';

  @override
  String get adminContentArchiveContent => 'Admin Content Archive Content';

  @override
  String get adminContentArchived => 'Admin Content Archived';

  @override
  String get adminContentArchivedNotVisible =>
      'Admin Content Archived Not Visible';

  @override
  String get adminContentArchivedSuccessfully =>
      'Admin Content Archived Successfully';

  @override
  String get adminContentArts => 'Admin Content Arts';

  @override
  String get adminContentAssign => 'Admin Content Assign';

  @override
  String get adminContentAssignContent => 'Admin Content Assign Content';

  @override
  String get adminContentAssignTo => 'Admin Content Assign To';

  @override
  String get adminContentAuthorInstitution =>
      'Admin Content Author Institution';

  @override
  String get adminContentBeginner => 'Admin Content Beginner';

  @override
  String get adminContentBusiness => 'Admin Content Business';

  @override
  String get adminContentCategory => 'Admin Content Category';

  @override
  String get adminContentClearAll => 'Admin Content Clear All';

  @override
  String adminContentConfirmArchive(String title) {
    return 'Admin Content Confirm Archive: $title';
  }

  @override
  String adminContentCreatedAsDraft(String title) {
    return 'Admin Content Created As Draft: $title';
  }

  @override
  String get adminContentDelete => 'Admin Content Delete';

  @override
  String get adminContentDraft => 'Admin Content Draft';

  @override
  String get adminContentEditContent => 'Admin Content Edit Content';

  @override
  String get adminContentEducation => 'Admin Content Education';

  @override
  String get adminContentExpert => 'Admin Content Expert';

  @override
  String get adminContentFailedToArchive => 'Admin Content Failed To Archive';

  @override
  String get adminContentFailedToCreate => 'Admin Content Failed To Create';

  @override
  String get adminContentHybrid => 'Admin Content Hybrid';

  @override
  String get adminContentInProgress => 'Admin Content In Progress';

  @override
  String get adminContentInteractive => 'Admin Content Interactive';

  @override
  String get adminContentIntermediate => 'Admin Content Intermediate';

  @override
  String get adminContentLevelRequired => 'Admin Content Level Required';

  @override
  String get adminContentLive => 'Admin Content Live';

  @override
  String get adminContentLiveContent => 'Admin Content Live Content';

  @override
  String get adminContentLiveSession => 'Admin Content Live Session';

  @override
  String get adminContentMandatoryForUsers =>
      'Admin Content Mandatory For Users';

  @override
  String get adminContentOptionalForUsers => 'Admin Content Optional For Users';

  @override
  String get adminContentPendingApproval => 'Admin Content Pending Approval';

  @override
  String get adminContentPreview => 'Admin Content Preview';

  @override
  String get adminContentPublishUnpublish => 'Admin Content Publish Unpublish';

  @override
  String get adminContentPublished => 'Admin Content Published';

  @override
  String get adminContentRequired => 'Admin Content Required';

  @override
  String get adminContentScience => 'Admin Content Science';

  @override
  String get adminContentSearchByTitleAuthor =>
      'Admin Content Search By Title Author';

  @override
  String get adminContentSearchInstitutions =>
      'Admin Content Search Institutions';

  @override
  String get adminContentSearchStudents => 'Admin Content Search Students';

  @override
  String adminContentSelectedCount(int count) {
    return 'Admin Content Selected Count: $count';
  }

  @override
  String get adminContentSpecificInstitutions =>
      'Admin Content Specific Institutions';

  @override
  String get adminContentSpecificStudents => 'Admin Content Specific Students';

  @override
  String get adminContentStatus => 'Admin Content Status';

  @override
  String get adminContentTechnology => 'Admin Content Technology';

  @override
  String get adminContentText => 'Admin Content Text';

  @override
  String get adminContentTextCourse => 'Admin Content Text Course';

  @override
  String get adminContentTitle => 'Admin Content Title';

  @override
  String get adminContentTotalContent => 'Admin Content Total Content';

  @override
  String get adminContentType => 'Admin Content Type';

  @override
  String get adminContentTypeRequired => 'Admin Content Type Required';

  @override
  String get adminContentVideo => 'Admin Content Video';

  @override
  String get adminContentVideoCourse => 'Admin Content Video Course';

  @override
  String get adminCookiesAcceptAll => 'Admin Cookies Accept All';

  @override
  String get adminCookiesCategoryAcceptanceRates =>
      'Admin Cookies Category Acceptance Rates';

  @override
  String get adminCookiesConsentAnalyticsSubtitle =>
      'Admin Cookies Consent Analytics Subtitle';

  @override
  String get adminCookiesConsentAnalyticsTitle =>
      'Admin Cookies Consent Analytics Title';

  @override
  String get adminCookiesConsentRate => 'Admin Cookies Consent Rate';

  @override
  String get adminCookiesConsentStatusDistribution =>
      'Admin Cookies Consent Status Distribution';

  @override
  String get adminCookiesCustomized => 'Admin Cookies Customized';

  @override
  String get adminCookiesDeclined => 'Admin Cookies Declined';

  @override
  String adminCookiesErrorLoadingStatistics(String error) {
    return 'Admin Cookies Error Loading Statistics: $error';
  }

  @override
  String get adminCookiesExportAllData => 'Admin Cookies Export All Data';

  @override
  String get adminCookiesFilter => 'Admin Cookies Filter';

  @override
  String get adminCookiesFilterAccepted => 'Admin Cookies Filter Accepted';

  @override
  String get adminCookiesFilterAll => 'Admin Cookies Filter All';

  @override
  String get adminCookiesNoRecentActivity => 'Admin Cookies No Recent Activity';

  @override
  String get adminCookiesNotAsked => 'Admin Cookies Not Asked';

  @override
  String get adminCookiesOverview => 'Admin Cookies Overview';

  @override
  String get adminCookiesRecentConsentActivity =>
      'Admin Cookies Recent Consent Activity';

  @override
  String get adminCookiesRefresh => 'Admin Cookies Refresh';

  @override
  String get adminCookiesSearchByUserId => 'Admin Cookies Search By User Id';

  @override
  String get adminCookiesTotalUsers => 'Admin Cookies Total Users';

  @override
  String get adminCookiesUserCookieDataSubtitle =>
      'Admin Cookies User Cookie Data Subtitle';

  @override
  String get adminCookiesUserCookieDataTitle =>
      'Admin Cookies User Cookie Data Title';

  @override
  String get adminCookiesViewAll => 'Admin Cookies View All';

  @override
  String adminExportsErrorExportFailed(String error) {
    return 'Admin Exports Error Export Failed: $error';
  }

  @override
  String get adminExportsErrorFetchFailed => 'Admin Exports Error Fetch Failed';

  @override
  String get adminExportsErrorNoData => 'Admin Exports Error No Data';

  @override
  String get adminExportsExportData => 'Admin Exports Export Data';

  @override
  String get adminExportsExporting => 'Admin Exports Exporting';

  @override
  String get adminExportsFormatCsv => 'Admin Exports Format Csv';

  @override
  String get adminExportsFormatCsvDesc => 'Admin Exports Format Csv Desc';

  @override
  String get adminExportsFormatJson => 'Admin Exports Format Json';

  @override
  String get adminExportsFormatJsonDesc => 'Admin Exports Format Json Desc';

  @override
  String get adminExportsHistoryEmpty => 'Admin Exports History Empty';

  @override
  String adminExportsHistoryItemDetails(
    String source,
    String rows,
    String format,
  ) {
    return '$source • $rows rows • $format';
  }

  @override
  String get adminExportsHistoryTitle => 'Admin Exports History Title';

  @override
  String get adminExportsSelectFormat => 'Admin Exports Select Format';

  @override
  String get adminExportsSourceActivity => 'Admin Exports Source Activity';

  @override
  String get adminExportsSourceActivityDesc =>
      'Admin Exports Source Activity Desc';

  @override
  String get adminExportsSourceCampaigns => 'Admin Exports Source Campaigns';

  @override
  String get adminExportsSourceCampaignsDesc =>
      'Admin Exports Source Campaigns Desc';

  @override
  String get adminExportsSourceContent => 'Admin Exports Source Content';

  @override
  String get adminExportsSourceContentDesc =>
      'Admin Exports Source Content Desc';

  @override
  String get adminExportsSourceTickets => 'Admin Exports Source Tickets';

  @override
  String get adminExportsSourceTicketsDesc =>
      'Admin Exports Source Tickets Desc';

  @override
  String get adminExportsSourceTransactions =>
      'Admin Exports Source Transactions';

  @override
  String get adminExportsSourceTransactionsDesc =>
      'Admin Exports Source Transactions Desc';

  @override
  String get adminExportsSourceUsers => 'Admin Exports Source Users';

  @override
  String get adminExportsSourceUsersDesc => 'Admin Exports Source Users Desc';

  @override
  String adminExportsSuccessMessage(int count, String fileName) {
    return 'Exported $count records to $fileName';
  }

  @override
  String get adminSharedAdminAccessRequired =>
      'Admin Shared Admin Access Required';

  @override
  String get adminSharedAdminNavigationSidebar =>
      'Admin Shared Admin Navigation Sidebar';

  @override
  String get adminSharedAdminToolbar => 'Admin Shared Admin Toolbar';

  @override
  String get adminSharedCancel => 'Admin Shared Cancel';

  @override
  String get adminSharedClear => 'Admin Shared Clear';

  @override
  String get adminSharedFeatureUnderDevelopment =>
      'Admin Shared Feature Under Development';

  @override
  String get adminSharedGoBack => 'Admin Shared Go Back';

  @override
  String adminSharedItemsSelected(int count) {
    return 'Admin Shared Items Selected: $count';
  }

  @override
  String get adminSharedMainContent => 'Admin Shared Main Content';

  @override
  String get adminSharedNotifications => 'Admin Shared Notifications';

  @override
  String get adminSharedPleaseSignInWithAdmin =>
      'Admin Shared Please Sign In With Admin';

  @override
  String get adminSharedProfile => 'Admin Shared Profile';

  @override
  String get adminSharedRefreshing => 'Admin Shared Refreshing';

  @override
  String get adminSharedSettings => 'Admin Shared Settings';

  @override
  String get adminSharedSignOut => 'Admin Shared Sign Out';

  @override
  String get adminSharedSignOutConfirmation =>
      'Admin Shared Sign Out Confirmation';

  @override
  String get adminSharedSwitchToDarkMode => 'Admin Shared Switch To Dark Mode';

  @override
  String get adminSharedSwitchToLightMode =>
      'Admin Shared Switch To Light Mode';

  @override
  String get adminSharedToggleDarkMode => 'Admin Shared Toggle Dark Mode';

  @override
  String adminSharedUserMenuFor(String name) {
    return 'Admin Shared User Menu For: $name';
  }

  @override
  String get adminSupportTicketAllCategories =>
      'Admin Support Ticket All Categories';

  @override
  String get adminSupportTicketAllPriorities =>
      'Admin Support Ticket All Priorities';

  @override
  String get adminSupportTicketAllStatus => 'Admin Support Ticket All Status';

  @override
  String get adminSupportTicketAvgResolutionTime =>
      'Admin Support Ticket Avg Resolution Time';

  @override
  String get adminSupportTicketAvgResponse =>
      'Admin Support Ticket Avg Response';

  @override
  String get adminSupportTicketBeingHandled =>
      'Admin Support Ticket Being Handled';

  @override
  String get adminSupportTicketCategoryAccount =>
      'Admin Support Ticket Category Account';

  @override
  String get adminSupportTicketCategoryBilling =>
      'Admin Support Ticket Category Billing';

  @override
  String get adminSupportTicketCategoryGeneral =>
      'Admin Support Ticket Category General';

  @override
  String get adminSupportTicketCategoryLabel =>
      'Admin Support Ticket Category Label';

  @override
  String get adminSupportTicketCategoryTechnical =>
      'Admin Support Ticket Category Technical';

  @override
  String get adminSupportTicketColumnAssignedTo =>
      'Admin Support Ticket Column Assigned To';

  @override
  String get adminSupportTicketColumnCategory =>
      'Admin Support Ticket Column Category';

  @override
  String get adminSupportTicketColumnPriority =>
      'Admin Support Ticket Column Priority';

  @override
  String get adminSupportTicketColumnStatus =>
      'Admin Support Ticket Column Status';

  @override
  String get adminSupportTicketColumnSubject =>
      'Admin Support Ticket Column Subject';

  @override
  String get adminSupportTicketColumnTicketId =>
      'Admin Support Ticket Column Ticket Id';

  @override
  String get adminSupportTicketColumnUser => 'Admin Support Ticket Column User';

  @override
  String adminSupportTicketDaysAgo(int days) {
    return 'Admin Support Ticket Days Ago: $days';
  }

  @override
  String adminSupportTicketHoursAgo(int hours) {
    return 'Admin Support Ticket Hours Ago: $hours';
  }

  @override
  String get adminSupportTicketInProgress => 'Admin Support Ticket In Progress';

  @override
  String get adminSupportTicketJustNow => 'Admin Support Ticket Just Now';

  @override
  String get adminSupportTicketKnowledgeBase =>
      'Admin Support Ticket Knowledge Base';

  @override
  String get adminSupportTicketLiveChat => 'Admin Support Ticket Live Chat';

  @override
  String adminSupportTicketMinutesAgo(int minutes) {
    return 'Admin Support Ticket Minutes Ago: $minutes';
  }

  @override
  String get adminSupportTicketOpenTickets =>
      'Admin Support Ticket Open Tickets';

  @override
  String get adminSupportTicketPendingResolution =>
      'Admin Support Ticket Pending Resolution';

  @override
  String get adminSupportTicketPriorityHigh =>
      'Admin Support Ticket Priority High';

  @override
  String get adminSupportTicketPriorityLabel =>
      'Admin Support Ticket Priority Label';

  @override
  String get adminSupportTicketPriorityLow =>
      'Admin Support Ticket Priority Low';

  @override
  String get adminSupportTicketPriorityMedium =>
      'Admin Support Ticket Priority Medium';

  @override
  String get adminSupportTicketPriorityUrgent =>
      'Admin Support Ticket Priority Urgent';

  @override
  String get adminSupportTicketRefresh => 'Admin Support Ticket Refresh';

  @override
  String get adminSupportTicketResolved => 'Admin Support Ticket Resolved';

  @override
  String get adminSupportTicketRetry => 'Admin Support Ticket Retry';

  @override
  String get adminSupportTicketSearchHint =>
      'Search tickets by ID, subject, or customer...';

  @override
  String get adminSupportTicketStatusClosed =>
      'Admin Support Ticket Status Closed';

  @override
  String get adminSupportTicketStatusInProgress =>
      'Admin Support Ticket Status In Progress';

  @override
  String get adminSupportTicketStatusLabel =>
      'Admin Support Ticket Status Label';

  @override
  String get adminSupportTicketStatusOpen => 'Admin Support Ticket Status Open';

  @override
  String get adminSupportTicketStatusResolved =>
      'Admin Support Ticket Status Resolved';

  @override
  String get adminSupportTicketSubtitle => 'Admin Support Ticket Subtitle';

  @override
  String get adminSupportTicketTitle => 'Admin Support Ticket Title';

  @override
  String get adminSupportTicketTotalResolved =>
      'Admin Support Ticket Total Resolved';

  @override
  String get adminSystemApiBaseUrl => 'Admin System Api Base Url';

  @override
  String get adminSystemApiBaseUrlDesc => 'Admin System Api Base Url Desc';

  @override
  String get adminSystemApiKey => 'Admin System Api Key';

  @override
  String get adminSystemApiRateLimiting => 'Admin System Api Rate Limiting';

  @override
  String get adminSystemApiRateLimitingDesc =>
      'Admin System Api Rate Limiting Desc';

  @override
  String get adminSystemApiSettingsSubtitle =>
      'Admin System Api Settings Subtitle';

  @override
  String get adminSystemApiSettingsTitle => 'Admin System Api Settings Title';

  @override
  String get adminSystemApiVersion => 'Admin System Api Version';

  @override
  String get adminSystemApiVersionDesc => 'Admin System Api Version Desc';

  @override
  String get adminSystemApplicationName => 'Admin System Application Name';

  @override
  String get adminSystemApplicationNameDesc =>
      'Admin System Application Name Desc';

  @override
  String get adminSystemApplicationSubmissions =>
      'Admin System Application Submissions';

  @override
  String get adminSystemApplicationSubmissionsDesc =>
      'Admin System Application Submissions Desc';

  @override
  String get adminSystemConsumerKey => 'Admin System Consumer Key';

  @override
  String get adminSystemConsumerSecret => 'Admin System Consumer Secret';

  @override
  String get adminSystemDefaultCurrency => 'Admin System Default Currency';

  @override
  String get adminSystemDefaultCurrencyDesc =>
      'Admin System Default Currency Desc';

  @override
  String get adminSystemDefaultLanguage => 'Admin System Default Language';

  @override
  String get adminSystemDefaultLanguageDesc =>
      'Admin System Default Language Desc';

  @override
  String get adminSystemDefaultRegion => 'Admin System Default Region';

  @override
  String get adminSystemDefaultRegionDesc => 'Admin System Default Region Desc';

  @override
  String get adminSystemDocumentUpload => 'Admin System Document Upload';

  @override
  String get adminSystemDocumentUploadDesc =>
      'Admin System Document Upload Desc';

  @override
  String get adminSystemEmailApiKeyDesc => 'Admin System Email Api Key Desc';

  @override
  String get adminSystemEmailNotifications =>
      'Admin System Email Notifications';

  @override
  String get adminSystemEmailNotificationsDesc =>
      'Admin System Email Notifications Desc';

  @override
  String get adminSystemEmailService => 'Admin System Email Service';

  @override
  String get adminSystemEmailServiceDesc => 'Admin System Email Service Desc';

  @override
  String get adminSystemEmailSettingsSubtitle =>
      'Admin System Email Settings Subtitle';

  @override
  String get adminSystemEmailSettingsTitle =>
      'Admin System Email Settings Title';

  @override
  String get adminSystemEmailVerification => 'Admin System Email Verification';

  @override
  String get adminSystemEmailVerificationDesc =>
      'Admin System Email Verification Desc';

  @override
  String get adminSystemEnableCardPayments =>
      'Admin System Enable Card Payments';

  @override
  String get adminSystemEnableCardPaymentsDesc =>
      'Admin System Enable Card Payments Desc';

  @override
  String get adminSystemEnableMpesa => 'Admin System Enable Mpesa';

  @override
  String get adminSystemEnableMpesaDesc => 'Admin System Enable Mpesa Desc';

  @override
  String get adminSystemFeatureFlagsSubtitle =>
      'Admin System Feature Flags Subtitle';

  @override
  String get adminSystemFeatureFlagsTitle => 'Admin System Feature Flags Title';

  @override
  String get adminSystemFromEmail => 'Admin System From Email';

  @override
  String get adminSystemFromEmailDesc => 'Admin System From Email Desc';

  @override
  String get adminSystemFromName => 'Admin System From Name';

  @override
  String get adminSystemFromNameDesc => 'Admin System From Name Desc';

  @override
  String get adminSystemGeneralSettingsSubtitle =>
      'Admin System General Settings Subtitle';

  @override
  String get adminSystemGeneralSettingsTitle =>
      'Admin System General Settings Title';

  @override
  String get adminSystemGoogleAnalyticsId => 'Admin System Google Analytics Id';

  @override
  String get adminSystemGoogleAnalyticsIdDesc =>
      'Admin System Google Analytics Id Desc';

  @override
  String get adminSystemMpesaConsumerKeyDesc =>
      'Admin System Mpesa Consumer Key Desc';

  @override
  String get adminSystemMpesaConsumerSecretDesc =>
      'Admin System Mpesa Consumer Secret Desc';

  @override
  String get adminSystemMpesaShortcodeDesc =>
      'Admin System Mpesa Shortcode Desc';

  @override
  String get adminSystemNavApiIntegrations =>
      'Admin System Nav Api Integrations';

  @override
  String get adminSystemNavBackupRecovery => 'Admin System Nav Backup Recovery';

  @override
  String get adminSystemNavEmailSettings => 'Admin System Nav Email Settings';

  @override
  String get adminSystemNavFeatureFlags => 'Admin System Nav Feature Flags';

  @override
  String get adminSystemNavGeneral => 'Admin System Nav General';

  @override
  String get adminSystemNavPaymentGateways =>
      'Admin System Nav Payment Gateways';

  @override
  String get adminSystemNavSecurity => 'Admin System Nav Security';

  @override
  String get adminSystemNavSmsSettings => 'Admin System Nav Sms Settings';

  @override
  String get adminSystemPaymentProcessing => 'Admin System Payment Processing';

  @override
  String get adminSystemPaymentProcessingDesc =>
      'Admin System Payment Processing Desc';

  @override
  String get adminSystemPaymentProcessor => 'Admin System Payment Processor';

  @override
  String get adminSystemPaymentProcessorDesc =>
      'Admin System Payment Processor Desc';

  @override
  String get adminSystemPaymentSettingsSubtitle =>
      'Admin System Payment Settings Subtitle';

  @override
  String get adminSystemPaymentSettingsTitle =>
      'Admin System Payment Settings Title';

  @override
  String get adminSystemPublishableKey => 'Admin System Publishable Key';

  @override
  String get adminSystemPublishableKeyDesc =>
      'Admin System Publishable Key Desc';

  @override
  String get adminSystemPushNotifications => 'Admin System Push Notifications';

  @override
  String get adminSystemPushNotificationsDesc =>
      'Admin System Push Notifications Desc';

  @override
  String get adminSystemRecommendations => 'Admin System Recommendations';

  @override
  String get adminSystemRecommendationsDesc =>
      'Admin System Recommendations Desc';

  @override
  String get adminSystemSecretKey => 'Admin System Secret Key';

  @override
  String get adminSystemSecretKeyDesc => 'Admin System Secret Key Desc';

  @override
  String get adminSystemSectionApiConfiguration =>
      'Admin System Section Api Configuration';

  @override
  String get adminSystemSectionApplication =>
      'Admin System Section Application';

  @override
  String get adminSystemSectionApplicationFeatures =>
      'Admin System Section Application Features';

  @override
  String get adminSystemSectionCardPayments =>
      'Admin System Section Card Payments';

  @override
  String get adminSystemSectionCommunication =>
      'Admin System Section Communication';

  @override
  String get adminSystemSectionEmailProvider =>
      'Admin System Section Email Provider';

  @override
  String get adminSystemSectionMpesa => 'Admin System Section Mpesa';

  @override
  String get adminSystemSectionRegional => 'Admin System Section Regional';

  @override
  String get adminSystemSectionSmsProvider =>
      'Admin System Section Sms Provider';

  @override
  String get adminSystemSectionThirdPartyServices =>
      'Admin System Section Third Party Services';

  @override
  String get adminSystemSectionUserFeatures =>
      'Admin System Section User Features';

  @override
  String get adminSystemSentryDsn => 'Admin System Sentry Dsn';

  @override
  String get adminSystemSentryDsnDesc => 'Admin System Sentry Dsn Desc';

  @override
  String get adminSystemSettingsSavedError =>
      'Admin System Settings Saved Error';

  @override
  String get adminSystemSettingsSavedSuccess =>
      'Admin System Settings Saved Success';

  @override
  String get adminSystemSettingsSubtitle => 'Admin System Settings Subtitle';

  @override
  String get adminSystemSettingsTitle => 'Admin System Settings Title';

  @override
  String get adminSystemShortcode => 'Admin System Shortcode';

  @override
  String get adminSystemSmsApiKeyDesc => 'Admin System Sms Api Key Desc';

  @override
  String get adminSystemSmsNotifications => 'Admin System Sms Notifications';

  @override
  String get adminSystemSmsNotificationsDesc =>
      'Admin System Sms Notifications Desc';

  @override
  String get adminSystemSmsSenderId => 'Admin System Sms Sender Id';

  @override
  String get adminSystemSmsSenderIdDesc => 'Admin System Sms Sender Id Desc';

  @override
  String get adminSystemSmsService => 'Admin System Sms Service';

  @override
  String get adminSystemSmsServiceDesc => 'Admin System Sms Service Desc';

  @override
  String get adminSystemSmsSettingsSubtitle =>
      'Admin System Sms Settings Subtitle';

  @override
  String get adminSystemSmsSettingsTitle => 'Admin System Sms Settings Title';

  @override
  String get adminSystemSocialLogin => 'Admin System Social Login';

  @override
  String get adminSystemSocialLoginDesc => 'Admin System Social Login Desc';

  @override
  String get adminSystemSupportEmail => 'Admin System Support Email';

  @override
  String get adminSystemSupportEmailDesc => 'Admin System Support Email Desc';

  @override
  String get adminSystemSupportPhone => 'Admin System Support Phone';

  @override
  String get adminSystemSupportPhoneDesc => 'Admin System Support Phone Desc';

  @override
  String get adminSystemUnsavedChanges => 'Admin System Unsaved Changes';

  @override
  String get adminSystemUserRegistration => 'Admin System User Registration';

  @override
  String get adminSystemUserRegistrationDesc =>
      'Admin System User Registration Desc';

  @override
  String get adminSystemViewAuditLogs => 'Admin System View Audit Logs';

  @override
  String get adminUserDetailActivate => 'Admin User Detail Activate';

  @override
  String get adminUserDetailApplications => 'Admin User Detail Applications';

  @override
  String get adminUserDetailBackToStudents =>
      'Admin User Detail Back To Students';

  @override
  String get adminUserDetailCoursesEnrolled =>
      'Admin User Detail Courses Enrolled';

  @override
  String get adminUserDetailDeleteAccount => 'Admin User Detail Delete Account';

  @override
  String get adminUserDetailEditProfile => 'Admin User Detail Edit Profile';

  @override
  String get adminUserDetailGrade => 'Admin User Detail Grade';

  @override
  String get adminUserDetailGradePrefix => 'Admin User Detail Grade Prefix';

  @override
  String get adminUserDetailMessageComingSoon =>
      'Admin User Detail Message Coming Soon';

  @override
  String get adminUserDetailOverallProgress =>
      'Admin User Detail Overall Progress';

  @override
  String get adminUserDetailSendMessage => 'Admin User Detail Send Message';

  @override
  String get adminUserDetailStatusActive => 'Admin User Detail Status Active';

  @override
  String get adminUserDetailStatusInactive =>
      'Admin User Detail Status Inactive';

  @override
  String get adminUserDetailStudentDetails =>
      'Admin User Detail Student Details';

  @override
  String get adminUserDetailStudentId => 'Admin User Detail Student Id';

  @override
  String get adminUserDetailSuspend => 'Admin User Detail Suspend';

  @override
  String get adminUserDetailTabAcademic => 'Admin User Detail Tab Academic';

  @override
  String get adminUserDetailTabActivity => 'Admin User Detail Tab Activity';

  @override
  String get adminUserDetailTabApplications =>
      'Admin User Detail Tab Applications';

  @override
  String get adminUserDetailTabDocuments => 'Admin User Detail Tab Documents';

  @override
  String get adminUserDetailTabOverview => 'Admin User Detail Tab Overview';

  @override
  String get adminUserDetailTabPayments => 'Admin User Detail Tab Payments';

  @override
  String get adminUserDetailUnknownStudent =>
      'Admin User Detail Unknown Student';

  @override
  String get adminUserFormAcademicInformation =>
      'Admin User Form Academic Information';

  @override
  String get adminUserFormAddNewStudent => 'Admin User Form Add New Student';

  @override
  String get adminUserFormBackToStudents => 'Admin User Form Back To Students';

  @override
  String get adminUserFormCreateStudentAccount =>
      'Admin User Form Create Student Account';

  @override
  String get adminUserFormDateFormat => 'Admin User Form Date Format';

  @override
  String get adminUserFormDateOfBirth => 'Admin User Form Date Of Birth';

  @override
  String get adminUserFormEditStudent => 'Admin User Form Edit Student';

  @override
  String get adminUserFormEmail => 'Admin User Form Email';

  @override
  String get adminUserFormEmailInvalid => 'Admin User Form Email Invalid';

  @override
  String get adminUserFormEmailRequired => 'Admin User Form Email Required';

  @override
  String get adminUserFormFirstName => 'Admin User Form First Name';

  @override
  String get adminUserFormFirstNameRequired =>
      'Admin User Form First Name Required';

  @override
  String get adminUserFormGender => 'Admin User Form Gender';

  @override
  String get adminUserFormGenderFemale => 'Admin User Form Gender Female';

  @override
  String get adminUserFormGenderMale => 'Admin User Form Gender Male';

  @override
  String get adminUserFormGenderOther => 'Admin User Form Gender Other';

  @override
  String get adminUserFormGenderPreferNotToSay =>
      'Admin User Form Gender Prefer Not To Say';

  @override
  String get adminUserFormGrade => 'Admin User Form Grade';

  @override
  String get adminUserFormGrade10 => 'Admin User Form Grade10';

  @override
  String get adminUserFormGrade11 => 'Admin User Form Grade11';

  @override
  String get adminUserFormGrade12 => 'Admin User Form Grade12';

  @override
  String get adminUserFormGrade9 => 'Admin User Form Grade9';

  @override
  String get adminUserFormLastName => 'Admin User Form Last Name';

  @override
  String get adminUserFormLastNameRequired =>
      'Admin User Form Last Name Required';

  @override
  String get adminUserFormPersonalInformation =>
      'Admin User Form Personal Information';

  @override
  String get adminUserFormPhone => 'Admin User Form Phone';

  @override
  String get adminUserFormStatus => 'Admin User Form Status';

  @override
  String get adminUserFormStatusActive => 'Admin User Form Status Active';

  @override
  String get adminUserFormStatusInactive => 'Admin User Form Status Inactive';

  @override
  String get adminUserFormStatusPendingVerification =>
      'Admin User Form Status Pending Verification';

  @override
  String get adminUserFormStatusSuspended => 'Admin User Form Status Suspended';

  @override
  String get adminUserFormStudentCreatedSuccess =>
      'Admin User Form Student Created Success';

  @override
  String get adminUserFormStudentUpdatedSuccess =>
      'Admin User Form Student Updated Success';

  @override
  String get adminUserFormUpdateStudentInfo =>
      'Admin User Form Update Student Info';

  @override
  String get adminUsersListActivate => 'Admin Users List Activate';

  @override
  String adminUsersListActivateStudentsConfirm(int count) {
    return 'Admin Users List Activate Students Confirm: $count';
  }

  @override
  String get adminUsersListActivateStudentsTitle =>
      'Admin Users List Activate Students Title';

  @override
  String get adminUsersListAddInstitution => 'Admin Users List Add Institution';

  @override
  String get adminUsersListAddStudent => 'Admin Users List Add Student';

  @override
  String get adminUsersListAllGrades => 'Admin Users List All Grades';

  @override
  String get adminUsersListAllStatus => 'Admin Users List All Status';

  @override
  String get adminUsersListAllTypes => 'Admin Users List All Types';

  @override
  String get adminUsersListApprove => 'Admin Users List Approve';

  @override
  String adminUsersListApproveInstitutionsConfirm(int count) {
    return 'Admin Users List Approve Institutions Confirm: $count';
  }

  @override
  String get adminUsersListApproveInstitutionsTitle =>
      'Admin Users List Approve Institutions Title';

  @override
  String get adminUsersListCancel => 'Admin Users List Cancel';

  @override
  String get adminUsersListColumnApplications =>
      'Admin Users List Column Applications';

  @override
  String get adminUsersListColumnGrade => 'Admin Users List Column Grade';

  @override
  String get adminUsersListColumnInstitution =>
      'Admin Users List Column Institution';

  @override
  String get adminUsersListColumnInstitutionId =>
      'Admin Users List Column Institution Id';

  @override
  String get adminUsersListColumnJoined => 'Admin Users List Column Joined';

  @override
  String get adminUsersListColumnLocation => 'Admin Users List Column Location';

  @override
  String get adminUsersListColumnPrograms => 'Admin Users List Column Programs';

  @override
  String get adminUsersListColumnSchool => 'Admin Users List Column School';

  @override
  String get adminUsersListColumnStatus => 'Admin Users List Column Status';

  @override
  String get adminUsersListColumnStudent => 'Admin Users List Column Student';

  @override
  String get adminUsersListColumnStudentId =>
      'Admin Users List Column Student Id';

  @override
  String get adminUsersListColumnType => 'Admin Users List Column Type';

  @override
  String get adminUsersListDeactivate => 'Admin Users List Deactivate';

  @override
  String get adminUsersListDeactivateAccount =>
      'Admin Users List Deactivate Account';

  @override
  String adminUsersListDeactivateInstitutionsConfirm(int count) {
    return 'Admin Users List Deactivate Institutions Confirm: $count';
  }

  @override
  String get adminUsersListDeactivateInstitutionsTitle =>
      'Admin Users List Deactivate Institutions Title';

  @override
  String adminUsersListDeactivateStudentsConfirm(int count) {
    return 'Admin Users List Deactivate Students Confirm: $count';
  }

  @override
  String get adminUsersListDeactivateStudentsTitle =>
      'Admin Users List Deactivate Students Title';

  @override
  String get adminUsersListEditInstitution =>
      'Admin Users List Edit Institution';

  @override
  String get adminUsersListEditStudent => 'Admin Users List Edit Student';

  @override
  String get adminUsersListExport => 'Admin Users List Export';

  @override
  String get adminUsersListExportInstitutions =>
      'Admin Users List Export Institutions';

  @override
  String get adminUsersListExportStudents => 'Admin Users List Export Students';

  @override
  String get adminUsersListGrade10 => 'Admin Users List Grade10';

  @override
  String get adminUsersListGrade11 => 'Admin Users List Grade11';

  @override
  String get adminUsersListGrade12 => 'Admin Users List Grade12';

  @override
  String get adminUsersListGrade9 => 'Admin Users List Grade9';

  @override
  String get adminUsersListGradeLabel => 'Admin Users List Grade Label';

  @override
  String get adminUsersListInstitutionsSubtitle =>
      'Admin Users List Institutions Subtitle';

  @override
  String get adminUsersListInstitutionsTitle =>
      'Admin Users List Institutions Title';

  @override
  String get adminUsersListSearchInstitutionsHint =>
      'Admin Users List Search Institutions Hint';

  @override
  String get adminUsersListSearchStudentsHint =>
      'Admin Users List Search Students Hint';

  @override
  String get adminUsersListStatusActive => 'Admin Users List Status Active';

  @override
  String get adminUsersListStatusInactive => 'Admin Users List Status Inactive';

  @override
  String get adminUsersListStatusLabel => 'Admin Users List Status Label';

  @override
  String get adminUsersListStatusPending => 'Admin Users List Status Pending';

  @override
  String get adminUsersListStatusPendingApproval =>
      'Admin Users List Status Pending Approval';

  @override
  String get adminUsersListStatusPendingVerification =>
      'Admin Users List Status Pending Verification';

  @override
  String get adminUsersListStatusRejected => 'Admin Users List Status Rejected';

  @override
  String get adminUsersListStudentsSubtitle =>
      'Admin Users List Students Subtitle';

  @override
  String get adminUsersListStudentsTitle => 'Admin Users List Students Title';

  @override
  String get adminUsersListTypeCollege => 'Admin Users List Type College';

  @override
  String get adminUsersListTypeLabel => 'Admin Users List Type Label';

  @override
  String get adminUsersListTypeLanguageSchool =>
      'Admin Users List Type Language School';

  @override
  String get adminUsersListTypeUniversity => 'Admin Users List Type University';

  @override
  String get adminUsersListTypeVocational => 'Admin Users List Type Vocational';

  @override
  String get adminUsersListViewDetails => 'Admin Users List View Details';

  @override
  String get instCourseAdd => 'Inst Course Add';

  @override
  String get instCourseAddLearningObjective =>
      'Inst Course Add Learning Objective';

  @override
  String get instCourseAddModuleSubtitle => 'Inst Course Add Module Subtitle';

  @override
  String get instCourseClose => 'Inst Course Close';

  @override
  String get instCourseCopyToClipboard => 'Inst Course Copy To Clipboard';

  @override
  String get instCourseCreateModule => 'Inst Course Create Module';

  @override
  String get instCourseCreateNewModule => 'Inst Course Create New Module';

  @override
  String get instCourseCtrlPToPreview => 'Inst Course Ctrl P To Preview';

  @override
  String get instCourseCtrlSToSave => 'Inst Course Ctrl S To Save';

  @override
  String get instCourseDesktop => 'Inst Course Desktop';

  @override
  String get instCourseDiscardChanges => 'Inst Course Discard Changes';

  @override
  String get instCourseEdit => 'Inst Course Edit';

  @override
  String get instCourseEditLearningObjective =>
      'Inst Course Edit Learning Objective';

  @override
  String get instCourseEstimatedDuration => 'Inst Course Estimated Duration';

  @override
  String get instCourseEstimatedDurationHelper =>
      'Inst Course Estimated Duration Helper';

  @override
  String get instCourseExportInfo => 'Inst Course Export Info';

  @override
  String get instCourseExportQuestions => 'Inst Course Export Questions';

  @override
  String get instCourseFixIssuesBeforeSaving =>
      'Inst Course Fix Issues Before Saving';

  @override
  String get instCourseImport => 'Inst Course Import';

  @override
  String get instCourseImportFailed => 'Inst Course Import Failed';

  @override
  String get instCourseImportInfo => 'Inst Course Import Info';

  @override
  String get instCourseImportQuestions => 'Inst Course Import Questions';

  @override
  String get instCourseImportSuccess => 'Inst Course Import Success';

  @override
  String get instCourseJsonCopied => 'Inst Course Json Copied';

  @override
  String get instCourseJsonData => 'Inst Course Json Data';

  @override
  String get instCourseLearningObjectivesInfo =>
      'Inst Course Learning Objectives Info';

  @override
  String get instCourseMandatory => 'Inst Course Mandatory';

  @override
  String instCourseMinutesShort(int minutes) {
    return 'Inst Course Minutes Short: $minutes';
  }

  @override
  String get instCourseMobile => 'Inst Course Mobile';

  @override
  String get instCourseModuleDescription => 'Inst Course Module Description';

  @override
  String get instCourseModuleDescriptionHelper =>
      'Inst Course Module Description Helper';

  @override
  String get instCourseModuleDescriptionHint =>
      'Inst Course Module Description Hint';

  @override
  String get instCourseModuleHiddenFromStudents =>
      'Inst Course Module Hidden From Students';

  @override
  String instCourseModuleNumber(int number) {
    return 'Inst Course Module Number: $number';
  }

  @override
  String get instCourseModuleOptional => 'Inst Course Module Optional';

  @override
  String get instCourseModuleOverview => 'Inst Course Module Overview';

  @override
  String get instCourseModuleTitle => 'Inst Course Module Title';

  @override
  String get instCourseModuleTitleHelper => 'Inst Course Module Title Helper';

  @override
  String get instCourseModuleTitleHint => 'Inst Course Module Title Hint';

  @override
  String get instCourseModuleTitleMinLength =>
      'Inst Course Module Title Min Length';

  @override
  String get instCourseModuleTitleRequired =>
      'Inst Course Module Title Required';

  @override
  String get instCourseModuleVisibleToStudents =>
      'Inst Course Module Visible To Students';

  @override
  String get instCourseNoObjectivesSubtitle =>
      'Inst Course No Objectives Subtitle';

  @override
  String get instCourseNoObjectivesYet => 'Inst Course No Objectives Yet';

  @override
  String get instCourseNoOtherModulesAvailable =>
      'Inst Course No Other Modules Available';

  @override
  String get instCourseObjective => 'Inst Course Objective';

  @override
  String get instCourseObjectiveHint => 'Inst Course Objective Hint';

  @override
  String instCourseObjectivesCount(int count) {
    return 'Inst Course Objectives Count: $count';
  }

  @override
  String get instCourseOk => 'Inst Course Ok';

  @override
  String get instCoursePasteJsonHere => 'Inst Course Paste Json Here';

  @override
  String get instCoursePrerequisitesDescription =>
      'Inst Course Prerequisites Description';

  @override
  String get instCoursePreview => 'Inst Course Preview';

  @override
  String get instCoursePublished => 'Inst Course Published';

  @override
  String get instCoursePublishingSettings => 'Inst Course Publishing Settings';

  @override
  String get instCourseSaveAsDraft => 'Inst Course Save As Draft';

  @override
  String get instCourseSaved => 'Inst Course Saved';

  @override
  String get instCourseSettings => 'Inst Course Settings';

  @override
  String get instCourseStay => 'Inst Course Stay';

  @override
  String get instCourseStudentPreview => 'Inst Course Student Preview';

  @override
  String get instCourseStudentsMustComplete =>
      'Inst Course Students Must Complete';

  @override
  String get instCourseTablet => 'Inst Course Tablet';

  @override
  String get instCourseUnsavedChanges => 'Inst Course Unsaved Changes';

  @override
  String get instCourseUnsavedChangesMessage =>
      'Inst Course Unsaved Changes Message';

  @override
  String get instCourseUpdate => 'Inst Course Update';

  @override
  String get instCourseUpdateModule => 'Inst Course Update Module';

  @override
  String get instCourseUpdateModuleSubtitle =>
      'Inst Course Update Module Subtitle';

  @override
  String get instCourseValidationErrors => 'Inst Course Validation Errors';

  @override
  String get instCoursesDescription => 'Inst Courses Description';

  @override
  String get instCoursesEditCourse => 'Inst Courses Edit Course';

  @override
  String instCoursesEnrolledCount(int count) {
    return 'Inst Courses Enrolled Count: $count';
  }

  @override
  String get instCoursesLearningOutcomes => 'Inst Courses Learning Outcomes';

  @override
  String get instCoursesPrerequisites => 'Inst Courses Prerequisites';

  @override
  String get instCoursesPublished => 'Inst Courses Published';

  @override
  String get instCoursesQuickActions => 'Inst Courses Quick Actions';

  @override
  String get instCoursesStatistics => 'Inst Courses Statistics';

  @override
  String get instDebugAuthInfo => 'Inst Debug Auth Info';

  @override
  String get instDebugError => 'Inst Debug Error';

  @override
  String get instDebugRetry => 'Inst Debug Retry';

  @override
  String get instDebugRunningDiagnostics => 'Inst Debug Running Diagnostics';

  @override
  String get instDebugTitle => 'Inst Debug Title';

  @override
  String get instDebugUserStatus => 'Inst Debug User Status';

  @override
  String sharedCookiesDataExportedRecords(String count) {
    return 'Shared Cookies Data Exported Records: $count';
  }

  @override
  String sharedCookiesErrorLoadingConsent(String error) {
    return 'Shared Cookies Error Loading Consent: $error';
  }

  @override
  String sharedCookiesExpires(String date) {
    return 'Shared Cookies Expires: $date';
  }

  @override
  String sharedCookiesUpdated(String date) {
    return 'Shared Cookies Updated: $date';
  }

  @override
  String get sharedDocumentsBack => 'Shared Documents Back';

  @override
  String get sharedDocumentsCancel => 'Shared Documents Cancel';

  @override
  String get sharedDocumentsCategory => 'Shared Documents Category';

  @override
  String get sharedDocumentsDelete => 'Shared Documents Delete';

  @override
  String sharedDocumentsDeleteDocumentConfirm(String name) {
    return 'Shared Documents Delete Document Confirm: $name';
  }

  @override
  String get sharedDocumentsDeleteDocumentTitle =>
      'Shared Documents Delete Document Title';

  @override
  String get sharedDocumentsDescription => 'Shared Documents Description';

  @override
  String get sharedDocumentsDocumentDeleted =>
      'Shared Documents Document Deleted';

  @override
  String get sharedDocumentsDocumentInfo => 'Shared Documents Document Info';

  @override
  String get sharedDocumentsDocumentInformation =>
      'Shared Documents Document Information';

  @override
  String get sharedDocumentsDownload => 'Shared Documents Download';

  @override
  String get sharedDocumentsDownloadFile => 'Shared Documents Download File';

  @override
  String sharedDocumentsDownloading(String filename) {
    return 'Shared Documents Downloading: $filename';
  }

  @override
  String get sharedDocumentsName => 'Shared Documents Name';

  @override
  String get sharedDocumentsPending => 'Shared Documents Pending';

  @override
  String get sharedDocumentsPreviewNotAvailable =>
      'Shared Documents Preview Not Available';

  @override
  String sharedDocumentsPreviewNotAvailableSubtitle(String type) {
    return 'Shared Documents Preview Not Available Subtitle: $type';
  }

  @override
  String get sharedDocumentsShare => 'Shared Documents Share';

  @override
  String get sharedDocumentsShareComingSoon =>
      'Shared Documents Share Coming Soon';

  @override
  String get sharedDocumentsSize => 'Shared Documents Size';

  @override
  String get sharedDocumentsType => 'Shared Documents Type';

  @override
  String get sharedDocumentsUnknown => 'Shared Documents Unknown';

  @override
  String get sharedDocumentsUploadDate => 'Shared Documents Upload Date';

  @override
  String get sharedDocumentsUploadedBy => 'Shared Documents Uploaded By';

  @override
  String get sharedDocumentsVerificationStatus =>
      'Shared Documents Verification Status';

  @override
  String get sharedDocumentsVerified => 'Shared Documents Verified';

  @override
  String sharedExamsAnsweredCount(int count) {
    return 'Shared Exams Answered Count: $count';
  }

  @override
  String get sharedExamsNext => 'Shared Exams Next';

  @override
  String get sharedExamsPrevious => 'Shared Exams Previous';

  @override
  String sharedExamsQuestionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get sharedExamsSubmit => 'Shared Exams Submit';

  @override
  String get sharedExamsSubmitting => 'Shared Exams Submitting';

  @override
  String get sharedFocusBreakCompleteReadyToFocus =>
      'Shared Focus Break Complete Ready To Focus';

  @override
  String get sharedFocusFinish => 'Shared Focus Finish';

  @override
  String get sharedFocusGreatWorkTimeForBreak =>
      'Shared Focus Great Work Time For Break';

  @override
  String get sharedFocusPomodorosToday => 'Shared Focus Pomodoros Today';

  @override
  String get sharedFocusSessionComplete => 'Shared Focus Session Complete';

  @override
  String get sharedFocusStartBreak => 'Shared Focus Start Break';

  @override
  String get sharedFocusStartFocus => 'Shared Focus Start Focus';

  @override
  String get sharedFocusTimerTitle => 'Shared Focus Timer Title';

  @override
  String sharedHelpArticleCount(int count) {
    return 'Shared Help Article Count: $count';
  }

  @override
  String sharedHelpDaysAgo(int days) {
    return 'Shared Help Days Ago: $days';
  }

  @override
  String get sharedHelpMonthApr => 'Shared Help Month Apr';

  @override
  String get sharedHelpMonthAug => 'Shared Help Month Aug';

  @override
  String get sharedHelpMonthDec => 'Shared Help Month Dec';

  @override
  String get sharedHelpMonthFeb => 'Shared Help Month Feb';

  @override
  String get sharedHelpMonthJan => 'Shared Help Month Jan';

  @override
  String get sharedHelpMonthJul => 'Shared Help Month Jul';

  @override
  String get sharedHelpMonthJun => 'Shared Help Month Jun';

  @override
  String get sharedHelpMonthMar => 'Shared Help Month Mar';

  @override
  String get sharedHelpMonthMay => 'Shared Help Month May';

  @override
  String get sharedHelpMonthNov => 'Shared Help Month Nov';

  @override
  String get sharedHelpMonthOct => 'Shared Help Month Oct';

  @override
  String get sharedHelpMonthSep => 'Shared Help Month Sep';

  @override
  String sharedHelpSearchingFor(String query) {
    return 'Shared Help Searching For: $query';
  }

  @override
  String get sharedHelpToday => 'Shared Help Today';

  @override
  String sharedHelpViewCount(int count) {
    return 'Shared Help View Count: $count';
  }

  @override
  String get sharedHelpYesterday => 'Shared Help Yesterday';

  @override
  String get sharedMessagingChat => 'Shared Messaging Chat';

  @override
  String get sharedMessagingConnecting => 'Shared Messaging Connecting';

  @override
  String get sharedMessagingFailedToSend => 'Shared Messaging Failed To Send';

  @override
  String get sharedMessagingLoadingMessages =>
      'Shared Messaging Loading Messages';

  @override
  String get sharedMessagingNoMessagesYet => 'Shared Messaging No Messages Yet';

  @override
  String get sharedMessagingRetry => 'Shared Messaging Retry';

  @override
  String get sharedMessagingStartConversation =>
      'Shared Messaging Start Conversation';

  @override
  String get sharedMessagingTypeMessage => 'Shared Messaging Type Message';

  @override
  String get sharedMessagingTyping => 'Shared Messaging Typing';

  @override
  String get sharedMessagingTypingMultiple =>
      'Shared Messaging Typing Multiple';

  @override
  String get sharedNotesCancel => 'Shared Notes Cancel';

  @override
  String get sharedNotesDiscard => 'Shared Notes Discard';

  @override
  String get sharedNotesPleaseEnterTitle => 'Shared Notes Please Enter Title';

  @override
  String get sharedNotesUnsavedChangesMessage =>
      'Shared Notes Unsaved Changes Message';

  @override
  String get sharedNotesUnsavedChangesTitle =>
      'Shared Notes Unsaved Changes Title';

  @override
  String get sharedNotificationsMarkAllRead =>
      'Shared Notifications Mark All Read';

  @override
  String get sharedNotificationsTitle => 'Shared Notifications Title';

  @override
  String get sharedPaymentsPaymentSuccessfulTitle =>
      'Shared Payments Payment Successful Title';

  @override
  String get sharedProfileRetry => 'Shared Profile Retry';

  @override
  String get sharedQuizzesAnswered => 'Shared Quizzes Answered';

  @override
  String get sharedQuizzesCancel => 'Shared Quizzes Cancel';

  @override
  String get sharedQuizzesCurrent => 'Shared Quizzes Current';

  @override
  String get sharedQuizzesExit => 'Shared Quizzes Exit';

  @override
  String get sharedQuizzesExitQuizMessage => 'Shared Quizzes Exit Quiz Message';

  @override
  String get sharedQuizzesExitQuizTitle => 'Shared Quizzes Exit Quiz Title';

  @override
  String get sharedQuizzesNext => 'Shared Quizzes Next';

  @override
  String get sharedQuizzesOk => 'Shared Quizzes Ok';

  @override
  String get sharedQuizzesPrevious => 'Shared Quizzes Previous';

  @override
  String get sharedQuizzesQuestionNavigator =>
      'Shared Quizzes Question Navigator';

  @override
  String get sharedQuizzesReview => 'Shared Quizzes Review';

  @override
  String get sharedQuizzesSubmit => 'Shared Quizzes Submit';

  @override
  String get sharedQuizzesSubmitAnyway => 'Shared Quizzes Submit Anyway';

  @override
  String get sharedQuizzesSubmitQuiz => 'Shared Quizzes Submit Quiz';

  @override
  String get sharedQuizzesSubmitQuizMessage =>
      'Shared Quizzes Submit Quiz Message';

  @override
  String get sharedQuizzesSubmitQuizTitle => 'Shared Quizzes Submit Quiz Title';

  @override
  String get sharedQuizzesTimeExpiredMessage =>
      'Shared Quizzes Time Expired Message';

  @override
  String get sharedQuizzesTimesUp => 'Shared Quizzes Times Up';

  @override
  String get sharedQuizzesUnanswered => 'Shared Quizzes Unanswered';

  @override
  String sharedQuizzesUnansweredQuestionsMessage(int count) {
    return 'Shared Quizzes Unanswered Questions Message: $count';
  }

  @override
  String get sharedQuizzesUnansweredQuestionsTitle =>
      'Shared Quizzes Unanswered Questions Title';

  @override
  String get sharedResourcesAddedToBookmarks =>
      'Shared Resources Added To Bookmarks';

  @override
  String get sharedResourcesAudioControlsComingSoon =>
      'Shared Resources Audio Controls Coming Soon';

  @override
  String get sharedResourcesAudioControlsFeature =>
      'Shared Resources Audio Controls Feature';

  @override
  String get sharedResourcesAudioPlaybackComingSoon =>
      'Shared Resources Audio Playback Coming Soon';

  @override
  String get sharedResourcesAudioPlayerFeature =>
      'Shared Resources Audio Player Feature';

  @override
  String get sharedResourcesBookmarkTooltip =>
      'Shared Resources Bookmark Tooltip';

  @override
  String get sharedResourcesCheckConnectionMessage =>
      'Shared Resources Check Connection Message';

  @override
  String get sharedResourcesDownloadCompleted =>
      'Shared Resources Download Completed';

  @override
  String get sharedResourcesDownloadToView =>
      'Shared Resources Download To View';

  @override
  String get sharedResourcesDownloadTooltip =>
      'Shared Resources Download Tooltip';

  @override
  String get sharedResourcesFailedToLoadImage =>
      'Shared Resources Failed To Load Image';

  @override
  String get sharedResourcesFailedToLoadResource =>
      'Shared Resources Failed To Load Resource';

  @override
  String get sharedResourcesFileTypeRequiresViewer =>
      'Shared Resources File Type Requires Viewer';

  @override
  String sharedResourcesOpeningUrl(String url) {
    return 'Shared Resources Opening Url: $url';
  }

  @override
  String get sharedResourcesPdfViewerMessage =>
      'Shared Resources Pdf Viewer Message';

  @override
  String get sharedResourcesPdfViewerTitle =>
      'Shared Resources Pdf Viewer Title';

  @override
  String get sharedResourcesRemovedFromBookmarks =>
      'Shared Resources Removed From Bookmarks';

  @override
  String get sharedResourcesRetry => 'Shared Resources Retry';

  @override
  String get sharedResourcesShareComingSoon =>
      'Shared Resources Share Coming Soon';

  @override
  String get sharedResourcesShareTooltip => 'Shared Resources Share Tooltip';

  @override
  String get sharedResourcesVideoPlaybackComingSoon =>
      'Shared Resources Video Playback Coming Soon';

  @override
  String get sharedResourcesVideoPlayerMessage =>
      'Shared Resources Video Player Message';

  @override
  String get sharedResourcesVideoPlayerTitle =>
      'Shared Resources Video Player Title';

  @override
  String get sharedScheduleCalendar => 'Shared Schedule Calendar';

  @override
  String get sharedScheduleFilter => 'Shared Schedule Filter';

  @override
  String get sharedScheduleToday => 'Shared Schedule Today';

  @override
  String get sharedTasksCourseLabel => 'Shared Tasks Course Label';

  @override
  String get sharedTasksDeleteTooltip => 'Shared Tasks Delete Tooltip';

  @override
  String get sharedTasksDescriptionLabel => 'Shared Tasks Description Label';

  @override
  String get sharedTasksDetailsTitle => 'Shared Tasks Details Title';

  @override
  String get sharedTasksDueDateLabel => 'Shared Tasks Due Date Label';

  @override
  String get sharedTasksEditTooltip => 'Shared Tasks Edit Tooltip';

  @override
  String get sharedTasksFavoriteTooltip => 'Shared Tasks Favorite Tooltip';

  @override
  String get sharedTasksOverdueWarning => 'Shared Tasks Overdue Warning';

  @override
  String studentAppsFailedToPrepare(String error) {
    return 'Student Apps Failed To Prepare: $error';
  }

  @override
  String get studentAppsUploadingDocuments =>
      'Student Apps Uploading Documents';

  @override
  String studentCoursesCompletedOn(String date) {
    return 'Student Courses Completed On: $date';
  }

  @override
  String studentCoursesError(String error) {
    return 'Student Courses Error: $error';
  }

  @override
  String get studentCoursesFailedToLoadDetails =>
      'Student Courses Failed To Load Details';

  @override
  String get adminContentSelectCourse => 'Select a course';

  @override
  String get adminContentModuleTitleRequired => 'Module Title *';

  @override
  String get adminContentEnterModuleTitle => 'Enter module title';

  @override
  String get adminContentEnterModuleDescription =>
      'Enter module description (optional)';

  @override
  String get adminContentModuleCreatedAsDraft =>
      'Module will be created as a draft. Use the Course Builder to add lessons.';

  @override
  String get adminContentPleaseSelectCourse => 'Please select a course';

  @override
  String get adminContentFailedToCreateModule => 'Failed to create module';

  @override
  String get adminContentTotalModules => 'Total Modules';

  @override
  String get adminContentAcrossAllCourses => 'Across all courses';

  @override
  String get adminContentLiveModules => 'Live modules';

  @override
  String get adminContentDrafts => 'Drafts';

  @override
  String get adminContentUnpublishedModules => 'Unpublished modules';

  @override
  String get adminContentTotalLessons => 'Total Lessons';

  @override
  String get adminContentAllLessons => 'All lessons';

  @override
  String get adminContentSearchModules => 'Search modules by title...';

  @override
  String get adminContentModuleTitle => 'Module Title';

  @override
  String get adminContentCourse => 'Course';

  @override
  String get adminContentLessons => 'Lessons';

  @override
  String get adminContentDuration => 'Duration';

  @override
  String get adminContentViewDetails => 'View Details';

  @override
  String get adminContentEditInBuilder => 'Edit in Course Builder';

  @override
  String get adminContentErrorLoadingPage => 'Error loading page';

  @override
  String get adminContentBack => 'Back';

  @override
  String get adminContentPreviewMode => 'Preview Mode';

  @override
  String get adminContentBackToEditor => 'Back to Editor';

  @override
  String get adminContentUnsaved => 'UNSAVED';

  @override
  String get adminContentUnpublish => 'Unpublish';

  @override
  String get adminContentPublish => 'Publish';

  @override
  String get adminContentSaving => 'Saving...';

  @override
  String get adminContentSave => 'Save';

  @override
  String get adminContentBasicInformation => 'Basic Information';

  @override
  String get adminContentPageTitle => 'Page Title';

  @override
  String get adminContentEnterPageTitle => 'Enter the page title';

  @override
  String get adminContentSubtitleOptional => 'Subtitle (optional)';

  @override
  String get adminContentEnterSubtitle => 'Enter a subtitle or tagline';

  @override
  String get adminContentMetaDescription => 'Meta Description (SEO)';

  @override
  String get adminContentBriefDescription =>
      'Brief description for search engines';

  @override
  String get adminContentContent => 'Content';

  @override
  String get adminContentUseRichTextEditor =>
      'Use the rich text editor to format your content.';

  @override
  String get adminContentEditJsonFormat =>
      'Edit the page content in JSON format.';

  @override
  String get adminContentVisual => 'Visual';

  @override
  String get adminContentRawJson => 'Raw JSON';

  @override
  String get adminContentSections => 'Sections';

  @override
  String get adminContentAddSection => 'Add Section';

  @override
  String get adminContentComplexStructure =>
      'This page has a complex structure.';

  @override
  String get adminContentUseRawJsonMode =>
      'Use Raw JSON mode to edit this page\'s content.';

  @override
  String get adminContentFormat => 'Format';

  @override
  String get adminContentContentRequired => 'Content is required';

  @override
  String get adminContentInvalidJsonFormat => 'Invalid JSON format';

  @override
  String get adminContentRichTextEditor => 'Rich Text Editor';

  @override
  String get adminContentVisualEditorHelp =>
      'Use the Visual Editor for WYSIWYG editing. Switch to Raw JSON for advanced editing.';

  @override
  String get adminContentCannotFormatInvalidJson =>
      'Cannot format: Invalid JSON';

  @override
  String get adminContentResourceTypeRequired => 'Resource Type *';

  @override
  String get adminContentTextContent => 'Text Content';

  @override
  String get adminContentSelectCourseFirst => 'Select a course first';

  @override
  String get adminContentSelectModule => 'Select a module';

  @override
  String get adminContentVideoUrlRequired => 'Video URL *';

  @override
  String get adminContentVideoUrlHint => 'https://youtube.com/watch?v=...';

  @override
  String get adminContentEnterTextContent =>
      'Enter text content (Markdown supported)';

  @override
  String get adminContentResourceCreatedAsDraft =>
      'Resource will be created as a draft lesson.';

  @override
  String get adminContentPleaseEnterLessonTitle =>
      'Please enter a lesson title';

  @override
  String get adminContentPleaseEnterVideoUrl => 'Please enter a video URL';

  @override
  String get adminContentPleaseEnterContent => 'Please enter content';

  @override
  String get adminContentVideoResourceCreated => 'Video resource created';

  @override
  String get adminContentTextResourceCreated => 'Text resource created';

  @override
  String get adminContentFailedToCreateResource => 'Failed to create resource';

  @override
  String get adminContentTotalResources => 'Total Resources';

  @override
  String get adminContentVideos => 'Videos';

  @override
  String get adminContentVideoResources => 'Video resources';

  @override
  String get adminContentTextResources => 'Text resources';

  @override
  String get adminContentTotalDuration => 'Total Duration';

  @override
  String get adminContentVideoContent => 'Video content';

  @override
  String get adminContentSearchResources => 'Search resources by title...';

  @override
  String get adminContentResourceType => 'Resource Type';

  @override
  String get adminContentLocation => 'Location';

  @override
  String get adminContentDurationReadTime => 'Duration / Read Time';

  @override
  String get adminContentModule => 'Module';

  @override
  String get adminContentLesson => 'Lesson';

  @override
  String get adminContentVideoUrl => 'Video URL';

  @override
  String get adminContentReadingTime => 'Reading Time';

  @override
  String get studentHelpCategoryGettingStarted => 'Getting Started';

  @override
  String get studentHelpCategoryApplications => 'Applications';

  @override
  String get studentHelpCategoryCounseling => 'Counseling';

  @override
  String get studentHelpCategoryCourses => 'Courses';

  @override
  String get studentHelpCategoryAccount => 'Account';

  @override
  String get studentHelpCategoryTechnical => 'Technical';

  @override
  String get studentResourcesCategoryStudyGuide => 'Study Guide';

  @override
  String get studentResourcesCategoryVideo => 'Video';

  @override
  String get studentResourcesCategoryTemplate => 'Template';

  @override
  String get studentResourcesCategoryExternalLink => 'External Link';

  @override
  String get studentResourcesCategoryCareer => 'Career';

  @override
  String get studentResourcesDateToday => 'Today';

  @override
  String get studentResourcesDateYesterday => 'Yesterday';

  @override
  String get studentScheduleWeekdaySun => 'Sun';

  @override
  String get studentScheduleWeekdayMon => 'Mon';

  @override
  String get studentScheduleWeekdayTue => 'Tue';

  @override
  String get studentScheduleWeekdayWed => 'Wed';

  @override
  String get studentScheduleWeekdayThu => 'Thu';

  @override
  String get studentScheduleWeekdayFri => 'Fri';

  @override
  String get studentScheduleWeekdaySat => 'Sat';

  @override
  String get studentScheduleEventCounseling => 'Counseling';

  @override
  String get studentScheduleEventCourse => 'Course';

  @override
  String get studentScheduleEventDeadline => 'Deadline';

  @override
  String get studentScheduleEventStudy => 'Study';

  @override
  String get studentScheduleEventOther => 'Other';

  @override
  String get studentCoursesDateToday => 'Today';

  @override
  String get studentCoursesDateYesterday => 'Yesterday';

  @override
  String get parentLinkTimeAgoJustNow => 'Just now';

  @override
  String get parentLinkStatusActive => 'Active';

  @override
  String get parentLinkStatusExpired => 'Expired';

  @override
  String get parentLinkStatusUsed => 'Used';

  @override
  String get studentRecStatusPending => 'Pending';

  @override
  String get studentRecStatusAccepted => 'Accepted';

  @override
  String get studentRecStatusInProgress => 'In Progress';

  @override
  String get studentRecStatusCompleted => 'Completed';

  @override
  String get studentRecStatusDeclined => 'Declined';

  @override
  String get studentRecStatusCancelled => 'Cancelled';

  @override
  String get studentRecChipPending => 'PENDING';

  @override
  String get studentRecChipAccepted => 'ACCEPTED';

  @override
  String get studentRecChipWriting => 'WRITING';

  @override
  String get studentRecChipCompleted => 'COMPLETED';

  @override
  String get studentRecChipDeclined => 'DECLINED';

  @override
  String get studentRecChipCancelled => 'CANCELLED';

  @override
  String studentCoursesEnrolledDate(String date) {
    return 'Enrolled: $date';
  }

  @override
  String studentCoursesDateDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String studentCoursesDateWeeksAgo(int weeks) {
    return '$weeks weeks ago';
  }

  @override
  String studentCoursesDateMonthsAgo(int months) {
    return '$months months ago';
  }

  @override
  String parentLinkLinkedTimeAgo(String timeAgo) {
    return 'Linked $timeAgo';
  }

  @override
  String parentLinkRequestedTimeAgo(String timeAgo) {
    return 'Requested $timeAgo';
  }

  @override
  String parentLinkTimeAgoMonths(int months) {
    return '$months months ago';
  }

  @override
  String parentLinkTimeAgoDays(int days) {
    return '$days days ago';
  }

  @override
  String parentLinkTimeAgoHours(int hours) {
    return '$hours hours ago';
  }

  @override
  String parentLinkTimeAgoMinutes(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String parentLinkExpiresInDays(int days) {
    return 'Expires in: $days days';
  }

  @override
  String parentLinkMaxUses(int count) {
    return 'Maximum uses: $count';
  }

  @override
  String parentLinkUsesRemaining(int remaining, int total) {
    return '$remaining/$total uses left';
  }

  @override
  String parentLinkExpiresOn(String date) {
    return 'Expires: $date';
  }

  @override
  String studentScheduleNoEventsOn(String date) {
    return 'No events on $date';
  }

  @override
  String studentScheduleDueBy(String time) {
    return 'Due by $time';
  }

  @override
  String studentResourcesDateDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String studentResourcesDateWeeksAgo(int weeks) {
    return '${weeks}w ago';
  }

  @override
  String studentResourcesDateMonthsAgo(int months) {
    return '${months}mo ago';
  }

  @override
  String studentResourcesOpening(String title) {
    return 'Opening $title...';
  }

  @override
  String studentHelpAppVersion(String version) {
    return 'Flow App v$version';
  }

  @override
  String adminContentEditPageTitle(String title) {
    return 'Edit Page: $title';
  }

  @override
  String adminContentSlug(String slug) {
    return 'Slug: $slug';
  }

  @override
  String adminContentModuleCreated(String title) {
    return 'Module \"$title\" created';
  }

  @override
  String get focusAnalyticsTitle => 'Focus Analytics';

  @override
  String get focusAnalyticsShare => 'Share';

  @override
  String get focusAnalyticsThisMonth => 'This Month';

  @override
  String get focusAnalyticsTotalFocusTime => 'Total Focus Time';

  @override
  String get focusAnalyticsSessions => 'Sessions';

  @override
  String get focusAnalyticsCompletion => 'Completion';

  @override
  String get focusAnalyticsAvgFocus => 'Avg Focus';

  @override
  String get focusAnalyticsCurrentStreak => 'Current Streak';

  @override
  String get focusAnalyticsDaysInARow => 'days in a row';

  @override
  String get focusAnalyticsBestStreak => 'Best Streak';

  @override
  String get focusAnalyticsDaysAchieved => 'days achieved';

  @override
  String get focusAnalyticsLongestSession => 'Longest Session';

  @override
  String get focusAnalyticsCompletionRate => 'Completion Rate';

  @override
  String get focusAnalyticsInsights => 'Insights';

  @override
  String get focusAnalyticsPeakFocusTime => 'Peak Focus Time';

  @override
  String get focusAnalyticsPeakFocusTimeDesc =>
      'You are most productive between 9 AM - 11 AM';

  @override
  String get focusAnalyticsGreatWeek => 'Great Week!';

  @override
  String get focusAnalyticsGreatWeekDesc =>
      'You completed 87% of your sessions this week';

  @override
  String get focusAnalyticsKeepItUp => 'Keep it up!';

  @override
  String get focusAnalyticsKeepItUpDesc =>
      '7-day streak - just 7 more for your best';

  @override
  String get focusAnalyticsShareComingSoon => 'Share functionality coming soon';

  @override
  String get studySessionsTitle => 'Study Sessions';

  @override
  String get studySessionsBack => 'Back';

  @override
  String studySessionsToday(int count) {
    return 'Today ($count)';
  }

  @override
  String studySessionsThisWeek(int count) {
    return 'This Week ($count)';
  }

  @override
  String studySessionsAll(int count) {
    return 'All ($count)';
  }

  @override
  String get studySessionsSessions => 'Sessions';

  @override
  String get studySessionsTotalTime => 'Total Time';

  @override
  String get studySessionsAvgFocus => 'Avg Focus';

  @override
  String get studySessionsNoSessions => 'No sessions yet';

  @override
  String get studySessionsNoSessionsSubtitle =>
      'Start a focus session to see it here';

  @override
  String get studySessionsDuration => 'Duration';

  @override
  String get studySessionsStatus => 'Status';

  @override
  String get studySessionsFocusLevel => 'Focus Level';

  @override
  String get studySessionsDistractions => 'Distractions';

  @override
  String get studySessionsClose => 'Close';

  @override
  String get adminCounselorDetailBackToCounselors => 'Back to Counselors';

  @override
  String get adminCounselorDetailTitle => 'Counselor Details';

  @override
  String get adminCounselorDetailStudents => 'Students';

  @override
  String get adminCounselorDetailSessions => 'Sessions';

  @override
  String get adminCounselorDetailRating => 'Rating';

  @override
  String get adminCounselorDetailActive => 'Active';

  @override
  String get adminCounselorDetailSuspended => 'Suspended';

  @override
  String get adminCounselorDetailPending => 'Pending';

  @override
  String get adminCounselorDetailInactive => 'Inactive';

  @override
  String get adminCounselorDetailApprove => 'Approve';

  @override
  String get adminCounselorDetailSuspend => 'Suspend';

  @override
  String get adminCounselorDetailActivate => 'Activate';

  @override
  String get adminCounselorDetailDelete => 'Delete';

  @override
  String get adminCounselorDetailMessage => 'Message';

  @override
  String get adminCounselorDetailTabOverview => 'Overview';

  @override
  String get adminCounselorDetailTabStudents => 'Students';

  @override
  String get adminCounselorDetailTabSessions => 'Sessions';

  @override
  String get adminCounselorDetailTabSchedule => 'Schedule';

  @override
  String get adminCounselorDetailTabDocuments => 'Documents';

  @override
  String get adminCounselorDetailTabActivity => 'Activity';

  @override
  String get adminCounselorDetailBasicInfo => 'Basic Information';

  @override
  String get adminCounselorDetailEmail => 'Email';

  @override
  String get adminCounselorDetailPhone => 'Phone';

  @override
  String get adminCounselorDetailJoined => 'Joined';

  @override
  String get adminCounselorDetailLastActive => 'Last Active';

  @override
  String get adminCounselorDetailProfessionalInfo => 'Professional Information';

  @override
  String get adminCounselorDetailSpecialization => 'Specialization';

  @override
  String get adminCounselorDetailExperience => 'Experience';

  @override
  String get adminCounselorDetailCertifications => 'Certifications';

  @override
  String get adminCounselorDetailHourlyRate => 'Hourly Rate';

  @override
  String get adminCounselorDetailBio => 'Bio';

  @override
  String adminCounselorDetailAssignedStudents(int count) {
    return '$count Assigned Students';
  }

  @override
  String get adminCounselorDetailNoStudents => 'No students assigned';

  @override
  String get adminCounselorDetailCounselingSessions => 'Counseling Sessions';

  @override
  String get adminCounselorDetailNoSessions => 'No sessions found';

  @override
  String get adminCounselorDetailSchedule => 'Schedule';

  @override
  String get adminCounselorDetailNoSchedule => 'No schedule set';

  @override
  String get adminCounselorDetailDocuments => 'Documents';

  @override
  String get adminCounselorDetailNoDocuments => 'No documents';

  @override
  String get adminCounselorDetailActivityLog => 'Activity Log';

  @override
  String get adminCounselorDetailNoActivity => 'No activity recorded';

  @override
  String get adminCounselorDetailSuspendTitle => 'Suspend Counselor';

  @override
  String adminCounselorDetailSuspendMessage(String name) {
    return 'Are you sure you want to suspend $name?';
  }

  @override
  String get adminCounselorDetailCancel => 'Cancel';

  @override
  String get adminCounselorDetailSuspendAction => 'Suspend';

  @override
  String get adminCounselorDetailActivateTitle => 'Activate Counselor';

  @override
  String adminCounselorDetailActivateMessage(String name) {
    return 'Are you sure you want to activate $name?';
  }

  @override
  String get adminCounselorDetailActivateAction => 'Activate';

  @override
  String get adminCounselorDetailDeleteTitle => 'Delete Counselor';

  @override
  String adminCounselorDetailDeleteMessage(String name) {
    return 'Are you sure you want to permanently delete $name? This action cannot be undone.';
  }

  @override
  String get adminCounselorDetailDeleteAction => 'Delete';

  @override
  String get adminCounselorDetailSuspendSuccess =>
      'Counselor suspended successfully';

  @override
  String get adminCounselorDetailActivateSuccess =>
      'Counselor activated successfully';

  @override
  String get adminCounselorDetailDeleteSuccess =>
      'Counselor deleted successfully';

  @override
  String adminCounselorDetailYears(int count) {
    return '$count years';
  }

  @override
  String adminCounselorDetailCertCount(int count) {
    return '$count certifications';
  }

  @override
  String adminCounselorDetailHourlyRateValue(String rate) {
    return '\$$rate/hour';
  }

  @override
  String get adminCounselorDetailCompleted => 'Completed';

  @override
  String get adminCounselorDetailScheduled => 'Scheduled';

  @override
  String get adminCounselorDetailCancelled => 'Cancelled';

  @override
  String get adminCounselorDetailUpload => 'Upload';

  @override
  String get adminCounselorDetailView => 'View';

  @override
  String get adminCounselorDetailDownload => 'Download';

  @override
  String get adminCounselorDetailActivityTimeline => 'Activity Timeline';

  @override
  String get adminCounselorDetailCounselorId => 'Counselor ID';

  @override
  String get adminCounselorDetailSpecialty => 'Specialty';

  @override
  String get adminCounselorDetailStatusActive => 'Active';

  @override
  String get adminCounselorDetailStatusInactive => 'Inactive';

  @override
  String get adminCounselorDetailStatusSuspended => 'Suspended';

  @override
  String get adminCounselorDetailEditCounselor => 'Edit Counselor';

  @override
  String get adminCounselorDetailSendMessage => 'Send Message';

  @override
  String get adminCounselorDetailSuspendAccount => 'Suspend Account';

  @override
  String get adminCounselorDetailActivateAccount => 'Activate Account';

  @override
  String get adminCounselorDetailDeleteCounselor => 'Delete Counselor';

  @override
  String get adminCounselorDetailFullName => 'Full Name';

  @override
  String get adminCounselorDetailCredentials => 'Credentials';

  @override
  String get adminCounselorDetailLicenseNumber => 'License Number';

  @override
  String get adminCounselorDetailYearsExperience => 'Years of Experience';

  @override
  String get adminCounselorDetailYearsValue => '8+ years';

  @override
  String get adminCounselorDetailContactInfo => 'Contact Information';

  @override
  String get adminCounselorDetailOfficeLocation => 'Office Location';

  @override
  String get adminCounselorDetailAvailability => 'Availability';

  @override
  String get adminCounselorDetailAccountInfo => 'Account Information';

  @override
  String get adminCounselorDetailAccountCreated => 'Account Created';

  @override
  String get adminCounselorDetailLastLogin => 'Last Login';

  @override
  String get adminCounselorDetailHoursAgo => '2 hours ago';

  @override
  String get adminCounselorDetailEmailVerified => 'Email Verified';

  @override
  String get adminCounselorDetailYes => 'Yes';

  @override
  String adminCounselorDetailSessionsCount(int count) {
    return '$count sessions';
  }

  @override
  String get adminCounselorDetailViewDetails => 'View Details';

  @override
  String adminCounselorDetailRecentSessions(int count) {
    return '$count Recent Sessions';
  }

  @override
  String get adminCounselorDetailWeeklySchedule => 'Weekly Schedule';

  @override
  String get adminCounselorDetailScheduleCalendar => 'Schedule Calendar';

  @override
  String get adminCounselorDetailCalendarComingSoon =>
      'Calendar view coming soon';

  @override
  String get adminCounselorDetailProfessionalDocuments =>
      'Professional Documents';

  @override
  String get adminInstitutionDetailBackToInstitutions => 'Back to Institutions';

  @override
  String get adminInstitutionDetailTitle => 'Institution Details';

  @override
  String get adminInstitutionDetailPrograms => 'Programs';

  @override
  String get adminInstitutionDetailApplicants => 'Applicants';

  @override
  String get adminInstitutionDetailAcceptance => 'Acceptance';

  @override
  String get adminInstitutionDetailApproved => 'Approved';

  @override
  String get adminInstitutionDetailPending => 'Pending';

  @override
  String get adminInstitutionDetailRejected => 'Rejected';

  @override
  String get adminInstitutionDetailSuspended => 'Suspended';

  @override
  String get adminInstitutionDetailApprove => 'Approve';

  @override
  String get adminInstitutionDetailReject => 'Reject';

  @override
  String get adminInstitutionDetailSuspend => 'Suspend';

  @override
  String get adminInstitutionDetailActivate => 'Activate';

  @override
  String get adminInstitutionDetailDelete => 'Delete';

  @override
  String get adminInstitutionDetailMessage => 'Message';

  @override
  String get adminInstitutionDetailTabOverview => 'Overview';

  @override
  String get adminInstitutionDetailTabPrograms => 'Programs';

  @override
  String get adminInstitutionDetailTabApplicants => 'Applicants';

  @override
  String get adminInstitutionDetailTabStatistics => 'Statistics';

  @override
  String get adminInstitutionDetailTabDocuments => 'Documents';

  @override
  String get adminInstitutionDetailTabActivity => 'Activity';

  @override
  String get adminInstitutionDetailBasicInfo => 'Basic Information';

  @override
  String get adminInstitutionDetailType => 'Type';

  @override
  String get adminInstitutionDetailLocation => 'Location';

  @override
  String get adminInstitutionDetailWebsite => 'Website';

  @override
  String get adminInstitutionDetailEmail => 'Email';

  @override
  String get adminInstitutionDetailPhone => 'Phone';

  @override
  String get adminInstitutionDetailJoined => 'Joined';

  @override
  String get adminInstitutionDetailDescription => 'Description';

  @override
  String get adminInstitutionDetailAcademicInfo => 'Academic Information';

  @override
  String get adminInstitutionDetailRanking => 'Ranking';

  @override
  String get adminInstitutionDetailAccreditedPrograms => 'Accredited Programs';

  @override
  String get adminInstitutionDetailTuitionRange => 'Tuition Range';

  @override
  String get adminInstitutionDetailAcceptanceRate => 'Acceptance Rate';

  @override
  String get adminInstitutionDetailOfferedPrograms => 'Offered Programs';

  @override
  String get adminInstitutionDetailNoPrograms => 'No programs offered';

  @override
  String adminInstitutionDetailRecentApplicants(int count) {
    return '$count Recent Applicants';
  }

  @override
  String get adminInstitutionDetailNoApplicants => 'No applicants';

  @override
  String get adminInstitutionDetailInstitutionStatistics =>
      'Institution Statistics';

  @override
  String get adminInstitutionDetailApplicationsTrend =>
      'Applications trend over time';

  @override
  String get adminInstitutionDetailDocuments => 'Documents';

  @override
  String get adminInstitutionDetailNoDocuments => 'No documents';

  @override
  String get adminInstitutionDetailActivityLog => 'Activity Log';

  @override
  String get adminInstitutionDetailNoActivity => 'No activity recorded';

  @override
  String get adminInstitutionDetailApproveTitle => 'Approve Institution';

  @override
  String adminInstitutionDetailApproveMessage(String name) {
    return 'Are you sure you want to approve $name?';
  }

  @override
  String get adminInstitutionDetailCancel => 'Cancel';

  @override
  String get adminInstitutionDetailApproveAction => 'Approve';

  @override
  String get adminInstitutionDetailRejectTitle => 'Reject Institution';

  @override
  String adminInstitutionDetailRejectMessage(String name) {
    return 'Are you sure you want to reject $name?';
  }

  @override
  String get adminInstitutionDetailRejectAction => 'Reject';

  @override
  String get adminInstitutionDetailSuspendTitle => 'Suspend Institution';

  @override
  String adminInstitutionDetailSuspendMessage(String name) {
    return 'Are you sure you want to suspend $name?';
  }

  @override
  String get adminInstitutionDetailSuspendAction => 'Suspend';

  @override
  String get adminInstitutionDetailActivateTitle => 'Activate Institution';

  @override
  String adminInstitutionDetailActivateMessage(String name) {
    return 'Are you sure you want to activate $name?';
  }

  @override
  String get adminInstitutionDetailActivateAction => 'Activate';

  @override
  String get adminInstitutionDetailDeleteTitle => 'Delete Institution';

  @override
  String adminInstitutionDetailDeleteMessage(String name) {
    return 'Are you sure you want to permanently delete $name? This action cannot be undone.';
  }

  @override
  String get adminInstitutionDetailDeleteAction => 'Delete';

  @override
  String get adminInstitutionDetailApproveSuccess =>
      'Institution approved successfully';

  @override
  String get adminInstitutionDetailRejectSuccess =>
      'Institution rejected successfully';

  @override
  String get adminInstitutionDetailSuspendSuccess =>
      'Institution suspended successfully';

  @override
  String get adminInstitutionDetailActivateSuccess =>
      'Institution activated successfully';

  @override
  String get adminInstitutionDetailDeleteSuccess =>
      'Institution deleted successfully';

  @override
  String get adminInstitutionDetailUniversity => 'University';

  @override
  String get adminInstitutionDetailCollege => 'College';

  @override
  String get adminInstitutionDetailCommunityCollege => 'Community College';

  @override
  String get adminInstitutionDetailTechnicalSchool => 'Technical School';

  @override
  String get adminInstitutionDetailVocationalSchool => 'Vocational School';

  @override
  String get adminInstitutionDetailOther => 'Other';

  @override
  String adminInstitutionDetailRankingValue(int rank) {
    return '#$rank nationally';
  }

  @override
  String adminInstitutionDetailProgramCount(int count) {
    return '$count programs';
  }

  @override
  String adminInstitutionDetailTuitionRangeValue(String min, String max) {
    return '\$$min - \$$max';
  }

  @override
  String adminInstitutionDetailAcceptanceRateValue(String rate) {
    return '$rate%';
  }

  @override
  String get adminInstitutionDetailViewDetails => 'View details';

  @override
  String get adminInstitutionDetailAccepted => 'Accepted';

  @override
  String adminInstitutionDetailGpa(String gpa) {
    return 'GPA: $gpa';
  }

  @override
  String get adminInstitutionDetailInstitutionId => 'Institution ID';

  @override
  String get adminInstitutionDetailStudents => 'Students';

  @override
  String get adminInstitutionDetailStatusVerified => 'Verified';

  @override
  String get adminInstitutionDetailStatusPending => 'Pending Verification';

  @override
  String get adminInstitutionDetailStatusRejected => 'Rejected';

  @override
  String get adminInstitutionDetailStatusActive => 'Active';

  @override
  String get adminInstitutionDetailEditInstitution => 'Edit Institution';

  @override
  String get adminInstitutionDetailSendMessage => 'Send Message';

  @override
  String get adminInstitutionDetailDeactivate => 'Deactivate';

  @override
  String get adminInstitutionDetailDeleteInstitution => 'Delete Institution';

  @override
  String get adminInstitutionDetailInstitutionInfo => 'Institution Information';

  @override
  String get adminInstitutionDetailFullName => 'Full Name';

  @override
  String get adminInstitutionDetailInstitutionType => 'Institution Type';

  @override
  String get adminInstitutionDetailContactPerson => 'Contact Person';

  @override
  String get adminInstitutionDetailName => 'Name';

  @override
  String get adminInstitutionDetailPosition => 'Position';

  @override
  String get adminInstitutionDetailAdmissionsDirector => 'Admissions Director';

  @override
  String get adminInstitutionDetailAccountInfo => 'Account Information';

  @override
  String get adminInstitutionDetailAccountCreated => 'Account Created';

  @override
  String get adminInstitutionDetailLastUpdated => 'Last Updated';

  @override
  String get adminInstitutionDetailWeeksAgo => '2 weeks ago';

  @override
  String get adminInstitutionDetailLastLogin => 'Last Login';

  @override
  String get adminInstitutionDetailHoursAgo => '3 hours ago';

  @override
  String get adminInstitutionDetailVerificationDate => 'Verification Date';

  @override
  String get adminInstitutionDetailMonthAgo => '1 month ago';

  @override
  String adminInstitutionDetailProgramsCount(int count) {
    return '$count Programs';
  }

  @override
  String get adminInstitutionDetailAddProgram => 'Add Program';

  @override
  String adminInstitutionDetailRecentApplicantsCount(int count) {
    return '$count Recent Applicants';
  }

  @override
  String get adminInstitutionDetailStatistics => 'Statistics';

  @override
  String get adminInstitutionDetailTotalApplicants => 'Total Applicants';

  @override
  String get adminInstitutionDetailFromLastMonth => '+15% from last month';

  @override
  String get adminInstitutionDetailAboveAverage => '+5% above average';

  @override
  String get adminInstitutionDetailActivePrograms => 'Active Programs';

  @override
  String get adminInstitutionDetailNewThisYear => '2 new this year';

  @override
  String get adminInstitutionDetailEnrolledStudents => 'Enrolled Students';

  @override
  String get adminInstitutionDetailFromLastYear => '+8% from last year';

  @override
  String get adminInstitutionDetailApplicationTrends => 'Application Trends';

  @override
  String get adminInstitutionDetailChartComingSoon =>
      'Chart visualization coming soon';

  @override
  String get adminInstitutionDetailVerificationDocuments =>
      'Verification Documents';

  @override
  String get adminInstitutionDetailUpload => 'Upload';

  @override
  String get adminInstitutionDetailView => 'View';

  @override
  String get adminInstitutionDetailDownload => 'Download';

  @override
  String get adminInstitutionDetailActivityTimeline => 'Activity Timeline';

  @override
  String adminInstitutionDetailRejectConfirm(String name) {
    return 'Are you sure you want to reject $name?';
  }

  @override
  String get adminInstitutionDetailReasonForRejection => 'Reason for rejection';

  @override
  String get adminInstitutionDetailDeactivateTitle => 'Deactivate Institution';

  @override
  String adminInstitutionDetailDeactivateMessage(String name) {
    return 'Are you sure you want to deactivate $name?';
  }

  @override
  String get adminInstitutionDetailDeactivateSuccess =>
      'Institution deactivated successfully';

  @override
  String get adminParentDetailBackToParents => 'Back to Parents';

  @override
  String get adminParentDetailTitle => 'Parent Details';

  @override
  String get adminParentDetailChildren => 'Children';

  @override
  String get adminParentDetailApplications => 'Applications';

  @override
  String get adminParentDetailSpent => 'Spent';

  @override
  String get adminParentDetailActive => 'Active';

  @override
  String get adminParentDetailSuspended => 'Suspended';

  @override
  String get adminParentDetailPending => 'Pending';

  @override
  String get adminParentDetailInactive => 'Inactive';

  @override
  String get adminParentDetailSuspend => 'Suspend';

  @override
  String get adminParentDetailActivate => 'Activate';

  @override
  String get adminParentDetailDelete => 'Delete';

  @override
  String get adminParentDetailMessage => 'Message';

  @override
  String get adminParentDetailTabOverview => 'Overview';

  @override
  String get adminParentDetailTabChildren => 'Children';

  @override
  String get adminParentDetailTabApplications => 'Applications';

  @override
  String get adminParentDetailTabDocuments => 'Documents';

  @override
  String get adminParentDetailTabPayments => 'Payments';

  @override
  String get adminParentDetailTabActivity => 'Activity';

  @override
  String get adminParentDetailBasicInfo => 'Basic Information';

  @override
  String get adminParentDetailEmail => 'Email';

  @override
  String get adminParentDetailPhone => 'Phone';

  @override
  String get adminParentDetailAddress => 'Address';

  @override
  String get adminParentDetailJoined => 'Joined';

  @override
  String get adminParentDetailLastActive => 'Last Active';

  @override
  String get adminParentDetailLinkedChildren => 'Linked Children';

  @override
  String get adminParentDetailNoChildren => 'No children linked';

  @override
  String get adminParentDetailApplicationsTracked => 'Applications Tracked';

  @override
  String get adminParentDetailNoApplications => 'No applications tracked';

  @override
  String get adminParentDetailDocuments => 'Documents';

  @override
  String get adminParentDetailNoDocuments => 'No documents';

  @override
  String get adminParentDetailPaymentHistory => 'Payment History';

  @override
  String get adminParentDetailNoPayments => 'No payments';

  @override
  String get adminParentDetailActivityLog => 'Activity Log';

  @override
  String get adminParentDetailNoActivity => 'No activity recorded';

  @override
  String get adminParentDetailSuspendTitle => 'Suspend Parent';

  @override
  String adminParentDetailSuspendMessage(String name) {
    return 'Are you sure you want to suspend $name?';
  }

  @override
  String get adminParentDetailCancel => 'Cancel';

  @override
  String get adminParentDetailSuspendAction => 'Suspend';

  @override
  String get adminParentDetailActivateTitle => 'Activate Parent';

  @override
  String adminParentDetailActivateMessage(String name) {
    return 'Are you sure you want to activate $name?';
  }

  @override
  String get adminParentDetailActivateAction => 'Activate';

  @override
  String get adminParentDetailDeleteTitle => 'Delete Parent';

  @override
  String adminParentDetailDeleteMessage(String name) {
    return 'Are you sure you want to permanently delete $name? This action cannot be undone.';
  }

  @override
  String get adminParentDetailDeleteAction => 'Delete';

  @override
  String get adminParentDetailSuspendSuccess => 'Parent suspended successfully';

  @override
  String get adminParentDetailActivateSuccess =>
      'Parent activated successfully';

  @override
  String get adminParentDetailDeleteSuccess => 'Parent deleted successfully';

  @override
  String adminParentDetailGrade(String grade) {
    return 'Grade $grade';
  }

  @override
  String get adminParentDetailViewProfile => 'View Profile';

  @override
  String adminParentDetailAppliedTo(String institution) {
    return 'Applied to: $institution';
  }

  @override
  String get adminParentDetailSubmitted => 'Submitted';

  @override
  String get adminParentDetailAccepted => 'Accepted';

  @override
  String get adminParentDetailRejected => 'Rejected';

  @override
  String get adminParentDetailDraft => 'Draft';

  @override
  String adminParentDetailPaymentAmount(String amount) {
    return '\$$amount';
  }

  @override
  String get adminParentDetailCompleted => 'Completed';

  @override
  String get adminParentDetailFailed => 'Failed';

  @override
  String get adminParentDetailParentId => 'Parent ID';

  @override
  String get adminParentDetailMessages => 'Messages';

  @override
  String get adminParentDetailStatusActive => 'Active';

  @override
  String get adminParentDetailStatusInactive => 'Inactive';

  @override
  String get adminParentDetailStatusSuspended => 'Suspended';

  @override
  String get adminParentDetailEditParent => 'Edit Parent';

  @override
  String get adminParentDetailSendMessage => 'Send Message';

  @override
  String get adminParentDetailSuspendAccount => 'Suspend Account';

  @override
  String get adminParentDetailActivateAccount => 'Activate Account';

  @override
  String get adminParentDetailDeleteParent => 'Delete Parent';

  @override
  String get adminParentDetailPersonalInfo => 'Personal Information';

  @override
  String get adminParentDetailFullName => 'Full Name';

  @override
  String get adminParentDetailLocation => 'Location';

  @override
  String get adminParentDetailOccupation => 'Occupation';

  @override
  String get adminParentDetailBusinessOwner => 'Business Owner';

  @override
  String get adminParentDetailAccountInfo => 'Account Information';

  @override
  String get adminParentDetailAccountCreated => 'Account Created';

  @override
  String get adminParentDetailLastLogin => 'Last Login';

  @override
  String get adminParentDetailHoursAgo => '2 hours ago';

  @override
  String get adminParentDetailEmailVerified => 'Email Verified';

  @override
  String get adminParentDetailYes => 'Yes';

  @override
  String get adminParentDetailPhoneVerified => 'Phone Verified';

  @override
  String adminParentDetailChildrenCount(int count) {
    return '$count Children';
  }

  @override
  String get adminParentDetailLinkChild => 'Link Child';

  @override
  String get adminParentDetailViewDetails => 'View Details';

  @override
  String adminParentDetailApplicationsFromChildren(int count) {
    return '$count Applications from Children';
  }

  @override
  String get adminParentDetailUpload => 'Upload';

  @override
  String get adminParentDetailView => 'View';

  @override
  String get adminParentDetailDownload => 'Download';

  @override
  String get adminParentDetailPaymentSummary => 'Payment Summary';

  @override
  String get adminParentDetailTotalPaid => 'Total Paid';

  @override
  String get adminParentDetailTransactions => 'Transactions';

  @override
  String get adminParentDetailActivityTimeline => 'Activity Timeline';

  @override
  String get adminRecommenderDetailBackToRecommenders => 'Back to Recommenders';

  @override
  String get adminRecommenderDetailTitle => 'Recommender Details';

  @override
  String get adminRecommenderDetailRequests => 'Requests';

  @override
  String get adminRecommenderDetailCompleted => 'Completed';

  @override
  String get adminRecommenderDetailRating => 'Rating';

  @override
  String get adminRecommenderDetailActive => 'Active';

  @override
  String get adminRecommenderDetailSuspended => 'Suspended';

  @override
  String get adminRecommenderDetailPending => 'Pending';

  @override
  String get adminRecommenderDetailInactive => 'Inactive';

  @override
  String get adminRecommenderDetailSuspend => 'Suspend';

  @override
  String get adminRecommenderDetailActivate => 'Activate';

  @override
  String get adminRecommenderDetailDelete => 'Delete';

  @override
  String get adminRecommenderDetailMessage => 'Message';

  @override
  String get adminRecommenderDetailTabOverview => 'Overview';

  @override
  String get adminRecommenderDetailTabRequests => 'Requests';

  @override
  String get adminRecommenderDetailTabRecommendations => 'Recommendations';

  @override
  String get adminRecommenderDetailTabStatistics => 'Statistics';

  @override
  String get adminRecommenderDetailTabDocuments => 'Documents';

  @override
  String get adminRecommenderDetailTabActivity => 'Activity';

  @override
  String get adminRecommenderDetailBasicInfo => 'Basic Information';

  @override
  String get adminRecommenderDetailEmail => 'Email';

  @override
  String get adminRecommenderDetailPhone => 'Phone';

  @override
  String get adminRecommenderDetailInstitution => 'Institution';

  @override
  String get adminRecommenderDetailPosition => 'Position';

  @override
  String get adminRecommenderDetailJoined => 'Joined';

  @override
  String get adminRecommenderDetailLastActive => 'Last Active';

  @override
  String get adminRecommenderDetailLastLogin => 'Last Login';

  @override
  String get adminRecommenderDetailProfessionalInfo =>
      'Professional Information';

  @override
  String get adminRecommenderDetailDepartment => 'Department';

  @override
  String get adminRecommenderDetailYearsExperience => 'Years of Experience';

  @override
  String get adminRecommenderDetailSpecialization => 'Specialization';

  @override
  String get adminRecommenderDetailRecommendationRequests =>
      'Recommendation Requests';

  @override
  String get adminRecommenderDetailNoRequests => 'No requests';

  @override
  String get adminRecommenderDetailSubmittedRecommendations =>
      'Submitted Recommendations';

  @override
  String get adminRecommenderDetailNoRecommendations =>
      'No recommendations submitted';

  @override
  String get adminRecommenderDetailRecommenderStatistics =>
      'Recommender Statistics';

  @override
  String get adminRecommenderDetailResponseTimeChart =>
      'Response time and completion rate over time';

  @override
  String get adminRecommenderDetailDocuments => 'Documents';

  @override
  String get adminRecommenderDetailNoDocuments => 'No documents';

  @override
  String get adminRecommenderDetailActivityLog => 'Activity Log';

  @override
  String get adminRecommenderDetailNoActivity => 'No activity recorded';

  @override
  String get adminRecommenderDetailSuspendTitle => 'Suspend Recommender';

  @override
  String adminRecommenderDetailSuspendMessage(String name) {
    return 'Are you sure you want to suspend $name?';
  }

  @override
  String get adminRecommenderDetailCancel => 'Cancel';

  @override
  String get adminRecommenderDetailSuspendAction => 'Suspend';

  @override
  String get adminRecommenderDetailActivateTitle => 'Activate Recommender';

  @override
  String adminRecommenderDetailActivateMessage(String name) {
    return 'Are you sure you want to activate $name?';
  }

  @override
  String get adminRecommenderDetailActivateAction => 'Activate';

  @override
  String get adminRecommenderDetailDeleteTitle => 'Delete Recommender';

  @override
  String adminRecommenderDetailDeleteMessage(String name) {
    return 'Are you sure you want to permanently delete $name? This action cannot be undone.';
  }

  @override
  String get adminRecommenderDetailDeleteAction => 'Delete';

  @override
  String get adminRecommenderDetailSuspendSuccess =>
      'Recommender suspended successfully';

  @override
  String get adminRecommenderDetailActivateSuccess =>
      'Recommender activated successfully';

  @override
  String get adminRecommenderDetailDeleteSuccess =>
      'Recommender deleted successfully';

  @override
  String adminRecommenderDetailYearsCount(int count) {
    return '$count years';
  }

  @override
  String get adminRecommenderDetailRequestPending => 'Pending';

  @override
  String get adminRecommenderDetailRequestInProgress => 'In Progress';

  @override
  String get adminRecommenderDetailRequestDeclined => 'Declined';

  @override
  String adminRecommenderDetailDueDate(String date) {
    return 'Due: $date';
  }

  @override
  String adminRecommenderDetailForStudent(String student) {
    return 'For: $student';
  }

  @override
  String adminRecommenderDetailToInstitution(String institution) {
    return 'To: $institution';
  }

  @override
  String get adminRecommenderDetailChartComingSoon => 'Charts coming soon';

  @override
  String get adminRecommenderDetailUpload => 'Upload';

  @override
  String get adminRecommenderDetailView => 'View';

  @override
  String get adminRecommenderDetailDownload => 'Download';

  @override
  String get adminRecommenderDetailActivityTimeline => 'Activity Timeline';

  @override
  String adminRecommenderDetailCompletedRecommendations(int count) {
    return '$count Completed Recommendations';
  }

  @override
  String get adminRecommenderDetailSubmitted => 'Submitted';

  @override
  String get adminRecommenderDetailStatistics => 'Statistics';

  @override
  String get adminRecommenderDetailTotalRequests => 'Total Requests';

  @override
  String get adminRecommenderDetailAvgResponseTime => 'Avg Response Time';

  @override
  String adminRecommenderDetailDaysValue(int days) {
    return '$days days';
  }

  @override
  String get adminRecommenderDetailRecommendationTrends =>
      'Recommendation Trends';

  @override
  String get adminRecommenderDetailRecommenderId => 'Recommender ID';

  @override
  String get adminRecommenderDetailType => 'Type';

  @override
  String get adminRecommenderDetailOrganization => 'Organization';

  @override
  String get adminRecommenderDetailCompletionRate => 'Completion Rate';

  @override
  String get adminRecommenderDetailStatusActive => 'Active';

  @override
  String get adminRecommenderDetailStatusInactive => 'Inactive';

  @override
  String get adminRecommenderDetailStatusSuspended => 'Suspended';

  @override
  String get adminRecommenderDetailEditRecommender => 'Edit Recommender';

  @override
  String get adminRecommenderDetailSendMessage => 'Send Message';

  @override
  String get adminRecommenderDetailSuspendAccount => 'Suspend Account';

  @override
  String get adminRecommenderDetailActivateAccount => 'Activate Account';

  @override
  String get adminRecommenderDetailDeleteRecommender => 'Delete Recommender';

  @override
  String get adminRecommenderDetailFullName => 'Full Name';

  @override
  String get adminRecommenderDetailSenior => 'Senior';

  @override
  String get adminRecommenderDetailYearsAtOrg => 'Years at Organization';

  @override
  String get adminRecommenderDetailYearsValue => '5+ years';

  @override
  String get adminRecommenderDetailContactInfo => 'Contact Information';

  @override
  String get adminRecommenderDetailOffice => 'Office';

  @override
  String get adminRecommenderDetailPreferredContact => 'Preferred Contact';

  @override
  String get adminRecommenderDetailAccountInfo => 'Account Information';

  @override
  String get adminRecommenderDetailAccountCreated => 'Account Created';

  @override
  String get adminRecommenderDetailDayAgo => '1 day ago';

  @override
  String get adminRecommenderDetailEmailVerified => 'Email Verified';

  @override
  String get adminRecommenderDetailYes => 'Yes';

  @override
  String adminRecommenderDetailRequestsCount(int count) {
    return '$count Requests';
  }

  @override
  String get paymentFailureTitle => 'Payment Failed';

  @override
  String get paymentFailureDefaultMessage =>
      'We could not process your payment. Please try again.';

  @override
  String get paymentFailureTransactionDetails => 'Transaction Details';

  @override
  String get paymentFailureTransactionId => 'Transaction ID';

  @override
  String get paymentFailureNotAvailable => 'N/A';

  @override
  String get paymentFailureReference => 'Reference';

  @override
  String get paymentFailurePaymentMethod => 'Payment Method';

  @override
  String get paymentFailureAmount => 'Amount';

  @override
  String get paymentFailureReason => 'Failure Reason';

  @override
  String get paymentFailureCommonIssues => 'Common Issues';

  @override
  String get paymentFailureInsufficientFunds => 'Insufficient Funds';

  @override
  String get paymentFailureInsufficientFundsDesc =>
      'Ensure you have sufficient balance in your account';

  @override
  String get paymentFailureCardDeclined => 'Card Declined';

  @override
  String get paymentFailureCardDeclinedDesc =>
      'Check with your bank or try a different card';

  @override
  String get paymentFailureNetworkIssues => 'Network Issues';

  @override
  String get paymentFailureNetworkIssuesDesc =>
      'Ensure you have a stable internet connection';

  @override
  String get paymentFailureIncorrectDetails => 'Incorrect Details';

  @override
  String get paymentFailureIncorrectDetailsDesc =>
      'Verify your payment information is correct';

  @override
  String get paymentFailureContactSupportNotice =>
      'If the problem persists, please contact support';

  @override
  String get paymentFailureTryAgain => 'Try Again';

  @override
  String get paymentFailureContactSupport => 'Contact Support';

  @override
  String get paymentFailureBackToHome => 'Back to Home';

  @override
  String get paymentHistoryTitle => 'Payment History';

  @override
  String get paymentHistoryBack => 'Back';

  @override
  String paymentHistoryTabAll(int count) {
    return 'All ($count)';
  }

  @override
  String paymentHistoryTabCompleted(int count) {
    return 'Completed ($count)';
  }

  @override
  String paymentHistoryTabProcessing(int count) {
    return 'Processing ($count)';
  }

  @override
  String paymentHistoryTabFailed(int count) {
    return 'Failed ($count)';
  }

  @override
  String get paymentHistoryRetry => 'Retry';

  @override
  String get paymentHistoryLoading => 'Loading payment history...';

  @override
  String get paymentHistoryNoPayments => 'No Payments';

  @override
  String get paymentHistoryNoPaymentsFound => 'No payments found';

  @override
  String get paymentHistoryTransactionId => 'Transaction ID';

  @override
  String get paymentHistoryReference => 'Reference';

  @override
  String get paymentHistoryPaymentMethod => 'Payment Method';

  @override
  String get paymentHistoryDate => 'Date';

  @override
  String get paymentHistoryCompletedAt => 'Completed At';

  @override
  String get paymentHistoryDownloadReceipt => 'Download Receipt';

  @override
  String get paymentHistoryRetryPayment => 'Retry Payment';

  @override
  String get paymentHistoryReceiptOptions => 'Receipt Options';

  @override
  String get paymentHistoryDownloadAsPdf => 'Download as PDF';

  @override
  String get paymentHistorySaveToDevice => 'Save receipt to device';

  @override
  String get paymentHistoryEmailReceipt => 'Email Receipt';

  @override
  String get paymentHistorySendToEmail => 'Send to your email address';

  @override
  String get paymentHistoryShareReceipt => 'Share Receipt';

  @override
  String get paymentHistoryShareViaApps => 'Share via other apps';

  @override
  String get paymentHistoryDownloading => 'Downloading receipt...';

  @override
  String get paymentHistorySendingEmail => 'Sending receipt via email...';

  @override
  String get paymentHistoryOpeningShare => 'Opening share options...';

  @override
  String get paymentHistoryCourseEnrollment => 'Course Enrollment';

  @override
  String get paymentHistoryProgramApplication => 'Program Application';

  @override
  String get paymentHistoryCounselingSession => 'Counseling Session';

  @override
  String get paymentMethodTitle => 'Select Payment Method';

  @override
  String get paymentMethodBack => 'Back';

  @override
  String get paymentMethodRetry => 'Retry';

  @override
  String get paymentMethodLoading => 'Loading payment methods...';

  @override
  String get paymentMethodSummary => 'Payment Summary';

  @override
  String get paymentMethodItem => 'Item';

  @override
  String get paymentMethodType => 'Type';

  @override
  String get paymentMethodTotalAmount => 'Total Amount';

  @override
  String get paymentMethodChoose => 'Choose Payment Method';

  @override
  String get paymentMethodSecureNotice =>
      'Your payment information is secure and encrypted';

  @override
  String get paymentMethodContinue => 'Continue to Payment';

  @override
  String get paymentMethodCourseEnrollment => 'Course Enrollment';

  @override
  String get paymentMethodProgramApplication => 'Program Application';

  @override
  String get paymentMethodCounselingSession => 'Counseling Session';

  @override
  String paymentProcessingPayWith(String method) {
    return 'Pay with $method';
  }

  @override
  String get paymentProcessingAmountToPay => 'Amount to Pay';

  @override
  String get paymentProcessingSecureNotice =>
      'Your payment is secured with end-to-end encryption';

  @override
  String get paymentProcessingStatus => 'Processing...';

  @override
  String paymentProcessingPayAmount(String currency, String amount) {
    return 'Pay $currency $amount';
  }

  @override
  String get paymentProcessingMpesaTitle => 'M-Pesa Payment';

  @override
  String get paymentProcessingMpesaPhoneLabel => 'M-Pesa Phone Number';

  @override
  String get paymentProcessingMpesaPhoneHint => '254712345678';

  @override
  String get paymentProcessingMpesaPhoneRequired =>
      'Please enter your M-Pesa phone number';

  @override
  String get paymentProcessingMpesaPhoneInvalid =>
      'Please enter a valid Kenyan phone number (254...)';

  @override
  String get paymentProcessingMpesaHowToPay => 'How to pay';

  @override
  String get paymentProcessingMpesaStep1 =>
      'You will receive an M-Pesa prompt on your phone';

  @override
  String get paymentProcessingMpesaStep2 =>
      'Enter your M-Pesa PIN to confirm payment';

  @override
  String get paymentProcessingMpesaStep3 => 'Wait for confirmation SMS';

  @override
  String get paymentProcessingCardTitle => 'Card Details';

  @override
  String get paymentProcessingCardholderName => 'Cardholder Name';

  @override
  String get paymentProcessingCardholderHint => 'JOHN DOE';

  @override
  String get paymentProcessingCardholderRequired =>
      'Please enter cardholder name';

  @override
  String get paymentProcessingCardNumber => 'Card Number';

  @override
  String get paymentProcessingCardNumberHint => '1234 5678 9012 3456';

  @override
  String get paymentProcessingCardNumberRequired => 'Please enter card number';

  @override
  String get paymentProcessingCardNumberInvalid =>
      'Please enter a valid card number';

  @override
  String get paymentProcessingExpiryDate => 'Expiry Date';

  @override
  String get paymentProcessingExpiryHint => 'MM/YY';

  @override
  String get paymentProcessingRequired => 'Required';

  @override
  String get paymentProcessingInvalidFormat => 'Invalid format';

  @override
  String get paymentProcessingCvv => 'CVV';

  @override
  String get paymentProcessingCvvHint => '123';

  @override
  String get paymentProcessingCvvInvalid => 'Invalid CVV';

  @override
  String get paymentProcessingFlutterwaveTitle => 'Flutterwave Payment';

  @override
  String get paymentProcessingFlutterwaveOptions => 'Payment Options';

  @override
  String get paymentProcessingFlutterwaveCard => 'Card Payment';

  @override
  String get paymentProcessingFlutterwaveCardDesc =>
      'Pay with debit or credit card';

  @override
  String get paymentProcessingFlutterwaveMobile => 'Mobile Money';

  @override
  String get paymentProcessingFlutterwaveMobileDesc =>
      'Pay with mobile money (M-Pesa, Airtel, etc.)';

  @override
  String get paymentProcessingFlutterwaveBank => 'Bank Transfer';

  @override
  String get paymentProcessingFlutterwaveBankDesc => 'Direct bank transfer';

  @override
  String get paymentProcessingFlutterwaveRedirect =>
      'You will be redirected to Flutterwave secure payment page';

  @override
  String get browseInstitutionsTitle => 'Browse Institutions';

  @override
  String get browseInstitutionsSelectTitle => 'Select Institution';

  @override
  String get browseInstitutionsBack => 'Back';

  @override
  String get browseInstitutionsClearFilters => 'Clear filters';

  @override
  String get browseInstitutionsSearchHint =>
      'Search by institution name or email...';

  @override
  String get browseInstitutionsSortBy => 'Sort by: ';

  @override
  String get browseInstitutionsSortName => 'Name (A-Z)';

  @override
  String get browseInstitutionsSortOfferings => 'Total Offerings';

  @override
  String get browseInstitutionsSortPrograms => 'Programs';

  @override
  String get browseInstitutionsSortCourses => 'Courses';

  @override
  String get browseInstitutionsSortNewest => 'Newest';

  @override
  String get browseInstitutionsAscending => 'Ascending';

  @override
  String get browseInstitutionsDescending => 'Descending';

  @override
  String get browseInstitutionsShowVerifiedOnly => 'Show verified only';

  @override
  String browseInstitutionsResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'institutions',
      one: 'institution',
    );
    return '$count registered $_temp0';
  }

  @override
  String get browseInstitutionsTapToSelect => 'Tap to select';

  @override
  String get browseInstitutionsNoResults => 'No institutions found';

  @override
  String get browseInstitutionsNoResultsHint =>
      'Try adjusting your search or filters';

  @override
  String get browseInstitutionsRetry => 'Retry';

  @override
  String get browseInstitutionsVerified => 'Verified';

  @override
  String get browseInstitutionsNoOfferings => 'No offerings yet';

  @override
  String browseInstitutionsSelected(String name) {
    return 'Selected: $name';
  }

  @override
  String get browseUniversitiesTitle => 'Browse Universities';

  @override
  String get browseUniversitiesSelectTitle => 'Select University';

  @override
  String get browseUniversitiesBack => 'Back';

  @override
  String get browseUniversitiesClearFilters => 'Clear filters';

  @override
  String get browseUniversitiesSearchHint =>
      'Search by name, city, or state...';

  @override
  String get browseUniversitiesSortBy => 'Sort by: ';

  @override
  String get browseUniversitiesSortName => 'Name (A-Z)';

  @override
  String get browseUniversitiesSortAcceptanceRate => 'Acceptance Rate';

  @override
  String get browseUniversitiesSortTuition => 'Tuition Cost';

  @override
  String get browseUniversitiesSortRanking => 'Ranking';

  @override
  String get browseUniversitiesAscending => 'Ascending';

  @override
  String get browseUniversitiesDescending => 'Descending';

  @override
  String browseUniversitiesResultCount(int count) {
    return '$count universities found';
  }

  @override
  String get browseUniversitiesNoResults => 'No universities found';

  @override
  String get browseUniversitiesNoResultsHint =>
      'Try adjusting your search or filters';

  @override
  String get browseUniversitiesRetry => 'Retry';

  @override
  String browseUniversitiesSelected(String name) {
    return 'Selected: $name';
  }

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyShare => 'Share';

  @override
  String get privacyPolicyShareComingSoon => 'Share functionality coming soon';

  @override
  String get privacyPolicyHeaderTitle => 'Flow EdTech Privacy Policy';

  @override
  String get privacyPolicyLastUpdated => 'Last Updated: October 28, 2025';

  @override
  String get privacyPolicyHeaderDescription =>
      'This Privacy Policy describes how Flow EdTech collects, uses, and protects your personal information.';

  @override
  String get privacyPolicySection1Title => '1. Information We Collect';

  @override
  String get privacyPolicySection1Content =>
      'We collect information that you provide directly to us, including:\n\n• Personal Information: Name, email address, phone number, and profile information\n• Educational Data: Course enrollments, grades, assignments, and learning progress\n• Usage Data: How you interact with our platform, including pages visited and features used\n• Device Information: Device type, operating system, and browser information\n• Location Data: General location information to provide relevant content\n\nWe collect this information when you:\n• Create an account or update your profile\n• Enroll in courses or complete assignments\n• Communicate with us or other users\n• Use our services and features';

  @override
  String get privacyPolicySection2Title => '2. How We Use Your Information';

  @override
  String get privacyPolicySection2Content =>
      'We use the information we collect to:\n\n• Provide and improve our educational services\n• Personalize your learning experience\n• Process your enrollments and track your progress\n• Communicate with you about courses, updates, and support\n• Analyze usage patterns to enhance our platform\n• Ensure security and prevent fraud\n• Comply with legal obligations\n• Send promotional materials (with your consent)\n\nWe do not sell your personal information to third parties.';

  @override
  String get privacyPolicySection3Title =>
      '3. Information Sharing and Disclosure';

  @override
  String get privacyPolicySection3Content =>
      'We may share your information in the following circumstances:\n\n• Educational Institutions: With schools or institutions you\'re affiliated with\n• Instructors: Course instructors can see your progress and submissions\n• Service Providers: Third-party providers who assist in operating our platform\n• Legal Requirements: When required by law or to protect our rights\n• Business Transfers: In connection with a merger or acquisition\n• With Your Consent: When you explicitly authorize sharing\n\nWe require all third parties to respect the security of your data and treat it in accordance with the law.';

  @override
  String get privacyPolicySection4Title => '4. Data Security';

  @override
  String get privacyPolicySection4Content =>
      'We implement appropriate technical and organizational measures to protect your information:\n\n• Encryption of data in transit and at rest\n• Regular security assessments and audits\n• Access controls and authentication measures\n• Secure data storage and backup systems\n• Employee training on data protection\n\nHowever, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.';

  @override
  String get privacyPolicySection5Title => '5. Your Rights and Choices';

  @override
  String get privacyPolicySection5Content =>
      'You have the following rights regarding your personal information:\n\n• Access: Request a copy of your personal data\n• Correction: Update or correct inaccurate information\n• Deletion: Request deletion of your personal data\n• Portability: Receive your data in a portable format\n• Opt-Out: Unsubscribe from marketing communications\n• Restriction: Limit how we process your data\n\nTo exercise these rights, contact us at privacy@flowedtech.com.';

  @override
  String get privacyPolicySection6Title =>
      '6. Cookies and Tracking Technologies';

  @override
  String get privacyPolicySection6Content =>
      'We use cookies and similar technologies to:\n\n• Remember your preferences and settings\n• Authenticate your account\n• Analyze platform usage and performance\n• Provide personalized content and recommendations\n\nYou can control cookies through your browser settings. However, disabling cookies may limit some functionality.';

  @override
  String get privacyPolicySection7Title => '7. Children\'s Privacy';

  @override
  String get privacyPolicySection7Content =>
      'Our services are intended for users 13 years and older. For users under 18:\n\n• Parental consent may be required\n• Additional protections are in place\n• Special handling of educational records (FERPA compliance)\n\nWe do not knowingly collect information from children under 13 without parental consent.';

  @override
  String get privacyPolicySection8Title => '8. International Data Transfers';

  @override
  String get privacyPolicySection8Content =>
      'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place, including:\n\n• Standard contractual clauses\n• Adequacy decisions by relevant authorities\n• Your explicit consent when required';

  @override
  String get privacyPolicySection9Title => '9. Changes to This Privacy Policy';

  @override
  String get privacyPolicySection9Content =>
      'We may update this Privacy Policy from time to time. We will:\n\n• Notify you of material changes via email or platform notification\n• Update the \"Last Updated\" date at the top of this policy\n• Obtain your consent for significant changes if required by law\n\nYour continued use of our services after changes constitutes acceptance of the updated policy.';

  @override
  String get privacyPolicySection10Title => '10. Contact Us';

  @override
  String get privacyPolicySection10Content =>
      'If you have questions or concerns about this Privacy Policy or our data practices, please contact us:\n\nEmail: privacy@flowedtech.com\nPhone: +1 (555) 123-4567\nAddress: Flow EdTech, 123 Education Lane, Tech City, TC 12345\n\nData Protection Officer: dpo@flowedtech.com';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get termsOfServiceShare => 'Share';

  @override
  String get termsOfServiceShareComingSoon => 'Share functionality coming soon';

  @override
  String get termsOfServiceHeaderTitle => 'Flow EdTech Terms of Service';

  @override
  String get termsOfServiceEffectiveDate => 'Effective Date: October 28, 2025';

  @override
  String get termsOfServiceHeaderDescription =>
      'Please read these Terms of Service carefully before using our platform. By accessing or using our services, you agree to be bound by these terms.';

  @override
  String get termsOfServiceSection1Title => '1. Acceptance of Terms';

  @override
  String get termsOfServiceSection1Content =>
      'By creating an account and using Flow EdTech, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service and our Privacy Policy.\n\nIf you do not agree to these terms, you may not access or use our services.\n\nThese terms constitute a legally binding agreement between you and Flow EdTech.';

  @override
  String get termsOfServiceSection2Title =>
      '2. Account Registration and Eligibility';

  @override
  String get termsOfServiceSection2Content =>
      'To use certain features, you must create an account and provide:\n\n• Accurate and complete information\n• Valid email address\n• Secure password\n• Proof of age (must be 13 or older)\n\nYou are responsible for:\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized access\n\nWe reserve the right to refuse service, terminate accounts, or cancel orders at our discretion.';

  @override
  String get termsOfServiceSection3Title =>
      '3. User Conduct and Responsibilities';

  @override
  String get termsOfServiceSection3Content =>
      'You agree not to:\n\n• Violate any laws or regulations\n• Infringe on intellectual property rights\n• Upload malicious code or viruses\n• Harass, abuse, or harm other users\n• Impersonate others or provide false information\n• Attempt to gain unauthorized access to our systems\n• Use automated tools to access our services\n• Sell or transfer your account to others\n• Post inappropriate or offensive content\n• Engage in academic dishonesty or plagiarism\n\nViolation of these terms may result in suspension or termination of your account.';

  @override
  String get termsOfServiceSection4Title => '4. Intellectual Property Rights';

  @override
  String get termsOfServiceSection4Content =>
      'All content on Flow EdTech, including:\n\n• Course materials and lectures\n• Text, graphics, logos, and images\n• Software and technology\n• Trademarks and branding\n\nIs owned by Flow EdTech or its licensors and is protected by copyright, trademark, and other intellectual property laws.\n\nUser-Generated Content:\n• You retain ownership of content you create\n• You grant us a license to use, display, and distribute your content\n• You represent that you have rights to any content you upload\n• We may remove content that violates these terms\n\nYou may not copy, modify, distribute, or create derivative works without our explicit permission.';

  @override
  String get termsOfServiceSection5Title =>
      '5. Subscriptions, Payments, and Refunds';

  @override
  String get termsOfServiceSection5Content =>
      'Subscription Plans:\n• Pricing is subject to change with notice\n• Subscriptions automatically renew unless cancelled\n• You can cancel at any time through your account settings\n• Cancellation takes effect at the end of the billing period\n\nPayment Terms:\n• All fees are in USD unless otherwise stated\n• Payment is due at the time of purchase\n• We accept major credit cards and other payment methods\n• Failed payments may result in service suspension\n\nRefund Policy:\n• 7-day money-back guarantee for new subscriptions\n• Refunds are processed within 5-10 business days\n• Course-specific refund policies may apply\n• Contact support@flowedtech.com for refund requests';

  @override
  String get termsOfServiceSection6Title =>
      '6. Course Access and Educational Content';

  @override
  String get termsOfServiceSection6Content =>
      'Course Enrollment:\n• Access is granted upon successful payment\n• Courses may have prerequisites or requirements\n• Some courses have limited enrollment periods\n• Completion certificates are awarded based on performance\n\nContent Availability:\n• We strive to maintain continuous access to courses\n• Content may be updated or modified without notice\n• Some courses may be retired or archived\n• No guarantee of specific educational outcomes\n\nAcademic Integrity:\n• You must complete your own work\n• Collaboration is only allowed where explicitly permitted\n• Plagiarism and cheating will result in account termination\n• Certificates may be revoked for academic misconduct';

  @override
  String get termsOfServiceSection7Title => '7. Privacy and Data Protection';

  @override
  String get termsOfServiceSection7Content =>
      'We are committed to protecting your privacy. Our collection and use of personal information is governed by our Privacy Policy.\n\nBy using our services, you consent to:\n• Collection of personal and usage data\n• Processing data for service provision\n• Sharing data as described in our Privacy Policy\n• Use of cookies and tracking technologies\n\nYour Rights:\n• Access your personal data\n• Request data correction or deletion\n• Opt-out of marketing communications\n• Data portability\n\nSee our Privacy Policy for complete details.';

  @override
  String get termsOfServiceSection8Title =>
      '8. Disclaimers and Limitations of Liability';

  @override
  String get termsOfServiceSection8Content =>
      'Services Provided \"AS IS\":\n• No warranty of uninterrupted or error-free service\n• No guarantee of specific results or outcomes\n• Educational content for informational purposes only\n• Not a substitute for professional advice\n\nLimitation of Liability:\n• We are not liable for indirect, incidental, or consequential damages\n• Maximum liability limited to fees paid in the last 12 months\n• No liability for third-party content or actions\n• No liability for data loss or service interruptions\n\nYou use our services at your own risk.';

  @override
  String get termsOfServiceSection9Title => '9. Third-Party Services and Links';

  @override
  String get termsOfServiceSection9Content =>
      'Our platform may contain links to third-party websites or integrate with third-party services:\n\n• We do not control third-party content\n• We are not responsible for third-party practices\n• Third-party terms and privacy policies apply\n• Use third-party services at your own risk\n\nIntegration examples include:\n• Payment processors\n• Video hosting platforms\n• Analytics services\n• Social media platforms';

  @override
  String get termsOfServiceSection10Title => '10. Termination';

  @override
  String get termsOfServiceSection10Content =>
      'We may terminate or suspend your account:\n\n• For violation of these terms\n• For fraudulent or illegal activity\n• For prolonged inactivity\n• At our discretion with or without notice\n\nUpon termination:\n• Your access to services will cease\n• You may lose access to course materials\n• Certain provisions survive termination\n• Outstanding fees remain due\n\nYou may terminate your account at any time through account settings.';

  @override
  String get termsOfServiceSection11Title =>
      '11. Dispute Resolution and Arbitration';

  @override
  String get termsOfServiceSection11Content =>
      'For any disputes arising from these terms:\n\nInformal Resolution:\n• Contact us first to resolve disputes informally\n• Email: legal@flowedtech.com\n• 30-day period to reach resolution\n\nArbitration Agreement:\n• Disputes resolved through binding arbitration\n• Individual basis only (no class actions)\n• Governed by American Arbitration Association rules\n• Located in Tech City, TC\n\nExceptions:\n• Small claims court disputes\n• Intellectual property disputes\n• Emergency injunctive relief';

  @override
  String get termsOfServiceSection12Title => '12. Governing Law';

  @override
  String get termsOfServiceSection12Content =>
      'These Terms are governed by:\n\n• Laws of the State of [Your State]\n• United States federal law\n• Without regard to conflict of law provisions\n\nJurisdiction:\n• Courts of [Your State]\n• Tech City, TC county courts\n\nInternational Users:\n• Additional local laws may apply\n• You are responsible for compliance with local laws';

  @override
  String get termsOfServiceSection13Title => '13. Changes to Terms of Service';

  @override
  String get termsOfServiceSection13Content =>
      'We may modify these terms at any time:\n\n• Changes effective upon posting\n• Material changes will be notified via email\n• Continued use constitutes acceptance\n• You can review current terms anytime\n\nIf you do not agree to modified terms:\n• Discontinue use of our services\n• Contact us to close your account\n• No refunds for remaining subscription period';

  @override
  String get termsOfServiceSection14Title => '14. Contact Information';

  @override
  String get termsOfServiceSection14Content =>
      'For questions about these Terms of Service:\n\nGeneral Inquiries:\nEmail: support@flowedtech.com\nPhone: +1 (555) 123-4567\n\nLegal Department:\nEmail: legal@flowedtech.com\n\nMailing Address:\nFlow EdTech\n123 Education Lane\nTech City, TC 12345\nUnited States\n\nBusiness Hours: Monday-Friday, 9am-5pm EST';

  @override
  String get termsOfServiceAcknowledgment =>
      'By using Flow EdTech, you acknowledge that you have read and understood these Terms of Service.';

  @override
  String get progressReportsTitle => 'Progress Reports';

  @override
  String get exportReport => 'Export Report';

  @override
  String get overviewTab => 'Overview';

  @override
  String get coursesTab => 'Courses';

  @override
  String get skillsTab => 'Skills';

  @override
  String get studyTime => 'Study Time';

  @override
  String get achievements => 'Achievements';

  @override
  String get avgScore => 'Avg. Score';

  @override
  String get weeklyActivity => 'Weekly Activity';

  @override
  String get activityChartPlaceholder =>
      'Activity chart will be displayed here';

  @override
  String lessonsCompleted(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get completed => 'Completed';

  @override
  String get reportExportedSuccessfully => 'Report exported successfully';

  @override
  String get studyScheduleTitle => 'Study Schedule';

  @override
  String get save => 'Save';

  @override
  String get dailyStudyGoal => 'Daily Study Goal';

  @override
  String minutesPerDay(int minutes) {
    return '$minutes minutes per day';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get studyReminders => 'Study Reminders';

  @override
  String get getNotifiedAtScheduledTimes => 'Get notified at scheduled times';

  @override
  String get weeklySchedule => 'Weekly Schedule';

  @override
  String get setYourPreferredStudyTimes => 'Set your preferred study times';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get addTime => 'Add time';

  @override
  String get noStudyTimeSet => 'No study time set';

  @override
  String get studyScheduleSavedSuccessfully =>
      'Study schedule saved successfully';

  @override
  String get notificationDetailsTitle => 'Notification Details';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get delete => 'Delete';

  @override
  String get markedAsRead => 'Marked as read';

  @override
  String get deleteNotificationTitle => 'Delete Notification';

  @override
  String get deleteNotificationConfirm =>
      'Are you sure you want to delete this notification?';

  @override
  String get cancel => 'Cancel';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get actionPerformed => 'Action performed';

  @override
  String get newBadge => 'NEW';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get justNow => 'Just now';

  @override
  String minuteAgo(int count) {
    return '$count minute ago';
  }

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hourAgo(int count) {
    return '$count hour ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String dayAgo(int count) {
    return '$count day ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get notificationTypeCourse => 'COURSE';

  @override
  String get notificationTypeApplication => 'APPLICATION';

  @override
  String get notificationTypePayment => 'PAYMENT';

  @override
  String get notificationTypeMessage => 'MESSAGE';

  @override
  String get notificationTypeAnnouncement => 'ANNOUNCEMENT';

  @override
  String get notificationTypeReminder => 'REMINDER';

  @override
  String get notificationTypeAchievement => 'ACHIEVEMENT';

  @override
  String get notificationTypeGeneric => 'NOTIFICATION';

  @override
  String get viewCourse => 'View Course';

  @override
  String get viewApplication => 'View Application';

  @override
  String get viewTransaction => 'View Transaction';

  @override
  String get openConversation => 'Open Conversation';

  @override
  String get viewAchievement => 'View Achievement';

  @override
  String get viewDetails => 'View Details';

  @override
  String get gotIt => 'Got It!';

  @override
  String get howToUse => 'How to use:';

  @override
  String get close => 'Close';

  @override
  String get tryIt => 'Try It';

  @override
  String openingFeature(String feature) {
    return 'Opening $feature...';
  }

  @override
  String get exploreFeature => 'Explore the app to discover this feature!';

  @override
  String get featureCategoryCoreFeatures => 'Core Features';

  @override
  String get featureCategoryStudyTools => 'Study Tools';

  @override
  String get featureCategoryProductivity => 'Productivity';

  @override
  String get featureCategoryCollaboration => 'Collaboration';

  @override
  String get featureCourseDiscoveryTitle => 'Course Discovery';

  @override
  String get featureCourseDiscoveryDesc =>
      'Browse and search thousands of courses from top institutions worldwide';

  @override
  String get featureCourseDiscoveryInstructions =>
      'Navigate to the Explore tab and use the search bar or browse categories.';

  @override
  String get featureApplicationTrackingTitle => 'Application Tracking';

  @override
  String get featureApplicationTrackingDesc =>
      'Manage all your course applications and track their status in real-time';

  @override
  String get featureApplicationTrackingInstructions =>
      'Go to Applications tab to view and manage all your applications.';

  @override
  String get featureLearningDashboardTitle => 'Learning Dashboard';

  @override
  String get featureLearningDashboardDesc =>
      'Track your progress, view enrolled courses, and access learning materials';

  @override
  String get featureLearningDashboardInstructions =>
      'Access your dashboard from the Home tab to see your progress.';

  @override
  String get featureMessagingTitle => 'Messaging';

  @override
  String get featureMessagingDesc =>
      'Communicate directly with institutions and counselors';

  @override
  String get featureMessagingInstructions =>
      'Open the Messages tab to chat with institutions and counselors.';

  @override
  String get featureNotesTitle => 'Notes';

  @override
  String get featureNotesDesc =>
      'Take, organize, and sync notes across all your devices';

  @override
  String get featureNotesInstructions =>
      'Tap the Notes icon to create and organize your study notes.';

  @override
  String get featureBookmarksTitle => 'Bookmarks';

  @override
  String get featureBookmarksDesc =>
      'Save courses and resources for quick access later';

  @override
  String get featureBookmarksInstructions =>
      'Save items by tapping the bookmark icon on courses or resources.';

  @override
  String get featureAchievementsTitle => 'Achievements';

  @override
  String get featureAchievementsDesc =>
      'Earn badges and track milestones as you progress';

  @override
  String get featureAchievementsInstructions =>
      'View your achievements in the Profile section under Progress.';

  @override
  String get featureProgressAnalyticsTitle => 'Progress Analytics';

  @override
  String get featureProgressAnalyticsDesc =>
      'Visualize your learning journey with detailed statistics';

  @override
  String get featureProgressAnalyticsInstructions =>
      'Check detailed analytics in your Profile > Progress section.';

  @override
  String get featureCalendarTitle => 'Calendar';

  @override
  String get featureCalendarDesc =>
      'Track deadlines, events, and important dates';

  @override
  String get featureCalendarInstructions =>
      'Access the Calendar from the bottom navigation or menu.';

  @override
  String get featureSmartNotificationsTitle => 'Smart Notifications';

  @override
  String get featureSmartNotificationsDesc =>
      'Get timely reminders and updates about your applications';

  @override
  String get featureSmartNotificationsInstructions =>
      'Enable notifications in Settings > Notifications.';

  @override
  String get featureStudySchedulerTitle => 'Study Scheduler';

  @override
  String get featureStudySchedulerDesc => 'Plan and optimize your study time';

  @override
  String get featureStudySchedulerInstructions =>
      'Create study schedules in Tools > Study Planner.';

  @override
  String get featureGoalsMilestonesTitle => 'Goals & Milestones';

  @override
  String get featureGoalsMilestonesDesc => 'Set and track your learning goals';

  @override
  String get featureGoalsMilestonesInstructions =>
      'Set goals in Profile > Progress > Goals.';

  @override
  String get featureStudyGroupsTitle => 'Study Groups';

  @override
  String get featureStudyGroupsDesc =>
      'Connect and collaborate with fellow learners';

  @override
  String get featureStudyGroupsInstructions =>
      'Join or create study groups from Community > Groups.';

  @override
  String get featureDiscussionForumsTitle => 'Discussion Forums';

  @override
  String get featureDiscussionForumsDesc =>
      'Participate in course discussions and Q&A';

  @override
  String get featureDiscussionForumsInstructions =>
      'Participate in forums from Community > Discussions.';

  @override
  String get featureResourceSharingTitle => 'Resource Sharing';

  @override
  String get featureResourceSharingDesc =>
      'Share notes, links, and study materials';

  @override
  String get featureResourceSharingInstructions =>
      'Share resources using the share button on any content.';

  @override
  String get featureLiveSessionsTitle => 'Live Sessions';

  @override
  String get featureLiveSessionsDesc => 'Join virtual classes and webinars';

  @override
  String get featureLiveSessionsInstructions =>
      'Join live sessions from the Schedule or Courses section.';

  @override
  String get subscriptionsTitle => 'Subscriptions';

  @override
  String get subscriptionsAvailablePlans => 'Available Plans';

  @override
  String get subscriptionsBasicPlan => 'Basic Plan';

  @override
  String get subscriptionsPremiumPlan => 'Premium Plan';

  @override
  String get subscriptionsInstitutionPlan => 'Institution Plan';

  @override
  String get subscriptionsPriceFree => 'Free';

  @override
  String subscriptionsPricePerMonth(String price) {
    return '$price/month';
  }

  @override
  String get subscriptionsFeatureBasicCourses => 'Access to basic courses';

  @override
  String get subscriptionsFeatureLimitedStorage => 'Limited storage';

  @override
  String get subscriptionsFeatureEmailSupport => 'Email support';

  @override
  String get subscriptionsFeatureAllCourses => 'Access to all courses';

  @override
  String get subscriptionsFeatureUnlimitedStorage => 'Unlimited storage';

  @override
  String get subscriptionsFeaturePrioritySupport => 'Priority support';

  @override
  String get subscriptionsFeatureOfflineDownloads => 'Offline downloads';

  @override
  String get subscriptionsFeatureCertificate => 'Certificate of completion';

  @override
  String get subscriptionsFeatureEverythingInPremium => 'Everything in Premium';

  @override
  String get subscriptionsFeatureMultiUserManagement => 'Multi-user management';

  @override
  String get subscriptionsFeatureAnalyticsDashboard => 'Analytics dashboard';

  @override
  String get subscriptionsFeatureCustomBranding => 'Custom branding';

  @override
  String get subscriptionsFeatureApiAccess => 'API access';

  @override
  String get subscriptionsStatusActive => 'Active';

  @override
  String get subscriptionsStatusLabel => 'Status';

  @override
  String get subscriptionsPlanLabel => 'Plan';

  @override
  String get subscriptionsPlanBasicFree => 'Basic (Free)';

  @override
  String get subscriptionsStartedLabel => 'Started';

  @override
  String get subscriptionsStartedDate => 'January 1, 2025';

  @override
  String get subscriptionsUpgradePlan => 'Upgrade Plan';

  @override
  String get subscriptionsCurrent => 'Current';

  @override
  String get subscriptionsSelectPlan => 'Select Plan';

  @override
  String get privacySecurityTitle => 'Privacy & Security';

  @override
  String get privacySecurityBack => 'Back';

  @override
  String get privacyProfilePrivacySection => 'PROFILE PRIVACY';

  @override
  String get privacyProfilePrivacySubtitle =>
      'Control who can see your profile information';

  @override
  String get privacyPublicProfile => 'Public Profile';

  @override
  String get privacyPublicProfileDesc => 'Allow anyone to view your profile';

  @override
  String get privacyShowEmail => 'Show Email';

  @override
  String get privacyShowEmailDesc => 'Display email on your profile';

  @override
  String get privacyShowPhone => 'Show Phone Number';

  @override
  String get privacyShowPhoneDesc => 'Display phone number on your profile';

  @override
  String get privacyShareProgress => 'Share Progress';

  @override
  String get privacyShareProgressDesc =>
      'Share your learning progress with counselors';

  @override
  String get privacyCommunicationSection => 'COMMUNICATION';

  @override
  String get privacyCommunicationSubtitle => 'Manage who can contact you';

  @override
  String get privacyAllowMessages => 'Allow Messages from Anyone';

  @override
  String get privacyAllowMessagesDesc => 'Anyone can send you messages';

  @override
  String get privacySecuritySection => 'SECURITY';

  @override
  String get privacySecuritySubtitle => 'Protect your account';

  @override
  String get privacyChangePassword => 'Change Password';

  @override
  String get privacyChangePasswordDesc => 'Update your account password';

  @override
  String get privacyTwoFactor => 'Two-Factor Authentication';

  @override
  String get privacyTwoFactorEnabled => 'Enabled';

  @override
  String get privacyTwoFactorRecommended => 'Recommended';

  @override
  String get privacyBiometric => 'Biometric Authentication';

  @override
  String get privacyBiometricDesc => 'Use fingerprint or face ID';

  @override
  String get privacyActiveSessions => 'Active Sessions';

  @override
  String get privacyActiveSessionsDesc =>
      'Manage devices signed in to your account';

  @override
  String get privacyDataPrivacySection => 'DATA & PRIVACY';

  @override
  String get privacyDataPrivacySubtitle => 'Control your data';

  @override
  String get privacyDownloadData => 'Download My Data';

  @override
  String get privacyDownloadDataDesc => 'Request a copy of your data';

  @override
  String get privacyPrivacyPolicy => 'Privacy Policy';

  @override
  String get privacyPrivacyPolicyDesc => 'Read our privacy policy';

  @override
  String get privacyTermsOfService => 'Terms of Service';

  @override
  String get privacyTermsOfServiceDesc => 'Read our terms of service';

  @override
  String get privacyAccountActionsSection => 'ACCOUNT ACTIONS';

  @override
  String get privacyAccountActionsSubtitle => 'Irreversible actions';

  @override
  String get privacyDeleteAccount => 'Delete Account';

  @override
  String get privacyDeleteAccountDesc =>
      'Permanently delete your account and data';

  @override
  String get privacyEnableTwoFactorTitle => 'Enable Two-Factor Authentication';

  @override
  String get privacyEnableTwoFactorMessage =>
      'Two-factor authentication adds an extra layer of security to your account. You\'ll need to enter a code from your phone in addition to your password when signing in.';

  @override
  String get privacyCancel => 'Cancel';

  @override
  String get privacyContinue => 'Continue';

  @override
  String get privacyTwoFactorSetupRequired =>
      '2FA setup screen - Backend integration required';

  @override
  String get privacyDisableTwoFactorTitle =>
      'Disable Two-Factor Authentication';

  @override
  String get privacyDisableTwoFactorMessage =>
      'Are you sure you want to disable two-factor authentication? This will make your account less secure.';

  @override
  String get privacyDisable => 'Disable';

  @override
  String get privacyActiveSessionsTitle => 'Active Sessions';

  @override
  String get privacySessionDevice => 'Device';

  @override
  String get privacySessionLocation => 'Location';

  @override
  String get privacySessionLastActive => 'Last Active';

  @override
  String get privacySessionCurrent => 'Current';

  @override
  String get privacySessionClose => 'Close';

  @override
  String get privacySessionRevokeAll => 'Revoke All';

  @override
  String get privacySessionsRevoked => 'All other sessions revoked';

  @override
  String get privacyDownloadDataTitle => 'Download Your Data';

  @override
  String get privacyDownloadDataMessage =>
      'We\'ll prepare a copy of your data and send it to your email address. This may take up to 24 hours.';

  @override
  String get privacyRequest => 'Request';

  @override
  String get privacyDataDownloadRequested => 'Data download request submitted';

  @override
  String get privacyDeleteAccountTitle => 'Delete Account';

  @override
  String get privacyDeleteAccountMessage =>
      'Are you absolutely sure? This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get privacyDelete => 'Delete';

  @override
  String get privacyDeleteConfirmationTitle => 'Final Confirmation';

  @override
  String get privacyDeleteConfirmationPrompt =>
      'Type \"DELETE\" to confirm account deletion:';

  @override
  String get privacyDeletePlaceholder => 'DELETE';

  @override
  String get privacyDeleteAccountBackendRequired =>
      'Account deletion - Backend integration required';

  @override
  String get privacyPleaseTypeDelete => 'Please type DELETE to confirm';

  @override
  String get privacyPrivacyPolicyComingSoon => 'Privacy policy coming soon';

  @override
  String get privacyTermsOfServiceComingSoon => 'Terms of service coming soon';

  @override
  String get browseInstitutionsBrowseTitle => 'Browse Institutions';

  @override
  String get browseInstitutionsSortNameAZ => 'Name (A-Z)';

  @override
  String get browseInstitutionsSortTotalOfferings => 'Total Offerings';

  @override
  String get browseInstitutionsSortAscending => 'Ascending';

  @override
  String get browseInstitutionsSortDescending => 'Descending';

  @override
  String browseInstitutionsRegisteredCount(int count) {
    return '$count registered institution(s)';
  }

  @override
  String get browseInstitutionsNoInstitutionsFound => 'No institutions found';

  @override
  String get browseInstitutionsTryAdjusting =>
      'Try adjusting your search or filters';

  @override
  String get browseInstitutionsNoOfferingsYet => 'No offerings yet';
}
