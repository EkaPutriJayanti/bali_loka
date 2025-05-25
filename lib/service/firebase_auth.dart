import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> registerUser(
  String username,
  String email,
  String password,
  String phone,
) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  UserCredential userCredential = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  await firestore.collection('users').doc(userCredential.user!.uid).set({
    'username': username,
    'email': email,
    'phone': phone,
    'created_at': FieldValue.serverTimestamp(),
  });
}

Future<User?> loginUser(String email, String password) async {
  final auth = FirebaseAuth.instance;
  UserCredential userCredential = await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return userCredential.user;
}
