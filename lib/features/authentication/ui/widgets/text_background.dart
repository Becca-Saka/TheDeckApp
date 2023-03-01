import 'package:thedeck/app/routes/const_routes.dart';

class TextBackground extends StatelessWidget {
  const TextBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(
          top: MySize.isSmall ? 22 : 16,
          bottom: 12,
        ),
        child: child,
      ),
    );
  }
}
