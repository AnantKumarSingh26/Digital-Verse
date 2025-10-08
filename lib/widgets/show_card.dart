// lib/widgets/show_card.dart

import 'package:flutter/material.dart';

class ShowCard extends StatelessWidget {
  final String heroTag; // Unique ID for the Hero animation
  final String title;
  final String? imageUrl; // Made nullable to handle missing images
  final double? rating;
  final VoidCallback onTap;

  const ShowCard({
    super.key,
    required this.heroTag,
    required this.title,
    this.imageUrl,
    this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the rating is available and valid
    final bool hasRating = rating != null && rating! > 0;
    
    return InkWell(
      onTap: onTap,
      child: Card(
        // Use an elevation and rounded corners for a nice UI
        elevation: 4.0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias, // Ensures content respects the border radius
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hero Animation Image (The core of the card) ---
            Expanded(
              child: Hero(
                // The tag MUST be unique and MUST match the tag on the Details Page
                tag: heroTag, 
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // Add a simple fade-in effect (part of the Animations requirement)
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image, size: 40),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
              ),
            ),
            
            // --- Show Title and Rating ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (hasRating)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating!.toStringAsFixed(1), // Format rating to one decimal place
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
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