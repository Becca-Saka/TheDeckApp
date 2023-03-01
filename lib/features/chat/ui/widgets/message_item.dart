import 'dart:io';

import 'package:intl/intl.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/models/message_details/message_details.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.isLarge,
    required this.isSmall,
    required this.element,
    required this.uid,
    this.onTap,
    this.isTemp = false,
  }) : super(key: key);

  final bool isLarge;
  final bool isSmall;
  final Message element;
  final String uid;
  final Function()? onTap;
  final bool isTemp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment:
            (element.senderId != uid ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          margin: EdgeInsets.only(
            left: element.senderId == uid
                ? MySize.xMargin(25)
                : MySize.xMargin(5),
            right: element.senderId == uid
                ? MySize.xMargin(5)
                : MySize.xMargin(25),
          ),
          child: Column(
            crossAxisAlignment: element.senderId == uid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: element.senderId == uid ? MySize.xMargin(3) : 0,
                  right: element.senderId == uid ? MySize.xMargin(3) : 0,
                ),
                child: Text(
                  DateFormat.Hm().format(parseTimeStamp(element.time)),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: isLarge
                          ? 18
                          : isSmall
                              ? 8
                              : 10),
                ),
              ),
              element.isImage!
                  ? GestureDetector(
                      onTap: onTap,
                      child: Hero(
                        tag: 'image${element.imageUrl}',
                        child: SizedBox(
                          height: MySize.yMargin(25),
                          width: MySize.xMargin(60),
                          child: profilePicture(element.imageUrl!),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: (element.senderId == uid
                            ? AppColors.appRed
                            : AppColors.appGrey),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        element.message!,
                        style: TextStyle(
                            color: (element.senderId == uid
                                ? Colors.white
                                : Colors.black),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: isLarge
                                ? 21
                                : isSmall
                                    ? 12
                                    : 14),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class TempMessageItem extends StatelessWidget {
  const TempMessageItem({
    Key? key,
    required this.element,
    required this.isLarge,
    required this.isSmall,
    required this.uid,
  }) : super(key: key);

  final Message element;
  final bool isLarge;
  final bool isSmall;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(
            left: MySize.xMargin(25),
            right: MySize.xMargin(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MySize.xMargin(3),
                  right: MySize.xMargin(3),
                ),
                child: Text(
                  DateFormat.Hm().format(parseTimeStamp(element.time)),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: isLarge
                          ? 18
                          : isSmall
                              ? 8
                              : 10),
                ),
              ),
              element.isImage!
                  ? Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: MySize.yMargin(25),
                            width: MySize.xMargin(60),
                            child: Image.file(
                              File(element.imageUrl!),
                              color: const Color.fromRGBO(255, 255, 255, 0.5),
                              colorBlendMode: BlendMode.modulate,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        element.message!,
                        style: TextStyle(
                            color: (element.senderId == uid
                                ? Colors.white
                                : Colors.black),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: isLarge
                                ? 21
                                : isSmall
                                    ? 12
                                    : 14),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
