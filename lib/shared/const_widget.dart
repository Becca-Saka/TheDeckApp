//Defining sizes
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:thedeck/shared/const_color.dart';
import 'package:thedeck/shared/const_size.dart';

Widget heightOne() {
  return SizedBox(
    height: MySize.yMargin(1),
  );
}

Widget widthOne() {
  return SizedBox(
    width: MySize.xMargin(1),
  );
}

Widget heightTwo() {
  return SizedBox(
    height: MySize.yMargin(2),
  );
}

Widget widthTwo() {
  return SizedBox(
    width: MySize.xMargin(2),
  );
}

Widget heightMin({double size = 3}) {
  return SizedBox(
    height: MySize.yMargin(size),
  );
}

Widget heightMini({double size = 15}) {
  return SizedBox(height: size);
}

Widget widthMini({double size = 15}) {
  return SizedBox(
    width: size,
  );
}

Widget widthMin({double size = 3}) {
  return SizedBox(
    width: MySize.xMargin(size),
  );
}

Widget customTextField(
    {required hintText,
    TextEditingController? controller,
    TextInputType? textInputType,
    String? initialValue,
    bool isEnabled = true,
    Function()? onTap,
    Function(String)? onSubmitted,
    Function(String)? onChanged,
    bool isLast = false}) {
  return SizedBox(
    height: MySize.yMargin(2.8),
    child: TextFormField(
      maxLines: 1,
      initialValue: initialValue,
      enableInteractiveSelection: isEnabled,
      onTap: isEnabled == false ? onTap : null,
      textInputAction: isLast ? null : TextInputAction.next,
      controller: controller,
      keyboardType: textInputType,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(0.0),
          border: InputBorder.none,
          isDense: true,
          hintStyle: TextStyle(
              height: 1, letterSpacing: 0.2, color: AppColors.apptextGrey)),
    ),
  );
}

Widget authButton(
  String text, {
  Function()? onTap,
  double height = 50.0,
  double fontSize = 17.0,
  bool isButtonEnabled = false,
  bool isFacebook = false,
  bool isApple = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: isFacebook
              ? const Color(0xFF4267B2)
              : isApple
                  ? Colors.black
                  : (isButtonEnabled
                      ? AppColors.appRed
                      : AppColors.appRed.withOpacity(0.5)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onTap,
      child: Text(text,
          style: TextStyle(
              letterSpacing: 1.2,
              color: Colors.white,
              fontFamily: 'League Spartan',
              fontSize: fontSize)),
    ),
  );
}

Widget authButtons(String text,
    {Function()? onTap,
    double height = 50.0,
    double fontSize = 14.0,
    bool isButtonEnabled = false,
    bool isFacebook = false}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: isFacebook
              ? const Color(0xFF4267B2)
              : (isButtonEnabled
                  ? AppColors.appRed
                  : AppColors.appRed.withOpacity(0.5)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onTap,
      child: Text(text,
          style: TextStyle(
              letterSpacing: 1.2,
              color: Colors.white,
              fontFamily: 'League Spartan',
              fontSize: fontSize)),
    ),
  );
}

Widget appHeader(double deckSize, double peopleSize) {
  return Column(
    children: [
      Text(
        'The Deck',
        style: TextStyle(
            color: AppColors.appRed, fontFamily: 'Chewy', fontSize: deckSize),
      ),
      heightOne(),
      Text(
        'COLLECT PEOPLE',
        style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.black,
            height: 1,
            fontWeight: FontWeight.bold,
            fontFamily: 'League Spartan',
            fontSize: peopleSize),
      ),
    ],
  );
}

String personPlaceholder = 'assets/images/person.png';
Widget profilePicture(String? image) {
  return FancyShimmerImage(
    errorWidget: Image.asset(
      personPlaceholder,
      fit: BoxFit.cover,
    ),
    imageUrl: image!,
    boxFit: BoxFit.cover,
  );
}

Widget backButton({
  Function()? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: MySize.xMargin(
        0.2,
      ),
      width: MySize.xMargin(15),
      child: Image.asset(
        'assets/images/Back.png',
        fit: BoxFit.contain,
        width: 5,
        height: 2,
      ),
    ),
  );
}
