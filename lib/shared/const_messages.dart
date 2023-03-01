// import 'package:flutter/material.dart';
// import 'package:thedeck/services/navigation_services.dart';
// import 'package:thedeck/shared/const_color.dart';

// ScaffoldFeatureController<Widget, dynamic> appDialog.errorSnackbar(
//     {required String msg}) {
//   return NavigationService.snackBar(
//     'Error!',
//     msg,
//     backgroundColor: Colors.red[700],
//     colorText: Colors.white,
//   );
// }

// ScaffoldFeatureController<Widget, dynamic> successSnackbar(
//     {required String msg, required String title}) {
//   return NavigationService.snackBar(
//     title,
//     msg,
//     backgroundColor: Colors.green,
//     colorText: Colors.white,
//   );
// }

// Future<dynamic> appDialog.showLoadingDialog({String? msg}) {
//   return NavigationService.dialog(
//       SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
//     Padding(
//       padding: const EdgeInsets.all(9.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(AppColors.appRed),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             '${msg ?? ''} Please wait...',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppColors.appRed, fontSize: 13),
//           )
//         ],
//       ),
//     ),
//   ]));
// }
