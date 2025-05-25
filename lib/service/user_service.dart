import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    DocumentSnapshot doc = await users.doc(userId).get();
    if (doc.exists) {
      return {'user_id': doc.id, ...doc.data() as Map<String, dynamic>};
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await users.doc(userId).update(data);
  }
}
