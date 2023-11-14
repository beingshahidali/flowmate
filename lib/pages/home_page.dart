
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowwmate/pages/chat_page.dart';
import 'package:flowwmate/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/chat_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void signOut() {
    //getAuthService
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Message'),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList( ) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          return ListView(

            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        } // ListView },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    int randomImageNumber = Random().nextInt(5) + 1;
// display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40,10,40,5),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 5,color: Colors.cyan.shade200),
              top: BorderSide(width: 1.5, color: Colors.cyan.shade200),
              right: BorderSide(width: 1.5, color: Colors.cyan.shade200),
              left: BorderSide(width: 1.5, color: Colors.cyan.shade200),
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            leading:  CircleAvatar(
              radius: 50, // Set the desired radius for your circle
              backgroundImage: AssetImage('images/$randomImageNumber.jpeg'),
            ),



            tileColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Text(
                    data['name'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['email'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              // pass the clicked user's UID to the chat page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverName: data["name"],
                    receiverUserEmail: data['email'],
                    receiverUserID: data['uid'],
                  ),
                ),
              );
            },
          ),
        ),
      )
      ;
    }
    else
      return Container();
  }

}
//build a list of users for the current logged in users
