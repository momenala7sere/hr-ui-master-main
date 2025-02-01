import 'package:flutter/material.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'package:hr/screens/home/components/inbox_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final String token; // Add token as a required parameter

  const BottomNavScreen({Key? key, required this.token, required int currentIndex, required Locale currentLocale, required Null Function(dynamic index) onTabSelected}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  // List of screens to display
  late List<Widget> _screens;

  @override
  Widget build(BuildContext context) {
    // Initialize _screens with the correct context and token
    _screens = [
      HomePage(currentLocale: Localizations.localeOf(context), token: widget.token),  // HomePage
      const InboxScreen(),  // InboxScreen
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Bottom Navigation'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Use currentIndex for automatic highlighting
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile', // Profile screen tab
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the floating button action here (customize as needed)
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
