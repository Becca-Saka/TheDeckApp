import 'package:flutter/material.dart';
import 'package:thedeck/app/routes/app_routes.dart';
import 'package:thedeck/features/authentication/ui/account_settings.dart';
import 'package:thedeck/features/authentication/ui/edit_profile_view.dart';
import 'package:thedeck/features/authentication/ui/explanation_view.dart';
import 'package:thedeck/features/authentication/ui/forgotpassword_view.dart';
import 'package:thedeck/features/authentication/ui/login_view.dart';
import 'package:thedeck/features/authentication/ui/signup_view.dart';
import 'package:thedeck/features/authentication/ui/startup.dart';
import 'package:thedeck/features/chat/ui/chat_view.dart';
import 'package:thedeck/features/chat/ui/view_user.dart';
import 'package:thedeck/features/home/ui/home_view.dart';

class AppPages {
  static const initial = AppRoutes.root;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.root:
        return MaterialPageRoute(
          builder: (_) => const StartUp(),
          settings: settings,
        );
      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpView(),
          settings: settings,
        );
      case AppRoutes.exp:
        return MaterialPageRoute(
          builder: (_) => const ExplanationView(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
          settings: settings,
        );
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordView(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
          settings: settings,
        );
      case AppRoutes.chat:
        return MaterialPageRoute(
          builder: (_) => const ChatView(),
          settings: settings,
        );
      case AppRoutes.viewUser:
        return MaterialPageRoute(
          builder: (_) => const ViewUser(),
          settings: settings,
        );
      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileView(),
          settings: settings,
        );
      case AppRoutes.accountSetting:
        return MaterialPageRoute(
          builder: (_) => AccountSetting(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
