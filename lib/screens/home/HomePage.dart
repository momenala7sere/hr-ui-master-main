import 'package:flutter/material.dart';
import 'package:hr/screens/Profile_Page.dart';
import 'package:hr/screens/home/components/inbox_screen.dart';
import 'package:hr/screens/home/components/notification_screen.dart';
import 'package:hr/screens/home/dto/CardItems.dart';
import 'package:hr/screens/home/components/DashboardCard.dart';
import 'package:hr/screens/home/components/Drawer.dart';
import 'package:hr/screens/EmployeeDashboard.dart';
import 'package:hr/api/api_service.dart';

class HomePage extends StatefulWidget {
  final Locale currentLocale;
  final String token;

  const HomePage({
    Key? key,
    required this.currentLocale,
    required this.token,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<Map<String, dynamic>> _futureDashboardData;

  @override
  void initState() {
    super.initState();
    // Cache the future so that it’s only fetched once
    _futureDashboardData = _fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home tab with FutureBuilder
          FutureBuilder<Map<String, dynamic>>(
            future: _futureDashboardData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              } else {
                final data = snapshot.data ?? {};
                return _buildHomePage(data);
              }
            },
          ),
          // Inbox tab
          const InboxScreen(),
          // Notifications tab
          NotificationsScreen(),
          // Profile tab
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures equal spacing
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final apiService = ApiService();
    try {
      final leaveBalance = await apiService.getLeaveBalance(
          widget.token, 1); // Replace with actual UserID if needed
      final notificationCount =
          await apiService.getUnreadNotifications(widget.token);
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

  Widget _buildHomePage(Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmployeeDashboard(),
          const SizedBox(height: 16),
          Section(
            title: 'Requests',
            itemCount: 8,
            items: data['cards'].sublist(0, 8),
          ),
          Section(
            title: 'History',
            itemCount: 8,
            items: data['cards'].sublist(8, 16),
          ),
          Section(
            title: 'Other',
            itemCount: 6,
            items: data['cards'].sublist(16, 22),
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

  const Section({
    Key? key,
    required this.title,
    required this.itemCount,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can use the screen height or a fixed spacing value here
    double screenHeight = MediaQuery.of(context).size.height;
    double spacing = screenHeight * 0.05;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Display 4 cards per row
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 3,
                childAspectRatio: 0.660,
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
