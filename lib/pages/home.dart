import 'package:chatapp/components/userTile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/services/chat/chat._service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

//chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

//   void logout() {
// // get auth service

//     final _auth = AuthService();
//     _auth.signOut();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        centerTitle: true,
        title: Text(
          'home',
        ),
        // actions: [
        //   IconButton(onPressed: logout, icon: Icon(Icons.logout_rounded))
        // ],
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }
//build a list of users except the current logged in user

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStreamExcludingBlocked(),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text("Error");
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading......");
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("No users found");
            return const Text("No users found");
          }

          print("User data: ${snapshot.data}");

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users except current user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
//tap on a user to go on a chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recieverEmail: userData['email'],
                  recieverID: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
