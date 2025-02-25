import 'package:flutter/material.dart';
import 'package:hr/state_management/localization_service.dart'; // Assuming this exists
import 'package:hr/screens/home/HomePage.dart';

Widget buildDrawer(BuildContext context, {required List<dynamic> userMenu}) {
  return Drawer(
    elevation: 8.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          accountName: Text(
            LocalizationService.translate("admin_user"),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          accountEmail: Text(
            LocalizationService.translate("human_resources"),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: const AssetImage("assets/images/karlogo.png"),
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        ...userMenu.map((item) {
          return buildDrawerItem(
            context: context, // Pass context to buildDrawerItem
            icon: Icons.menu,
            text: item['name'] ?? 'Unnamed',
          );
        }).toList(),
        buildDivider(),
        buildDrawerItem(
          context: context,
          icon: Icons.account_circle_rounded,
          text: LocalizationService.translate("employee_code"),
        ),
        buildDivider(),
        buildDrawerItem(
          context: context,
          icon: Icons.apartment,
          text: LocalizationService.translate("company"),
        ),
        buildDivider(),
        buildDrawerItem(
          context: context,
          icon: Icons.calendar_month,
          text: LocalizationService.translate("hiring_date"),
        ),
      ],
    ),
  );
}

Widget buildEndDrawer(BuildContext context) {
  return Drawer(
    elevation: 8.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
    ),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 100,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              currentLocale: Localizations.localeOf(context),
                              token: '',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.mail, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 16),
                    Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ],
                ),
                Flexible(
                  child: Text(
                    LocalizationService.translate("employee_name"),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildStatusContainer(
                    context: context, // Pass context
                    icon: Icons.person,
                    title: LocalizationService.translate("annual_leave"),
                    value: LocalizationService.translate("annual_leave_days"),
                  ),
                  buildStatusContainer(
                    context: context, // Pass context
                    icon: Icons.hotel,
                    title: LocalizationService.translate("sick_leave"),
                    value: LocalizationService.translate("sick_leave_days"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
        ),
      ],
    ),
  );
}

Widget buildProfileButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(
      icon: Icon(
        Icons.account_circle,
        size: 30,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    ),
  );
}

Widget buildDrawerItem({required BuildContext context, required IconData icon, required String text}) {
  return ListTile(
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(

      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
    dense: true,
    visualDensity: const VisualDensity(vertical: -1),
    onTap: () {},
  );
}

Widget buildDivider() {
  return Divider(
    color: Colors.grey.shade300, // Fallback if theme isn’t available
    thickness: 1,
    height: 8,
  );
}

Widget buildStatusContainer({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: SizedBox(
      height: 120,
      width: 140,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildStatusRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}