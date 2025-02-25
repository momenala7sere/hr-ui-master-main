import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingScreen extends StatelessWidget {
  const ShimmerLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double boxHeight = 150.0; // Same height for Leave Boxes and Employee Box
    double cardSize = 55.0; // Same size for Dashboard Card icons

    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: <Widget>[
            // Shimmer for Employee Dashboard (Leave Boxes + Employee Box)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: _ShimmerLeaveBox(height: boxHeight),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ShimmerLeaveBox(height: boxHeight),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ShimmerEmployeeBox(height: boxHeight),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Shimmer for Recent Requests Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _ShimmerRecentRequestsBox(),
            ),
            const SizedBox(height: 20),
            // Shimmer for Dashboard Cards (The correct number of cards)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: _ShimmerDashboardCard(cardSize: cardSize),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // 3 rows of additional cards under each original card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: List.generate(3, (rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0), // Adjusted spacing between rows
                    child: Row(
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: _ShimmerDashboardCard(cardSize: cardSize),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer for Leave Boxes (Annual Leave and Sick Leave)
  Widget _ShimmerLeaveBox({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12), // Rounded corners for a smoother look
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  // Shimmer for Employee Box (Employee info section)
  Widget _ShimmerEmployeeBox({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12), // Rounded corners for smoother look
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  // Shimmer for Recent Requests Box
  Widget _ShimmerRecentRequestsBox() {
    return Container(
      height: 120, // Same height as recent requests box
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12), // Rounded corners for a professional look
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
    );
  }

  // Shimmer for Dashboard Cards (The correct number of cards)
  Widget _ShimmerDashboardCard({required double cardSize}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: cardSize,
          width: cardSize,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12), // Rounded corners for better appearance
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        // Shimmer for Card Title
        Container(
          height: 12.0,
          width: cardSize + 40,
          color: Colors.grey[200],
        ),
      ],
    );
  }
}
