class UserModel {
  final String uid;

  UserModel({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String currentTarget;
  final int currentSetSize;
  final String currentGrade;
  final String currentSchool;

  UserData(
      {this.uid,
      this.name,
      this.currentTarget,
      this.currentSetSize,
      this.currentGrade,
      this.currentSchool});
}
