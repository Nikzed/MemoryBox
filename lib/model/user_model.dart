class UserModel {
  final String uid;
  final String number;
  final String name;

  const UserModel({
    required this.number,
    required this.name,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'].toString(),
      number: json['number'].toString(),
      name: json['name'].toString(),
    );
  }
}
