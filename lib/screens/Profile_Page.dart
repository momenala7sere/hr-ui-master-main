import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    // Define responsive sizes based on screen dimensions.
    final double avatarRadius = screenWidth * 0.10; // 10% of screen width
    final double cardPadding = screenWidth * 0.04; // 4% of screen width
    final double nameFontSize = screenWidth * 0.06; // 6% of screen width
    final double emailFontSize = screenWidth * 0.036; // 4.5% of screen width
    final double listTileFontSize = screenWidth * 0.045;
    final double iconSize = screenWidth * 0.06;
    final double logoutButtonVerticalPadding = screenHeight * 0.02; // 2% of screen height
    final double appBarFontSize = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: appBarFontSize, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView(
          children: [
            // Profile Header Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: const NetworkImage(
                        "https://randomuser.me/api/portraits/men/1.jpg",
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasan Ahmad',
                            style: TextStyle(
                              fontSize: nameFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'Hasanahmad@example.com',
                            style: TextStyle(
                              fontSize: emailFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Settings Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person, size: iconSize),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: listTileFontSize),
                    ),
                    onTap: () {
                      // Navigate to edit profile screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.lock, size: iconSize),
                    title: Text(
                      'Change Password',
                      style: TextStyle(fontSize: listTileFontSize),
                    ),
                    onTap: () {
                      // Navigate to change password screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications, size: iconSize),
                    title: Text(
                      'Notifications',
                      style: TextStyle(fontSize: listTileFontSize),
                    ),
                    onTap: () {
                      // Navigate to notifications settings
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Logout Section
            ElevatedButton(
              onPressed: () {
                // Handle logout action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE5E52),
                padding: EdgeInsets.symmetric(vertical: logoutButtonVerticalPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: listTileFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
