class Destination {
  final String name;
  final String location;
  final String imageUrl;
  final bool isFavorite;

  Destination({
    required this.name,
    required this.location,
    required this.imageUrl,
    this.isFavorite = false,
  });
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
    name: 'Tanah Lot Temple',
    location: 'Desa Beraban, Kec. Kediri',
    imageUrl: 'assets/images/TanahLot.jpg',
  ),
  Destination(
    name: 'Danau Beratan',
    location: 'Desa Candikuning',
    imageUrl: 'assets/images/DanauBeratan.jpg',
  ),
];

final List<Destination> newDestinations = [
  Destination(
    name: 'Luna Beach Club',
    location: 'Desa Beraban, Kec. Kediri',
    imageUrl: 'assets/images/LunaMoon.jpg',
  ),
  Destination(
    name: 'Alas Harum Bali',
    location: 'Tegallalang, Kab. Gianyar',
    imageUrl: 'assets/images/AlasHarum.jpg',
  ),
];
