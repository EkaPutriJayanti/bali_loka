import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/destination.dart';
import '../service/favorite_service.dart';
import '../service/destination_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/destination_card.dart';
import '../widgets/new_destination_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final DestinationService _destinationService = DestinationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Destination> _wishlistDestinations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please log in to view your wishlist.';
      });
      return;
    }

    try {
      // Get favorite items for the current user
      final favoriteItems = await _favoriteService.getFavoritesByUser(user.uid);

      // Extract destination IDs from favorite items
      final List<String> destinationIds =
          favoriteItems
              .map((item) => item['destination_id'] as String)
              .toList();

      // Fetch the full Destination objects for these IDs
      final List<Destination> destinations = [];
      for (final id in destinationIds) {
        final destination = await _destinationService.getDestinationById(id);
        if (destination != null) {
          // Note: Destination model currently doesn't have an isFavorite field directly populated here.
          // DestinationCard handles the favorite state internally based on clicks.
          // For initial display, we need to check if it's in the wishlist.
          // A better approach would be to modify getDestinationById to take userId and check wishlist,
          // or fetch wishlist IDs first and mark destinations accordingly.

          // For now, let's just add the destination. The DestinationCard will manage its own state,
          // which might not immediately reflect the favorited status on load unless we enhance it.

          // To make the heart red by default in this screen, we'll modify the Destination object temporarily
          // or pass a flag to DestinationCard if it supported it.
          // Let's assume DestinationCard can take an initialIsFavorite flag or we modify Destination.

          // Modifying the destination object for display in this screen:
          destinations.add(
            Destination(
              id: destination.id,
              title: destination.title,
              location: destination.location,
              description: destination.description,
              category: destination.category,
              imageUrl: destination.imageUrl,
              isPopular: destination.isPopular,
              rating: destination.rating,
              createdAt: destination.createdAt,
              entranceTicket: destination.entranceTicket,
              goldenTime: destination.goldenTime,
              isFavorite: true, // Mark as favorite for display in this screen
            ),
          );
        }
      }

      setState(() {
        _wishlistDestinations = destinations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load wishlist: ${e.toString()}';
      });
      print('Error loading wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist', // Keeping title as Wishlist for consistency
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueAccent),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _wishlistDestinations.isEmpty
              ? const Center(child: Text('Your wishlist is empty.'))
              : Column(
                // Use Column to add search bar above grid
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Your Favorite Place',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: _wishlistDestinations.length,
                      itemBuilder: (context, index) {
                        final destination = _wishlistDestinations[index];
                        // Pass the favorited status to DestinationCard
                        return DestinationCard(destination: destination);
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
