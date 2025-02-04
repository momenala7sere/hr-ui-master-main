import 'package:flutter/material.dart';
import 'package:hr/state_management/localization_service.dart'; // Import localization service
import 'package:hr/screens/home/HomePage.dart';

Widget buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Color(0x00f7f2fa), // Background color
          ),
          child: Column(
            children: [
              ClipOval(
                child: const Image(
                  image: AssetImage("assets/images/karlogo.png"),
                  fit: BoxFit.cover,
                  width: 80, // Adjust size if needed
                  height: 80,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                LocalizationService.translate("admin_user"),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                LocalizationService.translate("human_resources"),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                ),
              ),
            ],
          ),
        ),
        buildDrawerItem(
          Icons.account_circle_rounded,
          LocalizationService.translate("employee_code"),
        ),
        buildDivider(),
        buildDrawerItem(
          Icons.apartment,
          LocalizationService.translate("company"),
        ),
        buildDivider(),
        buildDrawerItem(
          Icons.calendar_month,
          LocalizationService.translate("hiring_date"),
        ),
        buildDivider(),
      ],
    ),
  );
}

Widget buildEndDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 90,
          child: DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        currentLocale:
                            Localizations.localeOf(context), token: '', // Pass locale
                      ),
                    );
                  },
                ),
                const SizedBox(width: 13.0),
                const Icon(Icons.mail),
                const SizedBox(width: 13.0),
                const Icon(Icons.notifications),
                const SizedBox(width: 13.0),
                Text(
                  LocalizationService.translate("employee_name"),
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildStatusContainer(
              Icons.person,
              LocalizationService.translate("annual_leave"),
              LocalizationService.translate("annual_leave_days"),
            ),
            buildStatusContainer(
              Icons.hotel,
              LocalizationService.translate("sick_leave"),
              LocalizationService.translate("sick_leave_days"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildDivider(),
        buildStatusRow(
          LocalizationService.translate("requested_vacations"),
          LocalizationService.translate("requested_vacation_days"),
        ),
        buildDivider(),
        buildStatusRow(
          LocalizationService.translate("remaining_sick_leave"),
          LocalizationService.translate("remaining_sick_leave_days"),
        ),
      ],
    ),
  );
}

Widget buildProfileButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(
            Icons.account_circle,
            size: 30,
          ),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        );
      },
    ),
  );
}

Widget buildDrawerItem(IconData icon, String text) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
  );
}

Widget buildDivider() {
  return const Divider(
    color: Colors.grey,
    thickness: 0.5,
    height: 20,
  );
}

Widget buildStatusContainer(IconData icon, String title, String value) {
  return Container(
    height: 140,
    width: 140,
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color(0xffCE5E52),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
          blurRadius: 5.0,
          spreadRadius: 1.0,
          offset: const Offset(2.0, 2.0),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, size: 40, color: Colors.white),
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ],
    ),
  );
}

Widget buildStatusRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 104, 104, 104),
          ),
        ),
      ],
    ),
  );
}