import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passion_factory/main.dart';
import 'package:passion_factory/model/user.dart' as model;

class UserRepository {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String myUid;

  UserRepository() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        logger.i('User is currently signed out!');
      } else {
        myUid = user.uid;
        logger.i('User is signed in! >>>>>>>> $myUid}');
      }
    });
  }

  /*
  * ID, PW 회원가입
  * */
  Future<void> joinApp({required model.User user}) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.pw!,
      );

      myUid = userCredential.user!.uid;
      await users.add({
        'nickname': user.nickname,
        'uid': myUid,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });

    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        logger.i('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.i('The account already exists for that email.');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> loginApp({required model.User user}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email!, password: user.pw!);
    } catch (e){
      logger.e(e);
    }
  }

  /*
  * 로그아웃
  * */
  Future<void> logout() async {
    auth.signOut();
  }

  /*
  * 모든 유저 리스트 가져오기
  * */
  Future<List<model.User>?> getAllUserList() async {
    try {
      final snapshot = await users.where("uid", isNotEqualTo: myUid).get().then((value) => value.docs);
      List<model.User> userList = snapshot.map((e) => model.User.fromJson(e.data())).toList();

      return userList;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
