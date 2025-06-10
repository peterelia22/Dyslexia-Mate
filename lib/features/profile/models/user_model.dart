class UserModel {
  final String? username;
  final String? email;
  final String? fullName;
  final String? dateOfBirth;

  UserModel({
    this.username,
    this.email,
    this.fullName,
    this.dateOfBirth,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      email: map['email'],
      fullName: map['fullName'],
      dateOfBirth: map['dateOfBirth'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
    };
  }
}
