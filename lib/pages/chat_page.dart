import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/myTextfild.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat._service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

//chat and auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  //for textfield focus

  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //add listener to focus mode
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause delay to keyboard to show up
        //then remaining space be calculated
        //scroll down
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    //wait a bit to list view build then scroll to botoom
    Future.delayed(
      Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();

    super.dispose();
  }

// scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

//send messages
  void sendMessages() async {
    //if there anything in the text field then send mssg otherwise not
    if (_messageController.text.isNotEmpty) {
      //send messages
      await _chatService.sendMessage(
          widget.recieverID, _messageController.text);

      //clear text conroller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: Text(widget.recieverEmail),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //display all the messages
          Expanded(
            child: _buildMessageLIst(),
          ),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

//build message list
  Widget _buildMessageLIst() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverID, senderID),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return Text("Error");
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading....");
          }
          //return list view

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessagesItem(doc))
                .toList(),
          );
        });
  }

  //build message item
  Widget _buildMessagesItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data["message"],
              isCurrentUser: isCurrentUser,
              messageId: doc.id,
              userId: data['senderID'],
            )
          ],
        ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take most of the space
          Expanded(
            child: Mytextfild(
              hintext: "type the shit that you wanna say",
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          //send button
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 63, 139, 177),
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessages,
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
