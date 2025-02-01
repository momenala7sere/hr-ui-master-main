import 'package:flutter/material.dart';
import 'package:hr/screens/home/components/CardData.dart';

class DashboardCard extends StatelessWidget {
  final CardData cardData;

  const DashboardCard({required this.cardData, super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed card size
    double cardSize = 55.0;

    return GestureDetector(
      onTap: () {
        if (cardData.routeName.isNotEmpty) {
          Navigator.pushNamed(
            context,
            cardData.routeName,
          );
        } else {
          print("DEBUG: No route defined for ${cardData.title}");
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
              height: cardSize, // Fixed height
              width: cardSize, // Fixed width
              decoration: BoxDecoration(
                color: cardData.color, // Dynamic background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Icon(
                  cardData.icon, // Icon remains the same size
                  size: 32.0,
                  color: Colors.white, // Icon color set to white
                ),
              ),
            ),
          ),
          const SizedBox(height: 4.0), // Increased spacing between card and text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding for text
            child: Text(
              cardData.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.0, // Fixed font size for better readability
                fontWeight: FontWeight.normal,
                color: Colors.black, // Text color
              ),
               // Prevent text overflow with ellipsis
              maxLines: 1, // Allow text to wrap into 2 lines if needed
            ),
          ),
        ],
      ),
    );
  }
}
