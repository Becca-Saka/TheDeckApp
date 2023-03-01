import 'package:thedeck/app/routes/const_routes.dart';

class ChatActions extends StatelessWidget {
  const ChatActions({
    Key? key,
    required this.isSmall,
    required this.isLarge,
    required this.openImage,
    required this.controller,
    required this.sendMessage,
    required this.focusNode,
  }) : super(key: key);

  final bool isSmall;
  final bool isLarge;
  final Function() openImage, sendMessage;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        height: MySize.yMargin(9),
        margin: EdgeInsets.symmetric(horizontal: isSmall ? 5 : 11),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.appGrey),
            )),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: openImage,
              child: SizedBox(
                  height: isSmall
                      ? 20
                      : isLarge
                          ? 30
                          : 25,
                  width: isSmall
                      ? 20
                      : isLarge
                          ? 30
                          : 25,
                  child: Image.asset(
                    'assets/images/Plus.png',
                    cacheHeight: 25,
                    cacheWidth: 25,
                  )),
            ),
            widthMin(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.appGrey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ).copyWith(
                    top: isSmall ? 10 : 0,
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            widthMin(),
            InkWell(
              onTap: sendMessage,
              child: SizedBox(
                  height: isSmall
                      ? 20
                      : isLarge
                          ? 37
                          : 32,
                  width: isSmall
                      ? 20
                      : isLarge
                          ? 37
                          : 32,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Send.png',
                      cacheHeight: 36,
                      cacheWidth: 36,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
