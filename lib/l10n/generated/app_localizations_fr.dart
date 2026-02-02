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
  String get searchSuggestionGhana => 'Université du Ghana';

  @override
  String get searchSuggestionGhanaLocation => 'Accra, Ghana';

  @override
  String get searchSuggestionCapeTown => 'Université du Cap';

  @override
  String get searchSuggestionCapeTownLocation => 'Le Cap, Afrique du Sud';

  @override
  String get searchSuggestionAshesi => 'Université Ashesi';

  @override
  String get searchSuggestionAshesiLocation => 'Berekuso, Ghana';

  @override
  String get searchSuggestionPublicUniversity => 'Université publique';

  @override
  String get searchSuggestionPrivateUniversity => 'Université privée';

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

  @override
  String get chatViewDetails => 'Voir les détails';

  @override
  String get chatApply => 'Postuler';

  @override
  String get chatLearnMore => 'En savoir plus';

  @override
  String get chatEnroll => 'S\'inscrire';

  @override
  String get chatContinue => 'Continuer';

  @override
  String chatRankLabel(int rank) {
    return 'Classement : #$rank';
  }

  @override
  String chatAcceptanceLabel(String rate) {
    return 'Acceptation : $rate%';
  }

  @override
  String chatDeadlineLabel(String deadline) {
    return 'Date limite : $deadline';
  }

  @override
  String get chatRecommendedUniversities => 'Universités recommandées';

  @override
  String get chatRecommendedCourses => 'Cours recommandés';

  @override
  String get chatDetails => 'Détails';

  @override
  String chatAcceptanceRateLabel(String rate) {
    return '$rate% d\'acceptation';
  }

  @override
  String get chatHiNeedHelp => 'Bonjour ! Besoin d\'aide ? 👋';

  @override
  String get chatTalkToHuman => 'Parler à un humain';

  @override
  String get chatConnectWithAgent =>
      'Souhaitez-vous être mis en relation avec un agent de support ?';

  @override
  String get chatAgentWillJoin =>
      'Un membre de notre équipe rejoindra cette conversation pour vous aider.';

  @override
  String get chatCancel => 'Annuler';

  @override
  String get chatConnect => 'Se connecter';

  @override
  String get chatYourAccount => 'Votre compte';

  @override
  String get chatSignIn => 'Se connecter';

  @override
  String get chatSignedInAs => 'Connecté en tant que :';

  @override
  String get chatDefaultUserName => 'Utilisateur';

  @override
  String get chatConversationsSynced =>
      'Vos conversations sont synchronisées avec votre compte.';

  @override
  String get chatSignInDescription =>
      'Connectez-vous pour synchroniser vos conversations sur tous vos appareils et obtenir une assistance personnalisée.';

  @override
  String get chatHistorySaved =>
      'Votre historique de conversation sera sauvegardé dans votre compte.';

  @override
  String get chatClose => 'Fermer';

  @override
  String get chatViewProfile => 'Voir le profil';

  @override
  String get chatHumanSupport => 'Support humain';

  @override
  String get chatFlowAssistant => 'Assistant Flow';

  @override
  String get chatWaitingForAgent => 'En attente d\'un agent...';

  @override
  String get chatOnline => 'En ligne';

  @override
  String get chatStartConversation => 'Démarrer une conversation';

  @override
  String get chatUserRequestedHumanSupport =>
      'L\'utilisateur a demandé un support humain';

  @override
  String get chatRankStat => 'Classement';

  @override
  String get chatAcceptStat => 'Acceptation';

  @override
  String get chatMatchStat => 'Compatibilité';

  @override
  String chatLessonsCount(int count) {
    return '$count leçons';
  }

  @override
  String get chatProgress => 'Progression';

  @override
  String get chatToDo => 'À faire :';

  @override
  String get chatFailedToLoadImage => 'Échec du chargement de l\'image';

  @override
  String chatImageCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String get chatTypeYourMessage => 'Tapez votre message...';

  @override
  String get chatSupportAgent => 'Agent de support';

  @override
  String get chatSystem => 'Système';

  @override
  String get chatConfidenceHigh => 'Élevée';

  @override
  String get chatConfidenceMedium => 'Moyenne';

  @override
  String get chatConfidenceLow => 'Faible';

  @override
  String get chatHelpful => 'Utile';

  @override
  String get chatNotHelpful => 'Pas utile';

  @override
  String get chatWasThisHelpful => 'Cela vous a-t-il été utile ?';

  @override
  String get chatRateThisResponse => 'Évaluer cette réponse';

  @override
  String get chatCopied => 'Copié !';

  @override
  String get chatCopy => 'Copier';

  @override
  String get chatViewRecommendations => 'Voir les recommandations';

  @override
  String get chatUpdateProfile => 'Mettre à jour le profil';

  @override
  String get chatMyApplications => 'Mes candidatures';

  @override
  String get chatCompareSchools => 'Comparer les écoles';

  @override
  String get chatFilterResults => 'Filtrer les résultats';

  @override
  String get chatWhyTheseSchools => 'Pourquoi ces écoles ?';

  @override
  String get chatViewDeadlines => 'Voir les dates limites';

  @override
  String get chatEssayTips => 'Conseils pour les essais';

  @override
  String get chatApplicationChecklist => 'Liste de contrôle de candidature';

  @override
  String get chatHelpWithQuestions => 'Aide pour les questions';

  @override
  String get chatCanISkipSections => 'Puis-je sauter des sections ?';

  @override
  String get chatStartApplication => 'Démarrer la candidature';

  @override
  String get chatSaveToFavorites => 'Ajouter aux favoris';

  @override
  String get chatSimilarSchools => 'Écoles similaires';

  @override
  String get chatEssayWritingHelp => 'Aide à la rédaction d\'essais';

  @override
  String get chatSetDeadlineReminder => 'Définir un rappel de date limite';

  @override
  String get chatLetterRequestTips =>
      'Conseils pour les lettres de recommandation';

  @override
  String get chatTranscriptGuide => 'Guide des relevés de notes';

  @override
  String get chatStartQuestionnaire => 'Démarrer le questionnaire';

  @override
  String get chatHowItWorks => 'Comment ça marche';

  @override
  String get chatBrowseUniversities => 'Parcourir les universités';

  @override
  String get chatHowCanYouHelp => 'Comment pouvez-vous m\'aider ?';

  @override
  String get chatGetRecommendations => 'Obtenir des recommandations';

  @override
  String get chatContactSupport => 'Contacter le support';

  @override
  String chatCompleteProfile(int completeness) {
    return 'Compléter le profil ($completeness%)';
  }

  @override
  String get chatWhyCompleteProfile => 'Pourquoi compléter le profil ?';

  @override
  String chatViewSchools(int count) {
    return 'Voir $count écoles';
  }

  @override
  String chatMyFavorites(int count) {
    return 'Mes favoris ($count)';
  }

  @override
  String get chatStartApplying => 'Commencer à postuler';

  @override
  String get fypTitle => 'Trouve ta voie';

  @override
  String get fypHeroTitle => 'Trouvez votre université idéale';

  @override
  String get fypHeroSubtitle =>
      'Obtenez des recommandations universitaires personnalisées basées sur votre profil académique, vos préférences et vos objectifs';

  @override
  String get fypHowItWorks => 'Comment ça marche';

  @override
  String get fypStep1Title => 'Répondez aux questions';

  @override
  String get fypStep1Description =>
      'Parlez-nous de votre profil académique, de votre filière souhaitée et de vos préférences';

  @override
  String get fypStep2Title => 'Obtenez des correspondances';

  @override
  String get fypStep2Description =>
      'Notre algorithme analyse votre profil par rapport à des centaines d\'universités';

  @override
  String get fypStep3Title => 'Consultez les résultats';

  @override
  String get fypStep3Description =>
      'Découvrez vos recommandations personnalisées classées en écoles de sécurité, de correspondance et d\'ambition';

  @override
  String get fypWhatYoullGet => 'Ce que vous obtiendrez';

  @override
  String get fypFeatureMatchScore => 'Score de correspondance';

  @override
  String get fypFeatureSafetyMatchReach => 'Sécurité/Correspondance/Ambition';

  @override
  String get fypFeatureCostAnalysis => 'Analyse des coûts';

  @override
  String get fypFeatureDetailedInsights => 'Informations détaillées';

  @override
  String get fypFeatureSaveFavorites => 'Enregistrer les favoris';

  @override
  String get fypFeatureCompareOptions => 'Comparer les options';

  @override
  String get fypGetStarted => 'Commencer';

  @override
  String get fypViewMyRecommendations => 'Voir mes recommandations';

  @override
  String get fypDisclaimer =>
      'Les recommandations sont basées sur votre profil et vos préférences. Faites toujours des recherches approfondies sur les universités et consultez des conseillers d\'orientation avant de prendre des décisions définitives.';

  @override
  String get fypQuestionnaireTitle => 'Questionnaire universitaire';

  @override
  String fypStepOf(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get fypStepBackgroundInfo => 'Informations générales';

  @override
  String get fypStepAcademicAchievements => 'Résultats académiques';

  @override
  String get fypStepAcademicInterests => 'Intérêts académiques';

  @override
  String get fypStepLocationPreferences => 'Préférences de lieu';

  @override
  String get fypStepUniversityPreferences => 'Préférences universitaires';

  @override
  String get fypStepFinancialInfo => 'Informations financières';

  @override
  String get fypTellUsAboutYourself => 'Parlez-nous de vous';

  @override
  String get fypBackgroundHelper =>
      'Cela nous aide à comprendre votre parcours éducatif';

  @override
  String get fypNationalityLabel => 'Nationalité *';

  @override
  String get fypNationalityHelper => 'Votre pays de citoyenneté';

  @override
  String get fypSelectNationality => 'Veuillez sélectionner votre nationalité';

  @override
  String get fypCurrentStudyingLabel => 'Où étudiez-vous actuellement ? *';

  @override
  String get fypCurrentStudyingHelper =>
      'Votre emplacement actuel (pas celui où vous souhaitez étudier)';

  @override
  String get fypSelectCurrentCountry =>
      'Veuillez sélectionner votre pays actuel';

  @override
  String get fypCurrentRegionLabel => 'Région/État actuel (Facultatif)';

  @override
  String get fypSelectRegionHelper => 'Sélectionnez votre région si disponible';

  @override
  String get fypYourAcademicAchievements => 'Vos résultats académiques';

  @override
  String get fypAcademicMatchHelper =>
      'Cela nous aide à vous associer à des universités où vous serez compétitif';

  @override
  String get fypGradingSystemLabel => 'Votre système de notation *';

  @override
  String get fypSelectGradingSystem =>
      'Veuillez sélectionner votre système de notation';

  @override
  String get fypYourGradeLabel => 'Votre note *';

  @override
  String get fypEnterGrade => 'Veuillez entrer votre note';

  @override
  String get fypStandardizedTestLabel => 'Test standardisé (le cas échéant)';

  @override
  String get fypStandardizedTestHelper =>
      'Laissez vide si vous n\'en avez passé aucun';

  @override
  String get fypSatTotalScoreLabel => 'Score total SAT';

  @override
  String get fypSatScoreHint => 'ex. : 1400';

  @override
  String get fypSatValidation => 'Le SAT doit être entre 400 et 1600';

  @override
  String get fypActCompositeLabel => 'Score composite ACT';

  @override
  String get fypActScoreHint => 'ex. : 28';

  @override
  String get fypActValidation => 'L\'ACT doit être entre 1 et 36';

  @override
  String get fypIbScoreLabel => 'Score IB prévu/final';

  @override
  String get fypIbScoreHint => 'ex. : 38';

  @override
  String get fypIbValidation => 'Le score IB doit être entre 0 et 45';

  @override
  String get fypTestScoresOptional =>
      'Les scores aux tests standardisés sont facultatifs. Si vous n\'avez pas encore passé ces tests, vous pouvez les ignorer.';

  @override
  String get fypWhatStudy => 'Que voulez-vous étudier ?';

  @override
  String get fypInterestsHelper =>
      'Parlez-nous de vos intérêts académiques et de vos objectifs de carrière';

  @override
  String get fypIntendedMajorLabel => 'Filière souhaitée *';

  @override
  String get fypIntendedMajorHint => 'Sélectionnez votre filière souhaitée';

  @override
  String get fypSelectIntendedMajor =>
      'Veuillez sélectionner votre filière souhaitée';

  @override
  String get fypFieldOfStudyLabel => 'Domaine d\'étude *';

  @override
  String get fypSelectFieldOfStudy =>
      'Veuillez sélectionner un domaine d\'étude';

  @override
  String get fypCareerFocused => 'Je suis orienté carrière';

  @override
  String get fypCareerFocusedSubtitle =>
      'Je veux trouver des universités avec un fort placement professionnel et des services de carrière';

  @override
  String get fypResearchInterest =>
      'Intéressé par les opportunités de recherche';

  @override
  String get fypResearchInterestSubtitle =>
      'Je veux participer à des projets de recherche pendant mes études';

  @override
  String get fypWhereStudy => 'Où voulez-vous étudier ?';

  @override
  String get fypLocationHelper => 'Sélectionnez vos pays et régions préférés';

  @override
  String get fypWhereStudyRequired => 'Où voulez-vous étudier ? *';

  @override
  String get fypSelectCountriesHelper =>
      'Sélectionnez les pays où vous souhaitez fréquenter l\'université';

  @override
  String get fypCampusSetting => 'Cadre du campus';

  @override
  String get fypUniversityCharacteristics =>
      'Caractéristiques de l\'université';

  @override
  String get fypUniversityEnvironmentHelper =>
      'Quel type d\'environnement universitaire préférez-vous ?';

  @override
  String get fypPreferredSizeLabel => 'Taille d\'université préférée';

  @override
  String get fypPreferredTypeLabel => 'Type d\'université préféré';

  @override
  String get fypSportsInterest => 'Intéressé par l\'athlétisme/le sport';

  @override
  String get fypSportsInterestSubtitle =>
      'Je veux participer ou assister à des sports universitaires';

  @override
  String get fypDesiredFeatures =>
      'Caractéristiques du campus souhaitées (facultatif)';

  @override
  String get fypFinancialConsiderations => 'Considérations financières';

  @override
  String get fypFinancialHelper =>
      'Aidez-nous à recommander des universités dans votre budget';

  @override
  String get fypBudgetRangeLabel => 'Budget annuel (USD)';

  @override
  String get fypBudgetRangeHelper =>
      'Budget annuel approximatif pour les frais de scolarité';

  @override
  String get fypNeedFinancialAid => 'J\'aurai besoin d\'une aide financière';

  @override
  String get fypFinancialAidSubtitle =>
      'Nous donnerons la priorité aux universités offrant de solides programmes d\'aide financière';

  @override
  String get fypInStateTuitionLabel =>
      'Éligible aux frais de scolarité résidentiels ? (US)';

  @override
  String get fypNotApplicable => 'Non applicable';

  @override
  String get fypBack => 'Retour';

  @override
  String get fypNext => 'Suivant';

  @override
  String get fypGetRecommendations => 'Obtenir des recommandations';

  @override
  String fypErrorSavingProfile(String error) {
    return 'Erreur lors de l\'enregistrement du profil : $error';
  }

  @override
  String fypErrorGeneratingRecs(String error) {
    return 'Erreur lors de la génération des recommandations : $error';
  }

  @override
  String get fypRetry => 'Réessayer';

  @override
  String get fypSignUpToSave =>
      'Inscrivez-vous pour sauvegarder vos recommandations !';

  @override
  String get fypSignUp => 'S\'inscrire';

  @override
  String fypUnexpectedError(String error) {
    return 'Erreur inattendue : $error';
  }

  @override
  String get fypGeneratingRecommendations => 'Génération des recommandations';

  @override
  String get fypGeneratingPleaseWait =>
      'Veuillez patienter pendant que nous analysons les universités\net créons des correspondances personnalisées pour vous...';

  @override
  String get fypYourRecommendations => 'Vos recommandations';

  @override
  String get fypRefresh => 'Actualiser';

  @override
  String get fypErrorLoadingRecs =>
      'Erreur lors du chargement des recommandations';

  @override
  String get fypTryAgain => 'Réessayer';

  @override
  String get fypNoRecsYet => 'Aucune recommandation pour l\'instant';

  @override
  String get fypCompleteQuestionnaire =>
      'Complétez le questionnaire pour obtenir des recommandations personnalisées';

  @override
  String get fypStartQuestionnaire => 'Commencer le questionnaire';

  @override
  String get fypFoundPerfectMatches =>
      'Nous avons trouvé vos correspondances idéales !';

  @override
  String get fypStatTotal => 'Total';

  @override
  String get fypStatSafety => 'Sécurité';

  @override
  String get fypStatMatch => 'Correspondance';

  @override
  String get fypStatReach => 'Ambition';

  @override
  String fypFilterAll(int count) {
    return 'Tous ($count)';
  }

  @override
  String fypFilterSafety(int count) {
    return 'Sécurité ($count)';
  }

  @override
  String fypFilterMatch(int count) {
    return 'Correspondance ($count)';
  }

  @override
  String fypFilterReach(int count) {
    return 'Ambition ($count)';
  }

  @override
  String get fypNoFilterMatch =>
      'Aucune université ne correspond au filtre sélectionné';

  @override
  String fypPercentMatch(String score) {
    return '$score% de correspondance';
  }

  @override
  String get fypLoadingDetails => 'Chargement des détails de l\'université...';

  @override
  String get fypLocationNotAvailable => 'Emplacement non disponible';

  @override
  String get fypStatAcceptance => 'Acceptation';

  @override
  String get fypStatTuition => 'Frais de scolarité';

  @override
  String get fypStatStudents => 'Étudiants';

  @override
  String get fypStatRank => 'Classement';

  @override
  String get fypWhyGoodMatch => 'Pourquoi c\'est une bonne correspondance :';

  @override
  String get fypViewDetails => 'Voir les détails';

  @override
  String get fypUniversityDetails => 'Détails de l\'université';

  @override
  String get fypVisitWebsite => 'Visiter le site web';

  @override
  String get fypUniversityNotFound => 'Université non trouvée';

  @override
  String get fypErrorLoadingUniversity =>
      'Erreur lors du chargement de l\'université';

  @override
  String get fypUnknownError => 'Erreur inconnue';

  @override
  String fypKStudents(String count) {
    return '${count}k étudiants';
  }

  @override
  String get fypNationalRank => 'Classement national';

  @override
  String get fypAcceptanceRate => 'Taux d\'acceptation';

  @override
  String get fypAbout => 'À propos';

  @override
  String get fypAdmissions => 'Admissions';

  @override
  String get fypCostsFinancialAid => 'Coûts et aide financière';

  @override
  String get fypStudentOutcomes => 'Résultats des étudiants';

  @override
  String get fypProgramsOffered => 'Programmes offerts';

  @override
  String get fypAverageGPA => 'Moyenne générale';

  @override
  String get fypSatMathRange => 'Fourchette SAT Math';

  @override
  String get fypSatEbrwRange => 'Fourchette SAT EBRW';

  @override
  String get fypActRange => 'Fourchette ACT';

  @override
  String get fypOutOfStateTuition => 'Frais de scolarité hors état';

  @override
  String get fypTotalCostEst => 'Coût total (est.)';

  @override
  String get fypFinancialAidNote =>
      'Une aide financière peut être disponible. Contactez l\'université pour plus de détails.';

  @override
  String get fypGraduationRate => 'Taux de diplomation en 4 ans';

  @override
  String get fypMedianEarnings => 'Revenus médians (10 ans)';

  @override
  String get appListTitle => 'Mes candidatures';

  @override
  String appTabAll(int count) {
    return 'Toutes ($count)';
  }

  @override
  String appTabPending(int count) {
    return 'En attente ($count)';
  }

  @override
  String appTabUnderReview(int count) {
    return 'En cours d\'examen ($count)';
  }

  @override
  String appTabAccepted(int count) {
    return 'Acceptées ($count)';
  }

  @override
  String get appLoadingMessage => 'Chargement des candidatures...';

  @override
  String get appRetry => 'Réessayer';

  @override
  String get appNewApplication => 'Nouvelle candidature';

  @override
  String get appEmptyTitle => 'Aucune candidature';

  @override
  String get appEmptyMessage =>
      'Vous n\'avez soumis aucune candidature pour l\'instant.';

  @override
  String get appCreateApplication => 'Créer une candidature';

  @override
  String get appToday => 'Aujourd\'hui';

  @override
  String get appYesterday => 'Hier';

  @override
  String appDaysAgo(int days) {
    return 'Il y a $days jours';
  }

  @override
  String get appFeePaid => 'Frais payés';

  @override
  String get appPaymentPending => 'Paiement en attente';

  @override
  String appReviewedDaysAgo(int days) {
    return 'Examiné il y a $days jours';
  }

  @override
  String get appDetailTitle => 'Détails de la candidature';

  @override
  String get appDetailShare => 'Partager';

  @override
  String get appDetailStatus => 'Statut de la candidature';

  @override
  String get appStatusPendingReview => 'En attente d\'examen';

  @override
  String get appStatusUnderReview => 'En cours d\'examen';

  @override
  String get appStatusAccepted => 'Acceptée';

  @override
  String get appStatusRejected => 'Rejetée';

  @override
  String get appStatusUnknown => 'Inconnu';

  @override
  String get appDetailInfo => 'Informations sur la candidature';

  @override
  String get appDetailInstitution => 'Établissement';

  @override
  String get appDetailProgram => 'Programme';

  @override
  String get appDetailSubmitted => 'Soumise';

  @override
  String get appDetailReviewed => 'Examinée';

  @override
  String get appDetailPaymentInfo => 'Informations de paiement';

  @override
  String get appDetailApplicationFee => 'Frais de candidature';

  @override
  String get appDetailPaymentStatus => 'Statut du paiement';

  @override
  String get appDetailPaid => 'Payé';

  @override
  String get appDetailPendingPayment => 'En attente';

  @override
  String get appDetailPayFee => 'Payer les frais de candidature';

  @override
  String get appPaymentDialogTitle => 'Paiement';

  @override
  String appPaymentDialogContent(String fee) {
    return 'Payer les frais de candidature de $fee \$ ?';
  }

  @override
  String get appCancel => 'Annuler';

  @override
  String get appPayNow => 'Payer maintenant';

  @override
  String get appPaymentSuccess => 'Paiement effectué avec succès !';

  @override
  String get appPaymentFailed => 'Échec du paiement. Veuillez réessayer.';

  @override
  String appErrorPayment(String error) {
    return 'Erreur lors du traitement du paiement : $error';
  }

  @override
  String get appDetailReviewNotes => 'Notes d\'examen';

  @override
  String get appDetailDocuments => 'Documents';

  @override
  String get appDetailTranscript => 'Relevé de notes';

  @override
  String get appDetailUploaded => 'Téléversé';

  @override
  String get appDetailIdDocument => 'Pièce d\'identité';

  @override
  String get appDetailPersonalStatement => 'Lettre de motivation';

  @override
  String get appDetailWithdraw => 'Retirer';

  @override
  String get appDetailEdit => 'Modifier';

  @override
  String get appWithdrawTitle => 'Retirer la candidature';

  @override
  String get appWithdrawConfirmation =>
      'Êtes-vous sûr de vouloir retirer cette candidature ? Cette action est irréversible.';

  @override
  String get appWithdrawSuccess => 'Candidature retirée avec succès';

  @override
  String get appWithdrawFailed => 'Échec du retrait de la candidature';

  @override
  String appErrorWithdraw(String error) {
    return 'Erreur lors du retrait de la candidature : $error';
  }

  @override
  String get appCreateTitle => 'Nouvelle candidature';

  @override
  String get appStepProgramSelection => 'Sélection du programme';

  @override
  String get appSelectUniversity => 'Sélectionner une université';

  @override
  String get appBrowseInstitutions => 'Parcourir les établissements';

  @override
  String get appNoProgramsYet =>
      'Cet établissement n\'a pas encore de programmes actifs. Veuillez en sélectionner un autre.';

  @override
  String get appSelectProgramLabel => 'Sélectionner un programme *';

  @override
  String appProgramsAvailable(int count) {
    return '$count programmes disponibles';
  }

  @override
  String get appStepPersonalInfo => 'Informations personnelles';

  @override
  String get appFullNameLabel => 'Nom complet';

  @override
  String get appEmailLabel => 'Adresse e-mail';

  @override
  String get appPhoneLabel => 'Numéro de téléphone';

  @override
  String get appStreetAddressLabel => 'Adresse *';

  @override
  String get appCityLabel => 'Ville *';

  @override
  String get appCountryLabel => 'Pays *';

  @override
  String get appStateLabel => 'État/Province *';

  @override
  String get appSelectCountryFirst => 'Sélectionnez d\'abord un pays';

  @override
  String get appStepAcademicInfo => 'Informations académiques';

  @override
  String get appPreviousSchoolLabel => 'École/Établissement précédent';

  @override
  String get appGpaLabel => 'Moyenne générale / GPA';

  @override
  String get appPersonalStatementLabel => 'Lettre de motivation';

  @override
  String get appPersonalStatementHint =>
      'Pourquoi êtes-vous intéressé par ce programme ?';

  @override
  String get appStepDocuments => 'Documents (obligatoires)';

  @override
  String get appUploadRequiredDocs => 'Téléversez les documents requis';

  @override
  String get appDocTranscriptTitle => 'Relevé de notes académique';

  @override
  String get appDocTranscriptSubtitle =>
      'Relevé de notes officiel de votre école précédente (format PDF, DOC ou DOCX, max 5 Mo)';

  @override
  String get appDocIdTitle => 'Pièce d\'identité';

  @override
  String get appDocIdSubtitle =>
      'Pièce d\'identité officielle : passeport, carte d\'identité nationale ou permis de conduire (PDF, JPG ou PNG)';

  @override
  String get appDocPhotoTitle => 'Photo d\'identité';

  @override
  String get appDocPhotoSubtitle =>
      'Photo d\'identité récente sur fond uni (format JPG ou PNG)';

  @override
  String get appDocRequiredWarning =>
      'Les trois documents sont obligatoires. Veuillez télécharger le relevé de notes, la pièce d\'identité et la photo d\'identité avant de soumettre.';

  @override
  String get appSubmit => 'Soumettre';

  @override
  String get appContinue => 'Continuer';

  @override
  String get appBack => 'Retour';

  @override
  String get courseListTitle => 'Cours';

  @override
  String get courseFiltersTooltip => 'Filtres';

  @override
  String get courseBrowseAll => 'Parcourir tout';

  @override
  String get courseAssignedToMe => 'Qui me sont attribués';

  @override
  String get courseSearchHint => 'Rechercher des cours...';

  @override
  String get courseNoAvailable => 'Aucun cours disponible';

  @override
  String get courseCheckBackLater => 'Revenez plus tard pour de nouveaux cours';

  @override
  String get courseRetry => 'Réessayer';

  @override
  String get courseFailedLoadAssigned =>
      'Échec du chargement des cours attribués';

  @override
  String get courseNoAssignedYet => 'Aucun cours attribué pour l\'instant';

  @override
  String get courseAssignedDescription =>
      'Les cours attribués par votre administrateur ou établissement apparaîtront ici.';

  @override
  String get courseRequired => 'Obligatoire';

  @override
  String courseLessonsLabel(int count) {
    return '$count leçons';
  }

  @override
  String coursePercentComplete(int percent) {
    return '$percent% terminé';
  }

  @override
  String get courseNoRatingsYet => 'Pas encore de notes';

  @override
  String courseEnrolledCount(int count) {
    return '$count inscrits';
  }

  @override
  String get courseFiltersTitle => 'Filtres';

  @override
  String get courseLevelLabel => 'Niveau';

  @override
  String get courseAllLevels => 'Tous les niveaux';

  @override
  String get courseLevelBeginner => 'Débutant';

  @override
  String get courseLevelIntermediate => 'Intermédiaire';

  @override
  String get courseLevelAdvanced => 'Avancé';

  @override
  String get courseLevelExpert => 'Expert';

  @override
  String get courseClearAll => 'Tout effacer';

  @override
  String get courseApplyFilters => 'Appliquer';

  @override
  String get courseDescription => 'Description';

  @override
  String get courseWhatYoullLearn => 'Ce que vous apprendrez';

  @override
  String get coursePrerequisites => 'Prérequis';

  @override
  String get coursePrice => 'Prix';

  @override
  String get courseCourseFull => 'Cours complet';

  @override
  String get courseRequestPermission => 'Demander la permission';

  @override
  String get coursePermissionPending => 'Permission en attente';

  @override
  String get coursePermissionDenied => 'Permission refusée';

  @override
  String get courseRequestPermissionAgain => 'Redemander la permission';

  @override
  String get courseEnrollNow => 'S\'inscrire maintenant';

  @override
  String get courseRequestEnrollmentTitle =>
      'Demander la permission d\'inscription';

  @override
  String courseRequestEnrollmentContent(String title) {
    return 'Demander la permission de s\'inscrire au cours \"$title\" ?';
  }

  @override
  String get courseInstitutionReview =>
      'L\'établissement examinera votre demande.';

  @override
  String get courseMessageToInstitution =>
      'Message à l\'établissement (facultatif)';

  @override
  String get courseMessageHint => 'Pourquoi voulez-vous suivre ce cours ?';

  @override
  String get courseCancel => 'Annuler';

  @override
  String get courseRequest => 'Demander';

  @override
  String get coursePermissionRequestSent => 'Demande de permission envoyée !';

  @override
  String courseFailedRequestPermission(String error) {
    return 'Échec de la demande de permission : $error';
  }

  @override
  String get courseEnrolledSuccess => 'Inscription au cours réussie !';

  @override
  String get courseFailedEnroll => 'Échec de l\'inscription';

  @override
  String courseContinueLearning(String progress) {
    return 'Continuer l\'apprentissage ($progress%)';
  }

  @override
  String get courseStartLearning => 'Commencer l\'apprentissage';

  @override
  String courseLessonsCompleted(int completed, int total) {
    return '$completed/$total leçons terminées';
  }

  @override
  String get courseCollapseSidebar => 'Réduire la barre latérale';

  @override
  String get courseExpandSidebar => 'Développer la barre latérale';

  @override
  String courseErrorLoadingModules(String error) {
    return 'Erreur lors du chargement des modules :\n$error';
  }

  @override
  String get courseNoContentYet => 'Aucun contenu disponible pour l\'instant';

  @override
  String get courseNoLessonsAdded =>
      'L\'instructeur n\'a pas encore ajouté de leçons';

  @override
  String courseLessonsCount(int completed, int total) {
    return '$completed/$total leçons';
  }

  @override
  String courseWelcomeTo(String title) {
    return 'Bienvenue dans $title';
  }

  @override
  String get courseCompleted => 'Terminé';

  @override
  String get coursePrevious => 'Précédent';

  @override
  String get courseMarkAsComplete => 'Marquer comme terminé';

  @override
  String get courseNext => 'Suivant';

  @override
  String get courseMyCourses => 'Mes cours';

  @override
  String get courseFilterByStatus => 'Filtrer par statut';

  @override
  String courseTabAssigned(int count) {
    return 'Attribués ($count)';
  }

  @override
  String courseTabEnrolled(int count) {
    return 'Inscrits ($count)';
  }

  @override
  String get courseNoAssigned => 'Aucun cours attribué';

  @override
  String get courseAssignedByInstitution =>
      'Les cours qui vous sont attribués par votre établissement apparaîtront ici';

  @override
  String get courseREQUIRED => 'OBLIGATOIRE';

  @override
  String get courseProgress => 'Progression';

  @override
  String courseDuePrefix(String date) {
    return 'Échéance : $date';
  }

  @override
  String get courseStatusCompleted => 'Terminé';

  @override
  String get courseStatusInProgress => 'En cours';

  @override
  String get courseStatusOverdue => 'En retard';

  @override
  String get courseStatusAssigned => 'Attribué';

  @override
  String get courseDueToday => 'Aujourd\'hui';

  @override
  String get courseDueTomorrow => 'Demain';

  @override
  String courseDueDays(int days) {
    return '$days jours';
  }

  @override
  String get courseNoEnrolled => 'Aucun cours inscrit';

  @override
  String get courseBrowseToStart => 'Parcourez les cours pour commencer';

  @override
  String get courseBrowseCourses => 'Parcourir les cours';

  @override
  String get courseFilterAll => 'Tous';

  @override
  String get courseStatusActive => 'Actif';

  @override
  String get courseStatusDropped => 'Abandonné';

  @override
  String get courseStatusSuspended => 'Suspendu';

  @override
  String get homeNewFeature => 'NOUVELLE FONCTIONNALITÉ';

  @override
  String get homeFindYourPathTitle => 'Trouvez votre voie';

  @override
  String get homeFindYourPathDesc =>
      'Découvrez les universités qui correspondent à vos objectifs, votre budget et vos aspirations.\nLaissez notre système de recommandation intelligent vous guider vers le choix idéal.';

  @override
  String get homePersonalizedRecs => 'Recommandations personnalisées';

  @override
  String get homeTopUniversities => '12+ universités de premier plan';

  @override
  String get homeSmartMatching => 'Algorithme de correspondance intelligent';

  @override
  String get homeStartYourJourney => 'Commencez votre parcours';

  @override
  String get homeNoAccountRequired =>
      'Aucun compte requis - commencez immédiatement';

  @override
  String get homeSearchUniversitiesDesc =>
      'Explorez plus de 18 000 universités dans le monde entier.\nFiltrez par pays, frais de scolarité, taux d\'admission et plus encore.';

  @override
  String get homeFilters => 'Filtres';

  @override
  String get homeBrowseUniversities => 'Parcourir les universités';

  @override
  String get helpBack => 'Retour';

  @override
  String get helpContactSupport => 'Contacter le support';

  @override
  String get helpWeAreHereToHelp => 'Nous sommes là pour vous aider !';

  @override
  String get helpSupportResponseTime =>
      'Notre équipe de support répond généralement dans les 24 heures';

  @override
  String get helpSubject => 'Sujet';

  @override
  String get helpSubjectHint => 'Brève description de votre problème';

  @override
  String get helpSubjectRequired => 'Veuillez entrer un sujet';

  @override
  String get helpSubjectMinLength =>
      'Le sujet doit comporter au moins 5 caractères';

  @override
  String get helpCategory => 'Catégorie';

  @override
  String get helpCategoryGeneral => 'Demande générale';

  @override
  String get helpCategoryTechnical => 'Problème technique';

  @override
  String get helpCategoryBilling => 'Facturation et paiements';

  @override
  String get helpCategoryAccount => 'Gestion du compte';

  @override
  String get helpCategoryCourse => 'Contenu des cours';

  @override
  String get helpCategoryOther => 'Autre';

  @override
  String get helpPriority => 'Priorité';

  @override
  String get helpPriorityLow => 'Basse';

  @override
  String get helpPriorityMedium => 'Moyenne';

  @override
  String get helpPriorityHigh => 'Élevée';

  @override
  String get helpPriorityUrgent => 'Urgente';

  @override
  String get helpDescription => 'Description';

  @override
  String get helpDescriptionHint =>
      'Veuillez fournir des informations détaillées sur votre problème...';

  @override
  String get helpDescriptionRequired => 'Veuillez décrire votre problème';

  @override
  String get helpDescriptionMinLength =>
      'La description doit comporter au moins 20 caractères';

  @override
  String get helpAttachments => 'Pièces jointes';

  @override
  String get helpNoFilesAttached => 'Aucun fichier joint';

  @override
  String get helpAddAttachment => 'Ajouter une pièce jointe';

  @override
  String get helpAttachmentTypes => 'Images, PDF, documents (10 Mo max chacun)';

  @override
  String get helpPreferredContactMethod => 'Méthode de contact préférée';

  @override
  String get helpEmail => 'E-mail';

  @override
  String get helpRespondViaEmail => 'Nous répondrons par e-mail';

  @override
  String get helpPhone => 'Téléphone';

  @override
  String get helpCallYouBack => 'Nous vous rappellerons';

  @override
  String get helpSubmitting => 'Envoi en cours...';

  @override
  String get helpSubmitRequest => 'Envoyer la demande';

  @override
  String get helpOtherWaysToReachUs => 'Autres moyens de nous contacter';

  @override
  String get helpEmailCopied => 'E-mail copié dans le presse-papiers';

  @override
  String get helpPhoneCopied =>
      'Numéro de téléphone copié dans le presse-papiers';

  @override
  String get helpBusinessHours => 'Heures d’ouverture';

  @override
  String get helpBusinessHoursDetails => 'Lundi - Vendredi\n9h00 - 18h00 EST';

  @override
  String get helpAverageResponseTime => 'Temps de réponse moyen';

  @override
  String get helpTypicallyRespond24h =>
      'Nous répondons généralement dans les 24 heures';

  @override
  String get helpRequestSubmitted => 'Demande envoyée';

  @override
  String get helpRequestSubmittedSuccess =>
      'Votre demande de support a été envoyée avec succès !';

  @override
  String get helpTrackRequestInfo =>
      'Nous répondrons à votre e-mail dans les 24 heures. Vous pouvez suivre votre demande dans la section Tickets de support.';

  @override
  String get helpOk => 'OK';

  @override
  String get helpViewTicketInSupport =>
      'Voir votre ticket dans les Tickets de support';

  @override
  String get helpViewTickets => 'Voir les tickets';

  @override
  String get helpFaqTitle => 'Foire aux questions';

  @override
  String get helpFaqAll => 'Tous';

  @override
  String get helpFaqGettingStarted => 'Démarrage';

  @override
  String get helpFaqAccount => 'Compte';

  @override
  String get helpFaqCourses => 'Cours';

  @override
  String get helpFaqPayments => 'Paiements';

  @override
  String get helpFaqTechnical => 'Technique';

  @override
  String get helpSearchFaqs => 'Rechercher dans la FAQ...';

  @override
  String get helpNoFaqsFound => 'Aucune FAQ trouvée';

  @override
  String get helpTryDifferentSearch => 'Essayez un autre terme de recherche';

  @override
  String get helpThanksForFeedback => 'Merci pour votre retour !';

  @override
  String get helpCenterTitle => 'Centre d’aide';

  @override
  String get helpHowCanWeHelp => 'Comment pouvons-nous vous aider ?';

  @override
  String get helpSearchOrBrowse =>
      'Recherchez des réponses ou parcourez les sujets d’aide';

  @override
  String get helpSearchForHelp => 'Rechercher de l’aide...';

  @override
  String get helpQuickHelp => 'Aide rapide';

  @override
  String get helpBrowseFaqs => 'Parcourir la FAQ';

  @override
  String get helpBrowseFaqsDesc => 'Réponses rapides aux questions courantes';

  @override
  String get helpContactSupportDesc =>
      'Obtenez l’aide de notre équipe de support';

  @override
  String get helpMySupportTickets => 'Mes tickets de support';

  @override
  String get helpMySupportTicketsDesc => 'Voir vos tickets ouverts et fermés';

  @override
  String get helpBrowseByTopic => 'Parcourir par sujet';

  @override
  String get helpViewAll => 'Voir tout';

  @override
  String get helpPopularArticles => 'Articles populaires';

  @override
  String get helpRemovedFromBookmarks => 'Retiré des favoris';

  @override
  String get helpAddedToBookmarks => 'Ajouté aux favoris';

  @override
  String get helpStillNeedHelp => 'Besoin d’aide supplémentaire ?';

  @override
  String get helpSupportTeamHere =>
      'Notre équipe de support est là pour vous aider';

  @override
  String get helpWasArticleHelpful => 'Cet article vous a-t-il été utile ?';

  @override
  String get helpYes => 'Oui';

  @override
  String get helpNo => 'Non';

  @override
  String get helpThanksWeWillImprove =>
      'Merci ! Nous améliorerons cet article.';

  @override
  String get helpSupportTickets => 'Tickets de support';

  @override
  String get helpTicketActive => 'Actifs';

  @override
  String get helpTicketWaiting => 'En attente';

  @override
  String get helpTicketResolved => 'Résolus';

  @override
  String get helpNewTicket => 'Nouveau ticket';

  @override
  String get helpNoTickets => 'Aucun ticket';

  @override
  String get helpCreateTicketToGetSupport =>
      'Créez un ticket pour obtenir du support';

  @override
  String get helpTypeYourMessage => 'Tapez votre message...';

  @override
  String get helpMessageSent => 'Message envoyé !';

  @override
  String get helpCreateSupportTicket => 'Créer un ticket de support';

  @override
  String get helpDescribeIssueDetail => 'Décrivez votre problème en détail...';

  @override
  String get helpCancel => 'Annuler';

  @override
  String get helpSubmit => 'Envoyer';

  @override
  String get helpTicketCreatedSuccess => 'Ticket de support créé avec succès !';

  @override
  String get cookiePreferencesSaved => 'Préférences de cookies enregistrées';

  @override
  String get cookieEssentialOnly => 'Essentiels uniquement';

  @override
  String get cookieWeUseCookies => 'Nous utilisons des cookies';

  @override
  String get cookieBannerDescription =>
      'Nous utilisons des cookies pour améliorer votre expérience, analyser l’utilisation du site et fournir du contenu personnalisé. En cliquant sur « Tout accepter », vous consentez à notre utilisation des cookies.';

  @override
  String get cookieAcceptAll => 'Tout accepter';

  @override
  String get cookieCustomize => 'Personnaliser';

  @override
  String get cookiePrivacyPolicy => 'Politique de confidentialité';

  @override
  String get cookiePreferencesTitle => 'Préférences de cookies';

  @override
  String get cookieCustomizeDescription =>
      'Personnalisez vos préférences de cookies. Les cookies essentiels sont toujours activés.';

  @override
  String get cookiePreferencesSavedSuccess =>
      'Préférences de cookies enregistrées avec succès';

  @override
  String get cookieFailedToSave =>
      'Échec de l’enregistrement des préférences. Veuillez réessayer.';

  @override
  String get cookieRejectAll => 'Tout refuser';

  @override
  String get cookieSavePreferences => 'Enregistrer les préférences';

  @override
  String get cookieAlwaysActive => 'Toujours actif';

  @override
  String get cookieSettingsTitle => 'Paramètres des cookies';

  @override
  String get cookieNoConsentData => 'Aucune donnée de consentement disponible';

  @override
  String get cookieSetPreferences => 'Définir les préférences';

  @override
  String get cookieConsentActive => 'Consentement actif';

  @override
  String get cookieNoConsentGiven => 'Aucun consentement donné';

  @override
  String get cookieCurrentPreferences => 'Préférences actuelles';

  @override
  String get cookieChangePreferences => 'Modifier les préférences';

  @override
  String get cookieExportMyData => 'Exporter mes données';

  @override
  String get cookieDeleteMyData => 'Supprimer mes données';

  @override
  String get cookieAboutCookies => 'À propos des cookies';

  @override
  String get cookieAboutDescription =>
      'Les cookies nous aident à vous offrir une meilleure expérience. Vous pouvez modifier vos préférences à tout moment. Les cookies essentiels sont toujours actifs pour la sécurité et le fonctionnement.';

  @override
  String get cookieReadPrivacyPolicy => 'Lire la politique de confidentialité';

  @override
  String get cookieExportData => 'Exporter les données';

  @override
  String get cookieExportDataDescription =>
      'Cela créera un fichier avec toutes vos données de cookies et de consentement. Le fichier sera enregistré dans votre dossier de téléchargements.';

  @override
  String get cookieCancel => 'Annuler';

  @override
  String get cookieExport => 'Exporter';

  @override
  String get cookieDeleteData => 'Supprimer les données';

  @override
  String get cookieDeleteDataDescription =>
      'Cela supprimera définitivement toutes vos données de cookies. Les cookies essentiels nécessaires au fonctionnement de l’application seront conservés. Cette action est irréversible.';

  @override
  String get cookieDelete => 'Supprimer';

  @override
  String get cookieDataDeletedSuccess => 'Données supprimées avec succès';

  @override
  String get careerCounselingTitle => 'Orientation professionnelle';

  @override
  String get careerFindCounselor => 'Trouver un conseiller';

  @override
  String get careerUpcoming => 'À venir';

  @override
  String get careerPastSessions => 'Sessions passées';

  @override
  String get careerSearchCounselors =>
      'Rechercher par nom, spécialisation ou expertise...';

  @override
  String get careerAvailableNow => 'Disponible maintenant';

  @override
  String get careerHighestRated => 'Mieux notés';

  @override
  String get careerMostExperienced => 'Plus expérimentés';

  @override
  String get careerNoCounselorsFound => 'Aucun conseiller trouvé';

  @override
  String get careerTryAdjustingSearch => 'Essayez de modifier votre recherche';

  @override
  String get careerReschedule => 'Reprogrammer';

  @override
  String get careerJoinSession => 'Rejoindre la session';

  @override
  String get careerNoPastSessions => 'Aucune session passée';

  @override
  String get careerCompletedSessionsAppearHere =>
      'Vos sessions terminées apparaîtront ici';

  @override
  String get careerAbout => 'À propos';

  @override
  String get careerAreasOfExpertise => 'Domaines d’expertise';

  @override
  String get careerBookSession => 'Réserver une session';

  @override
  String get careerCurrentlyUnavailable => 'Actuellement indisponible';

  @override
  String get careerBookCounselingSession => 'Réserver une session de conseil';

  @override
  String get careerSessionType => 'Type de session';

  @override
  String get careerPreferredDate => 'Date préférée';

  @override
  String get careerSelectDate => 'Sélectionner une date';

  @override
  String get careerSessionNotesOptional => 'Notes de session (facultatif)';

  @override
  String get careerWhatToDiscuss => 'Que souhaitez-vous discuter ?';

  @override
  String get careerCancel => 'Annuler';

  @override
  String get careerConfirmBooking => 'Confirmer la réservation';

  @override
  String get careerSessionBookedSuccess => 'Session réservée avec succès !';

  @override
  String get careerResourcesTitle => 'Ressources de carrière';

  @override
  String get careerAll => 'Tous';

  @override
  String get careerArticles => 'Articles';

  @override
  String get careerVideos => 'Vidéos';

  @override
  String get careerCourses => 'Cours';

  @override
  String get careerSearchResources => 'Rechercher des ressources...';

  @override
  String get careerRemovedFromBookmarks => 'Retiré des favoris';

  @override
  String get careerAddedToBookmarks => 'Ajouté aux favoris';

  @override
  String get careerCategories => 'Catégories';

  @override
  String get careerNoResourcesFound => 'Aucune ressource trouvée';

  @override
  String get careerWhatYoullLearn => 'Ce que vous apprendrez';

  @override
  String get careerSaved => 'Enregistré';

  @override
  String get careerSave => 'Enregistrer';

  @override
  String get careerOpeningResource => 'Ouverture de la ressource...';

  @override
  String get careerStartLearning => 'Commencer à apprendre';

  @override
  String get careerBrowseCategories => 'Parcourir les catégories';

  @override
  String get jobDetailsTitle => 'Détails du poste';

  @override
  String get jobSavedSuccessfully => 'Offre enregistrée avec succès';

  @override
  String get jobRemovedFromSaved => 'Offre retirée des enregistrements';

  @override
  String get jobShareComingSoon =>
      'Fonctionnalité de partage bientôt disponible';

  @override
  String get jobApplyNow => 'Postuler maintenant';

  @override
  String get jobSalaryRange => 'Fourchette salariale';

  @override
  String get jobLocation => 'Localisation';

  @override
  String get jobApplicationDeadline => 'Date limite de candidature';

  @override
  String get jobDescription => 'Description du poste';

  @override
  String get jobRequirements => 'Exigences';

  @override
  String get jobResponsibilities => 'Responsabilités';

  @override
  String get jobBenefits => 'Avantages';

  @override
  String get jobRequiredSkills => 'Compétences requises';

  @override
  String get jobAboutTheCompany => 'À propos de l’entreprise';

  @override
  String get jobCompanyProfileComingSoon =>
      'Profil de l’entreprise bientôt disponible';

  @override
  String get jobViewCompanyProfile => 'Voir le profil de l’entreprise';

  @override
  String get jobSimilarJobs => 'Offres similaires';

  @override
  String get jobApplyForThisJob => 'Postuler pour ce poste';

  @override
  String get jobYouAreApplyingFor => 'Vous postulez pour :';

  @override
  String get jobCoverLetter => 'Lettre de motivation';

  @override
  String get jobCoverLetterHint =>
      'Dites-nous pourquoi vous êtes le candidat idéal...';

  @override
  String get jobUploadResume => 'Télécharger le CV';

  @override
  String get jobCancel => 'Annuler';

  @override
  String get jobSubmitApplication => 'Soumettre la candidature';

  @override
  String get jobApplicationSubmittedSuccess =>
      'Candidature soumise avec succès !';

  @override
  String get jobOpportunitiesTitle => 'Offres d’emploi';

  @override
  String get jobAllJobs => 'Toutes les offres';

  @override
  String get jobSaved => 'Enregistrées';

  @override
  String get jobApplied => 'Candidatures';

  @override
  String get jobSearchHint =>
      'Rechercher des emplois, entreprises ou compétences...';

  @override
  String get jobRemoteOnly => 'Télétravail uniquement';

  @override
  String get jobNoApplicationsYet => 'Aucune candidature pour le moment';

  @override
  String get jobStartApplyingToSee =>
      'Commencez à postuler pour voir vos candidatures ici';

  @override
  String get jobNoJobsFound => 'Aucune offre trouvée';

  @override
  String get jobTryAdjustingFilters => 'Essayez de modifier vos filtres';

  @override
  String get jobDetailComingSoon => 'Écran de détails bientôt disponible';

  @override
  String get jobFilterJobs => 'Filtrer les offres';

  @override
  String get jobClearAll => 'Tout effacer';

  @override
  String get jobJobType => 'Type d’emploi';

  @override
  String get jobExperienceLevel => 'Niveau d’expérience';

  @override
  String get jobApplyFilters => 'Appliquer les filtres';

  @override
  String get jobSortBy => 'Trier par';

  @override
  String get jobRelevance => 'Pertinence';

  @override
  String get jobNewestFirst => 'Plus récents';

  @override
  String get jobHighestSalary => 'Salaire le plus élevé';

  @override
  String get msgFailedToSendMessage => 'Échec de l’envoi du message';

  @override
  String get msgPhotoFromGallery => 'Photo depuis la galerie';

  @override
  String get msgTakePhoto => 'Prendre une photo';

  @override
  String get msgOpensCameraOnMobile =>
      'Ouvre la caméra sur les appareils mobiles';

  @override
  String get msgDocument => 'Document';

  @override
  String get msgCameraNotAvailable =>
      'Caméra non disponible dans le navigateur. Utilisez « Photo depuis la galerie » pour sélectionner une image.';

  @override
  String get msgNoMessagesYet => 'Aucun message pour le moment';

  @override
  String get msgSendMessageToStart =>
      'Envoyez un message pour démarrer la conversation';

  @override
  String get msgConversation => 'Conversation';

  @override
  String get msgOnline => 'En ligne';

  @override
  String get msgConnecting => 'Connexion...';

  @override
  String get msgTypeAMessage => 'Tapez un message...';

  @override
  String get msgMessages => 'Messages';

  @override
  String get msgSearchMessages => 'Rechercher des messages';

  @override
  String get msgSearchConversations => 'Rechercher des conversations...';

  @override
  String get msgRetry => 'Réessayer';

  @override
  String get msgCheckDatabaseSetup =>
      'Vérifier la configuration de la base de données';

  @override
  String get msgDatabaseSetupStatus =>
      'État de la configuration de la base de données';

  @override
  String get msgTestInsertResult => 'Résultat du test d’insertion';

  @override
  String get msgTestInsert => 'Tester l’insertion';

  @override
  String get msgNoConversationsYet => 'Aucune conversation pour le moment';

  @override
  String get msgFailedToCreateConversation =>
      'Échec de la création de la conversation';

  @override
  String get msgNewConversation => 'Nouvelle conversation';

  @override
  String get msgSearchByNameOrEmail => 'Rechercher par nom ou e-mail...';

  @override
  String get msgNoUsersFound => 'Aucun utilisateur trouvé';

  @override
  String msgNoUsersMatch(String query) {
    return 'Aucun utilisateur ne correspond à « $query »';
  }

  @override
  String get progressAchievementsTitle => 'Succès';

  @override
  String get progressNoAchievementsYet => 'Aucun succès pour le moment';

  @override
  String get progressClose => 'Fermer';

  @override
  String get progressMyProgress => 'Ma progression';

  @override
  String get progressKeepUpGreatWork => 'Continuez comme ça !';

  @override
  String get progressMakingExcellentProgress => 'Vous progressez excellemment';

  @override
  String get progressCoursesCompleted => 'Cours terminés';

  @override
  String get progressStudyTime => 'Temps d’étude';

  @override
  String get progressTotalLearningTime => 'Temps total d’apprentissage';

  @override
  String get progressAverageScore => 'Score moyen';

  @override
  String get progressCertificates => 'Certificats';

  @override
  String get progressLearningActivity => 'Activité d’apprentissage';

  @override
  String get progressStudyTimeMinutes => 'Temps d’étude (minutes)';

  @override
  String get progressCourseProgress => 'Progression des cours';

  @override
  String get progressViewAll => 'Voir tout';

  @override
  String get progressStudyGoalsTitle => 'Objectifs d’étude';

  @override
  String get progressYourGoals => 'Vos objectifs';

  @override
  String get progressCreateGoalComingSoon =>
      'Création d’objectif bientôt disponible';

  @override
  String get progressNewGoal => 'Nouvel objectif';

  @override
  String get instApplicantDetails => 'Details du candidat';

  @override
  String get instApplicantMarkUnderReview => 'Marquer en cours d\'examen';

  @override
  String get instApplicantAcceptApplication => 'Accepter la candidature';

  @override
  String get instApplicantRejectApplication => 'Rejeter la candidature';

  @override
  String get instApplicantApplicationStatus => 'Statut de la candidature';

  @override
  String get instApplicantStudentInfo => 'Informations sur l\'etudiant';

  @override
  String get instApplicantFullName => 'Nom complet';

  @override
  String get instApplicantEmail => 'E-mail';

  @override
  String get instApplicantPhone => 'Telephone';

  @override
  String get instApplicantPreviousSchool => 'Ecole precedente';

  @override
  String get instApplicantGpa => 'Moyenne';

  @override
  String get instApplicantProgramApplied => 'Programme demande';

  @override
  String get instApplicantSubmitted => 'Soumis';

  @override
  String get instApplicantStatementOfPurpose => 'Lettre de motivation';

  @override
  String get instApplicantDocuments => 'Documents';

  @override
  String get instApplicantDocViewerComingSoon =>
      'Visionneuse de documents bientot disponible';

  @override
  String instApplicantDownloading(String name) {
    return 'Telechargement de $name...';
  }

  @override
  String get instApplicantReviewInfo => 'Informations de revision';

  @override
  String get instApplicantReviewedBy => 'Examine par';

  @override
  String get instApplicantUnknown => 'Inconnu';

  @override
  String get instApplicantReviewDate => 'Date d\'examen';

  @override
  String get instApplicantReviewNotes => 'Notes de revision';

  @override
  String get instApplicantReject => 'Rejeter';

  @override
  String get instApplicantAccept => 'Accepter';

  @override
  String get instApplicantStatusPending => 'En attente d\'examen';

  @override
  String get instApplicantStatusUnderReview => 'En cours d\'examen';

  @override
  String get instApplicantStatusAccepted => 'Accepte';

  @override
  String get instApplicantStatusRejected => 'Rejete';

  @override
  String get instApplicantDocTranscript => 'Releve de notes';

  @override
  String get instApplicantDocId => 'Document d\'identite';

  @override
  String get instApplicantDocPhoto => 'Photo';

  @override
  String get instApplicantDocRecommendation => 'Lettre de recommandation';

  @override
  String get instApplicantDocGeneric => 'Document';

  @override
  String get instApplicantRecommendationLetters => 'Lettres de recommandation';

  @override
  String instApplicantReceivedCount(int count) {
    return '$count recue(s)';
  }

  @override
  String get instApplicantNoRecommendations =>
      'Aucune lettre de recommandation';

  @override
  String get instApplicantNoRecommendationsDesc =>
      'Le candidat n\'a soumis aucune lettre de recommandation avec cette candidature.';

  @override
  String get instApplicantType => 'Type';

  @override
  String get instApplicantLetterPreview => 'Apercu de la lettre';

  @override
  String get instApplicantClickViewFull =>
      'Cliquez sur \"Voir complet\" pour ouvrir la lettre de recommandation complete.';

  @override
  String get instApplicantLetterPreviewUnavailable =>
      'Apercu du contenu de la lettre non disponible.';

  @override
  String get instApplicantClose => 'Fermer';

  @override
  String get instApplicantViewFull => 'Voir complet';

  @override
  String get instApplicantDownloadNotAvailable =>
      'Telechargement non disponible';

  @override
  String instApplicantOpeningLetter(String url) {
    return 'Ouverture de la lettre : $url';
  }

  @override
  String get instApplicantMarkedUnderReview => 'Marque en cours d\'examen';

  @override
  String get instApplicantFailedUpdateStatus =>
      'Echec de la mise a jour du statut';

  @override
  String instApplicantErrorUpdatingStatus(String error) {
    return 'Erreur de mise a jour du statut : $error';
  }

  @override
  String get instApplicantConfirmAccept =>
      'Etes-vous sur de vouloir accepter cette candidature ?';

  @override
  String get instApplicantConfirmReject =>
      'Etes-vous sur de vouloir rejeter cette candidature ?';

  @override
  String get instApplicantReviewNotesOptional =>
      'Notes de revision (Facultatif)';

  @override
  String get instApplicantReviewNotesRequired =>
      'Notes de revision (Obligatoire)';

  @override
  String get instApplicantAddComments =>
      'Ajoutez des commentaires sur votre decision...';

  @override
  String get instApplicantCancel => 'Annuler';

  @override
  String get instApplicantNotesRequiredRejection =>
      'Les notes de revision sont obligatoires pour un rejet';

  @override
  String get instApplicantAcceptedSuccess => 'Candidature acceptee avec succes';

  @override
  String get instApplicantRejectedSuccess => 'Candidature rejetee';

  @override
  String instApplicantErrorProcessingReview(String error) {
    return 'Erreur lors du traitement de la revision : $error';
  }

  @override
  String get instApplicantReceived => 'RECU';

  @override
  String get instApplicantViewLetter => 'Voir la lettre';

  @override
  String get instApplicantDownload => 'Telecharger';

  @override
  String get instApplicantRetry => 'Reessayer';

  @override
  String get instApplicantSearchHint => 'Rechercher des candidats...';

  @override
  String instApplicantTabAll(int count) {
    return 'Tous ($count)';
  }

  @override
  String instApplicantTabPending(int count) {
    return 'En attente ($count)';
  }

  @override
  String instApplicantTabUnderReview(int count) {
    return 'En examen ($count)';
  }

  @override
  String instApplicantTabAccepted(int count) {
    return 'Acceptes ($count)';
  }

  @override
  String instApplicantTabRejected(int count) {
    return 'Rejetes ($count)';
  }

  @override
  String get instApplicantLoading => 'Chargement des candidats...';

  @override
  String get instApplicantNoApplicantsFound => 'Aucun candidat trouve';

  @override
  String get instApplicantTryAdjustingSearch =>
      'Essayez d\'ajuster votre recherche';

  @override
  String get instApplicantNoAppsInCategory =>
      'Aucune candidature dans cette categorie';

  @override
  String instApplicantGpaValue(String gpa) {
    return 'Moyenne : $gpa';
  }

  @override
  String instApplicantSubmittedDate(String date) {
    return 'Soumis : $date';
  }

  @override
  String get instApplicantChipPending => 'En attente';

  @override
  String get instApplicantChipReviewing => 'En examen';

  @override
  String get instCourseEditCourse => 'Modifier le cours';

  @override
  String get instCourseCreateCourse => 'Creer un cours';

  @override
  String get instCourseBasicInfo => 'Informations de base';

  @override
  String get instCourseTitleLabel => 'Titre du cours *';

  @override
  String get instCourseTitleHint => 'ex., Introduction a la programmation';

  @override
  String get instCourseTitleRequired => 'Le titre est obligatoire';

  @override
  String get instCourseTitleMinLength =>
      'Le titre doit comporter au moins 3 caracteres';

  @override
  String get instCourseTitleMaxLength =>
      'Le titre doit comporter moins de 200 caracteres';

  @override
  String get instCourseDescriptionLabel => 'Description *';

  @override
  String get instCourseDescriptionHint =>
      'Decrivez ce que les etudiants apprendront...';

  @override
  String get instCourseDescriptionRequired => 'La description est obligatoire';

  @override
  String get instCourseDescriptionMinLength =>
      'La description doit comporter au moins 10 caracteres';

  @override
  String get instCourseCourseDetails => 'Details du cours';

  @override
  String get instCourseCourseType => 'Type de cours *';

  @override
  String get instCourseDifficultyLevel => 'Niveau de difficulte *';

  @override
  String get instCourseDurationHours => 'Duree (heures)';

  @override
  String get instCourseCategory => 'Categorie';

  @override
  String get instCourseCategoryHint => 'Informatique';

  @override
  String get instCoursePricing => 'Tarification';

  @override
  String get instCoursePriceLabel => 'Prix *';

  @override
  String get instCoursePriceRequired => 'Le prix est obligatoire';

  @override
  String get instCourseInvalidPrice => 'Prix invalide';

  @override
  String get instCourseCurrency => 'Devise';

  @override
  String get instCourseMaxStudents => 'Nombre max d\'etudiants (facultatif)';

  @override
  String get instCourseMaxStudentsHint => 'Laisser vide pour illimite';

  @override
  String get instCourseMedia => 'Medias';

  @override
  String get instCourseThumbnailUrl => 'URL de la miniature (facultatif)';

  @override
  String get instCourseTags => 'Tags';

  @override
  String get instCourseAddTagHint =>
      'Ajouter un tag (ex., programmation, python)';

  @override
  String get instCourseLearningOutcomes => 'Resultats d\'apprentissage';

  @override
  String get instCourseOutcomeHint => 'Qu\'apprendront les etudiants ?';

  @override
  String get instCoursePrerequisites => 'Prerequis';

  @override
  String get instCoursePrerequisiteHint => 'Que doivent savoir les etudiants ?';

  @override
  String get instCourseUpdateCourse => 'Mettre a jour le cours';

  @override
  String get instCourseCreatedSuccess => 'Cours cree avec succes !';

  @override
  String get instCourseUpdatedSuccess => 'Cours mis a jour avec succes !';

  @override
  String get instCourseFailedToSave =>
      'Echec de l\'enregistrement du cours. Veuillez reessayer.';

  @override
  String get instCourseCourseRoster => 'Liste des inscrits';

  @override
  String get instCourseRefresh => 'Actualiser';

  @override
  String get instCourseRetry => 'Reessayer';

  @override
  String get instCourseNoEnrolledStudents =>
      'Aucun etudiant inscrit pour le moment';

  @override
  String get instCourseApprovedStudentsAppearHere =>
      'Les etudiants avec des autorisations approuvees apparaitront ici';

  @override
  String get instCourseEnrolledStudents => 'Etudiants inscrits';

  @override
  String get instCourseMaxCapacity => 'Capacite maximale';

  @override
  String instCourseEnrolledDate(String date) {
    return 'Inscrit : $date';
  }

  @override
  String get instCourseEnrollmentPermissions => 'Autorisations d\'inscription';

  @override
  String get instCoursePendingRequests => 'Demandes en attente';

  @override
  String get instCourseApproved => 'Approuve';

  @override
  String get instCourseAllStudents => 'Tous les etudiants';

  @override
  String get instCourseGrantPermission => 'Accorder l\'autorisation';

  @override
  String get instCourseSelectAtLeastOne =>
      'Veuillez selectionner au moins un etudiant';

  @override
  String instCourseGrantedPermission(int count) {
    return 'Autorisation accordee a $count etudiant(s)';
  }

  @override
  String instCourseFailedGrantPermission(int count) {
    return 'Echec de l\'autorisation pour $count etudiant(s)';
  }

  @override
  String get instCourseGrantEnrollmentPermission =>
      'Accorder l\'autorisation d\'inscription';

  @override
  String get instCourseSelectStudentsGrant =>
      'Selectionnez les etudiants pour accorder l\'acces a ce cours';

  @override
  String get instCourseSearchStudents => 'Rechercher des etudiants...';

  @override
  String instCourseSelectedCount(int count) {
    return '$count selectionne(s)';
  }

  @override
  String get instCourseClear => 'Effacer';

  @override
  String get instCourseCancel => 'Annuler';

  @override
  String get instCourseSelectStudents => 'Selectionner des etudiants';

  @override
  String instCourseGrantToStudents(int count) {
    return 'Accorder a $count etudiant(s)';
  }

  @override
  String get instCourseNoStudentsAvailable => 'Aucun etudiant disponible';

  @override
  String get instCourseAllStudentsHavePermissions =>
      'Tous les etudiants admis ont deja des autorisations';

  @override
  String get instCourseNoMatchingStudents => 'Aucun etudiant correspondant';

  @override
  String get instCourseNoPendingRequests => 'Aucune demande en attente';

  @override
  String get instCourseStudentsCanRequest =>
      'Les etudiants peuvent demander l\'autorisation d\'inscription';

  @override
  String get instCourseMessage => 'Message :';

  @override
  String instCourseRequested(String date) {
    return 'Demande : $date';
  }

  @override
  String get instCourseDeny => 'Refuser';

  @override
  String get instCourseApprove => 'Approuver';

  @override
  String instCourseApprovedStudent(String name) {
    return '$name approuve';
  }

  @override
  String get instCourseFailedToApprove => 'Echec de l\'approbation';

  @override
  String get instCourseDenyPermissionRequest =>
      'Refuser la demande d\'autorisation';

  @override
  String instCourseDenyStudent(String name) {
    return 'Refuser $name ?';
  }

  @override
  String get instCourseReasonForDenial => 'Raison du refus';

  @override
  String get instCourseEnterReason => 'Saisir la raison...';

  @override
  String get instCoursePleaseProvideReason => 'Veuillez fournir une raison';

  @override
  String instCourseDeniedStudent(String name) {
    return '$name refuse';
  }

  @override
  String get instCourseNoApprovedPermissions => 'Aucune autorisation approuvee';

  @override
  String get instCourseGrantToAllowEnroll =>
      'Accordez des autorisations pour permettre aux etudiants de s\'inscrire';

  @override
  String get instCourseRevokePermission => 'Revoquer l\'autorisation';

  @override
  String instCourseRevokePermissionFor(String name) {
    return 'Revoquer l\'autorisation pour $name ?';
  }

  @override
  String get instCourseReasonOptional => 'Raison (facultatif)';

  @override
  String get instCourseRevoke => 'Revoquer';

  @override
  String instCourseRevokedPermissionFor(String name) {
    return 'Autorisation revoquee pour $name';
  }

  @override
  String get instCourseNoAdmittedStudents => 'Aucun etudiant admis';

  @override
  String get instCourseAcceptedStudentsAppearHere =>
      'Les etudiants avec des candidatures acceptees apparaitront ici';

  @override
  String get instCourseRequestPending => 'Demande en attente';

  @override
  String get instCourseAccessGranted => 'Acces accorde';

  @override
  String get instCourseDenied => 'Refuse';

  @override
  String get instCourseRevoked => 'Revoque';

  @override
  String get instCourseGrantAccess => 'Accorder l\'acces';

  @override
  String instCourseGrantStudentPermission(String name) {
    return 'Accorder a $name l\'autorisation de s\'inscrire a ce cours ?';
  }

  @override
  String get instCourseNotesOptional => 'Notes (facultatif)';

  @override
  String get instCourseAddNotes => 'Ajouter des notes...';

  @override
  String get instCourseGrant => 'Accorder';

  @override
  String instCourseGrantedPermissionTo(String name) {
    return 'Autorisation accordee a $name';
  }

  @override
  String get instCourseFailedToGrantPermission =>
      'Echec de l\'accord de l\'autorisation';

  @override
  String get instCourseRequestApproved => 'Demande approuvee';

  @override
  String get instCourseFailedToApproveRequest =>
      'Echec de l\'approbation de la demande';

  @override
  String get instCourseContentBuilder => 'Constructeur de contenu de cours';

  @override
  String get instCoursePreviewCourse => 'Apercu du cours';

  @override
  String get instCourseAddModule => 'Ajouter un module';

  @override
  String get instCourseCourseTitle => 'Titre du cours';

  @override
  String get instCourseEditInfo => 'Modifier les infos';

  @override
  String get instCourseCourseModules => 'Modules du cours';

  @override
  String get instCourseNoModulesYet => 'Aucun module pour le moment';

  @override
  String get instCourseStartBuildingModules =>
      'Commencez a construire votre cours en ajoutant des modules';

  @override
  String instCourseModuleIndex(int index) {
    return 'Module $index';
  }

  @override
  String instCourseLessonsCount(int count) {
    return '$count lecons';
  }

  @override
  String get instCourseEditModule => 'Modifier le module';

  @override
  String get instCourseDeleteModule => 'Supprimer le module';

  @override
  String get instCourseLearningObjectives => 'Objectifs d\'apprentissage :';

  @override
  String get instCourseLessons => 'Lecons';

  @override
  String get instCourseAddLesson => 'Ajouter une lecon';

  @override
  String get instCourseNoLessonsInModule => 'Aucune lecon dans ce module';

  @override
  String get instCourseEditLesson => 'Modifier la lecon';

  @override
  String get instCourseDeleteLesson => 'Supprimer la lecon';

  @override
  String get instCourseError => 'Erreur';

  @override
  String instCourseModuleCreatedSuccess(String title) {
    return 'Module \"$title\" cree avec succes';
  }

  @override
  String instCourseModuleUpdatedSuccess(String title) {
    return 'Module \"$title\" mis a jour avec succes';
  }

  @override
  String get instCourseAddNewLesson => 'Ajouter une nouvelle lecon';

  @override
  String get instCourseLessonType => 'Type de lecon';

  @override
  String get instCourseLessonTitle => 'Titre de la lecon';

  @override
  String get instCoursePleaseEnterTitle => 'Veuillez saisir un titre';

  @override
  String get instCourseDescription => 'Description';

  @override
  String get instCourseLessonCreatedSuccess => 'Lecon creee avec succes';

  @override
  String get instCourseCreate => 'Creer';

  @override
  String get instCourseDeleteModuleConfirm =>
      'Etes-vous sur de vouloir supprimer ce module ? Cela supprimera egalement toutes les lecons du module.';

  @override
  String get instCourseDelete => 'Supprimer';

  @override
  String get instCourseModuleDeletedSuccess => 'Module supprime avec succes';

  @override
  String get instCourseDeleteLessonConfirm =>
      'Etes-vous sur de vouloir supprimer cette lecon ?';

  @override
  String get instCourseLessonDeletedSuccess => 'Lecon supprimee avec succes';

  @override
  String get instCourseEditCourseInfo => 'Modifier les infos du cours';

  @override
  String get instCourseEnterTitle => 'Saisir le titre du cours';

  @override
  String get instCourseEnterDescription => 'Saisir la description du cours';

  @override
  String get instCourseLevel => 'Niveau';

  @override
  String get instCourseInfoUpdatedSuccess =>
      'Informations du cours mises a jour avec succes';

  @override
  String get instCourseSaving => 'Enregistrement...';

  @override
  String get instCourseSaveChanges => 'Enregistrer les modifications';

  @override
  String get instProgramCreateProgram => 'Creer un programme';

  @override
  String get instProgramNameLabel => 'Nom du programme *';

  @override
  String get instProgramNameHint => 'ex., Licence en informatique';

  @override
  String get instProgramDescriptionLabel => 'Description *';

  @override
  String get instProgramDescriptionHint => 'Decrivez le programme...';

  @override
  String get instProgramCategoryLabel => 'Categorie *';

  @override
  String get instProgramLevelLabel => 'Niveau *';

  @override
  String get instProgramDuration => 'Duree';

  @override
  String get instProgramFeeLabel => 'Frais du programme (USD) *';

  @override
  String get instProgramMaxStudentsLabel => 'Nombre maximum d\'etudiants *';

  @override
  String get instProgramMaxStudentsHint => 'ex., 100';

  @override
  String get instProgramStartDate => 'Date de debut';

  @override
  String get instProgramApplicationDeadline => 'Date limite de candidature';

  @override
  String get instProgramRequirements => 'Conditions requises';

  @override
  String get instProgramAddRequirementHint => 'Ajouter une condition...';

  @override
  String get instProgramAddAtLeastOneRequirement =>
      'Veuillez ajouter au moins une condition';

  @override
  String get instProgramDeadlineBeforeStart =>
      'La date limite de candidature doit etre avant la date de debut';

  @override
  String get instProgramCreatedSuccess => 'Programme cree avec succes !';

  @override
  String get instProgramFailedToCreate => 'Echec de la creation du programme';

  @override
  String instProgramErrorCreating(String error) {
    return 'Erreur lors de la creation du programme : $error';
  }

  @override
  String get instProgramDetails => 'Details du programme';

  @override
  String get instProgramBack => 'Retour';

  @override
  String get instProgramEditComingSoon =>
      'Fonction de modification bientot disponible';

  @override
  String get instProgramEditProgram => 'Modifier le programme';

  @override
  String get instProgramDeactivate => 'Desactiver';

  @override
  String get instProgramActivate => 'Activer';

  @override
  String get instProgramDeleteProgram => 'Supprimer le programme';

  @override
  String get instProgramInactiveMessage =>
      'Ce programme est actuellement inactif et n\'accepte pas de candidatures';

  @override
  String get instProgramEnrolled => 'Inscrits';

  @override
  String get instProgramAvailable => 'Disponible';

  @override
  String get instProgramFee => 'Frais';

  @override
  String get instProgramDescription => 'Description';

  @override
  String get instProgramProgramDetails => 'Details du programme';

  @override
  String get instProgramCategory => 'Categorie';

  @override
  String get instProgramInstitution => 'Institution';

  @override
  String get instProgramMaxStudents => 'Nombre maximum d\'etudiants';

  @override
  String get instProgramEnrollmentStatus => 'Statut d\'inscription';

  @override
  String get instProgramFillRate => 'Taux de remplissage';

  @override
  String get instProgramIsFull => 'Le programme est complet';

  @override
  String instProgramSlotsRemaining(int count) {
    return '$count places restantes';
  }

  @override
  String get instProgramDeactivateQuestion => 'Desactiver le programme ?';

  @override
  String get instProgramActivateQuestion => 'Activer le programme ?';

  @override
  String get instProgramStopAccepting =>
      'Ce programme cessera d\'accepter de nouvelles candidatures.';

  @override
  String get instProgramStartAccepting =>
      'Ce programme commencera a accepter de nouvelles candidatures.';

  @override
  String get instProgramCancel => 'Annuler';

  @override
  String get instProgramConfirm => 'Confirmer';

  @override
  String get instProgramActivated => 'Programme active';

  @override
  String get instProgramDeactivated => 'Programme desactive';

  @override
  String instProgramErrorUpdatingStatus(String error) {
    return 'Erreur de mise a jour du statut du programme : $error';
  }

  @override
  String get instProgramDeleteProgramQuestion => 'Supprimer le programme ?';

  @override
  String get instProgramDeleteConfirm =>
      'Cette action est irreversible. Toutes les donnees associees a ce programme seront definitivement supprimees.';

  @override
  String get instProgramDelete => 'Supprimer';

  @override
  String get instProgramDeletedSuccess => 'Programme supprime avec succes';

  @override
  String get instProgramFailedToDelete =>
      'Echec de la suppression du programme';

  @override
  String instProgramErrorDeleting(String error) {
    return 'Erreur lors de la suppression du programme : $error';
  }

  @override
  String get instProgramPrograms => 'Programmes';

  @override
  String get instProgramRetry => 'Reessayer';

  @override
  String get instProgramLoading => 'Chargement des programmes...';

  @override
  String get instProgramActiveOnly => 'Actifs uniquement';

  @override
  String get instProgramShowAll => 'Afficher tout';

  @override
  String get instProgramSearchHint => 'Rechercher des programmes...';

  @override
  String get instProgramNewProgram => 'Nouveau programme';

  @override
  String get instProgramNoProgramsFound => 'Aucun programme trouve';

  @override
  String get instProgramTryAdjustingSearch =>
      'Essayez d\'ajuster votre recherche';

  @override
  String get instProgramCreateFirstProgram => 'Creez votre premier programme';

  @override
  String get instProgramInactive => 'INACTIF';

  @override
  String get instProgramEnrollment => 'Inscription';

  @override
  String get instProgramFull => 'Complet';

  @override
  String instProgramSlotsAvailable(int count) {
    return '$count places disponibles';
  }

  @override
  String get instCounselorSearchHint => 'Rechercher des conseillers...';

  @override
  String get instCounselorRetry => 'Reessayer';

  @override
  String get instCounselorNoCounselorsFound => 'Aucun conseiller trouve';

  @override
  String get instCounselorNoMatchSearch =>
      'Aucun conseiller ne correspond a votre recherche';

  @override
  String get instCounselorAddToInstitution =>
      'Ajoutez des conseillers a votre institution';

  @override
  String instCounselorPageOf(int current, int total) {
    return 'Page $current sur $total';
  }

  @override
  String get instCounselorCounselingOverview => 'Apercu du conseil';

  @override
  String get instCounselorCounselors => 'Conseillers';

  @override
  String get instCounselorStudents => 'Etudiants';

  @override
  String get instCounselorSessions => 'Seances';

  @override
  String get instCounselorCompleted => 'Terminees';

  @override
  String get instCounselorUpcoming => 'A venir';

  @override
  String get instCounselorAvgRating => 'Note moy.';

  @override
  String get instCounselorStudentAssigned => 'Etudiant assigne avec succes';

  @override
  String get instCounselorAssign => 'Assigner';

  @override
  String get instCounselorTotalSessions => 'Total des seances';

  @override
  String get instCounselorAssignStudents => 'Assigner des etudiants';

  @override
  String instCounselorAssignStudentTo(String name) {
    return 'Assigner un etudiant a $name';
  }

  @override
  String get instCounselorSearchStudents => 'Rechercher des etudiants...';

  @override
  String get instCounselorNoStudentsFound => 'Aucun etudiant trouve';

  @override
  String get instCounselorCancel => 'Annuler';

  @override
  String get studentCounselingBookSession => 'Reserver une seance';

  @override
  String get studentCounselingSelectDate => 'Selectionner la date';

  @override
  String get studentCounselingSelectTime => 'Selectionner l\'heure';

  @override
  String get studentCounselingSessionType => 'Type de seance';

  @override
  String get studentCounselingTopicOptional => 'Sujet (Facultatif)';

  @override
  String get studentCounselingTopicHint => 'De quoi aimeriez-vous discuter ?';

  @override
  String get studentCounselingDetailsOptional =>
      'Details supplementaires (Facultatif)';

  @override
  String get studentCounselingDetailsHint =>
      'Toute information supplementaire pour votre conseiller...';

  @override
  String get studentCounselingSessionSummary => 'Resume de la seance';

  @override
  String get studentCounselingCounselor => 'Conseiller';

  @override
  String get studentCounselingDate => 'Date';

  @override
  String get studentCounselingTime => 'Heure';

  @override
  String get studentCounselingType => 'Type';

  @override
  String get studentCounselingTopic => 'Sujet';

  @override
  String get studentCounselingBookedSuccess => 'Seance reservee avec succes !';

  @override
  String get studentCounselingBookFailed =>
      'Echec de la reservation de la seance';

  @override
  String studentCounselingUpcomingTab(int count) {
    return 'A venir ($count)';
  }

  @override
  String studentCounselingPastTab(int count) {
    return 'Passees ($count)';
  }

  @override
  String get studentCounselingContactAdmin =>
      'Veuillez contacter l\'administrateur de votre etablissement pour l\'attribution d\'un conseiller.';

  @override
  String get studentCounselingTotal => 'Total';

  @override
  String get studentCounselingCompleted => 'Terminees';

  @override
  String get studentCounselingUpcoming => 'A venir';

  @override
  String get studentCounselingRating => 'Note';

  @override
  String get studentCounselingNoUpcoming => 'Aucune seance a venir programmee';

  @override
  String get studentCounselingNoPast => 'Aucune seance passee';

  @override
  String get studentCounselingCancelSession => 'Annuler la seance';

  @override
  String get studentCounselingCancelConfirm =>
      'Etes-vous sur de vouloir annuler cette seance ? Cette action est irreversible.';

  @override
  String get studentCounselingKeepIt => 'Non, la garder';

  @override
  String get studentCounselingSessionCancelled => 'Seance annulee';

  @override
  String get studentCounselingYesCancel => 'Oui, annuler';

  @override
  String get studentCounselingRateSession => 'Evaluez votre seance';

  @override
  String get studentCounselingHowWasSession =>
      'Comment s\'est passee votre seance de conseil ?';

  @override
  String get studentCounselingCommentsOptional => 'Commentaires (facultatif)';

  @override
  String get studentCounselingCancel => 'Annuler';

  @override
  String get studentCounselingFeedbackThanks => 'Merci pour votre retour !';

  @override
  String get studentCounselingSubmit => 'Soumettre';

  @override
  String get studentCounselingSessions => 'Seances';

  @override
  String get studentCounselingAvailability => 'Disponibilite';

  @override
  String get studentCounselingBookASession => 'Reserver une seance';

  @override
  String get studentCounselingDuration => 'Duree';

  @override
  String studentCounselingMinutes(int count) {
    return '$count minutes';
  }

  @override
  String get studentCounselingNotes => 'Notes';

  @override
  String get studentCounselingYourFeedback => 'Votre avis';

  @override
  String get studentCounselingLeaveFeedback => 'Laisser un avis';

  @override
  String get studentHelpTitle => 'Aide et support';

  @override
  String get studentHelpSearchHint => 'Rechercher de l\'aide...';

  @override
  String get studentHelpQuickHelp => 'Aide rapide';

  @override
  String get studentHelpLiveChat => 'Chat en direct';

  @override
  String get studentHelpChatWithSupport => 'Discuter avec le support';

  @override
  String get studentHelpEmailUs => 'Nous contacter';

  @override
  String get studentHelpEmailAddress => 'support@flow.edu';

  @override
  String get studentHelpTutorials => 'Tutoriels';

  @override
  String get studentHelpVideoGuides => 'Guides video';

  @override
  String get studentHelpUserGuide => 'Guide utilisateur';

  @override
  String get studentHelpFullDocumentation => 'Documentation complete';

  @override
  String get studentHelpFaq => 'Questions frequemment posees';

  @override
  String get studentHelpSearchResults => 'Resultats de recherche';

  @override
  String get studentHelpNoResults => 'Aucun resultat trouve';

  @override
  String get studentHelpTryDifferentKeywords =>
      'Essayez d\'autres mots-cles ou contactez le support';

  @override
  String get studentHelpContactSupport => 'Contacter le support';

  @override
  String studentHelpQuestionsCount(int count) {
    return '$count questions';
  }

  @override
  String studentHelpComingSoon(String feature) {
    return '$feature bientot disponible !';
  }

  @override
  String get studentHelpReachOut =>
      'Besoin d\'aide ? Contactez-nous via l\'un de ces canaux :';

  @override
  String get studentHelpEmail => 'E-mail';

  @override
  String get studentHelpPhone => 'Telephone';

  @override
  String get studentHelpHours => 'Horaires';

  @override
  String get studentHelpBusinessHours => 'Lun-Ven, 9h - 18h EST';

  @override
  String get studentHelpClose => 'Fermer';

  @override
  String get studentHelpOpeningEmail => 'Ouverture du client e-mail...';

  @override
  String get studentHelpSendEmail => 'Envoyer un e-mail';

  @override
  String get parentLinkTitle => 'Liaison parentale';

  @override
  String get parentLinkLinkedTab => 'Lies';

  @override
  String get parentLinkRequestsTab => 'Demandes';

  @override
  String get parentLinkInviteCodesTab => 'Codes d\'invitation';

  @override
  String get parentLinkLoadingLinked => 'Chargement des parents lies...';

  @override
  String get parentLinkNoLinkedParents => 'Aucun parent lie';

  @override
  String get parentLinkNoLinkedMessage =>
      'Lorsqu\'un parent lie son compte au votre, il apparaitra ici.';

  @override
  String get parentLinkRefresh => 'Actualiser';

  @override
  String parentLinkManagePermissionsFor(String name) {
    return 'Gerer les permissions pour $name';
  }

  @override
  String get parentLinkControlPermissions =>
      'Controlez ce que ce parent peut voir :';

  @override
  String get parentLinkViewGrades => 'Voir les notes';

  @override
  String get parentLinkAllowViewGrades =>
      'Autoriser la consultation de vos notes academiques';

  @override
  String get parentLinkViewActivity => 'Voir l\'activite';

  @override
  String get parentLinkAllowViewActivity =>
      'Autoriser la consultation de votre activite';

  @override
  String get parentLinkViewMessages => 'Voir les messages';

  @override
  String get parentLinkAllowViewMessages =>
      'Autoriser la consultation de vos messages (prive)';

  @override
  String get parentLinkReceiveAlerts => 'Recevoir des alertes';

  @override
  String get parentLinkSendAlerts =>
      'Envoyer des alertes sur les mises a jour importantes';

  @override
  String get parentLinkCancel => 'Annuler';

  @override
  String get parentLinkSave => 'Enregistrer';

  @override
  String get parentLinkPermissionsUpdated => 'Permissions mises a jour';

  @override
  String get parentLinkUnlinkParent => 'Delier le parent';

  @override
  String parentLinkUnlinkConfirm(String name) {
    return 'Etes-vous sur de vouloir delier $name ? Il/elle ne pourra plus consulter vos informations.';
  }

  @override
  String get parentLinkUnlink => 'Delier';

  @override
  String parentLinkUnlinked(String name) {
    return '$name a ete delie(e)';
  }

  @override
  String get parentLinkLinked => 'Lie';

  @override
  String get parentLinkPermissions => 'Permissions :';

  @override
  String get parentLinkManage => 'Gerer';

  @override
  String get parentLinkLoadingRequests => 'Chargement des demandes...';

  @override
  String get parentLinkNoPendingRequests => 'Aucune demande en attente';

  @override
  String get parentLinkNoPendingMessage =>
      'Vous n\'avez aucune demande de liaison parentale a examiner.';

  @override
  String parentLinkApproved(String name) {
    return '$name a ete lie(e) a votre compte';
  }

  @override
  String get parentLinkDeclineRequest => 'Refuser la demande';

  @override
  String parentLinkDeclineConfirm(String name) {
    return 'Etes-vous sur de vouloir refuser la demande de liaison de $name ?';
  }

  @override
  String get parentLinkDecline => 'Refuser';

  @override
  String get parentLinkRequestDeclined => 'Demande refusee';

  @override
  String get parentLinkRequestedPermissions => 'Permissions demandees :';

  @override
  String get parentLinkApprove => 'Approuver';

  @override
  String get parentLinkGenerateNewCode =>
      'Generer un nouveau code d\'invitation';

  @override
  String get parentLinkShareCodeInfo =>
      'Partagez votre code d\'invitation avec votre parent pour qu\'il puisse lier son compte au votre.';

  @override
  String get parentLinkNoInviteCodes => 'Aucun code d\'invitation';

  @override
  String get parentLinkNoCodesMessage =>
      'Generez un code d\'invitation a partager avec votre parent.';

  @override
  String get parentLinkGenerateInviteCode => 'Generer un code d\'invitation';

  @override
  String get parentLinkConfigureCode =>
      'Configurez les parametres de votre code d\'invitation :';

  @override
  String get parentLinkGenerate => 'Generer';

  @override
  String get parentLinkCodeGenerated => 'Code genere !';

  @override
  String get parentLinkShareCode => 'Partagez ce code avec votre parent :';

  @override
  String get parentLinkCodeCopied => 'Code copie dans le presse-papiers';

  @override
  String get parentLinkDone => 'Termine';

  @override
  String get parentLinkDeleteCode => 'Supprimer le code d\'invitation';

  @override
  String get parentLinkDeleteCodeConfirm =>
      'Etes-vous sur de vouloir supprimer ce code d\'invitation ?';

  @override
  String get parentLinkDelete => 'Supprimer';

  @override
  String get studentProgressLoading => 'Chargement de la progression...';

  @override
  String get studentProgressTitle => 'Ma progression';

  @override
  String get studentProgressError => 'Erreur de chargement de la progression';

  @override
  String get studentProgressRetry => 'Reessayer';

  @override
  String get studentProgressNoData => 'Aucune donnee de progression';

  @override
  String get studentProgressEnrollMessage =>
      'Inscrivez-vous a des cours pour commencer a suivre votre progression.';

  @override
  String get studentProgressOverview => 'Apercu';

  @override
  String get studentProgressCourses => 'Cours';

  @override
  String get studentProgressAvgGrade => 'Note moyenne';

  @override
  String get studentProgressCompletion => 'Achevement';

  @override
  String get studentProgressAssignments => 'Devoirs';

  @override
  String get studentProgressGradeTrend => 'Tendance des notes';

  @override
  String get studentProgressStudyTime => 'Temps d\'etude (Heures)';

  @override
  String get studentProgressCourseCompletion => 'Achevement des cours';

  @override
  String get studentProgressCompleted => 'Termines';

  @override
  String get studentProgressInProgress => 'En cours';

  @override
  String get studentProgressProgress => 'Progression';

  @override
  String get studentProgressAppSuccessRate =>
      'Taux de reussite des candidatures';

  @override
  String get studentProgressNoAppData =>
      'Aucune donnee de candidature disponible';

  @override
  String get studentProgressNoAppsYet => 'Aucune candidature pour le moment';

  @override
  String get studentProgressAcceptanceRate => 'Taux d\'acceptation';

  @override
  String get studentProgressGpaTrend => 'Tendance de la MPC';

  @override
  String get studentProgressNoGpaData => 'Aucune donnee de MPC disponible';

  @override
  String get studentProgressCurrentGpa => 'MPC actuelle';

  @override
  String get studentProgressGoalGpa => 'MPC visee';

  @override
  String get studentProgressTrend => 'Tendance';

  @override
  String get studentProgressHistoricalGpa =>
      'Les donnees historiques de MPC apparaitront ici au fur et a mesure de votre progression';

  @override
  String get studentProgressCurrentGrade => 'Note actuelle';

  @override
  String get studentProgressTimeSpent => 'Temps consacre';

  @override
  String get studentProgressModules => 'Modules';

  @override
  String get studentProgressRecentGrades => 'Notes recentes';

  @override
  String get studentProgressFeedback => 'Commentaires';

  @override
  String get studentRecTitle => 'Lettres de recommandation';

  @override
  String studentRecAllTab(int count) {
    return 'Toutes ($count)';
  }

  @override
  String studentRecPendingTab(int count) {
    return 'En attente ($count)';
  }

  @override
  String studentRecInProgressTab(int count) {
    return 'En cours ($count)';
  }

  @override
  String studentRecCompletedTab(int count) {
    return 'Terminees ($count)';
  }

  @override
  String get studentRecRetry => 'Reessayer';

  @override
  String get studentRecLoadingRequests => 'Chargement des demandes...';

  @override
  String get studentRecRequestLetter => 'Demander une lettre';

  @override
  String get studentRecNoPending =>
      'Aucune demande de recommandation en attente';

  @override
  String get studentRecNoInProgress => 'Aucune lettre en cours de redaction';

  @override
  String get studentRecNoCompleted =>
      'Aucune lettre de recommandation terminee';

  @override
  String get studentRecNoRequests =>
      'Aucune demande de recommandation.\nAppuyez sur + pour demander une lettre.';

  @override
  String get studentRecNoRequestsTitle => 'Aucune demande';

  @override
  String get studentRecRequestSent =>
      'Demande de recommandation envoyee ! Le recommandeur recevra une invitation par e-mail.';

  @override
  String get studentRecFailedToSend => 'Echec de l\'envoi de la demande';

  @override
  String get studentRecStatus => 'Statut';

  @override
  String get studentRecType => 'Type';

  @override
  String get studentRecPurpose => 'Objectif';

  @override
  String get studentRecInstitution => 'Etablissement';

  @override
  String get studentRecDeadline => 'Date limite';

  @override
  String get studentRecRequested => 'Demandee le';

  @override
  String get studentRecDeclineReason => 'Raison du refus';

  @override
  String get studentRecClose => 'Fermer';

  @override
  String get studentRecCancelRequest => 'Annuler la demande';

  @override
  String get studentRecSendReminder => 'Envoyer un rappel';

  @override
  String get studentRecCancelRequestTitle => 'Annuler la demande ?';

  @override
  String get studentRecCancelRequestConfirm =>
      'Etes-vous sur de vouloir annuler cette demande de recommandation ?';

  @override
  String get studentRecNo => 'Non';

  @override
  String get studentRecYesCancel => 'Oui, annuler';

  @override
  String get studentRecRequestCancelled => 'Demande annulee';

  @override
  String get studentRecFailedToCancel => 'Echec de l\'annulation de la demande';

  @override
  String get studentRecReminderSent => 'Rappel envoye !';

  @override
  String get studentRecFailedReminder => 'Echec de l\'envoi du rappel';

  @override
  String get studentRecCompleted => 'Terminee';

  @override
  String get studentRecOverdue => 'En retard !';

  @override
  String get studentRecDueToday => 'A remettre aujourd\'hui';

  @override
  String studentRecDaysLeft(int count) {
    return '$count jours restants';
  }

  @override
  String get studentRecEdit => 'Modifier';

  @override
  String get studentRecCancel => 'Annuler';

  @override
  String get studentRecRemind => 'Rappeler';

  @override
  String get studentRecRequestRecLetter =>
      'Demander une lettre de recommandation';

  @override
  String get studentRecRecommenderEmail => 'E-mail du recommandeur *';

  @override
  String get studentRecEmailHelperText =>
      'Il/elle recevra une invitation pour soumettre la recommandation';

  @override
  String get studentRecEnterEmail =>
      'Veuillez saisir l\'e-mail du recommandeur';

  @override
  String get studentRecValidEmail =>
      'Veuillez saisir une adresse e-mail valide';

  @override
  String get studentRecRecommenderName => 'Nom du recommandeur *';

  @override
  String get studentRecNameHint => 'Dr. Jean Dupont';

  @override
  String get studentRecEnterName => 'Veuillez saisir le nom du recommandeur';

  @override
  String get studentRecTypeRequired => 'Type *';

  @override
  String get studentRecAcademic => 'Academique';

  @override
  String get studentRecProfessional => 'Professionnel';

  @override
  String get studentRecCharacter => 'Personnel';

  @override
  String get studentRecScholarship => 'Bourse';

  @override
  String get studentRecPurposeRequired => 'Objectif *';

  @override
  String get studentRecPurposeHint =>
      'ex. Candidature aux etudes superieures, Candidature a un emploi';

  @override
  String get studentRecPurposeValidation =>
      'Veuillez decrire l\'objectif (min 10 caracteres)';

  @override
  String get studentRecTargetInstitutions => 'Etablissements cibles *';

  @override
  String get studentRecNoAppsWarning =>
      'Vous n\'avez aucune candidature. Veuillez d\'abord soumettre des candidatures pour demander des recommandations.';

  @override
  String studentRecSelectInstitutions(int count) {
    return 'Selectionner les etablissements ($count selectionnes)';
  }

  @override
  String get studentRecSelectAtLeastOne =>
      'Veuillez selectionner au moins un etablissement';

  @override
  String get studentRecDeadlineRequired => 'Date limite *';

  @override
  String get studentRecPriority => 'Priorite';

  @override
  String get studentRecLow => 'Basse';

  @override
  String get studentRecNormal => 'Normale';

  @override
  String get studentRecHigh => 'Haute';

  @override
  String get studentRecUrgent => 'Urgente';

  @override
  String get studentRecMessageToRecommender => 'Message au recommandeur';

  @override
  String get studentRecMessageHint =>
      'Des points specifiques que vous aimeriez qu\'il/elle mette en avant ?';

  @override
  String get studentRecYourAchievements => 'Vos realisations';

  @override
  String get studentRecAchievementsHint =>
      'Listez les realisations pertinentes pour aider le recommandeur';

  @override
  String get studentRecYourGoals => 'Vos objectifs';

  @override
  String get studentRecGoalsHint =>
      'Quels sont vos objectifs de carriere/academiques ?';

  @override
  String get studentRecSendRequest => 'Envoyer la demande';

  @override
  String get studentRecEditRequest => 'Modifier la demande';

  @override
  String get studentRecTargetInstitution => 'Etablissement cible';

  @override
  String get studentRecInstitutionHint => 'Nom de l\'etablissement';

  @override
  String get studentRecSaveChanges => 'Enregistrer les modifications';

  @override
  String get studentRecRequestUpdated => 'Demande mise a jour avec succes !';

  @override
  String get studentRecFailedToUpdate =>
      'Echec de la mise a jour de la demande';

  @override
  String get studentResourcesTitle => 'Ressources';

  @override
  String get studentResourcesAllResources => 'Toutes les ressources';

  @override
  String get studentResourcesFavorites => 'Favoris';

  @override
  String get studentResourcesSearchHint => 'Rechercher des ressources...';

  @override
  String get studentResourcesAll => 'Toutes';

  @override
  String get studentResourcesNoResults => 'Aucune ressource trouvee';

  @override
  String get studentResourcesTryAdjusting =>
      'Essayez de modifier votre recherche ou vos filtres';

  @override
  String get studentResourcesRemovedFavorite => 'Retire des favoris';

  @override
  String get studentResourcesAddedFavorite => 'Ajoute aux favoris';

  @override
  String get studentResourcesOpenLink => 'Ouvrir le lien';

  @override
  String get studentResourcesDownload => 'Telecharger';

  @override
  String get studentScheduleTitle => 'Mon emploi du temps';

  @override
  String get studentScheduleGoToToday => 'Aller a aujourd\'hui';

  @override
  String get studentScheduleAddEventSoon =>
      'La fonctionnalite d\'ajout d\'evenement arrive bientot !';

  @override
  String get studentScheduleAddEvent => 'Ajouter un evenement';

  @override
  String get studentScheduleEnjoyFreeTime => 'Profitez de votre temps libre !';

  @override
  String get studentScheduleDate => 'Date';

  @override
  String get studentScheduleTime => 'Heure';

  @override
  String get studentScheduleLocation => 'Lieu';

  @override
  String get studentScheduleEditSoon =>
      'La fonctionnalite de modification arrive bientot !';

  @override
  String get studentScheduleEdit => 'Modifier';

  @override
  String get studentScheduleReminderSet => 'Rappel programme !';

  @override
  String get studentScheduleRemindMe => 'Me rappeler';

  @override
  String get parentChildAddChild => 'Ajouter un enfant';

  @override
  String get parentChildByEmail => 'Par e-mail';

  @override
  String get parentChildByCode => 'Par code';

  @override
  String get parentChildEmailDescription =>
      'Entrez l\'adresse e-mail de votre enfant pour lui envoyer une demande de lien.';

  @override
  String get parentChildStudentEmail => 'E-mail de l\'eleve';

  @override
  String get parentChildStudentEmailHint => 'eleve@exemple.com';

  @override
  String get parentChildEnterEmail => 'Veuillez entrer une adresse e-mail';

  @override
  String get parentChildValidEmail =>
      'Veuillez entrer une adresse e-mail valide';

  @override
  String get parentChildSendLinkRequest => 'Envoyer la demande de lien';

  @override
  String get parentChildApprovalNotice =>
      'Votre enfant recevra une notification pour approuver cette demande.';

  @override
  String get parentChildCodeDescription =>
      'Entrez le code d\'invitation que votre enfant a partage avec vous.';

  @override
  String get parentChildInviteCode => 'Code d\'invitation';

  @override
  String get parentChildInviteCodeHint => 'ABCD1234';

  @override
  String get parentChildEnterInviteCode =>
      'Veuillez entrer le code d\'invitation';

  @override
  String get parentChildCodeMinLength =>
      'Le code doit contenir au moins 6 caracteres';

  @override
  String get parentChildUseInviteCode => 'Utiliser le code d\'invitation';

  @override
  String get parentChildInviteCodeInfo =>
      'Demandez a votre enfant de generer un code d\'invitation depuis les parametres de son application.';

  @override
  String get parentChildRelationship => 'Relation';

  @override
  String get parentChildBack => 'Retour';

  @override
  String get parentChildOverview => 'Apercu';

  @override
  String get parentChildCourses => 'Cours';

  @override
  String get parentChildApplications => 'Candidatures';

  @override
  String get parentChildCounseling => 'Orientation';

  @override
  String get parentChildAcademicPerformance => 'Performance academique';

  @override
  String get parentChildAverageGrade => 'Note moyenne';

  @override
  String get parentChildActiveCourses => 'Cours actifs';

  @override
  String get parentChildSchool => 'Ecole';

  @override
  String get parentChildNotSet => 'Non defini';

  @override
  String get parentChildRecentActivity => 'Activite recente';

  @override
  String get parentChildCompletedAssignment => 'Devoir termine';

  @override
  String get parentChildMathChapter5 => 'Mathematiques - Test du chapitre 5';

  @override
  String parentChildHoursAgo(String count) {
    return 'Il y a $count heures';
  }

  @override
  String get parentChildSubmittedProject => 'Projet soumis';

  @override
  String get parentChildCsFinalProject => 'Informatique - Projet final';

  @override
  String parentChildDaysAgo(String count) {
    return 'Il y a $count jours';
  }

  @override
  String get parentChildReceivedGrade => 'Note recue';

  @override
  String get parentChildPhysicsLabReport =>
      'Physique - Rapport de laboratoire (92/100)';

  @override
  String get parentChildRetry => 'Reessayer';

  @override
  String get parentChildLoadingCourses => 'Chargement des cours...';

  @override
  String get parentChildNoCourseData => 'Aucune donnee de cours';

  @override
  String get parentChildNoCourseProgress =>
      'Aucune donnee de progression de cours disponible';

  @override
  String get parentChildCourseProgress => 'Progression du cours';

  @override
  String parentChildAssignments(String completed, String total) {
    return 'Devoirs : $completed/$total';
  }

  @override
  String get parentChildNoApplications => 'Aucune candidature';

  @override
  String get parentChildNoApplicationsYet =>
      'Votre enfant n\'a pas encore soumis de candidatures';

  @override
  String parentChildSubmitted(String date) {
    return 'Soumis le : $date';
  }

  @override
  String get parentChildStatusPending => 'En attente';

  @override
  String get parentChildStatusUnderReview => 'En cours d\'examen';

  @override
  String get parentChildStatusAccepted => 'Accepte';

  @override
  String get parentChildStatusRejected => 'Refuse';

  @override
  String get parentChildLoadingChildren => 'Chargement des enfants...';

  @override
  String get parentChildNoChildren => 'Aucun enfant';

  @override
  String get parentChildAddToMonitor =>
      'Ajoutez vos enfants pour suivre leur progression';

  @override
  String get parentChildAvg => 'MOY';

  @override
  String get parentChildLastActive => 'Derniere activite';

  @override
  String get parentChildPendingLinkRequests => 'Demandes de lien en attente';

  @override
  String get parentChildWaitingApproval =>
      'En attente de l\'approbation de l\'eleve';

  @override
  String get parentChildAwaitingApproval => 'En attente d\'approbation';

  @override
  String get parentChildNoCounselor => 'Aucun conseiller assigne';

  @override
  String parentChildNoCounselorDescription(String childName) {
    return '$childName n\'a pas encore de conseiller assigne.';
  }

  @override
  String parentChildChildCounselor(String childName) {
    return 'Conseiller de $childName';
  }

  @override
  String parentChildAssigned(String date) {
    return 'Assigne le : $date';
  }

  @override
  String get parentChildTotal => 'Total';

  @override
  String get parentChildUpcoming => 'A venir';

  @override
  String get parentChildCompleted => 'Terminees';

  @override
  String get parentChildUpcomingSessions => 'Seances a venir';

  @override
  String get parentChildNoUpcomingSessions => 'Aucune seance a venir';

  @override
  String get parentChildPastSessions => 'Seances passees';

  @override
  String get parentChildNoPastSessions => 'Aucune seance passee';

  @override
  String parentChildMinutes(String count) {
    return '$count min';
  }

  @override
  String get parentReportBack => 'Retour';

  @override
  String get parentReportAcademicReports => 'Rapports academiques';

  @override
  String get parentReportProgress => 'Progression';

  @override
  String get parentReportGrades => 'Notes';

  @override
  String get parentReportAttendance => 'Assiduite';

  @override
  String get parentReportStudentProgressReports =>
      'Rapports de progression des eleves';

  @override
  String get parentReportTrackProgress =>
      'Suivre la progression academique et l\'achevement des cours';

  @override
  String get parentReportNoProgressData => 'Aucune donnee de progression';

  @override
  String get parentReportAddChildrenProgress =>
      'Ajoutez des enfants pour voir leurs rapports de progression';

  @override
  String get parentReportCoursesEnrolled => 'Cours inscrits';

  @override
  String get parentReportApplications => 'Candidatures';

  @override
  String get parentReportOverallProgress => 'Progression globale';

  @override
  String get parentReportGradeReports => 'Rapports de notes';

  @override
  String get parentReportGradeBreakdown =>
      'Repartition detaillee des notes par matiere';

  @override
  String get parentReportNoGradeData => 'Aucune donnee de notes';

  @override
  String get parentReportAddChildrenGrades =>
      'Ajoutez des enfants pour voir leurs rapports de notes';

  @override
  String get parentReportAttendanceReports => 'Rapports d\'assiduite';

  @override
  String get parentReportTrackAttendance =>
      'Suivre l\'assiduite et la participation';

  @override
  String get parentReportNoAttendanceData => 'Aucune donnee d\'assiduite';

  @override
  String get parentReportAddChildrenAttendance =>
      'Ajoutez des enfants pour voir leurs rapports d\'assiduite';

  @override
  String get parentReportPresent => 'Present';

  @override
  String get parentReportLate => 'En retard';

  @override
  String get parentReportAbsent => 'Absent';

  @override
  String parentReportThisMonth(String present, String total) {
    return 'Ce mois-ci : $present sur $total jours present';
  }

  @override
  String get parentReportMathematics => 'Mathematiques';

  @override
  String get parentReportEnglish => 'Anglais';

  @override
  String get parentReportScience => 'Sciences';

  @override
  String get parentReportHistory => 'Histoire';

  @override
  String get parentMeetingBack => 'Retour';

  @override
  String get parentMeetingScheduleCounselor =>
      'Planifier une reunion avec le conseiller';

  @override
  String get parentMeetingScheduleTeacher =>
      'Planifier une reunion avec l\'enseignant';

  @override
  String get parentMeetingCounselorMeeting => 'Reunion avec le conseiller';

  @override
  String get parentMeetingParentTeacherConference =>
      'Conference parent-enseignant';

  @override
  String get parentMeetingCounselorDescription =>
      'Discuter de l\'orientation et de la planification academique';

  @override
  String get parentMeetingTeacherDescription =>
      'Discuter de la progression et des performances de l\'eleve';

  @override
  String get parentMeetingSelectStudent => 'Selectionner l\'eleve';

  @override
  String get parentMeetingNoChildren =>
      'Aucun enfant ajoute. Veuillez ajouter des enfants pour planifier des reunions.';

  @override
  String get parentMeetingSelectCounselor => 'Selectionner le conseiller';

  @override
  String get parentMeetingSelectTeacher => 'Selectionner l\'enseignant';

  @override
  String get parentMeetingNoCounselors =>
      'Aucun conseiller disponible pour le moment.';

  @override
  String get parentMeetingNoTeachers =>
      'Aucun enseignant disponible pour le moment.';

  @override
  String get parentMeetingCounselor => 'Conseiller';

  @override
  String get parentMeetingTeacher => 'Enseignant';

  @override
  String get parentMeetingSelectDateTime => 'Selectionner la date et l\'heure';

  @override
  String get parentMeetingDate => 'Date';

  @override
  String get parentMeetingSelectDate => 'Selectionner la date';

  @override
  String get parentMeetingTime => 'Heure';

  @override
  String get parentMeetingSelectTime => 'Selectionner l\'heure';

  @override
  String get parentMeetingMode => 'Mode de reunion';

  @override
  String get parentMeetingVideoCall => 'Appel video';

  @override
  String get parentMeetingInPerson => 'En personne';

  @override
  String get parentMeetingPhone => 'Telephone';

  @override
  String get parentMeetingDuration => 'Duree';

  @override
  String get parentMeetingDurationLabel => 'Duree de la reunion';

  @override
  String get parentMeeting15Min => '15 minutes';

  @override
  String get parentMeeting30Min => '30 minutes';

  @override
  String get parentMeeting45Min => '45 minutes';

  @override
  String get parentMeeting1Hour => '1 heure';

  @override
  String get parentMeeting1Point5Hours => '1h30';

  @override
  String get parentMeeting2Hours => '2 heures';

  @override
  String get parentMeetingSubject => 'Sujet de la reunion';

  @override
  String get parentMeetingSubjectLabel => 'Sujet';

  @override
  String get parentMeetingSubjectHint =>
      'ex. : Discussion sur la progression en mathematiques';

  @override
  String get parentMeetingAdditionalNotes =>
      'Notes supplementaires (Facultatif)';

  @override
  String get parentMeetingNotesLabel => 'Notes';

  @override
  String get parentMeetingNotesHint => 'Toute information supplementaire...';

  @override
  String get parentMeetingRequesting => 'Demande en cours...';

  @override
  String get parentMeetingRequestMeeting => 'Demander une reunion';

  @override
  String get parentMeetingRequestSent => 'Demande de reunion envoyee';

  @override
  String parentMeetingRequestSentDescription(String staffName) {
    return 'Votre demande de reunion a ete envoyee a $staffName. Vous serez notifie des qu\'il/elle aura repondu.';
  }

  @override
  String get parentMeetingOk => 'OK';

  @override
  String get parentMeetingRequestFailed =>
      'Echec de la demande de reunion. Veuillez reessayer.';

  @override
  String get parentMeetingError => 'Erreur';

  @override
  String get counselorMeetingBack => 'Retour';

  @override
  String get counselorMeetingRefresh => 'Actualiser';

  @override
  String get counselorMeetingManageAvailability => 'Gérer la disponibilité';

  @override
  String get counselorMeetingWeeklyAvailability => 'Disponibilité hebdomadaire';

  @override
  String get counselorMeetingSetAvailableHours =>
      'Définissez vos heures disponibles pour les réunions parents';

  @override
  String get counselorMeetingAddAvailabilitySlot =>
      'Ajouter un créneau de disponibilité';

  @override
  String get counselorMeetingAddNewAvailability =>
      'Ajouter une nouvelle disponibilité';

  @override
  String get counselorMeetingDayOfWeek => 'Jour de la semaine';

  @override
  String get counselorMeetingStartTime => 'Heure de début';

  @override
  String get counselorMeetingEndTime => 'Heure de fin';

  @override
  String counselorMeetingStartWithTime(String time) {
    return 'Début : $time';
  }

  @override
  String counselorMeetingEndWithTime(String time) {
    return 'Fin : $time';
  }

  @override
  String get counselorMeetingCancel => 'Annuler';

  @override
  String get counselorMeetingSave => 'Enregistrer';

  @override
  String get counselorMeetingNotAvailable => 'Non disponible';

  @override
  String get counselorMeetingInactive => 'Inactif';

  @override
  String get counselorMeetingDeactivate => 'Désactiver';

  @override
  String get counselorMeetingActivate => 'Activer';

  @override
  String get counselorMeetingDelete => 'Supprimer';

  @override
  String get counselorMeetingAvailabilityAdded =>
      'Disponibilité ajoutée avec succès';

  @override
  String get counselorMeetingFailedToAddAvailability =>
      'Échec de l’ajout de la disponibilité';

  @override
  String get counselorMeetingSlotDeactivated => 'Créneau désactivé';

  @override
  String get counselorMeetingSlotActivated => 'Créneau activé';

  @override
  String get counselorMeetingFailedToUpdateAvailability =>
      'Échec de la mise à jour de la disponibilité';

  @override
  String get counselorMeetingDeleteAvailability => 'Supprimer la disponibilité';

  @override
  String counselorMeetingConfirmDeleteSlot(String dayName) {
    return 'Êtes-vous sûr de vouloir supprimer le créneau du $dayName ?';
  }

  @override
  String get counselorMeetingAvailabilityDeleted =>
      'Disponibilité supprimée avec succès';

  @override
  String get counselorMeetingFailedToDeleteAvailability =>
      'Échec de la suppression de la disponibilité';

  @override
  String get counselorMeetingSunday => 'Dimanche';

  @override
  String get counselorMeetingMonday => 'Lundi';

  @override
  String get counselorMeetingTuesday => 'Mardi';

  @override
  String get counselorMeetingWednesday => 'Mercredi';

  @override
  String get counselorMeetingThursday => 'Jeudi';

  @override
  String get counselorMeetingFriday => 'Vendredi';

  @override
  String get counselorMeetingSaturday => 'Samedi';

  @override
  String get counselorMeetingRequests => 'Demandes de réunion';

  @override
  String get counselorMeetingPending => 'En attente';

  @override
  String get counselorMeetingToday => 'Aujourd’hui';

  @override
  String get counselorMeetingUpcoming => 'À venir';

  @override
  String get counselorMeetingNoPendingRequests => 'Aucune demande en attente';

  @override
  String get counselorMeetingNoPendingRequestsMessage =>
      'Vous n’avez aucune demande de réunion pour le moment.';

  @override
  String get counselorMeetingNoMeetingsToday => 'Aucune réunion aujourd’hui';

  @override
  String get counselorMeetingNoMeetingsTodayMessage =>
      'Vous n’avez aucune réunion prévue pour aujourd’hui.';

  @override
  String get counselorMeetingNoUpcomingMeetings => 'Aucune réunion à venir';

  @override
  String get counselorMeetingNoUpcomingMeetingsMessage =>
      'Vous n’avez aucune réunion prévue.';

  @override
  String get counselorMeetingParent => 'Parent';

  @override
  String get counselorMeetingUnknown => 'Inconnu';

  @override
  String counselorMeetingStudentLabel(String name) {
    return 'Élève : $name';
  }

  @override
  String get counselorMeetingPendingBadge => 'EN ATTENTE';

  @override
  String counselorMeetingRequested(String dateTime) {
    return 'Demandé : $dateTime';
  }

  @override
  String counselorMeetingMinutes(String count) {
    return '$count minutes';
  }

  @override
  String get counselorMeetingDecline => 'Refuser';

  @override
  String get counselorMeetingApprove => 'Approuver';

  @override
  String get counselorMeetingSoon => 'Bientôt';

  @override
  String get counselorMeetingCancelMeeting => 'Annuler la réunion';

  @override
  String counselorMeetingTimeWithDuration(String time, String minutes) {
    return '$time ($minutes min)';
  }

  @override
  String get counselorMeetingApproveMeeting => 'Approuver la réunion';

  @override
  String counselorMeetingApproveWith(String parentName) {
    return 'Approuver la réunion avec $parentName';
  }

  @override
  String get counselorMeetingSelectDate => 'Sélectionner la date';

  @override
  String get counselorMeetingSelectTime => 'Sélectionner l’heure';

  @override
  String get counselorMeetingDuration => 'Durée';

  @override
  String get counselorMeeting1Hour => '1 heure';

  @override
  String get counselorMeeting1Point5Hours => '1,5 heures';

  @override
  String get counselorMeeting2Hours => '2 heures';

  @override
  String get counselorMeetingMeetingLink => 'Lien de la réunion';

  @override
  String get counselorMeetingLocation => 'Lieu';

  @override
  String get counselorMeetingLocationHint => 'Salle 101, Bâtiment principal';

  @override
  String get counselorMeetingNotesOptional => 'Notes (Facultatif)';

  @override
  String get counselorMeetingApprovedSuccessfully =>
      'Réunion approuvée avec succès';

  @override
  String get counselorMeetingFailedToApprove =>
      'Échec de l’approbation de la réunion';

  @override
  String get counselorMeetingDeclineMeeting => 'Refuser la réunion';

  @override
  String counselorMeetingDeclineFrom(String parentName) {
    return 'Refuser la demande de réunion de $parentName ?';
  }

  @override
  String get counselorMeetingReasonForDeclining => 'Raison du refus';

  @override
  String get counselorMeetingProvideReason => 'Veuillez fournir une raison...';

  @override
  String get counselorMeetingPleaseProvideReason =>
      'Veuillez fournir une raison pour le refus';

  @override
  String get counselorMeetingDeclined => 'Réunion refusée';

  @override
  String get counselorMeetingFailedToDecline => 'Échec du refus de la réunion';

  @override
  String counselorMeetingCancelWith(String parentName) {
    return 'Annuler cette réunion avec $parentName ?';
  }

  @override
  String get counselorMeetingCancellationReasonOptional =>
      'Raison de l’annulation (Facultatif)';

  @override
  String get counselorMeetingBackButton => 'Retour';

  @override
  String get counselorMeetingCancelled => 'Réunion annulée';

  @override
  String get counselorMeetingFailedToCancel =>
      'Échec de l’annulation de la réunion';

  @override
  String get counselorSessionPleaseSelectStudent =>
      'Veuillez sélectionner un élève';

  @override
  String get counselorSessionScheduledSuccessfully =>
      'Session planifiée avec succès !';

  @override
  String counselorSessionErrorScheduling(String error) {
    return 'Erreur lors de la planification de la session : $error';
  }

  @override
  String get counselorSessionScheduleSession => 'Planifier une session';

  @override
  String get counselorSessionSave => 'ENREGISTRER';

  @override
  String get counselorSessionStudent => 'Élève';

  @override
  String get counselorSessionNoStudentsFound =>
      'Aucun élève trouvé. Veuillez d’abord ajouter des élèves.';

  @override
  String get counselorSessionSelectStudent => 'Sélectionner un élève';

  @override
  String get counselorSessionTitle => 'Titre de la session';

  @override
  String get counselorSessionTitleHint =>
      'ex. Discussion sur la planification de carrière';

  @override
  String get counselorSessionPleaseEnterTitle =>
      'Veuillez entrer un titre de session';

  @override
  String get counselorSessionType => 'Type de session';

  @override
  String get counselorSessionDate => 'Date';

  @override
  String get counselorSessionTime => 'Heure';

  @override
  String get counselorSessionDuration => 'Durée';

  @override
  String counselorSessionDurationMin(String count) {
    return '$count min';
  }

  @override
  String get counselorSessionLocation => 'Lieu';

  @override
  String get counselorSessionNotesOptional => 'Notes (Facultatif)';

  @override
  String get counselorSessionNotesHint =>
      'Ajoutez des notes supplémentaires ou des points à l’ordre du jour...';

  @override
  String get counselorSessionCancel => 'Annuler';

  @override
  String get counselorSessionSelectStudentDialog => 'Sélectionner un élève';

  @override
  String counselorSessionGradeAndGpa(String grade, String gpa) {
    return '$grade • MPC : $gpa';
  }

  @override
  String get counselorSessionRetry => 'Réessayer';

  @override
  String get counselorSessionLoadingSessions => 'Chargement des sessions...';

  @override
  String counselorSessionTodayTab(String count) {
    return 'Aujourd’hui ($count)';
  }

  @override
  String counselorSessionUpcomingTab(String count) {
    return 'À venir ($count)';
  }

  @override
  String counselorSessionCompletedTab(String count) {
    return 'Terminées ($count)';
  }

  @override
  String get counselorSessionNoSessionsTitle => 'Aucune session';

  @override
  String get counselorSessionNoSessionsToday =>
      'Aucune session prévue pour aujourd’hui';

  @override
  String get counselorSessionNoUpcomingSessions => 'Aucune session à venir';

  @override
  String get counselorSessionNoCompletedSessions =>
      'Aucune session terminée pour le moment';

  @override
  String get counselorSessionNoSessions => 'Aucune session';

  @override
  String get counselorSessionStudentLabel => 'Élève';

  @override
  String get counselorSessionDateTime => 'Date et heure';

  @override
  String get counselorSessionDurationLabel => 'Durée';

  @override
  String counselorSessionMinutesValue(String count) {
    return '$count minutes';
  }

  @override
  String get counselorSessionStatusLabel => 'Statut';

  @override
  String get counselorSessionNotes => 'Notes';

  @override
  String get counselorSessionSummary => 'Résumé';

  @override
  String get counselorSessionActionItems => 'Actions à suivre';

  @override
  String get counselorSessionStartSession => 'Démarrer la session';

  @override
  String get counselorSessionCancelSession => 'Annuler la session';

  @override
  String get counselorSessionIndividualCounseling => 'Conseil individuel';

  @override
  String get counselorSessionGroupSession => 'Session de groupe';

  @override
  String get counselorSessionCareerCounseling => 'Orientation professionnelle';

  @override
  String get counselorSessionAcademicAdvising => 'Conseil académique';

  @override
  String get counselorSessionPersonalCounseling => 'Conseil personnel';

  @override
  String counselorSessionStartSessionWith(String studentName) {
    return 'Démarrer la session de conseil avec $studentName ?';
  }

  @override
  String get counselorSessionStart => 'Démarrer';

  @override
  String counselorSessionStarted(String studentName) {
    return 'Session avec $studentName démarrée';
  }

  @override
  String counselorSessionCancelSessionWith(String studentName) {
    return 'Annuler la session avec $studentName ?';
  }

  @override
  String get counselorSessionReasonForCancellation =>
      'Raison de l’annulation :';

  @override
  String get counselorSessionStudentUnavailable => 'Élève indisponible';

  @override
  String get counselorSessionCounselorUnavailable => 'Conseiller indisponible';

  @override
  String get counselorSessionRescheduled => 'Reportée';

  @override
  String get counselorSessionOther => 'Autre';

  @override
  String get counselorSessionBack => 'Retour';

  @override
  String counselorSessionCancelled(String studentName) {
    return 'Session avec $studentName annulée';
  }

  @override
  String get counselorSessionTodayBadge => 'AUJOURD’HUI';

  @override
  String get counselorSessionIndividual => 'Individuel';

  @override
  String get counselorSessionGroup => 'Groupe';

  @override
  String get counselorSessionCareer => 'Carrière';

  @override
  String get counselorSessionAcademic => 'Académique';

  @override
  String get counselorSessionPersonal => 'Personnel';

  @override
  String get counselorSessionScheduled => 'Planifiée';

  @override
  String get counselorSessionCompleted => 'Terminée';

  @override
  String get counselorSessionCancelledStatus => 'Annulée';

  @override
  String get counselorSessionNoShow => 'Absent';

  @override
  String get counselorStudentBack => 'Retour';

  @override
  String get counselorStudentAddNotesComingSoon =>
      'Fonctionnalité d’ajout de notes bientôt disponible';

  @override
  String get counselorStudentOverview => 'Aperçu';

  @override
  String get counselorStudentSessions => 'Sessions';

  @override
  String get counselorStudentNotes => 'Notes';

  @override
  String get counselorStudentScheduleSession => 'Planifier une session';

  @override
  String get counselorStudentAcademicPerformance => 'Performance académique';

  @override
  String get counselorStudentGpa => 'MPC';

  @override
  String get counselorStudentInterests => 'Intérêts';

  @override
  String get counselorStudentStrengths => 'Points forts';

  @override
  String get counselorStudentAreasForGrowth => 'Axes d’amélioration';

  @override
  String get counselorStudentNoSessionsYet => 'Pas encore de sessions';

  @override
  String get counselorStudentScheduleSessionPrompt =>
      'Planifier une session avec cet élève';

  @override
  String get counselorStudentNoNotesYet => 'Aucune note pour le moment';

  @override
  String get counselorStudentAddPrivateNotes =>
      'Ajouter des notes privées sur cet élève';

  @override
  String get counselorStudentAddNote => 'Ajouter une note';

  @override
  String get counselorStudentIndividualCounseling => 'Conseil individuel';

  @override
  String get counselorStudentGroupSession => 'Session de groupe';

  @override
  String get counselorStudentCareerCounseling => 'Orientation professionnelle';

  @override
  String get counselorStudentAcademicAdvising => 'Conseil académique';

  @override
  String get counselorStudentPersonalCounseling => 'Conseil personnel';

  @override
  String get counselorStudentScheduleFeatureComingSoon =>
      'La fonctionnalité de planification de session sera implémentée avec l’intégration du calendrier.';

  @override
  String get counselorStudentClose => 'Fermer';

  @override
  String get counselorStudentScheduled => 'Planifiée';

  @override
  String get counselorStudentCompleted => 'Terminée';

  @override
  String get counselorStudentCancelled => 'Annulée';

  @override
  String get counselorStudentNoShow => 'Absent';

  @override
  String get counselorStudentRetry => 'Réessayer';

  @override
  String get counselorStudentLoadingStudents => 'Chargement des élèves...';

  @override
  String get counselorStudentSearchStudents => 'Rechercher des élèves...';

  @override
  String get counselorStudentNoStudentsFound => 'Aucun élève trouvé';

  @override
  String get counselorStudentTryAdjustingSearch =>
      'Essayez d’ajuster votre recherche';

  @override
  String get counselorStudentNoStudentsAssigned =>
      'Aucun élève assigné pour le moment';

  @override
  String counselorStudentGradeAndGpa(String grade, String gpa) {
    return '$grade • MPC : $gpa';
  }

  @override
  String counselorStudentSessionsCount(String count) {
    return '$count sessions';
  }

  @override
  String get counselorStudentToday => 'Aujourd’hui';

  @override
  String get counselorStudentYesterday => 'Hier';

  @override
  String counselorStudentDaysAgo(String count) {
    return 'il y a ${count}j';
  }

  @override
  String counselorStudentWeeksAgo(String count) {
    return 'il y a ${count}sem';
  }

  @override
  String get recRetry => 'Réessayer';

  @override
  String get recLoadingRequests => 'Chargement des demandes...';

  @override
  String recTabAll(int count) {
    return 'Toutes ($count)';
  }

  @override
  String recTabPending(int count) {
    return 'En attente ($count)';
  }

  @override
  String recTabInProgress(int count) {
    return 'En cours ($count)';
  }

  @override
  String recTabCompleted(int count) {
    return 'Terminées ($count)';
  }

  @override
  String get recNoPendingRequests =>
      'Aucune demande de recommandation en attente';

  @override
  String get recNoLettersInProgress => 'Aucune lettre en cours';

  @override
  String get recNoCompletedRecommendations =>
      'Aucune recommandation terminée pour le moment';

  @override
  String get recNoRecommendationRequests => 'Aucune demande de recommandation';

  @override
  String get recNoRequests => 'Aucune demande';

  @override
  String get recStudent => 'Étudiant';

  @override
  String get recInstitution => 'Établissement';

  @override
  String get recOverdue => 'En retard !';

  @override
  String get recDueToday => 'À remettre aujourd\'hui';

  @override
  String recDaysLeft(int count) {
    return '$count jours restants';
  }

  @override
  String get recUrgent => 'URGENT';

  @override
  String get recStatusOverdue => 'EN RETARD';

  @override
  String get recStatusPending => 'EN ATTENTE';

  @override
  String get recStatusAccepted => 'ACCEPTÉE';

  @override
  String get recStatusInProgress => 'EN COURS';

  @override
  String get recStatusCompleted => 'TERMINÉE';

  @override
  String get recStatusDeclined => 'REFUSÉE';

  @override
  String get recStatusCancelled => 'ANNULÉE';

  @override
  String get recRecommendationLetter => 'Lettre de recommandation';

  @override
  String get recSaveDraft => 'Enregistrer le brouillon';

  @override
  String recApplyingTo(String institution) {
    return 'Candidature à $institution';
  }

  @override
  String get recPurpose => 'Objet';

  @override
  String get recType => 'Type';

  @override
  String get recDeadline => 'Date limite';

  @override
  String get recStatus => 'Statut';

  @override
  String get recMessageFromStudent => 'Message de l\'étudiant';

  @override
  String get recAchievements => 'Réalisations';

  @override
  String get recDecline => 'Refuser';

  @override
  String get recAccept => 'Accepter';

  @override
  String get recQuickStartTemplates => 'Modèles de démarrage rapide';

  @override
  String get recProfessionalTemplate => 'Modèle professionnel';

  @override
  String get recProfessionalTemplateDesc =>
      'Recommandation formelle de style professionnel';

  @override
  String get recAcademicTemplate => 'Modèle académique';

  @override
  String get recAcademicTemplateDesc => 'Axé sur les réalisations académiques';

  @override
  String get recPersonalTemplate => 'Modèle personnel';

  @override
  String get recPersonalTemplateDesc =>
      'Met en valeur les qualités personnelles';

  @override
  String get recWriteHint =>
      'Rédigez votre recommandation ici ou utilisez un modèle ci-dessus...';

  @override
  String get recPleaseWriteRecommendation =>
      'Veuillez rédiger une recommandation';

  @override
  String get recMinCharacters =>
      'La recommandation doit comporter au moins 100 caractères';

  @override
  String get recSubmitRecommendation => 'Soumettre la recommandation';

  @override
  String get recTheStudent => 'l\'étudiant';

  @override
  String get recYourInstitution => 'votre établissement';

  @override
  String get recRequestAccepted =>
      'Demande acceptée ! Vous pouvez maintenant rédiger la lettre.';

  @override
  String get recFailedToAcceptRequest => 'Impossible d\'accepter la demande';

  @override
  String recErrorAcceptingRequest(String error) {
    return 'Erreur lors de l\'acceptation de la demande : $error';
  }

  @override
  String get recDeclineRequest => 'Refuser la demande';

  @override
  String get recDeclineReason =>
      'Veuillez fournir une raison pour le refus de cette demande.';

  @override
  String get recReasonLabel => 'Raison';

  @override
  String get recReasonHint => 'Entrez au moins 10 caractères';

  @override
  String get recCancel => 'Annuler';

  @override
  String get recReasonMinCharacters =>
      'La raison doit comporter au moins 10 caractères';

  @override
  String get recRequestDeclined => 'Demande refusée';

  @override
  String get recFailedToDeclineRequest => 'Impossible de refuser la demande';

  @override
  String recErrorDecliningRequest(String error) {
    return 'Erreur lors du refus de la demande : $error';
  }

  @override
  String get recLetterMinCharacters =>
      'Le contenu de la lettre doit comporter au moins 100 caractères';

  @override
  String get recDraftSaved => 'Brouillon enregistré avec succès';

  @override
  String recErrorSavingDraft(String error) {
    return 'Erreur lors de l\'enregistrement du brouillon : $error';
  }

  @override
  String get recSubmitConfirmTitle => 'Soumettre la recommandation ?';

  @override
  String get recSubmitConfirmMessage =>
      'Une fois soumise, vous ne pourrez plus modifier cette recommandation. Êtes-vous sûr de vouloir la soumettre ?';

  @override
  String get recSubmit => 'Soumettre';

  @override
  String get recSubmittedSuccessfully => 'Recommandation soumise avec succès !';

  @override
  String get recFailedToSubmit => 'Impossible de soumettre la recommandation';

  @override
  String recErrorSubmitting(String error) {
    return 'Erreur lors de la soumission de la recommandation : $error';
  }

  @override
  String get notifPrefTitle => 'Préférences de notification';

  @override
  String get notifPrefDefaultCreated =>
      'Préférences de notification par défaut créées avec succès !';

  @override
  String notifPrefErrorCreating(String error) {
    return 'Erreur lors de la création des préférences : $error';
  }

  @override
  String get notifPrefNotFound => 'Aucune préférence de notification trouvée';

  @override
  String get notifPrefCreateDefaults => 'Créer les préférences par défaut';

  @override
  String get notifPrefWaitingAuth => 'En attente de l\'authentification...';

  @override
  String get notifPrefSettings => 'Paramètres de notification';

  @override
  String get notifPrefDescription =>
      'Contrôlez les notifications que vous souhaitez recevoir. Les modifications sont enregistrées automatiquement.';

  @override
  String get notifPrefCollegeApplications => 'Candidatures universitaires';

  @override
  String get notifPrefAcademic => 'Académique';

  @override
  String get notifPrefCommunication => 'Communication';

  @override
  String get notifPrefMeetingsEvents => 'Réunions et événements';

  @override
  String get notifPrefAchievements => 'Réalisations';

  @override
  String get notifPrefSystem => 'Système';

  @override
  String notifPrefErrorLoading(String error) {
    return 'Erreur lors du chargement des préférences : $error';
  }

  @override
  String get notifPrefRetry => 'Réessayer';

  @override
  String get notifPrefEmail => 'E-mail';

  @override
  String get notifPrefPush => 'Push';

  @override
  String get notifPrefSoon => '(bientôt)';

  @override
  String get notifPrefDescApplicationStatus =>
      'Soyez informé lorsque le statut de votre candidature change';

  @override
  String get notifPrefDescGradePosted =>
      'Recevez des notifications lorsque de nouvelles notes sont publiées';

  @override
  String get notifPrefDescMessageReceived =>
      'Soyez informé des nouveaux messages';

  @override
  String get notifPrefDescMeetingScheduled =>
      'Recevez des notifications pour les réunions programmées';

  @override
  String get notifPrefDescMeetingReminder =>
      'Recevez des rappels avant vos réunions';

  @override
  String get notifPrefDescAchievementEarned =>
      'Célébrez vos nouvelles réalisations';

  @override
  String get notifPrefDescDeadlineReminder =>
      'Recevez des rappels pour les échéances à venir';

  @override
  String get notifPrefDescRecommendationReady =>
      'Recevez des notifications pour les nouvelles recommandations';

  @override
  String get notifPrefDescSystemAnnouncement =>
      'Restez informé des annonces système';

  @override
  String get notifPrefDescCommentReceived =>
      'Soyez informé lorsque quelqu\'un commente vos publications';

  @override
  String get notifPrefDescMention =>
      'Recevez des notifications lorsque vous êtes mentionné';

  @override
  String get notifPrefDescEventReminder =>
      'Recevez des rappels pour les événements à venir';

  @override
  String get notifPrefDescApprovalNew =>
      'Soyez informé des nouvelles demandes d\'approbation';

  @override
  String get notifPrefDescApprovalActionNeeded =>
      'Recevez des rappels pour les actions d\'approbation en attente';

  @override
  String get notifPrefDescApprovalStatusChanged =>
      'Soyez informé lorsque le statut de votre demande change';

  @override
  String get notifPrefDescApprovalEscalated =>
      'Recevez des notifications lorsque des demandes vous sont transmises';

  @override
  String get notifPrefDescApprovalExpiring =>
      'Recevez des rappels pour les demandes d\'approbation qui expirent';

  @override
  String get notifPrefDescApprovalComment =>
      'Soyez informé des nouveaux commentaires sur les demandes';

  @override
  String get notifPrefUpdated => 'Préférences mises à jour';

  @override
  String notifPrefErrorUpdating(String error) {
    return 'Erreur lors de la mise à jour des préférences : $error';
  }

  @override
  String get biometricSetupTitle => 'Configuration biométrique';

  @override
  String get biometricSettingsTitle => 'Paramètres biométriques';

  @override
  String biometricErrorChecking(String error) {
    return 'Erreur lors de la vérification biométrique : $error';
  }

  @override
  String get biometricEnabledSuccess =>
      'Authentification biométrique activée avec succès';

  @override
  String get biometricAuthFailed =>
      'Échec de l\'authentification. Veuillez réessayer.';

  @override
  String biometricError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get biometricDisabledSuccess =>
      'Authentification biométrique désactivée';

  @override
  String get biometricEnableLogin => 'Activer la connexion biométrique';

  @override
  String get biometricAuthentication => 'Authentification biométrique';

  @override
  String biometricUseType(String type) {
    return 'Utiliser $type';
  }

  @override
  String get biometricEnabled => 'Activé';

  @override
  String get biometricDisabled => 'Désactivé';

  @override
  String get biometricWhyUse => 'Pourquoi utiliser la biométrie ?';

  @override
  String get biometricBenefitFaster => 'Connexion plus rapide';

  @override
  String get biometricBenefitSecure => 'Plus sécurisé que les mots de passe';

  @override
  String get biometricBenefitUnique => 'Unique à vous - impossible à copier';

  @override
  String get biometricSecurityNote => 'Note de sécurité';

  @override
  String get biometricSecurityNoteDesc =>
      'Vos données biométriques restent sur votre appareil et ne sont jamais partagées avec Flow ou des tiers.';

  @override
  String get biometricSkipForNow => 'Passer pour le moment';

  @override
  String get biometricNotSupported => 'Non pris en charge';

  @override
  String get biometricNotSupportedDesc =>
      'Votre appareil ne prend pas en charge l\'authentification biométrique.';

  @override
  String get biometricGoBack => 'Retour';

  @override
  String get biometricNotEnrolled => 'Aucune biométrie enregistrée';

  @override
  String get biometricNotEnrolledDesc =>
      'Veuillez d\'abord enregistrer votre empreinte digitale ou Face ID dans les paramètres de votre appareil.';

  @override
  String get biometricOpenSettingsHint =>
      'Veuillez ouvrir Paramètres > Sécurité > Biométrie';

  @override
  String get biometricOpenSettings => 'Ouvrir les paramètres';

  @override
  String get biometricTypeFace => 'Face ID';

  @override
  String get biometricTypeFingerprint => 'Empreinte digitale';

  @override
  String get biometricTypeIris => 'Reconnaissance de l\'iris';

  @override
  String get biometricTypeGeneric => 'Biométrie';

  @override
  String biometricDescEnabled(String type) {
    return 'Votre $type est actuellement utilisé pour sécuriser votre compte. Vous pouvez vous connecter rapidement et en toute sécurité.';
  }

  @override
  String biometricDescDisabled(String type) {
    return 'Utilisez votre $type pour vous connecter rapidement et en toute sécurité sans entrer votre mot de passe.';
  }
}
