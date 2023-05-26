class Post {
  final int id;
  final String firstName;
  final String email;

  Post.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        firstName = map["firstName"],
        email = map["email"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['firstName'] = firstName;
    data['email'] = email;
    return data;
  }
}
