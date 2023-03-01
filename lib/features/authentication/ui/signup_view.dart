import 'dart:developer';
import 'dart:io';

import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/authentication_controller.dart';
import 'package:thedeck/features/authentication/ui/widgets/age_picker.dart';
import 'package:thedeck/features/authentication/ui/widgets/gender_picker.dart';
import 'package:thedeck/features/home/ui/base_view.dart';

import 'widgets/decorated_text_background.dart';
import 'widgets/text_background.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    return BaseView<AuthenticationController>(
      onModelReady: (m) {
        log(m.nameText);
      },
      builder: (context, controller, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () => controller.back(),
                        icon: const Icon(Icons.arrow_back_ios)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        heightMin(size: isSmall ? 2 : 3),
                        ImageSelector(controller: controller),
                        heightMin(),
                        DecoratedTextBackground(
                          child: Form(
                            child: Column(
                              children: [
                                TextBackground(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextField(
                                        hintText: 'Name',
                                        onChanged: controller.updateName,
                                        initialValue: controller.nameText,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8, bottom: 4),
                                        child: Divider(),
                                      ),
                                      AgePicker(
                                        onPicked: controller.selectAge,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 2, right: 2, bottom: 4),
                                        child: Divider(),
                                      ),
                                      GenderPicker(
                                          onPicked: controller.selectGender),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !controller.isSocial,
                                  child: Column(
                                    children: [
                                      heightMin(size: isSmall ? 2 : 3),
                                      TextBackground(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            customTextField(
                                              hintText: 'Email',
                                              initialValue:
                                                  controller.emailText,
                                              textInputType:
                                                  TextInputType.emailAddress,
                                              onChanged: controller.updateEmail,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2, right: 2, bottom: 4),
                                              child: Divider(),
                                            ),
                                            customTextField(
                                                hintText: 'Password',
                                                initialValue:
                                                    controller.passwordText,
                                                isLast: true,
                                                onChanged:
                                                    controller.updatePassword,
                                                textInputType: TextInputType
                                                    .visiblePassword),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        heightMin(),
                        authButton(
                          controller.isSocial ? 'Continue' : 'Create Account',
                          onTap: controller.isSocial
                              ? controller.onContinue
                              : controller.doSignUp,
                          isButtonEnabled: controller.isButtonEnabled,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImageSelector extends StatelessWidget {
  const ImageSelector({
    super.key,
    required this.controller,
  });

  final AuthenticationController controller;

  @override
  Widget build(BuildContext context) {
    MySize.init(context);
    bool isSmall = MySize.isSmall;
    bool isLarge = MySize.isLarge;
    return Center(
      child: InkWell(
          onTap: controller.openImageLocationDialog,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: SizedBox(
              height: isSmall
                  ? 150
                  : isLarge
                      ? 280
                      : 220,
              width: isSmall
                  ? 110
                  : isLarge
                      ? 220
                      : 145,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: controller.imageFromSocial
                    ? Image.network(
                        controller.path!,
                        fit: BoxFit.fitHeight,
                      )
                    : controller.path != ''
                        ? Image.file(
                            File('${controller.path}'),
                            fit: BoxFit.fitHeight,
                          )
                        : ColoredBox(
                            color: AppColors.appGrey,
                            child: const Icon(Icons.add,
                                size: 80, color: Colors.white)),
              ),
            ),
          )),
    );
  }
}
