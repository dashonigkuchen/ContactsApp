import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: RouteNames.login,
      path: "/login",
      //builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      name: RouteNames.register,
      path: "/register",
      //builder: (context, state) => const RegisterView(),
    ),
  ],
);
