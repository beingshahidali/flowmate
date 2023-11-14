import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowwmate/components/my_text_field.dart';
import 'package:flowwmate/components/chat_bubble.dart';
import 'package:flowwmate/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    Key? key,
    required this.receiverName,
    required this.receiverUserEmail,
    required this.receiverUserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.receiverName),
            CircleAvatar(
              radius: 20, // Set the desired radius to make it smaller
              backgroundImage: AssetImage('images/1.jpeg'),
            ),
          ],
        ),
      )
,
        body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildMessageInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isSender = (data['senderId'] == _firebaseAuth.currentUser!.uid);
    var alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    Color bubbleColor = isSender ? Colors.cyan : Colors.blueGrey;



    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5,1,5,0),
        child: Column(
          crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              bubbleColor: bubbleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: 'Enter message',
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward, size: 40),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
