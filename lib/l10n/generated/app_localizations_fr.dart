// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Flow - Plateforme EdTech Africaine';

  @override
  String get loading => 'Chargement...';

  @override
  String get backToTop => 'Haut de page';

  @override
  String get navHome => 'Accueil';

  @override
  String get navUniversities => 'Universités';

  @override
  String get navAbout => 'À propos';

  @override
  String get navContact => 'Contact';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navSignIn => 'Connexion';

  @override
  String get navGetStarted => 'Commencer';

  @override
  String get loginTitle => 'Flow';

  @override
  String get loginSubtitle => 'Plateforme EdTech Africaine';

  @override
  String get loginEmailLabel => 'Adresse e-mail';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginPasswordEmpty => 'Veuillez entrer votre mot de passe';

  @override
  String get loginPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginOr => 'OU';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String get loginResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get loginAlreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get registerTitle => 'Rejoignez Flow';

  @override
  String get registerSubtitle => 'Commencez votre parcours éducatif';

  @override
  String get registerAppBarTitle => 'Créer un compte';

  @override
  String get registerFullNameLabel => 'Nom complet';

  @override
  String get registerEmailLabel => 'Adresse e-mail';

  @override
  String get registerRoleLabel => 'Je suis...';

  @override
  String get registerPasswordLabel => 'Mot de passe';

  @override
  String get registerConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get registerConfirmPasswordEmpty =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get registerPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get registerButton => 'Créer un compte';

  @override
  String get registerLoginInstead => 'Se connecter';

  @override
  String get registerResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get registerLogin => 'Connexion';

  @override
  String get passwordStrengthWeak => 'Faible';

  @override
  String get passwordStrengthFair => 'Moyen';

  @override
  String get passwordStrengthGood => 'Bon';

  @override
  String get passwordStrengthStrong => 'Fort';

  @override
  String get passwordReq8Chars => '8+ caractères';

  @override
  String get passwordReqUppercase => 'Majuscule';

  @override
  String get passwordReqLowercase => 'Minuscule';

  @override
  String get passwordReqNumber => 'Chiffre';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordDescription =>
      'Entrez votre adresse e-mail et nous vous enverrons les instructions pour réinitialiser votre mot de passe.';

  @override
  String get forgotPasswordEmailLabel => 'Adresse e-mail';

  @override
  String get forgotPasswordEmailHint => 'Entrez votre e-mail';

  @override
  String get forgotPasswordSendButton => 'Envoyer le lien';

  @override
  String get forgotPasswordBackToLogin => 'Retour à la connexion';

  @override
  String get forgotPasswordCheckEmail => 'Vérifiez votre e-mail';

  @override
  String get forgotPasswordSentTo =>
      'Nous avons envoyé les instructions de réinitialisation à :';

  @override
  String get forgotPasswordDidntReceive => 'Vous n\'avez pas reçu l\'e-mail ?';

  @override
  String get forgotPasswordCheckSpam =>
      'Vérifiez votre dossier spam/courrier indésirable';

  @override
  String get forgotPasswordCheckCorrect =>
      'Assurez-vous que l\'adresse e-mail est correcte';

  @override
  String get forgotPasswordWait =>
      'Attendez quelques minutes pour recevoir l\'e-mail';

  @override
  String get forgotPasswordResend => 'Renvoyer l\'e-mail';

  @override
  String get emailVerifyTitle => 'Vérifiez votre e-mail';

  @override
  String get emailVerifyAppBarTitle => 'Vérification de l\'e-mail';

  @override
  String get emailVerifySentTo =>
      'Nous avons envoyé un lien de vérification à :';

  @override
  String get emailVerifyNextSteps => 'Étapes suivantes';

  @override
  String get emailVerifyStep1 => 'Vérifiez votre boîte de réception';

  @override
  String get emailVerifyStep2 => 'Cliquez sur le lien de vérification';

  @override
  String get emailVerifyStep3 => 'Revenez ici pour continuer';

  @override
  String get emailVerifyCheckButton => 'J\'ai vérifié mon e-mail';

  @override
  String get emailVerifyChecking => 'Vérification...';

  @override
  String get emailVerifyResend => 'Renvoyer l\'e-mail';

  @override
  String emailVerifyResendIn(int seconds) {
    return 'Renvoyer dans ${seconds}s';
  }

  @override
  String get emailVerifyNotYet =>
      'E-mail pas encore vérifié. Veuillez vérifier votre boîte de réception.';

  @override
  String emailVerifyCheckError(String error) {
    return 'Erreur lors de la vérification : $error';
  }

  @override
  String get emailVerifySent =>
      'E-mail de vérification envoyé ! Vérifiez votre boîte de réception.';

  @override
  String emailVerifySendFailed(String error) {
    return 'Échec de l\'envoi : $error';
  }

  @override
  String get emailVerifySuccess => 'E-mail vérifié !';

  @override
  String get emailVerifySuccessMessage =>
      'Votre e-mail a été vérifié avec succès.';

  @override
  String get emailVerifyDidntReceive => 'Vous n\'avez pas reçu l\'e-mail ?';

  @override
  String get emailVerifySpamTip =>
      'Vérifiez votre dossier spam/courrier indésirable';

  @override
  String get emailVerifyCorrectTip =>
      'Assurez-vous que l\'adresse e-mail est correcte';

  @override
  String get emailVerifyWaitTip => 'Attendez quelques minutes et réessayez';

  @override
  String get emailVerifyAutoCheck =>
      'Vérification automatique toutes les 5 secondes';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Flow';

  @override
  String get onboardingWelcomeDesc =>
      'Votre plateforme complète pour les opportunités éducatives en Afrique';

  @override
  String get onboardingCoursesTitle => 'Découvrez les cours';

  @override
  String get onboardingCoursesDesc =>
      'Parcourez et inscrivez-vous aux cours des meilleures institutions du continent';

  @override
  String get onboardingProgressTitle => 'Suivez votre progression';

  @override
  String get onboardingProgressDesc =>
      'Suivez votre parcours académique avec des analyses et des statistiques détaillées';

  @override
  String get onboardingConnectTitle => 'Connectez et collaborez';

  @override
  String get onboardingConnectDesc =>
      'Échangez avec des conseillers, recevez des recommandations et gérez vos candidatures';

  @override
  String get onboardingBack => 'Retour';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingFeatureCourseSelection => 'Large sélection de cours';

  @override
  String get onboardingFeatureFilter => 'Filtrer par catégorie et niveau';

  @override
  String get onboardingFeatureDetails =>
      'Informations détaillées sur les cours';

  @override
  String get onboardingFeatureProgress => 'Suivi de progression en temps réel';

  @override
  String get onboardingFeatureAnalytics => 'Analyses de performance';

  @override
  String get onboardingFeatureAchievements => 'Système de récompenses';

  @override
  String get heroTrustBadge => 'Approuvé par plus de 200 universités';

  @override
  String get heroHeadline => 'Trouvez l\'université\nidéale pour vous';

  @override
  String get heroSubheadline =>
      'Découvrez, comparez et postulez à plus de 18 000 universités\navec des recommandations personnalisées propulsées par l\'IA';

  @override
  String get heroStartFreeTrial => 'Essai gratuit';

  @override
  String get heroTakeATour => 'Visite guidée';

  @override
  String get heroStatActiveUsers => 'Utilisateurs actifs';

  @override
  String get heroStatUniversities => 'Universités';

  @override
  String get heroStatCountries => 'Pays';

  @override
  String get whyChooseTitle => 'Pourquoi choisir Flow ?';

  @override
  String get whyChooseSubtitle => 'Conçu pour l\'Afrique, pensé pour tous';

  @override
  String get valueOfflineTitle => 'Hors-ligne d\'abord';

  @override
  String get valueOfflineDesc =>
      'Accédez à votre contenu à tout moment, partout—même sans connexion internet';

  @override
  String get valueMobileMoneyTitle => 'Paiement mobile';

  @override
  String get valueMobileMoneyDesc =>
      'Payez avec M-Pesa, MTN Money et d\'autres méthodes de paiement locales';

  @override
  String get valueMultiLangTitle => 'Multilingue';

  @override
  String get valueMultiLangDesc =>
      'Plateforme disponible en plusieurs langues africaines pour votre confort';

  @override
  String get socialProofTitle =>
      'Approuvé par les institutions leaders en Afrique';

  @override
  String get testimonialsTitle => 'Ce que disent nos utilisateurs';

  @override
  String get testimonialsSubtitle =>
      'Témoignages d\'étudiants, d\'institutions et d\'éducateurs';

  @override
  String get quizBadge => 'Trouvez votre voie';

  @override
  String get quizTitle => 'Vous ne savez pas\npar où commencer ?';

  @override
  String get quizDescription =>
      'Répondez à notre quiz rapide pour découvrir les universités et programmes qui correspondent à vos intérêts, objectifs et profil académique.';

  @override
  String get quizDuration => '2 minutes';

  @override
  String get quizAIPowered => 'Propulsé par l\'IA';

  @override
  String get featuresTitle => 'Tout ce dont vous avez besoin';

  @override
  String get featuresSubtitle =>
      'Un écosystème éducatif complet conçu pour l\'Afrique moderne';

  @override
  String get featureLearningTitle => 'Apprentissage complet';

  @override
  String get featureLearningDesc =>
      'Accédez aux cours, suivez votre progression et gérez vos candidatures en un seul endroit';

  @override
  String get featureCollabTitle => 'Conçu pour la collaboration';

  @override
  String get featureCollabDesc =>
      'Connectez étudiants, parents, conseillers et institutions en toute simplicité';

  @override
  String get featureSecurityTitle => 'Sécurité de niveau entreprise';

  @override
  String get featureSecurityDesc =>
      'Chiffrement de niveau bancaire et protection des données conforme au RGPD';

  @override
  String get featuresWorksOnAllDevices => 'Fonctionne sur tous les appareils';

  @override
  String get builtForEveryoneTitle => 'Conçu pour tous';

  @override
  String get builtForEveryoneSubtitle =>
      'Choisissez votre rôle et commencez avec une expérience personnalisée';

  @override
  String get roleStudents => 'Étudiants';

  @override
  String get roleStudentsDesc =>
      'Suivez vos cours, gérez vos candidatures et atteignez vos objectifs éducatifs';

  @override
  String get roleInstitutions => 'Institutions';

  @override
  String get roleInstitutionsDesc =>
      'Simplifiez les admissions, gérez les programmes et engagez les étudiants';

  @override
  String get roleParents => 'Parents';

  @override
  String get roleParentsDesc =>
      'Suivez la progression, communiquez avec les enseignants et soutenez vos enfants';

  @override
  String get roleCounselors => 'Conseillers';

  @override
  String get roleCounselorsDesc =>
      'Guidez les étudiants, gérez les sessions et suivez les résultats';

  @override
  String getStartedAs(String role) {
    return 'Commencer en tant que $role';
  }

  @override
  String get ctaTitle => 'Prêt à transformer\nvotre parcours éducatif ?';

  @override
  String get ctaSubtitle =>
      'Rejoignez plus de 50 000 étudiants, institutions et éducateurs qui font confiance à Flow';

  @override
  String get ctaButton => 'Commencez votre essai gratuit';

  @override
  String get ctaNoCreditCard => 'Aucune carte de crédit requise';

  @override
  String get cta14DayTrial => 'Essai gratuit de 14 jours';

  @override
  String get footerTagline =>
      'La plateforme EdTech leader en Afrique\nDonner accès à l\'éducation sans frontières.';

  @override
  String get footerProducts => 'Produits';

  @override
  String get footerStudentPortal => 'Portail étudiant';

  @override
  String get footerInstitutionDashboard => 'Tableau de bord institution';

  @override
  String get footerParentApp => 'Application parents';

  @override
  String get footerCounselorTools => 'Outils conseillers';

  @override
  String get footerMobileApps => 'Applications mobiles';

  @override
  String get footerCompany => 'Entreprise';

  @override
  String get footerAboutUs => 'À propos';

  @override
  String get footerCareers => 'Carrières';

  @override
  String get footerPressKit => 'Kit presse';

  @override
  String get footerPartners => 'Partenaires';

  @override
  String get footerContact => 'Contact';

  @override
  String get footerResources => 'Ressources';

  @override
  String get footerHelpCenter => 'Centre d\'aide';

  @override
  String get footerDocumentation => 'Documentation';

  @override
  String get footerApiReference => 'Référence API';

  @override
  String get footerCommunity => 'Communauté';

  @override
  String get footerBlog => 'Blog';

  @override
  String get footerLegal => 'Mentions légales';

  @override
  String get footerPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get footerTermsOfService => 'Conditions d\'utilisation';

  @override
  String get footerCookiePolicy => 'Politique des cookies';

  @override
  String get footerDataProtection => 'Protection des données';

  @override
  String get footerCompliance => 'Conformité';

  @override
  String get footerCopyright => '© 2025 Flow EdTech. Tous droits réservés.';

  @override
  String get footerSoc2 => 'Certifié SOC 2';

  @override
  String get footerIso27001 => 'ISO 27001';

  @override
  String get footerGdpr => 'Conforme au RGPD';

  @override
  String get searchHint =>
      'Rechercher des universités par nom, pays ou programme...';

  @override
  String get searchUniversitiesCount => 'Rechercher parmi 18 000+ universités';

  @override
  String get searchPlaceholder => 'Rechercher des universités...';

  @override
  String get searchBadge => '18K+';

  @override
  String get filterEngineering => 'Ingénierie';

  @override
  String get filterBusiness => 'Commerce';

  @override
  String get filterMedicine => 'Médecine';

  @override
  String get filterArts => 'Arts';

  @override
  String get filterScience => 'Sciences';

  @override
  String get quizFindYourPath => 'Trouvez votre voie';

  @override
  String get quizQuickPreview => 'Aperçu rapide';

  @override
  String get quizFieldQuestion => 'Quel domaine vous intéresse le plus ?';

  @override
  String get quizFieldTechEngineering => 'Technologie et ingénierie';

  @override
  String get quizFieldBusinessFinance => 'Commerce et finance';

  @override
  String get quizFieldHealthcareMedicine => 'Santé et médecine';

  @override
  String get quizFieldArtsHumanities => 'Arts et sciences humaines';

  @override
  String get quizLocationQuestion => 'Où préféreriez-vous étudier ?';

  @override
  String get quizLocationWestAfrica => 'Afrique de l\'Ouest';

  @override
  String get quizLocationEastAfrica => 'Afrique de l\'Est';

  @override
  String get quizLocationSouthernAfrica => 'Afrique australe';

  @override
  String get quizLocationAnywhereAfrica => 'N\'importe où en Afrique';

  @override
  String get quizGetRecommendations => 'Obtenez vos recommandations';

  @override
  String get quizTakeTheQuiz => 'Répondre au quiz';

  @override
  String get tourTitle => 'Découvrez Flow en action';

  @override
  String get tourSubtitle => 'Une visite guidée de la plateforme';

  @override
  String get tourClose => 'Fermer';

  @override
  String get tourBack => 'Retour';

  @override
  String get tourNext => 'Suivant';

  @override
  String get tourGetStarted => 'Commencer';

  @override
  String get tourSlide1Title => 'Découvrez les universités';

  @override
  String get tourSlide1Desc =>
      'Recherchez et comparez les universités en Afrique avec des profils détaillés, des classements et des informations sur les programmes.';

  @override
  String get tourSlide1H1 => 'Parcourez plus de 500 institutions';

  @override
  String get tourSlide1H2 =>
      'Filtrez par pays, programme et frais de scolarité';

  @override
  String get tourSlide1H3 => 'Consultez les profils détaillés des universités';

  @override
  String get tourSlide2Title => 'Trouvez votre voie';

  @override
  String get tourSlide2Desc =>
      'Répondez à notre quiz guidé pour obtenir des recommandations personnalisées d\'universités et de programmes adaptés à vos objectifs.';

  @override
  String get tourSlide2H1 => 'Recommandations propulsées par l\'IA';

  @override
  String get tourSlide2H2 => 'Correspondance de personnalité et d\'intérêts';

  @override
  String get tourSlide2H3 => 'Suggestions de programmes sur mesure';

  @override
  String get tourSlide3Title => 'Tableaux de bord par rôle';

  @override
  String get tourSlide3Desc =>
      'Des tableaux de bord dédiés pour les étudiants, parents, conseillers et institutions — chacun avec les outils nécessaires.';

  @override
  String get tourSlide3H1 => 'Suivez les candidatures et la progression';

  @override
  String get tourSlide3H2 => 'Surveillez les performances des étudiants';

  @override
  String get tourSlide3H3 => 'Gérez les données institutionnelles';

  @override
  String get tourSlide4Title => 'Assistant d\'étude IA';

  @override
  String get tourSlide4Desc =>
      'Obtenez une aide instantanée pour les questions d\'admission, les conseils de candidature et la planification académique grâce à notre chatbot IA.';

  @override
  String get tourSlide4H1 => 'Disponible 24h/24, 7j/7';

  @override
  String get tourSlide4H2 => 'Réponses contextuelles';

  @override
  String get tourSlide4H3 => 'Rappels de dates limites de candidature';

  @override
  String get tourSlide5Title => 'Écosystème connecté';

  @override
  String get tourSlide5Desc =>
      'Étudiants, parents, conseillers et institutions collaborent sans effort sur une seule plateforme.';

  @override
  String get tourSlide5H1 => 'Notifications en temps réel';

  @override
  String get tourSlide5H2 => 'Suivi de progression partagé';

  @override
  String get tourSlide5H3 => 'Messagerie sécurisée';

  @override
  String get uniSearchTitle => 'Rechercher des universités';

  @override
  String get uniSearchClearAll => 'Tout effacer';

  @override
  String get uniSearchHint => 'Rechercher par nom d\'université...';

  @override
  String get uniSearchFilters => 'Filtres';

  @override
  String uniSearchResultCount(int count) {
    return '$count universités trouvées';
  }

  @override
  String get uniSearchNoMatchFilters =>
      'Aucune université ne correspond à vos filtres';

  @override
  String get uniSearchNoResults => 'Aucune université trouvée';

  @override
  String get uniSearchAdjustFilters =>
      'Essayez d\'ajuster vos filtres pour voir plus de résultats';

  @override
  String get uniSearchTrySearching =>
      'Essayez de rechercher un nom d\'université';

  @override
  String get uniSearchError => 'Une erreur est survenue';

  @override
  String get uniSearchRetry => 'Réessayer';

  @override
  String get uniSearchFilterReset => 'Réinitialiser';

  @override
  String get uniSearchFilterCountry => 'Pays';

  @override
  String get uniSearchFilterSelectCountry => 'Sélectionner un pays';

  @override
  String get uniSearchFilterAllCountries => 'Tous les pays';

  @override
  String get uniSearchFilterUniType => 'Type d\'université';

  @override
  String get uniSearchFilterSelectType => 'Sélectionner un type';

  @override
  String get uniSearchFilterAllTypes => 'Tous les types';

  @override
  String get uniSearchFilterLocationType => 'Type de localisation';

  @override
  String get uniSearchFilterSelectLocation =>
      'Sélectionner un type de localisation';

  @override
  String get uniSearchFilterAllLocations => 'Toutes les localisations';

  @override
  String get uniSearchFilterMaxTuition => 'Frais de scolarité maximum (USD/an)';

  @override
  String get uniSearchFilterNoLimit => 'Sans limite';

  @override
  String get uniSearchFilterAny => 'Tous';

  @override
  String get uniSearchFilterAcceptanceRate => 'Taux d\'admission';

  @override
  String get uniSearchFilterAnyRate => 'Tous les taux';

  @override
  String get uniSearchFilterApply => 'Appliquer les filtres';

  @override
  String uniSearchAcceptance(String rate) {
    return '$rate% d\'admission';
  }

  @override
  String uniSearchStudents(String count) {
    return '$count étudiants';
  }

  @override
  String get uniDetailNotFound => 'Cette université n\'a pas pu être trouvée.';

  @override
  String uniDetailError(String error) {
    return 'Erreur lors du chargement de l\'université : $error';
  }

  @override
  String get uniDetailVisitWebsite => 'Visiter le site web';

  @override
  String get uniDetailLocation => 'Localisation';

  @override
  String get uniDetailAddress => 'Adresse';

  @override
  String get uniDetailSetting => 'Environnement';

  @override
  String get uniDetailKeyStats => 'Statistiques clés';

  @override
  String get uniDetailTotalStudents => 'Nombre total d\'étudiants';

  @override
  String get uniDetailAcceptanceRate => 'Taux d\'admission';

  @override
  String get uniDetailGradRate => 'Taux de diplôme en 4 ans';

  @override
  String get uniDetailAvgGPA => 'Moyenne générale (GPA)';

  @override
  String get uniDetailTuitionCosts => 'Frais de scolarité';

  @override
  String get uniDetailTuitionOutState => 'Frais (hors état)';

  @override
  String get uniDetailTotalCost => 'Coût total';

  @override
  String get uniDetailMedianEarnings => 'Revenus médians (10 ans)';

  @override
  String get uniDetailTestScores => 'Scores aux tests (25e-75e percentile)';

  @override
  String get uniDetailSATMath => 'SAT Math';

  @override
  String get uniDetailSATEBRW => 'SAT EBRW';

  @override
  String get uniDetailACTComposite => 'ACT Composite';

  @override
  String get uniDetailRankings => 'Classements';

  @override
  String get uniDetailGlobalRank => 'Classement mondial';

  @override
  String get uniDetailNationalRank => 'Classement national';

  @override
  String get uniDetailAbout => 'À propos';

  @override
  String get uniDetailType => 'Type';

  @override
  String get uniDetailWebsite => 'Site web';

  @override
  String get uniDetailDescription => 'Description';

  @override
  String get dashCommonBack => 'Retour';

  @override
  String get dashCommonHome => 'Accueil';

  @override
  String get dashCommonProfile => 'Profil';

  @override
  String get dashCommonSettings => 'Paramètres';

  @override
  String get dashCommonOverview => 'Aperçu';

  @override
  String get dashCommonRetry => 'Réessayer';

  @override
  String get dashCommonViewAll => 'Tout voir';

  @override
  String get dashCommonClose => 'Fermer';

  @override
  String get dashCommonCancel => 'Annuler';

  @override
  String get dashCommonPending => 'En attente';

  @override
  String get dashCommonLoadingOverview => 'Chargement de l\'aperçu...';

  @override
  String get dashCommonNotifications => 'Notifications';

  @override
  String get dashCommonMessages => 'Messages';

  @override
  String get dashCommonQuickActions => 'Actions rapides';

  @override
  String get dashCommonWelcomeBack => 'Bon retour !';

  @override
  String get dashCommonRecentActivity => 'Activité récente';

  @override
  String get dashCommonNoRecentActivity => 'Aucune activité récente';

  @override
  String get dashCommonSwitchRole => 'Changer de rôle';

  @override
  String get dashCommonLogout => 'Déconnexion';

  @override
  String get dashCommonRecommendedForYou => 'Recommandé pour vous';

  @override
  String get dashCommonApplications => 'Candidatures';

  @override
  String get dashCommonAccepted => 'Accepté';

  @override
  String get dashCommonRejected => 'Refusé';

  @override
  String get dashCommonUnderReview => 'En cours d\'examen';

  @override
  String get dashCommonRequests => 'Demandes';

  @override
  String get dashCommonUpcoming => 'À venir';

  @override
  String get dashCommonMeetings => 'Réunions';

  @override
  String get dashCommonSubmitted => 'Soumis';

  @override
  String get dashCommonDraft => 'Brouillon';

  @override
  String dashCommonDays(int count) {
    return '$count jours';
  }

  @override
  String dashCommonMin(int count) {
    return '$count min';
  }

  @override
  String get dashCommonNoDataAvailable => 'Aucune donnée disponible';

  @override
  String get dashStudentTitle => 'Tableau de bord étudiant';

  @override
  String get dashStudentMyApplications => 'Mes candidatures';

  @override
  String get dashStudentMyCourses => 'Mes cours';

  @override
  String get dashStudentProgress => 'Progression';

  @override
  String get dashStudentEditProfile => 'Modifier le profil';

  @override
  String get dashStudentCourses => 'Cours';

  @override
  String get dashStudentContinueJourney =>
      'Continuez votre parcours d\'apprentissage';

  @override
  String get dashStudentSuccessRate => 'Taux de réussite des candidatures';

  @override
  String get dashStudentLetters => 'Lettres';

  @override
  String get dashStudentParentLink => 'Lien parent';

  @override
  String get dashStudentCounseling => 'Conseil';

  @override
  String get dashStudentSchedule => 'Emploi du temps';

  @override
  String get dashStudentResources => 'Ressources';

  @override
  String get dashStudentHelp => 'Aide';

  @override
  String get dashStudentTotalApplications => 'Total des candidatures';

  @override
  String get dashStudentInReview => 'En examen';

  @override
  String get dashStudentFindYourPath => 'Trouvez votre voie';

  @override
  String get dashStudentNew => 'NOUVEAU';

  @override
  String get dashStudentFindYourPathDesc =>
      'Découvrez les universités qui correspondent à votre profil, vos objectifs et vos préférences grâce aux recommandations propulsées par l\'IA';

  @override
  String get dashStudentStartJourney => 'Commencez votre parcours';

  @override
  String get dashStudentFailedActivities => 'Échec du chargement des activités';

  @override
  String get dashStudentActivityHistory => 'Historique des activités';

  @override
  String get dashStudentActivityHistoryMsg =>
      'Une vue complète de l\'historique des activités avec filtres et recherche sera bientôt disponible.';

  @override
  String get dashStudentAchievement => 'Réussite';

  @override
  String get dashStudentPaymentHistory => 'Historique des paiements';

  @override
  String get dashStudentPaymentHistoryMsg =>
      'Consultez l\'historique détaillé des paiements et des transactions.';

  @override
  String get dashStudentFailedRecommendations =>
      'Échec du chargement des recommandations';

  @override
  String get dashParentTitle => 'Tableau de bord parent';

  @override
  String get dashParentMyChildren => 'Mes enfants';

  @override
  String get dashParentAlerts => 'Alertes';

  @override
  String get dashParentChildren => 'Enfants';

  @override
  String get dashParentAvgGrade => 'Moy. notes';

  @override
  String get dashParentUpcomingMeetings => 'Réunions à venir';

  @override
  String get dashParentNoUpcomingMeetings => 'Aucune réunion à venir';

  @override
  String get dashParentScheduleMeetingsHint =>
      'Planifiez des réunions avec les enseignants ou conseillers';

  @override
  String get dashParentScheduleMeeting => 'Planifier une réunion';

  @override
  String dashParentViewMoreMeetings(int count) {
    return 'Voir $count réunions de plus';
  }

  @override
  String get dashParentChildrenOverview => 'Aperçu des enfants';

  @override
  String get dashParentNoChildren => 'Aucun enfant ajouté';

  @override
  String get dashParentNoChildrenHint =>
      'Ajoutez vos enfants pour suivre leur progression';

  @override
  String dashParentCourseCount(int count) {
    return '$count cours';
  }

  @override
  String dashParentAppCount(int count) {
    return '$count cand.';
  }

  @override
  String get dashParentViewAllReports => 'Voir tous les rapports';

  @override
  String get dashParentAcademicReports => 'Rapports de performance académique';

  @override
  String get dashParentWithTeachersOrCounselors =>
      'Avec enseignants ou conseillers';

  @override
  String get dashParentNotificationSettings => 'Paramètres de notification';

  @override
  String get dashParentManageAlerts => 'Gérer les alertes et mises à jour';

  @override
  String get dashParentMeetWith => 'Avec qui souhaitez-vous vous réunir ?';

  @override
  String get dashParentTeacher => 'Enseignant';

  @override
  String get dashParentTeacherConference =>
      'Planifier une réunion parents-enseignant';

  @override
  String get dashParentCounselor => 'Conseiller';

  @override
  String get dashParentCounselorMeeting =>
      'Rencontrer un conseiller d\'orientation';

  @override
  String get dashParentStatusPending => 'EN ATTENTE';

  @override
  String get dashParentStatusApproved => 'APPROUVÉ';

  @override
  String get dashParentStatusDeclined => 'REFUSÉ';

  @override
  String get dashParentStatusCancelled => 'ANNULÉ';

  @override
  String get dashParentStatusCompleted => 'TERMINÉ';

  @override
  String get dashCounselorTitle => 'Tableau de bord conseiller';

  @override
  String get dashCounselorMyStudents => 'Mes étudiants';

  @override
  String get dashCounselorSessions => 'Sessions';

  @override
  String get dashCounselorStudents => 'Étudiants';

  @override
  String get dashCounselorToday => 'Aujourd\'hui';

  @override
  String get dashCounselorMeetingRequests => 'Demandes de réunion';

  @override
  String get dashCounselorManageAvailability => 'Gérer les disponibilités';

  @override
  String get dashCounselorSetMeetingHours => 'Définissez vos heures de réunion';

  @override
  String dashCounselorPendingApproval(int count) {
    return '$count en attente d\'approbation';
  }

  @override
  String dashCounselorViewMoreRequests(int count) {
    return 'Voir $count demandes de plus';
  }

  @override
  String get dashCounselorTodaySessions => 'Sessions du jour';

  @override
  String get dashCounselorNoStudents => 'Aucun étudiant assigné';

  @override
  String get dashCounselorNoStudentsHint =>
      'Vos étudiants apparaîtront ici une fois assignés';

  @override
  String get dashCounselorPendingRecommendations =>
      'Recommandations en attente';

  @override
  String dashCounselorDraftRecommendations(int count) {
    return 'Vous avez $count brouillons de recommandations';
  }

  @override
  String get dashCounselorSessionIndividual => 'Individuel';

  @override
  String get dashCounselorSessionGroup => 'Groupe';

  @override
  String get dashCounselorSessionCareer => 'Carrière';

  @override
  String get dashCounselorSessionAcademic => 'Académique';

  @override
  String get dashCounselorSessionPersonal => 'Personnel';

  @override
  String get dashCounselorStatusPending => 'EN ATTENTE';

  @override
  String get dashAdminNotAuthenticated => 'Non authentifié';

  @override
  String get dashAdminDashboard => 'Tableau de bord';

  @override
  String dashAdminWelcomeBack(String name) {
    return 'Bon retour, $name';
  }

  @override
  String get dashAdminQuickAction => 'Action rapide';

  @override
  String get dashAdminAddUser => 'Ajouter un utilisateur';

  @override
  String get dashAdminCreateAnnouncement => 'Créer une annonce';

  @override
  String get dashAdminGenerateReport => 'Générer un rapport';

  @override
  String get dashAdminBulkActions => 'Actions groupées';

  @override
  String get dashAdminTotalUsers => 'Total utilisateurs';

  @override
  String get dashAdminStudents => 'Étudiants';

  @override
  String get dashAdminInstitutions => 'Institutions';

  @override
  String get dashAdminRecommenders => 'Recommandeurs';

  @override
  String dashAdminCountStudents(int count) {
    return '$count étudiants';
  }

  @override
  String dashAdminCountParents(int count) {
    return '$count parents';
  }

  @override
  String dashAdminCountCounselors(int count) {
    return '$count conseillers';
  }

  @override
  String dashAdminCountAdmins(int count) {
    return '$count admins';
  }

  @override
  String get dashAdminJustNow => 'À l\'instant';

  @override
  String dashAdminMinutesAgo(int count) {
    return 'il y a $count min';
  }

  @override
  String dashAdminHoursAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String dashAdminDaysAgo(int count) {
    return 'il y a $count j';
  }

  @override
  String get dashAdminRefresh => 'Actualiser';

  @override
  String get dashAdminQuickStats => 'Statistiques rapides';

  @override
  String get dashAdminActive30d => 'Actifs (30j)';

  @override
  String get dashAdminNewUsers7d => 'Nouveaux (7j)';

  @override
  String get dashAdminApplications7d => 'Candidatures (7j)';

  @override
  String get dashAdminUserGrowth => 'Croissance des utilisateurs';

  @override
  String get dashAdminUserGrowthDesc =>
      'Nouvelles inscriptions au cours des 6 derniers mois';

  @override
  String get dashAdminUserDistribution => 'Répartition des utilisateurs';

  @override
  String get dashAdminByUserType => 'Par type d\'utilisateur';

  @override
  String get dashInstTitle => 'Tableau de bord institution';

  @override
  String get dashInstDebugPanel => 'Panneau de débogage';

  @override
  String get dashInstApplicants => 'Candidats';

  @override
  String get dashInstPrograms => 'Programmes';

  @override
  String get dashInstCourses => 'Cours';

  @override
  String get dashInstCounselors => 'Conseillers';

  @override
  String get dashInstNewProgram => 'Nouveau programme';

  @override
  String get dashInstNewCourse => 'Nouveau cours';

  @override
  String get dashInstTotalApplicants => 'Total des candidats';

  @override
  String get dashInstPendingReview => 'En attente d\'examen';

  @override
  String get dashInstActivePrograms => 'Programmes actifs';

  @override
  String get dashInstTotalStudents => 'Total des étudiants';

  @override
  String get dashInstReviewPending => 'Examiner les candidatures en attente';

  @override
  String dashInstApplicationsWaiting(int count) {
    return '$count candidatures en attente';
  }

  @override
  String dashInstApplicationsInProgress(int count) {
    return '$count candidatures en cours';
  }

  @override
  String get dashInstAcceptedApplicants => 'Candidats acceptés';

  @override
  String dashInstApplicationsApproved(int count) {
    return '$count candidatures approuvées';
  }

  @override
  String get dashInstCreateNewProgram => 'Créer un nouveau programme';

  @override
  String get dashInstAddProgramHint => 'Ajouter un nouveau cours ou programme';

  @override
  String get dashInstApplicationSummary => 'Résumé des candidatures';

  @override
  String get dashInstProgramsOverview => 'Aperçu des programmes';

  @override
  String get dashInstTotalPrograms => 'Total des programmes';

  @override
  String get dashInstInactivePrograms => 'Programmes inactifs';

  @override
  String get dashInstTotalEnrollments => 'Total des inscriptions';

  @override
  String get dashInstApplicationFunnel => 'Entonnoir de candidatures';

  @override
  String dashInstConversionRate(String rate) {
    return 'Taux de conversion global : $rate%';
  }

  @override
  String get dashInstApplicantDemographics => 'Démographie des candidats';

  @override
  String dashInstTotalApplicantsCount(int count) {
    return 'Total des candidats : $count';
  }

  @override
  String get dashInstByLocation => 'Par localisation';

  @override
  String get dashInstByAgeGroup => 'Par tranche d\'âge';

  @override
  String get dashInstByAcademicBackground => 'Par parcours académique';

  @override
  String get dashInstProgramPopularity => 'Popularité des programmes';

  @override
  String get dashInstTopPrograms => 'Programmes les plus demandés';

  @override
  String dashInstAppsCount(int count) {
    return '$count cand.';
  }

  @override
  String get dashInstProcessingTime => 'Temps de traitement des candidatures';

  @override
  String get dashInstAverageTime => 'Temps moyen';

  @override
  String dashInstDaysValue(String count) {
    return '$count jours';
  }

  @override
  String get dashRecTitle => 'Tableau de bord recommandeur';

  @override
  String get dashRecRecommendations => 'Recommandations';

  @override
  String get dashRecTotal => 'Total';

  @override
  String get dashRecUrgent => 'Urgent';

  @override
  String get dashRecUrgentRecommendations => 'Recommandations urgentes';

  @override
  String dashRecPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Vous avez $count recommandation$_temp0 en attente';
  }

  @override
  String get dashRecUnknownStudent => 'Étudiant inconnu';

  @override
  String get dashRecInstitutionNotSpecified => 'Institution non spécifiée';

  @override
  String get dashRecRecentRequests => 'Demandes récentes';

  @override
  String get dashRecNoRequests => 'Aucune demande de recommandation';

  @override
  String get dashRecNoRequestsHint =>
      'Les demandes apparaîtront ici quand les étudiants demanderont des recommandations';

  @override
  String get dashRecQuickTips => 'Conseils rapides';

  @override
  String get dashRecTip1 =>
      'Rédigez des exemples précis des réalisations de l\'étudiant';

  @override
  String get dashRecTip2 =>
      'Soumettez les recommandations au moins 2 semaines avant la date limite';

  @override
  String get dashRecTip3 =>
      'Personnalisez chaque recommandation pour l\'institution';
}
