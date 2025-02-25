import 'package:flutter/material.dart';
import 'package:hr/screens/home/components/CardData.dart';

class DashboardCard extends StatelessWidget {
  final CardData cardData;

  const DashboardCard({required this.cardData, super.key});

  @override
  Widget build(BuildContext context) {
    double cardSize = 65.0;

    return GestureDetector(
      onTap: () {
        if (cardData.routeName.isNotEmpty) {
          Navigator.pushNamed(context, cardData.routeName);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: cardSize,
              width: cardSize,
              decoration: BoxDecoration(
                color: cardData.color,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Icon(
                  cardData.icon,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6.0), // Slightly increased spacing for better separation
          
          // --- Improved Text Layout ---
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: cardSize + 35, // Slightly increased width for better alignment
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                cardData.title.replaceAll("_", " "), // Replace underscores with spaces
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.0, // Slightly larger for readability
                  fontWeight: FontWeight.w500, // Better font weight for clarity
                  color: Colors.black,
                  height: 1.3, // More comfortable line spacing
                ),
                maxLines: 3,
                softWrap: true, // Ensure text wraps properly
                overflow: TextOverflow.visible, // Prevent ellipsis cutting important words
              ),
            ),
          ),
        ],
      ),
    );
  }
}
