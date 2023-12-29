import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screen/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    )
  ]
);
