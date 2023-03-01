import 'dart:io';

import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/features/authentication/ui/widgets/decorated_text_background.dart';
import 'package:thedeck/features/authentication/ui/widgets/text_background.dart';
import 'package:thedeck/features/home/ui/base_view.dart';

import 'widgets/app_logo.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    bool isMedium = MySize.isMedium;
    bool isLarge = MySize.isLarge;

    return BaseView<AuthenticationController>(
        builder: (context, controller, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppLogo(),
                  appHeader(
                      isSmall
                          ? 28
                          : isMedium
                              ? 44
                              : 60,
                      isSmall
                          ? 6.3
                          : isMedium
                              ? 10
                              : 15),
                  heightMin(size: isLarge ? 10 : 3),
                  DecoratedTextBackground(
                    child: TextBackground(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customTextField(
                            hintText: 'Email',
                            initialValue: controller.emailText,
                            textInputType: TextInputType.emailAddress,
                            onChanged: controller.updateEmail,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 2, right: 2, bottom: isSmall ? 10 : 4),
                            child: const Divider(),
                          ),
                          customTextField(
                            initialValue: controller.passwordText,
                            hintText: 'Password',
                            isLast: true,
                            onSubmitted: (value) {
                              controller.doLogin();
                            },
                            onChanged: controller.updatePassword,
                            textInputType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  heightMin(size: isLarge ? 10 : 3),
                  InkWell(
                    onTap: controller.navigateToForgotPassword,
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: MySize.textSize(isLarge ? 3 : 4)),
                    ),
                  ),
                  heightMin(),
                  authButton(
                    'Login',
                    height: isSmall ? 40 : 50,
                    fontSize: isLarge
                        ? 18
                        : isMedium
                            ? 17
                            : 13,
                    onTap: controller.doLogin,
                    isButtonEnabled: controller.isLoginButtonEnabled,
                  ),
                  heightMin(),
                  Visibility(
                    visible: Platform.isIOS,
                    replacement: authButton(
                      'Login With Facebook',
                      height: isSmall ? 40 : 50,
                      fontSize: isLarge
                          ? 18
                          : isMedium
                              ? 17
                              : 13,
                      onTap: controller.doFacebookLogin,
                      isFacebook: true,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: controller.doAppleLogin,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.4),
                                  width: 0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: SizedBox(
                                  height: 40,
                                  child: Image.asset(
                                      'assets/images/apple_logo.png')),
                            ),
                          ),
                        ),
                        widthMin(),
                        InkWell(
                          onTap: controller.doFacebookLogin,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color(0xFF4267B2).withOpacity(0.4),
                                  width: 0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: SizedBox(
                                  height: 40,
                                  child: Image.asset(
                                      'assets/images/facebook.png')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightMin(size: isSmall ? 3 : 6),
                  Center(
                    child: InkWell(
                      onTap: () {
                        controller.goToSignUp();
                      },
                      child: Text('Signup',
                          style: TextStyle(
                            letterSpacing: 1.2,
                            color: AppColors.appRed,
                            fontFamily: 'League Spartan',
                            fontSize: isLarge
                                ? 20
                                : isMedium
                                    ? 18
                                    : 13,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
