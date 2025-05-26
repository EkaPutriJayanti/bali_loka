import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../service/destination_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure cloud_firestore is imported for Timestamp
import 'package:intl/intl.dart'; // Ensure intl is imported for DateFormat

class DestinationDetailScreen extends StatefulWidget {
  final String destinationId;

  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  final DestinationService _destinationService = DestinationService();
  Destination? _destination;
  List<Map<String, dynamic>> _reviews = []; // List to store reviews
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _reviewController =
      TextEditingController(); // Controller for review input
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  bool _isReviewButtonEnabled = false; // State to control button enabled state

  @override
  void initState() {
    super.initState();
    _loadDestinationDetailAndReviews(); // Load both detail and reviews
    _reviewController
        .addListener(_updateReviewButtonState); // Listen to text changes
  }

  @override
  void dispose() {
    _reviewController
        .removeListener(_updateReviewButtonState); // Remove listener
    _reviewController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _updateReviewButtonState() {
    setState(() {
      _isReviewButtonEnabled = _reviewController.text.isNotEmpty;
    });
  }

  Future<void> _loadDestinationDetailAndReviews() async {
    try {
      final destination = await _destinationService.getDestinationById(
        widget.destinationId,
      );
      final reviews = await _destinationService
          .getReviews(widget.destinationId); // Fetch reviews
      setState(() {
        _destination = destination;
        // Sort reviews by date descending
        _reviews = reviews
          ..sort((a, b) =>
              (b['created_at'] is Timestamp && a['created_at'] is Timestamp)
                  ? (b['created_at'] as Timestamp)
                      .compareTo(a['created_at'] as Timestamp)
                  : 0); // Handle cases where created_at might not be Timestamp
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error loading destination detail or reviews: $e');
    }
  }

  Future<void> _submitReview() async {
    final user = _auth.currentUser; // Get current logged-in user
    if (user == null) {
      // Handle case where user is not logged in (e.g., show a login prompt)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit a review.')),
      );
      return;
    }

    if (!_isReviewButtonEnabled) {
      // Prevent submitting if button is not enabled
      return;
    }

    try {
      // Add the review to Firestore
      await _destinationService.addReview(
        destinationId: widget.destinationId,
        comment: _reviewController.text,
        email: user.email ?? 'Anonymous', // Use user email or 'Anonymous'
      );

      // Clear the input field
      _reviewController.clear();

      // Reload reviews to show the new one
      _loadDestinationDetailAndReviews();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
      );
      print('Error submitting review: $e');
    }
  }

  void _likeReview(String reviewId, int currentLikes) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to like a review.')),
      );
      return;
    }

    // TODO: Implement actual like logic in service (handle unique likes per user)
    // For now, just a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Liking review $reviewId...')),
    );
    // After successful like in service, reload reviews to update like count
    // _loadDestinationDetailAndReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _destination?.title ?? 'Loading...',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _destination == null
                  ? const Center(child: Text('Destination not found.'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display image
                          Image.asset(
                            _destination!.imageUrl,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and Rating
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _destination!.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.amber[700]),
                                        const SizedBox(width: 4),
                                        Text(
                                          _destination!.rating.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Location
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _destination!.location,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Description
                                Text(
                                  'Description',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _destination!.description,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                                const SizedBox(height: 16),

                                // Entrance Ticket
                                Text(
                                  'Entrance Ticket',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Assuming you want to display entrance fee and activity fee from entranceTicket map
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Entrance Fee: Rp ${_destination!.entranceFee.toStringAsFixed(0)}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car_outlined,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Activity Fee: Rp ${_destination!.activityFee.toStringAsFixed(0)}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Golden Time
                                Text(
                                  'Golden Time',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${_destination!.goldenTime['start']} - ${_destination!.goldenTime['finish']}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Ratings & Review Section
                                Text(
                                  'Ratings & Review',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Basic Rating Stars (Non-interactive for now)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      5,
                                      (index) => Icon(Icons.star_border,
                                          color: Colors.amber[
                                              700])), // Placeholder stars
                                ),
                                const SizedBox(height: 16),
                                // Review Input Field
                                TextField(
                                  controller: _reviewController,
                                  decoration: InputDecoration(
                                    hintText: 'Share your experience here',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 16),
                                // Share Button
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _isReviewButtonEnabled
                                        ? _submitReview
                                        : null, // Enable/disable based on state
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isReviewButtonEnabled
                                          ? const Color(0xFF3B82F6)
                                          : Colors
                                              .grey, // Use theme color or grey
                                      foregroundColor:
                                          Colors.white, // Text color
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical:
                                              12), // Adjust padding as needed
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('Share'),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Existing Reviews List
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _reviews
                                      .length, // Use fetched reviews count
                                  itemBuilder: (context, index) {
                                    final review = _reviews[index];
                                    // Build review item widget
                                    // Ensure created_at is a Timestamp before formatting
                                    final DateTime? reviewDate =
                                        (review['created_at'] is Timestamp)
                                            ? (review['created_at']
                                                    as Timestamp)
                                                .toDate()
                                            : null;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(), // Separator between reviews
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // User Avatar/Icon
                                              CircleAvatar(
                                                child: Icon(Icons
                                                    .person), // Placeholder icon
                                                radius: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // User Name/Email
                                                        Text(
                                                          review['email'] ??
                                                              'Anonymous',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14),
                                                        ),
                                                        // Date
                                                        Text(
                                                          reviewDate != null
                                                              ? DateFormat(
                                                                      'dd MMM yyyy')
                                                                  .format(
                                                                      reviewDate)
                                                              : '',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                        ),
                                                      ],
                                                    ),
                                                    // Rating Stars (Placeholder for each review)
                                                    Row(
                                                      children: List.generate(
                                                          5,
                                                          (index) => Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .amber[700],
                                                              size:
                                                                  16)), // Placeholder for review rating
                                                    ),
                                                    const SizedBox(height: 4),
                                                    // Review Text
                                                    Text(
                                                      review['comment'] ?? '',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    // Helpful Section
                                                    GestureDetector(
                                                      onTap: () => _likeReview(
                                                          review['review_id'] ??
                                                              '',
                                                          review['likes'] ??
                                                              0), // Call like method
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .thumb_up_alt_outlined,
                                                              size: 16,
                                                              color: Colors
                                                                      .grey[
                                                                  600]), // Like icon
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            'Helpful (${review['likes'] ?? 0})',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
