class User {
  final String id;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;

  User({
    this.id = "",
    this.name = "",
    this.email = "",
    this.createdAt = "",
    this.updatedAt = "",
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}
