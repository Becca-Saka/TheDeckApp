import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/home/ui/base_view.dart';

import '../controller/edit_profile_controller.dart';
import 'widgets/gender_change_widget.dart';
import 'widgets/image_stack.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileController>(
      onModelReady: (controller) {
        controller.setUserData();
      },
      builder: (context, controller, child) {
        return WillPopScope(
          onWillPop: () async {
            controller.updateUser();
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomCenter,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ImageStack(controller: controller),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenderChangeWidget(controller: controller),
                              heightMin(size: 2),
                              const Divider(
                                thickness: 1.2,
                              ),
                              EditProfileItem(
                                text: 'Notifications',
                                onTap: controller.goToNotification,
                              ),
                              const Divider(
                                thickness: 1.2,
                              ),
                              EditProfileItem(
                                text: 'Account Settings',
                                onTap: controller.goToAccountSettings,
                              ),
                              const Divider(
                                thickness: 1.2,
                              ),
                              EditProfileItem(
                                text: 'Signout',
                                onTap: controller.logout,
                                color: AppColors.appRed.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                        heightMin(size: MySize.isSmall ? 10 : 0),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: Container(
                          height: MySize.xMargin(15),
                          width: double.infinity,
                          color: Colors.white,
                          child: InkWell(
                              onTap: () {
                                controller.updateUser();
                                return controller.goBack();
                              },
                              child:
                                  Image.asset('assets/images/Close Icon.png')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EditProfileItem extends StatelessWidget {
  const EditProfileItem({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  final String text;
  final Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isLarge = MySize.isLarge;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MySize.yMargin(4),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
              fontSize: MySize.textSize(isLarge ? 3 : 4),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: color),
        ),
      ),
    );
  }
}
