import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screen/screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) => DetailScreen(
        pushMessageId: state.pathParameters['messageId'] ?? '',
      ),
    )
  ]
);
