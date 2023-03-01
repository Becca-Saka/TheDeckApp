import 'package:flutter/material.dart';
import 'package:thedeck/shared/const_color.dart';
import 'package:thedeck/shared/const_size.dart';

class DecoratedTextBackground extends StatelessWidget {
  const DecoratedTextBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.appGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(MySize.isSmall ? 15 : 20.0),
        child: child,
      ),
    );
  }
}
