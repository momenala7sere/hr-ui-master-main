import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({Key? key}) : super(key: key);

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  final ApiService _apiService = ApiService();
  late GenericBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GenericBloc();
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    final token = await _apiService.getSavedToken();
    if (token != null) {
      _bloc.add(FetchLeaveBalances(token: token, userId: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    double boxHeight = 150.0; // Fixed height for the boxes

    return BlocProvider(
      create: (context) => _bloc,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFFFEF7FF),
          child: Column(
            children: [
              // Row for the 3 equally spaced boxes (Annual Leave, Sick Leave, Employee Info)
              Row(
                children: [
                  Expanded(
                    child: _LeaveBox(
                      balance: '31.0',
                      title: 'Annual Leave',
                      description: '30 days per year ',
                      height: boxHeight,
                    ),
                  ),
                  const SizedBox(width: 8), // Equal spacing between boxes
                  Expanded(
                    child: _LeaveBox(
                      balance: '30.0',
                      title: 'Sick Leave',
                      description: '30 days per year',
                      height: boxHeight,
                    ),
                  ),
                  const SizedBox(width: 8), // Equal spacing between boxes
                  Expanded(
                    child: _EmployeeBox(
                        height:
                            boxHeight), // Employee Box width adjusted to match others
                  ),
                ],
              ),
              const SizedBox(
                  height: 8), // Equal spacing between boxes and recent requests

              // Recent Requests box
              const _RecentRequestsBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmployeeBox extends StatelessWidget {
  final double height;

  const _EmployeeBox({
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
          ),
          SizedBox(height: 20),
          Text(
            "Employee Test Name",
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3),
          Text(
            "Employee No. 18093484914",
            style: TextStyle(fontSize: 6, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LeaveBox extends StatelessWidget {
  final String balance;
  final String title;
  final String description;
  final double height;

  const _LeaveBox({
    required this.balance,
    required this.title,
    required this.description,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            balance,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RecentRequestsBox extends StatelessWidget {
  const _RecentRequestsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Requests",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const _RequestRow(
            id: "#9154",
            type: "Vacation",
            dateTime: "30/12/2024 00:00:06",
            status: "Approved",
            statusColor: Colors.green,
          ),
          const SizedBox(height: 15),
          const _RequestRow(
            id: "#8144",
            type: "Vacation",
            dateTime: "30/12/2024 00:00:06",
            status: "Pending",
            statusColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  final String id;
  final String type;
  final String dateTime;
  final String status;
  final Color statusColor;

  const _RequestRow({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.status,
    required this.statusColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                id,
                style:
                    const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              Text(
                type,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            dateTime,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
