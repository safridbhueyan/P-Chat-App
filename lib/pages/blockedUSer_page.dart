import 'package:chatapp/components/userTile.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat._service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  //show confirm unblock box
  void _showUnblockbox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Unblock this niggah!"),
              content:
                  Text("Are you sure ? on God you wanna unblock this asshole?"),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                //unblock button
                TextButton(
                  onPressed: () {
                    chatService.unblockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("this niggah will break your heart again!")));
                  },
                  child: Text("Unblock"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //get current user
    String userId = authService.getCurrentUser()!.uid;

//UI
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blocked mfks ",
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getblockedUsersStream(userId),
        builder: (context, snapshot) {
          //error....
          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading...."),
            );
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final blockedUsers = snapshot.data ?? [];
          //no users
          if (blockedUsers.isEmpty) {
            return Center(
              child: Text("no blocked users!"),
            );
          }
          //load complete
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user["email"],
                onTap: () => _showUnblockbox(context, user['uid']),
              );
            },
          );
        },
      ),
    );
  }
}
