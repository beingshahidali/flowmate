import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  final Color bubbleColor;

  const ChatBubble({super.key,required this.message, required this.bubbleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        color: bubbleColor,
      )
      ,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1,1,8,0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
