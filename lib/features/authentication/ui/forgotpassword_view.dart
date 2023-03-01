import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';

import 'widgets/app_logo.dart';
import 'widgets/decorated_text_background.dart';
import 'widgets/text_background.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    bool isMedium = MySize.isMedium;
    bool isLarge = MySize.isLarge;
    final controller = locator<AuthenticationController>();
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: controller.back,
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
                const AppLogo(),
                appHeader(
                    isSmall
                        ? 26
                        : isMedium
                            ? 42
                            : 58,
                    isSmall
                        ? 5.5
                        : isMedium
                            ? 8
                            : 13),
                heightMin(size: isLarge ? 10 : 3),
                Text('Enter your email address to reset your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isSmall
                            ? 12
                            : isMedium
                                ? 16
                                : 20,
                        fontWeight: FontWeight.w500)),
                heightMin(size: isLarge ? 10 : 3),
                DecoratedTextBackground(
                  child: TextBackground(
                    child: customTextField(
                      hintText: 'Email',
                      initialValue: controller.emailText,
                      textInputType: TextInputType.emailAddress,
                      onChanged: controller.updateEmail,
                    ),
                  ),
                ),
                heightMin(size: isLarge ? 10 : 3),
                authButton('Send Recovery Email',
                    height: isSmall ? 40 : 50,
                    fontSize: isLarge
                        ? 18
                        : isMedium
                            ? 17
                            : 13, onTap: () {
                  FocusScope.of(context).unfocus();
                  controller.sendPasswordEmail();
                }, isButtonEnabled: controller.isRecoverButtonEnabled),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
