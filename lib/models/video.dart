import 'package:uvbs/models/comment.dart';

class Video {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final int likes;
  final List<Comment>? comments;
  final String createdAt;
  final String updatedAt;

  Video({
    this.id = "",
    this.title = "",
    this.description = "",
    this.thumbnail = "",
    this.videoUrl = "",
    this.likes = 0,
    this.comments,
    this.createdAt = "",
    this.updatedAt = "",
  });

  Video.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        title = json['title'],
        thumbnail = json['thumbnail'],
        videoUrl = json['videoUrl'],
        likes = json['likes'],
        comments = [],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}
