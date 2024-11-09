import 'package:go_router/go_router.dart';
import 'package:todo_app/core/routes/route_name.dart';
import 'package:todo_app/features/auth/view/login_view.dart';
import 'package:todo_app/features/auth/view/register_view.dart';
import '../../features/splash/view/splash_view.dart';

final GoRouter router = GoRouter(routes:[
  GoRoute(
    name: RouteNames.splash,
    path: "/",
    builder: (context, state) => const SplashView(),
  ),
  GoRoute(
    name: RouteNames.login,
    path: "/login",
    builder: (context, state) => const LoginView(),
  ),
  GoRoute(
    name: RouteNames.register,
    path: "/register",
    builder: (context, state) => const RegisterView(),
  ),
]);