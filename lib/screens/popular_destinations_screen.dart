import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularDestinationsScreen extends StatelessWidget {
  final List<Destination> popularDestinations;

  const PopularDestinationsScreen({
    super.key,
    required this.popularDestinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular Destinations',
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
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16, // Spacing between columns
          mainAxisSpacing: 16, // Spacing between rows
          childAspectRatio: 0.75, // Adjust aspect ratio to match card size
        ),
        itemCount: popularDestinations.length,
        itemBuilder: (context, index) {
          return DestinationCard(destination: popularDestinations[index]);
        },
      ),
    );
  }
}
