import 'package:flutter/material.dart';

class DetailExploreScreen extends StatelessWidget {
  final String category;
  const DetailExploreScreen({Key? key, required this.category}) : super(key: key);

  List<Map<String, String>> getPlacesByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'sunrise':
        return [
          {
            'image': 'assets/images/Sunrise_Mertasari.jpg',
            'name': 'Pantai Mertasari',
            'location': 'Kec. Denpasar Timur',
          },
          {
            'image': 'assets/images/Sunrise_Lovina.jpg',
            'name': 'Pantai Lovina',
            'location': 'Desa Beraban, Kec. Kediri',
          },
          {
            'image': 'assets/images/Sunrise_Sanur.jpg',
            'name': 'Pantai Sanur',
            'location': 'Kec. Denpasar Timur',
          },
          {
            'image': 'assets/images/Sunrise_Batur.jpg',
            'name': 'Gunung Batur',
            'location': 'Desa Beraban, Kec. Kediri',
          },
          {
            'image': 'assets/images/Sunrise_Kintamani.jpg',
            'name': 'Kintamani',
            'location': 'Kec. Kintamani, Bangli',
          },
        ];
      case 'dance':
        return [
          {
            'image': 'assets/images/CendrawasihDance.jpg',
            'name': 'Cendrawasih Dance',
            'location': 'Ubud, Gianyar',
          },
          {
            'image': 'assets/images/Tari_Barong.jpg',
            'name': 'Barong Dance',
            'location': 'GWK, Badung',
          },
          {
            'image': 'assets/images/Tari_Kecak.jpg',
            'name': 'Kecak Dance',
            'location': 'Uluwatu, Bsadung',
          },
          
        ];
      case 'market':
        return [
          {
            'image': 'assets/images/SundayMarketCanggu.jpg',
            'name': 'Sunday Market',
            'location': 'Canggu',
          },
        ];
      case 'monkey':
        return [
          {
            'image': 'assets/images/UbudMonkey.jpg',
            'name': 'Monkey Forest',
            'location': 'Ubud',
          },
        ];
      case 'sunset':
        return [
          {
            'image': 'assets/images/Sunset_TanahLot.jpg',
            'name': 'Tanah Lot',
            'location': 'Tabanan',
          },
        ];
      default:
        return [];
    }
  }

  String getTitle(String category) {
    switch (category.toLowerCase()) {
      case 'sunrise':
        return 'Sunrise';
      case 'dance':
        return 'Dance';
      case 'market':
        return 'Market';
      case 'monkey':
        return 'Monkey';
      case 'sunset':
        return 'Sunset';
      case 'spirituals':
        return 'Spirituals';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = getPlacesByCategory(category);
    final title = getTitle(category);
    return Scaffold(
      backgroundColor: Color(0xFFEFF2F7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue[800]),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore the Magic of $title',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: places.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            place['image']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      place['location']!,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

  