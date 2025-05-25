import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreScreen extends StatelessWidget {
  final VoidCallback? onBackToHome;

  const ExploreScreen({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'title': 'Cendrawasih Dance',
        'image': 'assets/images/CendrawasihDance.jpg',
      },
      {'title': 'Sunrise in Batur', 'image': 'assets/images/SunriseBatur.jpg'},
      {'title': 'Ubud Monkey', 'image': 'assets/images/UbudMonkey.jpg'},
      {
        'title': 'Sunday Market Canggu',
        'image': 'assets/images/SundayMarketCanggu.jpg',
      },
      {'title': 'Dolphins Lovina', 'image': 'assets/images/DolphinsLovina.jpg'},
      {'title': 'Ogoh-ogoh', 'image': 'assets/images/OgohOgoh.jpg'},
    ];

    // Ukuran tiap card (crossAxisCellCount, mainAxisCellCount)
    final List<List<double>> cardSizes = [
      [1, 1], // Cendrawasih Dance
      [1, 2], // Sunrise in Batur
      [1, 2], // Ubud Monkey
      [1, 1.3], // Sunday Market Canggu
      [1, 2], // Dolphins Lovina
      [1, 1.57], // Ogoh-ogoh
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A72B0)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else if (onBackToHome != null) {
              onBackToHome!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Explore',
          style: GoogleFonts.poppins(
            color: const Color(0xFF4A72B0),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          //     child: MasonryGridView.count(
          //       crossAxisCount: 2,
          //       mainAxisSpacing: 16,
          //       crossAxisSpacing: 16,
          //       itemCount: items.length,
          //       itemBuilder: (context, index) {
          //         final item = items[index];
          //         final size = cardSizes[index];
          //         return SizedBox(
          //           height: 120 * size[1],
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(16),
          //             child: Stack(
          //               fit: StackFit.expand,
          //               children: [
          //                 Image.asset(item['image']!, fit: BoxFit.cover),
          //                 // Blur effect
          //                 BackdropFilter(
          //                   filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          //                   child: Container(
          //                     color: Colors.black.withOpacity(0.10),
          //                   ),
          //                 ),
          //                 Center(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text(
          //                       item['title']!,
          //                       textAlign: TextAlign.center,
          //                       style: GoogleFonts.poppins(
          //                         color: Colors.white,
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 16,
          //                         letterSpacing: 1,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(overscroll: false),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16, // Tambahkan jarak antar baris
                  crossAxisSpacing: 16, // Tambahkan jarak antar kolom
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final size = cardSizes[index];
                    return SizedBox(
                      height: 120 * size[1],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(item['image']!, fit: BoxFit.cover),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.black.withOpacity(0.10),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item['title']!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
