class User {
  User({
    required this.email,
    required this.pw,
    required this.uid,
    required this.nickname,
  });

  final String? email;
  final String? pw;
  final String? uid;
  final String nickname;

  factory User.fromJson(json) => User(
        email: json['id'],
        pw: json['pw'],
        uid: json['uid'],
        nickname: json['nickname'],
      );

  Map<String, dynamic> toJson() => {
    'id': email,
    'pw': pw,
    'nickname': nickname,
    'uid': uid,
  };

}
