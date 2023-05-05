import 'package:uvbs/models/user.dart';

class Comment {
  final String id;
  final User? user;
  final String msg;
  final String createdAt;
  final String updatedAt;

  Comment({
    this.id = "",
    this.user,
    this.msg = "",
    this.createdAt = "",
    this.updatedAt = "",
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'],
        msg = json['msg'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}
