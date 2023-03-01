import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:thedeck/app/routes/const_routes.dart';
import 'package:thedeck/features/home/controller/home_controller.dart';

class FirestoreServices {
  // final HomeController homeController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // FirebaseAuth auth = FirebaseAuth.instance;
  final messagecollection = FirebaseFirestore.instance.collection("Messages");
  final firestoreInstance = FirebaseFirestore.instance;
  final usercollection = FirebaseFirestore.instance.collection("Users");
  final deckcollection = FirebaseFirestore.instance.collection("Decks");
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('recursiveDeleteDeck');
  // final HomeController homeController = locator<HomeController>();

  Future<void> saveUserData(String email, String name, String age,
      String gender, String userId, String url) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final time = DateTime.now().subtract(const Duration(hours: 8));
    final timestamp = Timestamp.fromDate(time);
    UserDetails userDetails = UserDetails(
        email: email,
        name: name,
        age: age,
        prefferedGender: gender == 'Female' ? 'Male' : 'Female',
        lat: null,
        long: null,
        fcmToken: fcmToken,
        imageList: [url],
        lastMatchedTime: timestamp,
        gender: gender,
        uid: userId,
        imageUrl: url);

    await usercollection.doc(userDetails.uid).set(userDetails.toJson());
    await getData(userDetails.uid!);
  }

  Future<UserDetails?> getUserData(String userId) async {
    final userDoc = await getData(userId);
    if (userDoc.data() != null) {
      final UserDetails user = UserDetails.fromJson(userDoc.data()!);
      final token = await FirebaseMessaging.instance.getToken();
      if (user.fcmToken == null || user.fcmToken != token) {
        await update(id: userId, data: {'fcmToken': token});
      }
      locator<HomeController>().setUser(user);
      return user;
    }
    return null;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData(String uid) async {
    return await usercollection.doc(uid).get();
  }

  Future<void> update(
      {required Map<String, dynamic> data, required String id}) {
    return usercollection.doc(id).update(data);
  }

  Stream<UserDetails> getUserStream(String uid) {
    return usercollection
        .doc(uid)
        .snapshots()
        .map((event) => UserDetails.fromJson(event.data()!));
  }

  Future<void> removeMatch(UserDetails removeUser, MatchDetails matchDetails,
      UserDetails currentUser) async {
    removeUser.currentMatches.remove(currentUser.uid!);
    removeUser.currentDeck.remove(matchDetails.uid);
    removeUser.noOfCurrentMatches = removeUser.currentDeck.length;

    currentUser.currentMatches.remove(removeUser.uid!);
    currentUser.currentDeck.remove(matchDetails.uid);
    currentUser.noOfCurrentMatches = currentUser.currentDeck.length;
    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        transaction
            .update(usercollection.doc(currentUser.uid), currentUser.toJson())
            .update(usercollection.doc(removeUser.uid), removeUser.toJson());
      },
    );
    await callable.call({'path': 'Decks/${matchDetails.uid}'});
  }

  Future updateLastMatchedChecked(uid) async {
    UserDetails userDetails =
        UserDetails(lastMatchedTime: FieldValue.serverTimestamp());

    await usercollection.doc(uid).update(userDetails.toJson());
  }

  Future updateIsNew(MatchDetails matchDetails) async {
    final controller = locator<HomeController>();
    matchDetails.isNew![controller.currentUser.uid!] = false;

    await deckcollection.doc(matchDetails.uid).update({
      'isNew': matchDetails.isNew,
    });
  }

  Stream<List<MatchDetails>?> getCurrentlyMatchedUserStream() {
    final currentUser = locator<HomeController>().currentUser;
    if (currentUser.currentDeck.isEmpty) {
      return const Stream.empty();
    }

    return deckcollection
        .where('uid', whereIn: currentUser.currentDeck)
        .snapshots()
        .map((event) => event.docs.map((e) {
              final json = e.data();
              final MatchDetails match = MatchDetails(
                uid: json['uid'] as String,
                isNew: Map<String, bool>.from(json['isNew'] as Map),
                messageId: json['messageId'] as String?,
                timeMatched: json['timeMatched'],
                users: (json['users'] as List<dynamic>)
                    .map((e) => e as String)
                    .toList(),
                recentMessageTime: json['recentMessageTime'],
                unReadMessagesList:
                    (json['${currentUser.uid}Unread'] as List<dynamic>?)
                        ?.map((e) => e as String)
                        .toList(),
                recentmessage: json['recentmessage'] as String?,
              );
              return match;
            }).toList());
  }

  Stream<List<UserDetails>?> getUsersDetail() {
    final currentMatches = locator<HomeController>().currentUser.currentMatches;
    if (currentMatches.isEmpty) {
      return const Stream.empty();
    }

    return usercollection.where('uid', whereIn: currentMatches).snapshots().map(
        (event) =>
            event.docs.map((e) => UserDetails.fromJson(e.data())).toList());
  }

  Future<List<UserDetails>> getUsersSingleDetail(List<String> userIds) async {
    final user = await usercollection.where('uid', whereIn: userIds).get();
    return user.docs.map((e) => UserDetails.fromJson(e.data())).toList();
  }

  Future<void> blockUser(UserDetails removeUser, MatchDetails matchDetails,
      UserDetails user) async {
    user.blockedUsers.add(removeUser.uid!);
    await removeMatch(removeUser, matchDetails, user);
  }
}
