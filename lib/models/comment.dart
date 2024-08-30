import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? userName;
  String? userID;
  String? userProfileImage;
  String? commentText;
  String? commentID;
  List<String>? commentLikesList;
  DateTime? publishedDateTime;

  Comment({
    this.userName,
    this.userID,
    this.userProfileImage,
    this.commentText,
    this.commentID,
    this.commentLikesList,
    this.publishedDateTime,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userID": userID,
        "userProfileImage": userProfileImage,
        "commentText": commentText,
        "commentID": commentID,
        "commentLikesList": commentLikesList,
        "publishedDateTime": publishedDateTime != null
            ? Timestamp.fromDate(publishedDateTime!)
            : null,
      };

  static Comment fromDocumentSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      userName: snapshot["userName"],
      userID: snapshot["userID"],
      userProfileImage: snapshot["userProfileImage"],
      commentText: snapshot["commentText"],
      commentID: snapshot["commentID"],
      commentLikesList: List<String>.from(snapshot["commentLikesList"] ?? []),
      publishedDateTime: _parseDateTime(snapshot["publishedDateTime"]),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is DateTime) {
      return value;
    } else if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
