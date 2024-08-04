import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatService extends ChangeNotifier {
//get instence of firestore

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

/*
List <map<String, dynamics>=
[
{
'email': test@gmail.com
'id':.....
}
{
'email': test@gmail.com
'id':.....
}
]


*/
//get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          //go through each individual user
          final user = doc.data() as Map<String, dynamic>;
          //return user
          return user;
        }).toList();
      },
    );
  }

//get all the users except the blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get blocked usr ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //get all users
      final userSnapshot = await _firestore.collection('Users').get();

      //return as a stream list,exluding current user and blocked user
      return userSnapshot.docs
          .where((docs) =>
              docs.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(docs.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

//send massages
  Future<void> sendMessage(String receiverID, message) async {
    //get current user
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    final Timestamp timestamp = Timestamp.now();
    //create new messages
    Message newMessage = Message(
        message: message,
        receiverID: receiverID,
        senderEmail: currentUserEmail,
        senderID: currentUserID,
        timestamp: timestamp);
    //construct chat room for two users(sorted to ensure uniqness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort id ensure the authenticity of the chat room
    String chatRoomID = ids.join('_');
    //add messeges to database
    await _firestore
        .collection("chat_room")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

// get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUSerID) {
//construct a chat room id for two users

    List<String> ids = [userID, otherUSerID];
    ids.sort();
    String chatroomID = ids.join('_');
    return _firestore
        .collection("chat_room")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

// Report USER
  Future<void> reportUser(String massegeID, String userID) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportdBy': currentUser!.uid,
      'messageID': massegeID,
      'messageOwnerID': userID,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Reports').add(report);
  }

// Block USER
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userID)
        .set({});
    notifyListeners();
  }

// Unblck User
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserID)
        .delete();
  }

//Get Blocked User
  Stream<List<Map<String, dynamic>>> getblockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked user Ids

      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('Users').doc(id).get()),
      );
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
