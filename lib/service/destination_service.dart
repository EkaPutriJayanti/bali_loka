import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/destination.dart';

class DestinationService {
  final CollectionReference destinations = FirebaseFirestore.instance
      .collection('destinations');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _ensureAuthenticated() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
        print('Signed in anonymously');
      } catch (e) {
        print('Error signing in anonymously: $e');
        throw Exception('Authentication failed: $e');
      }
    }
  }

  Future<String> addDestination({
    required String title,
    required String description,
    required String location,
    required String imageUrl,
    required String category,
    required bool isPopular,
    required double rating,
    required Map<String, dynamic> entranceTicket,
    required Map<String, dynamic> goldenTime,
  }) async {
    try {
      await _ensureAuthenticated();
      DocumentReference doc = await destinations.add({
        'title': title,
        'description': description,
        'location': location,
        'image_url': imageUrl,
        'category': category,
        'is_popular': isPopular,
        'rating': rating,
        'entrance_ticket': entranceTicket,
        'golden_time': goldenTime,
        'created_at': FieldValue.serverTimestamp(),
      });
      return doc.id;
    } catch (e) {
      throw Exception('Failed to add destination: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllDestinations() async {
    try {
      await _ensureAuthenticated();
      QuerySnapshot snapshot = await destinations.get();
      return snapshot.docs
          .map(
            (doc) => {
              'destination_id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            },
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get all destinations: $e');
    }
  }

  Future<List<Destination>> getPopularDestinations() async {
    try {
      await _ensureAuthenticated();
      print('Fetching popular destinations...');
      QuerySnapshot snapshot =
          await destinations
              .where('is_popular', isEqualTo: true)
              .orderBy('rating', descending: true)
              .limit(5)
              .get();

      print('Got ${snapshot.docs.length} popular destinations');

      final result =
          snapshot.docs.map((doc) {
            print('Processing document ${doc.id}');
            final data = doc.data() as Map<String, dynamic>;
            print('Document data: $data');
            return Destination.fromFirestore(data, doc.id);
          }).toList();

      print('Successfully converted ${result.length} destinations');
      return result;
    } catch (e) {
      print('Error in getPopularDestinations: $e');
      throw Exception('Failed to get popular destinations: $e');
    }
  }

  Future<List<Destination>> getNewDestinations() async {
    try {
      await _ensureAuthenticated();
      print('Fetching new destinations...');
      QuerySnapshot snapshot =
          await destinations
              .orderBy('created_at', descending: true)
              .limit(5)
              .get();

      print('Got ${snapshot.docs.length} new destinations');

      final result =
          snapshot.docs.map((doc) {
            print('Processing document ${doc.id}');
            final data = doc.data() as Map<String, dynamic>;
            print('Document data: $data');
            return Destination.fromFirestore(data, doc.id);
          }).toList();

      print('Successfully converted ${result.length} destinations');
      return result;
    } catch (e) {
      print('Error in getNewDestinations: $e');
      throw Exception('Failed to get new destinations: $e');
    }
  }

  Future<Destination?> getDestinationById(String id) async {
    try {
      await _ensureAuthenticated();
      DocumentSnapshot doc = await destinations.doc(id).get();
      if (doc.exists) {
        return Destination.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get destination by id: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getReviews(String destinationId) async {
    try {
      await _ensureAuthenticated();
      QuerySnapshot snapshot =
          await destinations
              .doc(destinationId)
              .collection('reviews')
              .orderBy('created_at', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        return {'review_id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  Future<void> addReview({
    required String destinationId,
    required String comment,
    required String email,
  }) async {
    try {
      await _ensureAuthenticated();
      await destinations.doc(destinationId).collection('reviews').add({
        'comment': comment,
        'email': email,
        'likes': 0,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  Future<void> updateDestination(String id, Map<String, dynamic> data) async {
    try {
      await _ensureAuthenticated();
      await destinations.doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update destination: $e');
    }
  }

  Future<void> deleteDestination(String id) async {
    try {
      await _ensureAuthenticated();
      await destinations.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete destination: $e');
    }
  }

  Future<List<Destination>> getDestinationsByCategory(String category) async {
    try {
      await _ensureAuthenticated();
      print('Fetching destinations for category: $category');
      QuerySnapshot snapshot =
          await destinations
              .where('category', isEqualTo: category)
              .orderBy('title')
              .get();

      print(
        'Found ${snapshot.docs.length} destinations for category: $category',
      );

      final result =
          snapshot.docs.map((doc) {
            print('Processing document ${doc.id} with data: ${doc.data()}');
            return Destination.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();

      print('Successfully converted ${result.length} destinations');
      return result;
    } catch (e) {
      print('Error in getDestinationsByCategory: $e');
      throw Exception('Failed to get destinations by category: $e');
    }
  }

  Future<void> createTestData() async {
    try {
      await _ensureAuthenticated();
      print('Starting test data creation...');

      // Create test destinations
      final testDestinations = [
        {
          'title': 'Tanah Lot Temple',
          'location': 'Desa Beraban, Kec. Kediri',
          'description':
              'A beautiful temple on the sea with stunning sunset views. One of Bali\'s most iconic landmarks.',
          'category': 'Religi',
          'image_url': 'assets/images/TanahLot.jpg',
          'is_popular': true,
          'rating': 4.8,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 50000, 'activity': 0},
          'golden_time': {'start': '06:00', 'finish': '18:00'},
        },
        {
          'title': 'Ubud Monkey Forest',
          'location': 'Ubud, Gianyar',
          'description':
              'Sacred monkey sanctuary and natural forest with ancient temples.',
          'category': 'Culture',
          'image_url': 'assets/images/UbudMonkey.jpg',
          'is_popular': true,
          'rating': 4.5,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 80000, 'activity': 0},
          'golden_time': {'start': '08:30', 'finish': '17:30'},
        },
        {
          'title': 'Tegallalang Rice Terrace',
          'location': 'Tegallalang, Gianyar',
          'description':
              'Famous rice terraces with stunning views of the valley.',
          'category': 'Culture',
          'image_url': 'assets/images/TegallalangRice.jpg',
          'is_popular': true,
          'rating': 4.6,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 25000, 'activity': 0},
          'golden_time': {'start': '07:00', 'finish': '17:00'},
        },
        {
          'title': 'Kuta Beach',
          'location': 'Kuta, Badung',
          'description':
              'Famous beach known for surfing and beautiful sunsets.',
          'category': 'Beach',
          'image_url': 'assets/images/KutaBeach.jpg',
          'is_popular': true,
          'rating': 4.4,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 0, 'activity': 0},
          'golden_time': {'start': '06:00', 'finish': '18:00'},
        },
        {
          'title': 'Mount Batur',
          'location': 'Kintamani, Bangli',
          'description':
              'Active volcano with stunning sunrise views from the summit.',
          'category': 'Mount',
          'image_url': 'assets/images/SunriseBatur.jpg',
          'is_popular': true,
          'rating': 4.7,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 100000, 'activity': 0},
          'golden_time': {'start': '04:00', 'finish': '10:00'},
        },
        {
          'title': 'Danau Beratan',
          'location': 'Bedugul, Tabanan',
          'description': 'Beautiful lake surrounded by mountains and temples.',
          'category': 'Lake',
          'image_url': 'assets/images/DanauBeratan.jpg',
          'is_popular': true,
          'rating': 4.6,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 50000, 'activity': 0},
          'golden_time': {'start': '08:00', 'finish': '17:00'},
        },
        {
          'title': 'Tibumana Waterfall',
          'location': 'Bangli, Bali',
          'description': 'Hidden waterfall in the middle of the jungle.',
          'category': 'Waterfall',
          'image_url': 'assets/images/Waterfall.jpg',
          'is_popular': true,
          'rating': 4.5,
          'created_at': FieldValue.serverTimestamp(),
          'entrance_ticket': {'entrance_fee': 20000, 'activity': 0},
          'golden_time': {'start': '08:00', 'finish': '17:00'},
        },
      ];

      // Add destinations to Firestore
      for (var destination in testDestinations) {
        print('Adding destination: ${destination['title']}');
        await destinations.add(destination);
      }

      print('Test data created successfully');
    } catch (e) {
      print('Error creating test data: $e');
      throw Exception('Failed to create test data: $e');
    }
  }
}
