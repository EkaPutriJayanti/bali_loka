import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String id;
  final String title;
  final String location;
  final String description;
  final String category;
  final String imageUrl;
  final bool isPopular;
  final double rating;
  final DateTime createdAt;
  final Map<String, dynamic> entranceTicket;
  final Map<String, dynamic> goldenTime;
  final bool isFavorite;

  Destination({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.isPopular,
    required this.rating,
    required this.createdAt,
    required this.entranceTicket,
    required this.goldenTime,
    this.isFavorite = false,
  });

  int get entranceFee => entranceTicket['entrance_fee'] ?? 0;
  int get activityFee => entranceTicket['activity'] ?? 0;

  factory Destination.fromFirestore(Map<String, dynamic> data, String id) {
    print('Converting Firestore data to Destination: $data');
    try {
      final entranceTicket = data['entrance_ticket'] ?? {};
      final goldenTime = data['golden_time'] ?? {};

      return Destination(
        id: id,
        title: data['title'] ?? '',
        location: data['location'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        imageUrl: data['image_url'] ?? '',
        isPopular: data['is_popular'] ?? false,
        rating:
            (data['rating'] is int)
                ? (data['rating'] as int).toDouble()
                : (data['rating'] ?? 0.0).toDouble(),
        createdAt: (data['created_at'] as Timestamp).toDate(),
        entranceTicket: Map<String, dynamic>.from(entranceTicket),
        goldenTime: Map<String, dynamic>.from(goldenTime),
      );
    } catch (e) {
      print('Error converting Firestore data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'is_popular': isPopular,
      'rating': rating,
      'created_at': Timestamp.fromDate(createdAt),
      'entrance_ticket': entranceTicket,
      'golden_time': goldenTime,
    };
  }
}

final List<Map<String, String>> categories = [
  {'name': 'Beach', 'image': 'assets/images/Beach.jpg'},
  {'name': 'Mount', 'image': 'assets/images/Mount.jpg'},
  {'name': 'Lake', 'image': 'assets/images/Lake.jpg'},
  {'name': 'Religi', 'image': 'assets/images/Religi.jpg'},
  {'name': 'Culture', 'image': 'assets/images/Culture.jpg'},
];

final List<Destination> popularDestinations = [
  Destination(
    id: '1',
    title: 'Tanah Lot Temple',
    location: 'Desa Beraban, Kec. Kediri',
    description: 'A beautiful temple on the sea',
    category: 'Religi',
    imageUrl: 'assets/images/TanahLot.jpg',
    isPopular: true,
    rating: 4.5,
    createdAt: DateTime.now(),
    entranceTicket: {},
    goldenTime: {'start': '06:00', 'finish': '18:00'},
  ),
  Destination(
    id: '2',
    title: 'Danau Beratan',
    location: 'Desa Candikuning',
    description: 'A beautiful lake in the mountains',
    category: 'Lake',
    imageUrl: 'assets/images/DanauBeratan.jpg',
    isPopular: true,
    rating: 4.3,
    createdAt: DateTime.now(),
    entranceTicket: {},
    goldenTime: {'start': '08:00', 'finish': '17:00'},
  ),
];

final List<Destination> newDestinations = [
  Destination(
    id: '3',
    title: 'Luna Beach Club',
    location: 'Desa Beraban, Kec. Kediri',
    description: 'A beautiful beach club',
    category: 'Beach',
    imageUrl: 'assets/images/LunaMoon.jpg',
    isPopular: false,
    rating: 4.7,
    createdAt: DateTime.now(),
    entranceTicket: {},
    goldenTime: {'start': '10:00', 'finish': '22:00'},
  ),
  Destination(
    id: '4',
    title: 'Alas Harum Bali',
    location: 'Tegallalang, Kab. Gianyar',
    description: 'A beautiful rice terrace',
    category: 'Culture',
    imageUrl: 'assets/images/AlasHarum.jpg',
    isPopular: false,
    rating: 4.4,
    createdAt: DateTime.now(),
    entranceTicket: {},
    goldenTime: {'start': '08:00', 'finish': '17:00'},
  ),
];
