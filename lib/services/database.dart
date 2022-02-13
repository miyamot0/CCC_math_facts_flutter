import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference mainCollection =
      FirebaseFirestore.instance.collection('mainCollection');

  // Update teacher's data
  Future initialTeacherDataInsert(String school, String teacherName,
      String grade, String target, int setSize) async {
    return await mainCollection.doc(uid).set({
      'school': school,
      'teacherName': teacherName,
      'grade': grade,
      'target': target,
      'setSize': setSize,
      'students': []
    });
  }

  // Update teacher's data
  Future updateTeacherData(String school, String teacherName, String grade,
      String target, int setSize) async {
    return await mainCollection.doc(uid).set({
      'school': school,
      'teacherName': teacherName,
      'grade': grade,
      'target': target,
      'setSize': setSize
    });
  }

  /*
  List<String> _studentListFromSnapshot(QuerySnapshot snapshot) {
    snapshot.docs.map((d) {
      print(d.toString());
    });

    return snapshot.docs.map((d) {
      return d.toString();
    }).toList();
  }
  */

  List<String> _studentListingFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    final studentArray = List<String>.from(data["students"] as List);

    return studentArray;
  }

  List<String> _studentListingFromSnapshotHack(DocumentSnapshot snapshot) {
    //Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    //final studentArray = List<String>.from(data["students"] as List);
    final studentArray = ["hack"];

    return studentArray;
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserData(
        uid: uid,
        name: data['teacherName'],
        currentTarget: data['target'],
        currentSetSize: data['setSize'],
        currentGrade: data['grade'],
        currentSchool: data['school']);
  }

  Stream<List<String>> get students {
    return mainCollection
        .doc(uid)
        .snapshots()
        .map(_studentListingFromSnapshotHack);
  }

  // Get user doc screen
  Stream<UserData> get userData {
    return mainCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Updates

  // Add Student to classroom
  Future addStudentToClassroom(String studentTag) async {
    return await mainCollection.doc(uid).update({
      'students': FieldValue.arrayUnion([studentTag])
    });
  }

  // Add Student to classroom collection
  Future addToStudentCollection(String studentTag) async {
    var test =
        FirebaseFirestore.instance.collection('mainCollection/$uid/students');

    return await test.add({'name': studentTag});
  }

  /*
  void readStudents() async {
    final List<String> studentList =
        await mainCollection.doc(uid).get().then((value) {
      Map<String, dynamic> data = value.data()! as Map<String, dynamic>;

      final studentArray = List<String>.from(data["students"] as List);

      return studentArray;
    });
  }
  */
}
