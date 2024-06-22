import 'dart:io';

import 'package:boom_client/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class ChatDetailPage extends StatefulWidget {
  final providerId;
  final providerName;
  final providerEmail;
  final providerPhoto;
  final customerId;
  final chatCustomerId;
  final customerName;
  final customerPhoto;
  final customerEmail;
  ChatDetailPage(
      {super.key,
      required this.customerEmail,
      required this.providerId,
      required this.chatCustomerId,
      required this.customerName,
      required this.customerPhoto,
      required this.providerEmail,
      required this.customerId,
      required this.providerName,
      required this.providerPhoto});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String groupChatId = "";
  ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  File? imageUrl;
  UploadTask? task;
  File? file;
  bool show = false;

  TextEditingController messageController = TextEditingController();
  String? imageLink, fileLink;
  firebase_storage.UploadTask? uploadTask;
  @override
  void initState() {
    // TODO: implement initState
    if (FirebaseAuth.instance.currentUser!.uid.hashCode <=
        widget.providerId.hashCode) {
      groupChatId =
          "${FirebaseAuth.instance.currentUser!.uid}-${widget.providerId}";
    } else {
      groupChatId =
          "${widget.providerId}-${FirebaseAuth.instance.currentUser!.uid}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.providerPhoto),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.providerName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.call,
                  color: mainBtnColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.docs == 0
                      ? Center(child: Text("Empty "))
                      : Expanded(
                          child: ListView.builder(
                            reverse: false,
                            controller: scrollController,
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            itemBuilder: (context, index) {
                              var ds = snapshot.data!.docs[index];
                              return ds.get("type") == 0
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: Align(
                                        alignment: (ds.get("senderId") ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? Alignment.bottomRight
                                            : Alignment.bottomLeft),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: (ds.get("senderId") ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Colors.grey.shade100
                                                : Colors.blue[100]),
                                          ),
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Text(
                                                ds.get("content"),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                DateFormat.jm().format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        int.parse(
                                                            ds.get("time")))),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : ds.get("type") == 1
                                      ? Stack(
                                          children: [
                                            Column(children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Align(
                                                  alignment: (ds.get(
                                                              "senderId") ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? Alignment.bottomRight
                                                      : Alignment.bottomLeft),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),

                                                      // color: (ds.get("senderId") == FirebaseAuth.instance.currentUser!.uid?Colors.grey.shade100:Colors.blue[100]),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          height: 140,
                                                          imageUrl:
                                                              ds.get("image"),
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                        ),
                                                        Text(
                                                          DateFormat.jm().format(
                                                              DateTime.fromMillisecondsSinceEpoch(
                                                                  int.parse(ds.get(
                                                                      "time")))),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ],
                                                    ),
                                                    // padding: EdgeInsets.all(16),
                                                  ),
                                                ),
                                              ),
                                              task != null
                                                  ? buildUploadStatus(task!)
                                                  : Container(),
                                            ]),
                                          ],
                                        )
                                      : Container();
                            },
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error_outline));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) => SafeArea(
                          child: SizedBox(
                            height: 144,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    addImage();
                                  },
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text('Photo'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/pp.png",
                      width: 15,
                      height: 18,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.mic,
                    color: mainBtnColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage(messageController.text.trim(), 0);
                    },
                    child: Image.asset(
                      "assets/chatss.png",
                      width: 24,
                      height: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      messageController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "senderId": FirebaseAuth.instance.currentUser!.uid,
            "receiverId": widget.providerId,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }).then((value) {
        if (type == 0) {
          // Assuming type 0 is for 'note'
          updateLastMessageByProvider(content);
        }
      });

      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      // Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return Container();
          }
        },
      );

  Future uploadImageToFirebase() async {
    File? fileName = imageUrl;
    var uuid = Uuid();
    firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(
            'messages/${FirebaseAuth.instance.currentUser!.uid}/images+${uuid.v4()}');
    firebase_storage.UploadTask uploadTask =
        firebaseStorageRef.putFile(fileName!);
    firebase_storage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() async {
      print(fileName);
      String img = await uploadTask.snapshot.ref.getDownloadURL();
      setState(() {
        imageLink = img;
      });
    });
  }

  void updateLastMessageByProvider(String messageContent) async {
    final chatDocRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatCustomerId);

    // Check if the document exists before attempting to update it
    final chatDocSnapshot = await chatDocRef.get();
    if (chatDocSnapshot.exists) {
      // Document exists, update the lastMessageByProvider field
      await chatDocRef.update({
        'lastMessageByCustomer': messageContent,
      }).catchError((error) {
        print("Failed to update last message by provider: $error");
      });
    } else {
      print("Document does not exist, cannot update last message by provider");
    }
  }

  void addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageUrl = File(image!.path);
    });
    await uploadImageToFirebase().then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "senderId": FirebaseAuth.instance.currentUser!.uid,
            "receiverId": widget.providerId,
            // "content": messageController.text,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            'image': imageLink,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            // 'content': content,
            "file": "",
            'type': 1,
          },
        );
      });
    }).then((value) {
      // FocusScope.of(context).unfocus();
      messageController.clear();
    });
  }
}
