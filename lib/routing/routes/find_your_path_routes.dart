import 'package:go_router/go_router.dart';
import '../../features/find_your_path/presentation/screens/find_your_path_landing_screen.dart';
import '../../features/find_your_path/presentation/screens/questionnaire_screen.dart';
import '../../features/find_your_path/presentation/screens/results_screen.dart';
import '../../features/find_your_path/presentation/screens/university_detail_screen.dart';

/// Find Your Path feature routes (public access)
List<RouteBase> findYourPathRoutes = [
  GoRoute(
    path: '/find-your-path',
    name: 'find-your-path',
    builder: (context, state) => const FindYourPathLandingScreen(),
  ),
  GoRoute(
    path: '/find-your-path/questionnaire',
    name: 'find-your-path-questionnaire',
    builder: (context, state) => const QuestionnaireScreen(),
  ),
  GoRoute(
    path: '/find-your-path/results',
    name: 'find-your-path-results',
    builder: (context, state) => const ResultsScreen(),
  ),
  GoRoute(
    path: '/find-your-path/university/:id',
    name: 'find-your-path-university-detail',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return UniversityDetailScreen(universityId: id);
    },
  ),
];