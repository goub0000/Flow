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
  String get featuresTitle => 'Everything you need';

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
}
