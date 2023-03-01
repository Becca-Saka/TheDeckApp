// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' as math;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:thedeck/models/user_details/user_details.dart';
// import 'package:thedeck/services/authentication_service.dart';
// import 'package:thedeck/services/navigation_services.dart';

// class TestScreen extends StatelessWidget {
//   TestScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: TextButton(
//           child: Text('data'),
//           onPressed: () async {
//             loadCSV();
//           },
//         ),
//       ),
//     );
//   }

//   String readTimeStampDaysOnly(DateTime timeStamp) {
//     var now = DateTime.now();
//     final times = timeStamp;
//     var diff = now.difference(times);
//     var time = '';
//     if (diff.inSeconds <= 0 ||
//         diff.inSeconds > 0 && diff.inMinutes == 0 ||
//         diff.inMinutes > 0 && diff.inHours == 0 ||
//         diff.inHours > 0 && diff.inDays <= 1) {
//       time = 'Today';
//     } else if (diff.inDays > 1 && diff.inDays < 2) {
//       time = 'Yesterday';
//     } else {
//       time = DateFormat.yMMMd().format(times);
//     }
//     return time;
//   }

//   Future<void> loginSamp() async {
//     try {
//       FirebaseAuth auth = FirebaseAuth.instance;
//       await auth.signInWithEmailAndPassword(
//           email: 'test@example.com', password: '1234567');
//       log('logged in');
//     } on FirebaseAuthException catch (e) {
//       NavigationService.close(1);
//       log('$e');
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//     }
//   }

//   login() async {
//     await loginSamp();
//   }

//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   // This function is triggered when the floating button is pressed
//   void deleteCSV() async {
//     final doc = await firestore.collection("Users").get();
//     List<UserDetails> result = doc.docs
//         .map<UserDetails>((e) => UserDetails.fromJson(e.data()))
//         .toList();
//     // result.removeWhere((element) => element.uid == currentUser.uid);
//     result.forEach((element) async {
//       await firestore.collection("Users").doc(element.uid).delete();
//     });
//   }

//   List<UserDetails> added = [];
//   bool getDistanceDiffy(
//       double userlat, double userlong, double lat, double long, diff) {
//     // log('message p');
//     final getDistanceDiff =
//         Geolocator.distanceBetween(userlat, userlong, lat, long);
//     final distanceInKM = getDistanceDiff / 50000;
//     // final distanceInKM = getDistanceDiff / 1000;
//     // if (distanceInKM <= 500) {
//     //   log('message $distanceInKM');
//     // }
//     return distanceInKM <= diff;
//   }

//   void loadCSV() async {
//     try {
//       // await login();
//       // await firestore
//       //     .collection("Usersz")
//       //     .doc()
//       //     .set({'uid': 'currentUser.uid', 'name': 'currentUser.displayName'})
//       //     .whenComplete(() => log('message'));
//       List<UserDetails> valid = [];
//       print('object');
//       final _rawData = await rootBundle.loadString("assets/json/THe deck.json");
//       final List data = await json.decode(_rawData);

//       List<UserDetails> res =
//           data.map((item) => new UserDetails.fromJson(item)).toList();
//       res.shuffle();

//       res.forEach((element) {
//         final rand = math.Random();
//         // final y = rand.nextInt(DateTime.now().add(Duration(hours: -8)).hour);
//         final ty = DateTime.now().subtract(Duration(hours: 8));
//         final tx = Timestamp.fromDate(ty);
//         element.lastMatchedTime = tx;
//         element.openToMatch = true;
//       });
//       res = res
//           .where((element) => formatDate(element.lastMatchedTime) >= 8)
//           .toList();

//       log('here' + res.length.toString());

//       final tempCurrentUsery = res[math.Random().nextInt(res.length)];

//       print('object t');
//       res.forEach((user) {
//         if (getDistanceDiffy(tempCurrentUsery.lat!, tempCurrentUsery.long!,
//             user.lat!, user.long!, 500)) {
//           valid.add(user);
//         }
//       });

//       log('${valid.length}');

//       valid.shuffle();
//       // final tempindex =
//       //     tt.indexWhere((element) => element.uid == tempCurrentUsery.uid);
//       final tempCurrentUser = tempCurrentUsery;
//       valid.removeWhere((element) =>
//           element.uid == tempCurrentUser.uid &&
//           element.name == tempCurrentUser.name);

//       final finalList = valid.take(19).toList();

//       // final tempCurrentUspgone =
//       //     finalList[math.Random().nextInt(finalList.length)];
//       // finalList.removeWhere((element) =>
//       //     element.uid == tempCurrentUspgone.uid &&
//       //     element.name == tempCurrentUspgone.name);
//       // final finalList = tt;
//       // log('$finalList');

//       // log('got here');
//       // tempCurrentUser.uid = FirebaseAuth.instance.currentUser!.uid;
//       // tempCurrentUser.email = FirebaseAuth.instance.currentUser!.email;
//       // tempCurrentUser.fcmToken = await FirebaseMessaging.instance.getToken();

//       // tempCurrentUspgone.uid = 'xQ0PvlW6g9efSJx9lxQoVYXOQCv1';
//       // tempCurrentUspgone.email = 'tester@example.com';
//       // tempCurrentUspgone.fcmToken =
//       //     'fgyydU0MR7ScfV_T-sZ7T4:APA91bH7B5muh5mRQwJmznd05NIJYf5tXMSszEoj0BLB-VlFqEjgPIvBYEXRbzP0U4P6Y8kdmwj4lUoSskki3HPFNk4VbNPi4Sd_dJ3cqaJ3TbaZUqZsC1oQZwVwKWZTX0AGzVdBmt96';
//       added = finalList;
//       added.add(tempCurrentUser);

//       print('object tjddnn');
//       added.forEach((userDetails) async {
//         log('about to add');
//         try {
//           await firestore
//               .collection("Users")
//               .doc(userDetails.uid)
//               .set(userDetails.toJson());
//           log('object added');
//         } on Exception catch (e) {
//           log('object not added, why? ${e.toString()}');
//         }
//       });
//       // finalList.forEach((userDetails) async {
//       //   await firestore
//       //       .collection("Users")
//       //       .doc(userDetails.uid)
//       //       .set(userDetails.toJson())
//       //       .whenComplete(() async => await firestore
//       //           .collection("Users")
//       //           .doc(tempCurrentUser.uid)
//       //           .set(tempCurrentUser.toJson()))
//       //       .whenComplete(() => log('done'));
//       // }

//       // .whenComplete(() async => await firestore
//       //     .collection("Users")
//       //     .doc(tempCurrentUspgone.uid)
//       //     .set(tempCurrentUspgone.toJson()))
//       // );
//       log('object done');
//     } catch (e) {
//       log('Error $e');
//     }
//   }

//   int formatDate(Timestamp timeStamp) {
//     final old =
//         DateTime.fromMillisecondsSinceEpoch(timeStamp.millisecondsSinceEpoch);
//     var now = DateTime.now();
//     var diff = now.difference(old);
//     return diff.inHours;
//   }
// }
