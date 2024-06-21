import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String password;
  String fullName;
  String photoURL;
  String contactNumber;
  bool isblocked;
  String confrimPassword;
  String userLocation;
  final review;
  int rate;

  UserModel({
    required this.uid,
    required this.email,
    required this.isblocked,
    required this.password,
    required this.rate,
    required this.review,
    required this.photoURL,
    required this.userLocation,
    required this.contactNumber,
    required this.confrimPassword,
    required this.fullName,
  });

  ///Converting Object into Json Object
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'isblocked': isblocked,
        'rate': rate,
        "review": review,
        'uid': uid,
        'email': email,
        "confrimPassword": confrimPassword,
        'password': password,
        'location': userLocation,
        'contactNumber': contactNumber,
        'photoURL': photoURL
      };

  ///
  static UserModel fromSnap(DocumentSnapshot snaps) {
    var snapshot = snaps.data() as Map<String, dynamic>;

    return UserModel(
      fullName: snapshot['fullName'],
      review: snapshot['review'],
      rate: snapshot['rate'],
      confrimPassword: snapshot['confrimPassword'],
      uid: snapshot['uid'],
      isblocked: snapshot['isblocked'],
      email: snapshot['email'],
      photoURL: snapshot['photoURL'],
      userLocation: snapshot['location'],
      password: snapshot['password'],
      contactNumber: snapshot['contactNumber'],
    );
  }
}
