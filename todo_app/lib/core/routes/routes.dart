import 'package:go_router/go_router.dart';
import 'package:todo_app/core/routes/route_name.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/features/auth/view/login_view.dart';
import 'package:todo_app/features/auth/view/register_view.dart';
import 'package:todo_app/features/todo/view/add_edit_todo_view.dart';
import 'package:todo_app/features/todo/view/todo_view.dart';
import '../../features/splash/view/splash_view.dart';

final GoRouter router = GoRouter(routes: [
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
  GoRoute(
    name: RouteNames.todo,
    path: "/todo",
    builder: (context, state) => const TodoView(),
  ),
  GoRoute(
    name: RouteNames.addTodo,
    path: "/add-todo",
    builder: (context, state) => const AddEditTodoView(),
  ),
  GoRoute(
    name: RouteNames.editTodo,
    path: "/edit-todo",
    builder: (context, state) {
      final todoModel = state.extra as TodoModel;
      return AddEditTodoView(
        todoModel: todoModel,
      );
    },
  ),
]);
