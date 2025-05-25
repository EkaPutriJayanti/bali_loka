import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationService {
  final CollectionReference destinations = FirebaseFirestore.instance
      .collection('destinations');

  Future<String> addDestination({
    required String name,
    required String description,
    required String location,
    required String imageUrl,
    required String category,
  }) async {
    DocumentReference doc = await destinations.add({
      'name': name,
      'description': description,
      'location': location,
      'image_url': imageUrl,
      'category': category,
      'created_at': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<List<Map<String, dynamic>>> getAllDestinations() async {
    QuerySnapshot snapshot = await destinations.get();
    return snapshot.docs
        .map(
          (doc) => {
            'destination_id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          },
        )
        .toList();
  }

  Future<Map<String, dynamic>?> getDestinationById(String id) async {
    DocumentSnapshot doc = await destinations.doc(id).get();
    if (doc.exists) {
      return {'destination_id': doc.id, ...doc.data() as Map<String, dynamic>};
    }
    return null;
  }

  Future<void> updateDestination(String id, Map<String, dynamic> data) async {
    await destinations.doc(id).update(data);
  }

  Future<void> deleteDestination(String id) async {
    await destinations.doc(id).delete();
  }
}
