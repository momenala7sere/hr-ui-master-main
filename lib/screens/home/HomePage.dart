import 'package:flutter/material.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/screens/Profile_Page.dart';
import 'package:hr/screens/EmployeeDashboard.dart';
import 'package:hr/screens/home/components/Drawer.dart';
import 'package:hr/screens/home/components/DashboardCard.dart';
import 'package:hr/screens/home/components/inbox_screen.dart';
import 'package:hr/screens/home/components/notification_screen.dart';
import 'package:hr/screens/home/components/CardData.dart';
import 'package:hr/screens/home/dto/CardItems.dart';
import 'package:hr/screens/home/components/ShimmerLoadingScreen.dart';

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
      drawer: buildDrawer(userMenu: []),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _futureDashboardData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerLoadingScreen();
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
          const InboxScreen(),
          const NotificationsScreen(),
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

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final apiService = ApiService();
    try {
      final leaveBalance = await apiService.getLeaveBalance(widget.token, 1);
      final messageCount = await apiService.getUnreadMessages(widget.token);
      final userMenu = await apiService.getUserMenu(widget.token, 1);

      List<CardData> dynamicCards = [];
      if (userMenu['response'] != null && userMenu['response'] is List) {
        dynamicCards = (userMenu['response'] as List)
            .map((cardMap) => CardData.fromMap(cardMap))
            .toList();
      }

      final List<CardData> finalCards = [];

      final Map<String, CardData> dynamicMap = {
        for (var card in dynamicCards) card.title: card
      };

      // Merge static and dynamic cards.
      for (var staticCard in cardItems) {
        if (dynamicMap.containsKey(staticCard.title)) {
          final dynCard = dynamicMap[staticCard.title]!;
          finalCards.add(CardData(
            title: dynCard.title,
            icon: dynCard.icon,
            color: dynCard.color,
            routeName: staticCard.routeName,
            category: dynCard.category,
          ));
          dynamicMap.remove(staticCard.title);
        } else {
          finalCards.add(staticCard);
        }
      }
      finalCards.addAll(dynamicMap.values);

      return {
        'leaveBalance': leaveBalance['balance'],
        'messageCount': messageCount['count'],
        'cards': finalCards,
        'userMenu': userMenu,
      };
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

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

  // Updated grouping to include only Request, History, and Other.
  Map<String, List<CardData>> _groupCards(List<CardData> cards) {
    final Map<String, List<CardData>> groups = {
      'Request': [],
      'History': [],
      'Other': [],
    };

    for (var card in cards) {
      final titleLower = card.title.toLowerCase();
      if (titleLower.contains('history')) {
        groups['History']!.add(card);
      } else if (titleLower.contains('request')) {
        groups['Request']!.add(card);
      } else {
        groups['Other']!.add(card);
      }
    }
    return groups;
  }
}

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                const int crossAxisCount = 4;
                final double totalSpacing = (crossAxisCount - 1) * 12.0;
                final double itemWidth =
                    (constraints.maxWidth - totalSpacing) / crossAxisCount;
                final double itemHeight = itemWidth * 1.5;
                final double aspectRatio = itemWidth / itemHeight;

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) =>
                      DashboardCard(cardData: items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
