import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../widgets/new_destination_card.dart';
import 'package:google_fonts/google_fonts.dart';

class NewDestinationsScreen extends StatelessWidget {
  final List<Destination> newDestinations;

  const NewDestinationsScreen({super.key, required this.newDestinations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Destinations',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: newDestinations.length,
        itemBuilder: (context, index) {
          return NewDestinationCard(destination: newDestinations[index]);
        },
      ),
    );
  }
}
