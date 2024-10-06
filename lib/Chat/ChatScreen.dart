import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  final String profileUserId;

  ChatScreen({required this.currentUserId, required this.profileUserId});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              _showUsersWhoMessaged(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isMe = message['senderId'] == currentUserId;
                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('Chats')
                          .doc(getChatId())
                          .collection('messages')
                          .add({
                        'text': _messageController.text,
                        'senderId': currentUserId,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getChatId() {
    return currentUserId.compareTo(profileUserId) > 0
        ? '$currentUserId-$profileUserId'
        : '$profileUserId-$currentUserId';
  }

  void _showUsersWhoMessaged(BuildContext context) async {
    var chatDoc = await FirebaseFirestore.instance
        .collection('Chats')
        .doc(getChatId())
        .collection('messages')
        .get();

    var users = <String>{};
    for (var message in chatDoc.docs) {
      users.add(message['senderId']);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Users Who Messaged'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                String userId = users.elementAt(index);
                return ListTile(
                  title: Text(userId), // Display user name or ID
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          currentUserId: currentUserId,
                          profileUserId: userId,
                        ),
                      ),
                    );
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
