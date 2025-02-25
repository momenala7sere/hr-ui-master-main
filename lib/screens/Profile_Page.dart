import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    // Responsive sizes based on MD3 guidelines
    final double avatarRadius = screenWidth * 0.12; // Slightly larger for prominence
    final double padding = screenWidth * 0.05; // Consistent spacing
    final double iconSize = screenWidth * 0.07;

    return Scaffold(
      // AppBar with MD3 styling
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0, // Flat AppBar per MD3
        scrolledUnderElevation: 1, // Subtle elevation on scroll
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: ListView(
          children: [
            // Profile Header Section (MD3 Card)
            Card(
              elevation: 0, // Tonal elevation via surfaceTint
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // MD3 larger radius
              ),
              child: Padding(
                padding: EdgeInsets.all(padding * 1.5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                      backgroundImage: const NetworkImage(
                        "https://randomuser.me/api/portraits/men/1.jpg",
                      ),
                    ),
                    SizedBox(width: padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasan Ahmad',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                              Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'Hasanahmad@example.com',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Settings Section (MD3 Card with ListTiles)
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      size: iconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: iconSize * 0.6,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      // Navigate to edit profile screen
                    },
                  ),
                  Divider(
                    indent: padding * 2,
                    endIndent: padding * 2,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      size: iconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: iconSize * 0.6,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      // Navigate to change password screen
                    },
                  ),
                  Divider(
                    indent: padding * 2,
                    endIndent: padding * 2,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications_outlined,
                      size: iconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: iconSize * 0.6,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      // Navigate to notifications settings
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Logout Button (MD3 Filled Tonal Button)
            FilledButton.tonal(
              onPressed: () {
                // Handle logout action
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50), // MD3 minimum height
              ),
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example main.dart to apply MD3 Theme
void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    ),
  );
}