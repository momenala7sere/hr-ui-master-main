import 'package:flutter/material.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/screens/Profile_Page.dart';
import 'package:hr/screens/EmployeeDashboard.dart';
import 'package:hr/screens/home/components/Drawer.dart';
import 'package:hr/screens/home/components/DashboardCard.dart';
import 'package:hr/screens/home/components/inbox_screen.dart';
import 'package:hr/screens/home/components/notification_screen.dart';
import 'package:hr/screens/home/components/CardData.dart'; // Contains CardData model and fromMap() method
import 'package:hr/screens/home/dto/CardItems.dart'; // Contains the static card list (cardItems)

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
    // Cache the future so that the data is fetched only once.
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
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: _futureDashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Drawer(child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Drawer(child: Center(child: Text('Error fetching user menu')));
          } else {
            final userMenu = snapshot.data?['userMenu'] ?? [];
            return buildDrawer(userMenu: userMenu);
          }
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home tab
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
        type: BottomNavigationBarType.fixed,
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
        constraints: const BoxConstraints.tightFor(width: 50, height: 50),
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

  /// Fetches dashboard data including leave balance, notifications, messages, and cards.
  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final apiService = ApiService();
    try {
      final leaveBalance = await apiService.getLeaveBalance(widget.token, 1); // Replace 1 with actual userID as needed.
      final notificationCount = await apiService.getUnreadNotifications(widget.token);
      final messageCount = await apiService.getUnreadMessages(widget.token);
      final userMenu = await apiService.getUserMenu(widget.token, 1);

      // Parse dynamic card data from the API response, if available.
      List<CardData> dynamicCards = [];
      if (userMenu['response'] != null && userMenu['response'] is List) {
        dynamicCards = (userMenu['response'] as List)
            .map((cardMap) => CardData.fromMap(cardMap))
            .toList();
      }

      // Merge static cards (from carditem.dart) with dynamic cards.
      // For duplicates (by title), remove the static card and use the dynamic card,
      // but update the dynamic card's routeName with the static card's routeName.
      final List<CardData> finalCards = [];

      // Build a map for quick lookup of dynamic cards by title.
      final Map<String, CardData> dynamicMap = {
        for (var card in dynamicCards) card.title: card
      };

      // Iterate through the static cards.
      for (var staticCard in cardItems) {
        if (dynamicMap.containsKey(staticCard.title)) {
          // Duplicate found: Use the dynamic card data but preserve the static card's route.
          final dynCard = dynamicMap[staticCard.title]!;
          finalCards.add(CardData(
            title: dynCard.title,
            icon: dynCard.icon,
            color: dynCard.color,
            routeName: staticCard.routeName, // Preserve the static navigator route.
            category: dynCard.category,
          ));
          // Remove it from the map so it's not added twice.
          dynamicMap.remove(staticCard.title);
        } else {
          // No duplicate; add the static card.
          finalCards.add(staticCard);
        }
      }
      // Append any remaining dynamic cards (which did not match a static card).
      finalCards.addAll(dynamicMap.values);

      return {
        'leaveBalance': leaveBalance['balance'],
        'notificationCount': notificationCount['count'],
        'messageCount': messageCount['count'],
        'cards': finalCards,
        'userMenu': userMenu,
      };
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  /// Groups cards into sections: Request, History, Report, Other.
  Map<String, List<CardData>> _groupCards(List<CardData> cards) {
    final Map<String, List<CardData>> groups = {
      'Request': [],
      'History': [],
      'Report': [],
      'Other': [],
    };

    for (var card in cards) {
      final titleLower = card.title.toLowerCase();
      if (titleLower.contains('history')) {
        groups['History']!.add(card);
      } else if (titleLower.contains('request')) {
        groups['Request']!.add(card);
      } else if (titleLower.contains('report')) {
        groups['Report']!.add(card);
      } else {
        groups['Other']!.add(card);
      }
    }
    return groups;
  }

  /// Builds the home page layout and displays the merged cards grouped into sections.
  Widget _buildHomePage(Map<String, dynamic> data) {
    List<CardData> cards = data['cards'] as List<CardData>;
    final groupedCards = _groupCards(cards);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmployeeDashboard(),
          const SizedBox(height: 16),
          if (groupedCards['Request']!.isNotEmpty)
            Section(
              title: 'Request',
              itemCount: groupedCards['Request']!.length,
              items: groupedCards['Request']!,
            ),
          if (groupedCards['History']!.isNotEmpty)
            Section(
              title: 'History',
              itemCount: groupedCards['History']!.length,
              items: groupedCards['History']!,
            ),
          if (groupedCards['Report']!.isNotEmpty)
            Section(
              title: 'Report',
              itemCount: groupedCards['Report']!.length,
              items: groupedCards['Report']!,
            ),
          if (groupedCards['Other']!.isNotEmpty)
            Section(
              title: 'Other',
              itemCount: groupedCards['Other']!.length,
              items: groupedCards['Other']!,
            ),
        ],
      ),
    );
  }
}

/// A reusable widget that displays a grid of dashboard cards.
class Section extends StatelessWidget {
  final String title;
  final int itemCount;
  final List<CardData> items;

  const Section({
    Key? key,
    required this.title,
    required this.itemCount,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double spacing = screenHeight * 0.05; // Optional spacing adjustment

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
                crossAxisCount: 4, // 4 cards per row
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 3,
                childAspectRatio: 0.660,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) => DashboardCard(cardData: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}
