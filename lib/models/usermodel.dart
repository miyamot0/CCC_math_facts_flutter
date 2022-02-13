class UserModel {
  final String uid;

  UserModel({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String currentTarget;
  final int currentSetSize;
  final String currentGrade;
  final String currentSchool;

  UserData(
      {required this.uid,
      required this.name,
      required this.currentTarget,
      required this.currentSetSize,
      required this.currentGrade,
      required this.currentSchool});
}
