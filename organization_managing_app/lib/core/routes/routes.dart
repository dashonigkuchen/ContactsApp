import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/data/model/member_with_paid_membership_fees.dart';
import 'package:organization_managing_app/pages/add_edit_delete_member_page.dart';
import 'package:organization_managing_app/pages/add_edit_delete_paid_membership_fee_page.dart';
import 'package:organization_managing_app/pages/login_page.dart';
import 'package:organization_managing_app/pages/members_filter_page.dart';
import 'package:organization_managing_app/pages/members_page.dart';
import 'package:organization_managing_app/pages/paid_membership_fee_page.dart';
import 'package:organization_managing_app/pages/register_page.dart';
import 'package:organization_managing_app/pages/settings_page.dart';
import 'package:organization_managing_app/pages/splash_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: "/",
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: RouteNames.login,
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: RouteNames.register,
      path: "/register",
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: RouteNames.members,
      path: "/members",
      builder: (context, state) => const MembersPage(),
    ),
    GoRoute(
      name: RouteNames.addEditDeleteMember,
      path: "/addEditDeleteMember",
      builder: (context, state) {
        return AddEditDeleteMemberPage(
          originalMemberWithLatestPaidMembershipFee: state.extra as MemberWithPaidMembershipFees?,
        );
      },
    ),
    GoRoute(
      name: RouteNames.addEditDeletePaidMembershipFee,
      path: "/addEditDeletePaidMembershipFee",
      builder: (context, state) {
        final vars = state.extra as List<dynamic>;
        return AddEditDeletePaidMembershipFeePage(
          memberId: vars.elementAtOrNull(0),
          name: vars.elementAtOrNull(1),
          paidMembershipFeeModel: vars.elementAtOrNull(2),
        );
      },
    ),
    GoRoute(
      name: RouteNames.settings,
      path: "/settings",
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      name: RouteNames.filterMembers,
      path: "/filterMembers",
      builder: (context, state) => const MembersFilterPage(),
    ),
    GoRoute(
      name: RouteNames.paidMembershipFee,
      path: "/paidMembershipFee",
      builder: (context, state) => const PaidMembershipFeePage(),
    ),
  ],
);
