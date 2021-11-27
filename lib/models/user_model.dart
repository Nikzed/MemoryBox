class UserModel {
  final String uid;
  final String phoneNumber;
  final String name;

  const UserModel({
    required this.phoneNumber,
    required this.name,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'].toString(),
      phoneNumber: json['phoneNumber'].toString(),
      name: json['name'].toString(),
    );
  }
}
