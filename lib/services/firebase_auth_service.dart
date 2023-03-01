import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<String?> signIn(String email, String password) async {
    final UserCredential authResult = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    final User? user = authResult.user;
    return user?.uid;
  }

  Future<String?> signUp(String email, String password) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = authResult.user;
    return user?.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  bool get providerIsFacebook {
    final providerId = _firebaseAuth.currentUser!.providerData.first.providerId;
    return providerId == 'facebook.com' ? true : false;
  }

  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential credential) {
    return _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> delete() async => await _firebaseAuth.currentUser!.delete();
}
