import 'package:get/get.dart';
import 'package:texans_web/pages/create_password.dart';
import 'package:texans_web/pages/decline_screen.dart';
import 'package:texans_web/Parent%20Flow/UI/parent_accept_invitation.dart';
import 'package:texans_web/Parent%20Flow/UI/parent_create_password.dart';
import 'package:texans_web/pages/success_screen.dart';

class AppRoutes {
  AppRoutes._();

  //Coach
  static const String createPassword = '/create-password';

  //Common
  static const String success = '/success';
  static const String decline = '/decline';
  static const String root = '/';

  //Parent
  static const String parentAcceptInvitation = '/accept-invitation';
  static const String parentCreatePassword = '/parent/create-password';
}

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.createPassword,
      page: () => const CreatePasswordPage(),
    ),
    GetPage(name: AppRoutes.success, page: () => const InvitationSuccessPage()),
    GetPage(name: AppRoutes.decline, page: () => const InvitationDeclinePage()),
    GetPage(
      name: AppRoutes.parentAcceptInvitation,
      page: () => const ParentAcceptInvitationPage(),
    ),
    GetPage(
      name: AppRoutes.parentCreatePassword,
      page: () => const ParentCreatePasswordPage(),
    ),
    GetPage(
      name: AppRoutes.root,
      page: () => const CreatePasswordPage(),
    ),
  ];
}
