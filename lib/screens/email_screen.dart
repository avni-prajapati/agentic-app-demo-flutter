import 'package:agentic_app_demo/data/emails.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  final Color themeColor;
  final List<String> messages;
  final bool isLoading;
  final Function(String) onSendMessage;

  const EmailScreen({
    super.key,
    required this.themeColor,
    required this.messages,
    required this.isLoading,
    required this.onSendMessage,
  });

  void _showMessageDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Compose Message or Color Request'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText:
                    'Type your message or color change here... eg. Make it blue',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    onSendMessage(textController.text.trim());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: const Text(
          'myMail',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Email list
          Expanded(
            child: ListView.separated(
              itemCount: emails.length,
              separatorBuilder:
                  (context, index) =>
                      const Divider(height: 1, indent: 72, endIndent: 16),
              itemBuilder: (context, index) {
                final email = emails[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: themeColor,
                    child: Text(
                      email['avatar'],
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    email['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email['subject'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (email['snippet'] != null &&
                          email['snippet'].toString().isNotEmpty)
                        Text(
                          email['snippet'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.star,
                    color:
                        email['starred'] ? Colors.amber : Colors.grey.shade400,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => _showMessageDialog(context),
        child: const Icon(Icons.edit, color: Colors.black87),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeColor,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
        elevation: 8,
      ),
    );
  }
}
