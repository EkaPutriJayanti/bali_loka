import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Ambil user aktif dan data Firestore-nya
  Future<UserModel?> getCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(currentUser.uid, doc.data()! as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Update data user ke Firestore (buat dokumen jika belum ada)
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}
}
