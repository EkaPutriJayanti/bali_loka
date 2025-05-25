import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final CollectionReference favorites = FirebaseFirestore.instance.collection(
    'favorites',
  );

  Future<String> addFavorite({
    required String userId,
    required String destinationId,
  }) async {
    DocumentReference doc = await favorites.add({
      'user_id': userId,
      'destination_id': destinationId,
      'created_at': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<List<Map<String, dynamic>>> getFavoritesByUser(String userId) async {
    QuerySnapshot snapshot =
        await favorites.where('user_id', isEqualTo: userId).get();
    return snapshot.docs
        .map(
          (doc) => {
            'favorite_id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          },
        )
        .toList();
  }

  Future<void> deleteFavorite(String favoriteId) async {
    await favorites.doc(favoriteId).delete();
  }
}
