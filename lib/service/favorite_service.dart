import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a destination to the user's wishlist subcollection
  Future<void> addFavorite({
    required String userId,
    required String destinationId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(
            destinationId,
          ) // Use destinationId as document ID for easy check/delete
          .set({
            'destination_id': destinationId,
            'created_at': FieldValue.serverTimestamp(),
          });
      print('Added $destinationId to user $userId wishlist');
    } catch (e) {
      print('Error adding to wishlist: $e');
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  // Get all favorite destinations for a user from the wishlist subcollection
  Future<List<Map<String, dynamic>>> getFavoritesByUser(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('wishlist')
              .get();

      print(
        'Found ${snapshot.docs.length} favorite destinations for user $userId',
      );

      return snapshot.docs.map((doc) {
        // Ensure data exists and cast it correctly
        final data = doc.data() as Map<String, dynamic>;
        return {
          'favorite_id': doc.id, // In this case, doc.id is the destinationId
          'destination_id': data['destination_id'],
          'created_at': data['created_at'],
        };
      }).toList();
    } catch (e) {
      print('Error getting user favorites: $e');
      throw Exception('Failed to get user favorites: $e');
    }
  }

  // Remove a destination from the user's wishlist subcollection
  // favoriteId here is actually the destinationId used as document ID
  Future<void> deleteFavorite({
    required String userId,
    required String destinationId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(destinationId) // Use destinationId as document ID
          .delete();
      print('Removed $destinationId from user $userId wishlist');
    } catch (e) {
      print('Error deleting from wishlist: $e');
      throw Exception('Failed to delete from wishlist: $e');
    }
  }

  // Check if a destination is in the user's wishlist
  Future<bool> isDestinationFavorited({
    required String userId,
    required String destinationId,
  }) async {
    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('wishlist')
              .doc(destinationId)
              .get();
      return doc.exists;
    } catch (e) {
      print('Error checking if favorited: $e');
      // Consider returning false or rethrowing based on desired error handling
      return false;
    }
  }
}
