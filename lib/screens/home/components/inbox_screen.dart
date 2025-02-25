import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/screens/home/HomePage.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with AutomaticKeepAliveClientMixin<InboxScreen> {
  late String token;

  @override
  void initState() {
    super.initState();
    _fetchUnreadMessages();
  }

  @override
  bool get wantKeepAlive => true; // Ensures the screen state is kept alive when switching tabs

  Future<void> _fetchUnreadMessages() async {
    try {
      final retrievedToken = await ApiService().getSavedToken();
      if (retrievedToken == null || retrievedToken.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Unable to fetch token.')),
        );
        return;
      }
      token = retrievedToken;
      print('Token retrieved in InboxScreen: $token');
      context.read<GenericBloc>().add(FetchUnreadMessages(token: token));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching messages: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin to function correctly
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        centerTitle: true, // Center the title
        leading: null, // Remove the back icon
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchUnreadMessages, // Trigger message refresh on tap
          ),
        ],
      ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context, state) {
          if (state is GenericLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GenericLoaded) {
            final messages = state.data as List<dynamic>;
            if (messages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No unread messages.', style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['subject'] ?? 'No Subject'),
                  subtitle: Text(message['content'] ?? 'No Content'),
                );
              },
            );
          } else if (state is GenericError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchUnreadMessages, // Retry fetching messages on button press
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unexpected state.'));
          }
        },
      ),
    );
  }
}
