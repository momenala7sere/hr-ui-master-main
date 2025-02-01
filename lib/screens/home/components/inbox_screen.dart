import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/api/api_service.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late String token;

  @override
  void initState() {
    super.initState();
    // Retrieve token and dispatch fetch event
    _fetchUnreadMessages();
  }

  Future<void> _fetchUnreadMessages() async {
    // Retrieve token from secure storage
    final retrievedToken = await ApiService().getSavedToken();
    if (retrievedToken == null || retrievedToken.isEmpty) {
      print('Error: Token is null or empty.');
      return;
    }
    token = retrievedToken;
    print('Token retrieved in InboxScreen: $token');
    
    // Dispatch fetch event with the valid token
    context.read<GenericBloc>().add(FetchUnreadMessages(token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: const Text('Inbox'),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            currentLocale: Localizations.localeOf(context),
            token: token, // Pass the token to HomePage
          ),
        ),
      );
    },
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () {
        context.read<GenericBloc>().add(FetchUnreadMessages(token: token));
      },
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
                    const Text(
                      'No unread messages.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      // Dispatch event to mark as read
                      context
                          .read<GenericBloc>()
                          .add(MarkMessageAsRead(messageId: message['id']));
                    },
                  ),
                  onTap: () {
                    // Navigate to a message detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MessageDetailScreen(message: message),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is GenericError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message.contains('Invalid token')
                        ? 'Session expired. Please log in again.'
                        : state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (state.message.contains('Invalid token')) {
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        _fetchUnreadMessages();
                      }
                    },
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

class MessageDetailScreen extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageDetailScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['subject'] ?? 'No Subject',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              message['content'] ?? 'No Content',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
