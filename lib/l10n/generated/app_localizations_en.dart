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
}
