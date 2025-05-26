import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/destination.dart';
import '../service/destination_service.dart';
import '../widgets/destination_card.dart';

class CategoryDestinationsScreen extends StatefulWidget {
  final String category;

  const CategoryDestinationsScreen({super.key, required this.category});

  @override
  State<CategoryDestinationsScreen> createState() =>
      _CategoryDestinationsScreenState();
}

class _CategoryDestinationsScreenState
    extends State<CategoryDestinationsScreen> {
  final DestinationService _destinationService = DestinationService();
  List<Destination> _destinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      print('Attempting to load destinations for category: ${widget.category}');
      final destinations = await _destinationService.getDestinationsByCategory(
        widget.category,
      );

      if (destinations.isEmpty) {
        print(
          'No destinations found for ${widget.category}, attempting to create test data.',
        );
        // If no destinations found, try to create test data
        await _destinationService.createTestData();
        // Try loading destinations again after creating test data
        print(
          'Attempting to load destinations again after creating test data.',
        );
        final updatedDestinations = await _destinationService
            .getDestinationsByCategory(widget.category);
        print(
          'Found ${updatedDestinations.length} destinations after creating test data.',
        );
        setState(() {
          _destinations = updatedDestinations;
          _isLoading = false;
        });
      } else {
        print(
          'Found ${destinations.length} destinations for category: ${widget.category}',
        );
        setState(() {
          _destinations = destinations;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading destinations: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.poppins(
            color: Colors.blueAccent, // Adjust color as needed
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Or your desired background color
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.blueAccent, // Adjust color as needed for back button
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _destinations.length,
                itemBuilder: (context, index) {
                  return DestinationCard(destination: _destinations[index]);
                },
              ),
    );
  }
}
