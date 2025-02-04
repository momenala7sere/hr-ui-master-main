import 'package:flutter/material.dart';
import 'package:hr/screens/home/components/inbox_screen.dart';
import 'package:hr/screens/home/components/notification_screen.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/screens/home/dto/CardItems.dart';
import 'components/DashboardCard.dart';
import 'components/Drawer.dart';
import 'package:hr/screens/EmployeeDashboard.dart';

class HomePage extends StatefulWidget {
  final Locale currentLocale;
  final String token;

  const HomePage({
    super.key,
    required this.currentLocale,
    required this.token,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          );
        } else {
          final data = snapshot.data ?? {};
          return Scaffold(
            appBar: _selectedIndex == 0
                ? AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          'assets/images/icon.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ],
                  )
                : null,
            drawer: buildDrawer(),
            body: _getBody(data),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,  // Ensures equal spacing
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inbox),
                  label: 'Inbox',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: const Color(0xFFCE5E52),
              unselectedItemColor: Colors.grey,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: RawMaterialButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('Add Item'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Settings'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              fillColor: const Color(0xFFCE5E52),
              shape: const CircleBorder(),
              constraints: const BoxConstraints.tightFor(
                width: 50,
                height: 50,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _getBody(Map<String, dynamic> data) {
    const double fontSize = 14.0;  // Adjust this value as needed

    switch (_selectedIndex) {
      case 0:
        return _buildHomePage(data, fontSize);
      case 1:
        return const InboxScreen();
      case 2:
        return const NotificationsScreen();
      case 3:
        return const Center(child: Text('Profile Page'));
      default:
        return _buildHomePage(data, fontSize);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final apiService = ApiService();
    try {
      final leaveBalance = await apiService.getLeaveBalance(
          widget.token, 1); // Replace with actual UserID
      final notificationCount = await apiService.getUnreadNotifications(widget.token);
      final messageCount = await apiService.getUnreadMessages(widget.token);

      return {
        'leaveBalance': leaveBalance['balance'],
        'notificationCount': notificationCount['count'],
        'messageCount': messageCount['count'],
        'cards': cardItems.map((card) => card).toList(),
      };
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  Widget _buildHomePage(Map<String, dynamic> data, double fontSize) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmployeeDashboard(),
          const SizedBox(height: 16),
          Section(
            title: 'Requests',
            itemCount: 8,  // 8 cards for requests
            items: data['cards'].sublist(0, 8),
            fontSize: fontSize,
          ),
          Section(
            title: 'History',
            itemCount: 8,  // 8 cards for history
            items: data['cards'].sublist(8, 16),
            fontSize: fontSize,
          ),
          Section(
            title: 'Other',
            itemCount: 6,  // 6 cards for other
            items: data['cards'].sublist(16, 22),
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final int itemCount;
  final List<dynamic> items;
  final double fontSize;

  const Section({
    super.key,
    required this.title,
    required this.itemCount,
    required this.items,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen height dynamically
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamically calculate vertical spacing based on screen height
    double spacing = screenHeight * 0.05; // Increase spacing multiplier for better layout

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,  // Display 4 cards per row
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 3,  // Increased vertical spacing dynamically
                childAspectRatio: 0.660, // Aspect ratio remains the same (square cards)
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) =>
                  DashboardCard(cardData: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}
