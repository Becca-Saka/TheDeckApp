import 'package:thedeck/app/routes/const_routes.dart';

class NoMessageItem extends StatelessWidget {
  const NoMessageItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: MySize.yMargin(60),
                  width: MySize.xMargin(80),
                  child: SvgPicture.asset(
                    'assets/images/nomessage.svg',
                    height: MySize.yMargin(60),
                    width: MySize.xMargin(80),
                    fit: BoxFit.scaleDown,
                  )),
              Text(
                'No messages yet',
                style: TextStyle(
                    color: Colors.black, fontSize: MySize.textSize(4)),
              ),
            ]),
      ),
    );
  }
}
