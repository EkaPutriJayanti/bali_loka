import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/destination.dart';
import '../service/destination_service.dart';
import '../widgets/category_item.dart';
import '../widgets/destination_card.dart';
import '../widgets/new_destination_card.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'category_destinations_screen.dart';
import 'popular_destinations_screen.dart';
import 'new_destinations_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DestinationService _destinationService = DestinationService();
  List<Destination> _popularDestinations = [];
  List<Destination> _newDestinations = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ExploreScreen(),
    const WishlistScreen(),
    const ProfileScreen(onBackToHome: null),
  ];

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      final popular = await _destinationService.getPopularDestinations();
      final newDests = await _destinationService.getNewDestinations();

      setState(() {
        _popularDestinations = popular;
        _newDestinations = newDests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load destinations: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _createTestData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _destinationService.createTestData();
      await _loadDestinations();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test data created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create test data: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _selectedIndex == 0
              ? HomeContent(
                popularDestinations: _popularDestinations,
                newDestinations: _newDestinations,
              )
              : _pages[_selectedIndex - 1],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Destination> popularDestinations;
  final List<Destination> newDestinations;

  static const List<Map<String, String>> categories = [
    {'name': 'Beach', 'image': 'assets/images/Beach.jpg'},
    {'name': 'Mount', 'image': 'assets/images/Mount.jpg'},
    {'name': 'Lake', 'image': 'assets/images/Lake.jpg'},
    {'name': 'Religi', 'image': 'assets/images/Religi.jpg'},
    {'name': 'Culture', 'image': 'assets/images/Culture.jpg'},
    {'name': 'Waterfall', 'image': 'assets/images/Waterfall.jpg'},
  ];

  const HomeContent({
    super.key,
    required this.popularDestinations,
    required this.newDestinations,
  });

  @override
  Widget build(BuildContext context) {
    // Take only the first 3 popular destinations for the home screen
    final limitedPopularDestinations = popularDestinations.take(3).toList();

    // Take only the first 4 new destinations for the home screen
    final limitedNewDestinations = newDestinations.take(4).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Om Swastyastu, Queen',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Discover the beautiful Bali!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CategoryDestinationsScreen(
                                category: category['name']!,
                              ),
                        ),
                      );
                    },
                    child: CategoryItem(
                      name: category['name']!,
                      imageUrl: category['image']!,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PopularDestinationsScreen(
                              popularDestinations: popularDestinations,
                            ),
                      ),
                    );
                  },
                  child: const Text('Show all'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: limitedPopularDestinations.length,
              itemBuilder: (context, index) {
                return DestinationCard(
                  destination: limitedPopularDestinations[index],
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Destinations',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NewDestinationsScreen(
                              newDestinations: newDestinations,
                            ),
                      ),
                    );
                  },
                  child: const Text('Show all'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: limitedNewDestinations.length,
            itemBuilder: (context, index) {
              return NewDestinationCard(
                destination: limitedNewDestinations[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
