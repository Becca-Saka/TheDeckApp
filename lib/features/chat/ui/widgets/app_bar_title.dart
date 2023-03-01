import 'package:thedeck/app/routes/const_routes.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.isSmall,
    required this.isMedium,
    required this.title,
    required this.navigateToViewUser,
    required this.url,
  }) : super(key: key);

  final bool isSmall;
  final bool isMedium;
  final Function() navigateToViewUser;
  final String title, url;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            await Future.delayed(const Duration(milliseconds: 120));
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: isSmall
                      ? 12
                      : isMedium
                          ? 16
                          : 18,
                  letterSpacing: 0.5,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        InkWell(
          onTap: navigateToViewUser,
          child: SizedBox(
              height: isSmall
                  ? 24
                  : isMedium
                      ? 28
                      : 30,
              width: isSmall
                  ? 24
                  : isMedium
                      ? 28
                      : 30,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Hero(tag: 'picture', child: profilePicture(url)))),
        ),
      ],
    );
  }
}
