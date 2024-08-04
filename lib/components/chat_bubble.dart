import 'package:chatapp/services/chat/chat._service.dart';
import 'package:chatapp/theme/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });
//show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            //report message button
            ListTile(
              leading: Icon(Icons.flag_circle),
              title: Text("Report his ass! "),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(context, messageId, userId);
              },
            ),
            //block user button
            ListTile(
              leading: Icon(Icons.block_rounded),
              title: Text("Block this asshole!"),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),
            //cancel button
            ListTile(
              leading: Icon(Icons.cancel_rounded),
              title: Text("cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
      },
    );
  }

//report messages
  void _reportMessage(BuildContext context, String meesageId, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Report Message"),
              content: Text("Are you sure u wanna report his ass?"),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),

                //report button
                TextButton(
                    onPressed: () => {
                          ChatService().reportUser(messageId, userId),
                          Navigator.pop(context),
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "yessirski report is done yo dig!"))),
                        },
                    child: Text("Report"))
              ],
            ));
  }

//block user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Block User!"),
              content: Text("Are you sure u wanna Block this asshole?"),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),

                //block button
                TextButton(
                  onPressed: () {
                    ChatService().blockUser(userId);
                    //double pop to dissmiss dialog box and another one is for dismiss page
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("fuck this niggah his ass is done fr!")));
                  },
                  child: Text("Block"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode
                    ? const Color.fromARGB(255, 63, 139, 177)
                    : Color.fromARGB(255, 111, 154, 175))
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
