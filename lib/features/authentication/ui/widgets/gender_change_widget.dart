import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/authentication/controller/edit_profile_controller.dart';

class GenderChangeWidget extends StatelessWidget {
  const GenderChangeWidget({
    super.key,
    required this.controller,
  });

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    final isLarge = MySize.isLarge;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: controller.updatedPrefferedGender,
      title: Text(
        'Gender to be matched with?',
        style: TextStyle(
          fontSize: MySize.textSize(isLarge ? 3 : 4),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        'Tap to change',
        style: TextStyle(
          fontSize: MySize.textSize(isLarge ? 3 : 4),
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: SizedBox(
        height: MySize.xMargin(10),
        width: MySize.xMargin(10),
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Image.asset(controller.prefferedGender == 'Male'
                ? 'assets/images/Gender Male.png'
                : 'assets/images/Gender Female.png')),
      ),
    );
  }
}
