import 'package:thedeck/app/routes/const_routes.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSmall = MySize.isSmall;
    bool isMedium = MySize.isMedium;

    return Center(
      child: SizedBox(
          height: isSmall
              ? 130
              : isMedium
                  ? 200
                  : 300,
          width: isSmall
              ? 130
              : isMedium
                  ? 200
                  : 300,
          child: SvgPicture.asset(
            'assets/images/Deck Logo Transparent.svg',
          )),
    );
  }
}
