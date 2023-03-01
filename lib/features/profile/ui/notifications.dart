import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:thedeck/features/authentication/controller/edit_profile_controller.dart';
import 'package:thedeck/features/home/ui/base_view.dart';
import 'package:thedeck/shared/const_color.dart';
import 'package:thedeck/shared/const_size.dart';
import 'package:thedeck/shared/const_widget.dart';

class NotificationSetting extends StatelessWidget {
  const NotificationSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isLarge = MySize.isLarge;

    return BaseView<EditProfileController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: controller.goBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightMin(size: 1),
                  Text(
                    'Receive Notifications When You:',
                    style: TextStyle(
                      fontSize: MySize.textSize(isLarge ? 3.2 : 4.2),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  heightMin(size: 2),
                  SwitchItem(
                      onChanged: controller.updateMatchNotificationSetting,
                      status: controller.recieveMatchAlert,
                      text: 'Receive a New Match'),
                  heightMin(size: 1),
                  const Divider(
                    thickness: 1.2,
                  ),
                  heightMin(size: 1),
                  SwitchItem(
                    onChanged: controller.updateMessageNotificationSetting,
                    status: controller.recieveMessageAlert,
                    text: 'Receive a Message',
                  ),
                ],
              )),
        );
      },
    );
  }
}

class SwitchItem extends StatelessWidget {
  const SwitchItem({
    super.key,
    required this.text,
    required this.status,
    required this.onChanged,
  });

  final String text;
  final bool status;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final isSmall = MySize.isSmall;
    final isMedium = MySize.isMedium;
    final isLarge = MySize.isLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: MySize.textSize(isLarge ? 3.5 : 4.5),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        FlutterSwitch(
          width: MySize.xMargin(isMedium
              ? 15
              : isSmall
                  ? 11
                  : 13),
          activeColor: AppColors.appRed,
          height: MySize.yMargin(isMedium ? 3.2 : 3.5),
          value: status,
          toggleSize: MySize.xMargin(isMedium ? 6 : 5),
          borderRadius: 30.0,
          padding: 0.8,
          onToggle: onChanged,
        ),
      ],
    );
  }
}
