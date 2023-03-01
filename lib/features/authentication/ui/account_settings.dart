import 'package:flutter/material.dart';
import 'package:thedeck/app/locator.dart';
import 'package:thedeck/features/authentication/controller/edit_profile_controller.dart';
import 'package:thedeck/shared/const_color.dart';
import 'package:thedeck/shared/const_size.dart';
import 'package:thedeck/shared/const_widget.dart';

class AccountSetting extends StatelessWidget {
  AccountSetting({Key? key}) : super(key: key);

  final EditProfileController controller = locator<EditProfileController>();
  @override
  Widget build(BuildContext context) {
    final isLarge = MySize.isLarge;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: controller.goBack,
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(children: [
            heightMin(size: 0.5),
            InkWell(
              onTap: controller.openPrivacyUrl,
              child: Container(
                height: MySize.yMargin(4),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: MySize.textSize(isLarge ? 3 : 4),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1.2),
            heightMin(size: 0.5),
            InkWell(
              onTap: controller.openTermsUrl,
              child: Container(
                height: MySize.yMargin(isLarge ? 3 : 4),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: MySize.textSize(isLarge ? 3 : 4),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            heightMin(size: 0.5),
            const Divider(thickness: 1.2),
            heightMin(size: 0.5),
            InkWell(
              onTap: controller.showConfirmationDialog,
              child: Container(
                height: MySize.yMargin(4),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: MySize.textSize(isLarge ? 3 : 4),
                    fontFamily: 'Poppins',
                    color: AppColors.appRed.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
