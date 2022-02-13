import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';

import '../models/student.dart';

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

  // Updates

/*
  // Add Student to classroom
  Future addStudentToClassroom(String studentTag) async {
    return await mainCollection.doc(uid).update({
      'students': FieldValue.arrayUnion([studentTag])
    });
  }
*/

// ------------------------
// Modern Calls here
// ------------------------

  List<Student> _studentListingFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((d) {
      Map<String, dynamic> data = d.data() as Map<String, dynamic>;

      return Student(
        name: data['name'].toString() ?? '',
        setSize: data['setSize'].toString() ?? '',
        target: data['target'].toString() ?? '',
      );
    }).toList();
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

  // Get user doc screen
  Stream<UserData> get userData {
    return mainCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<Student>> get students {
    return FirebaseFirestore.instance
        .collection('mainCollection/$uid/students')
        .snapshots()
        .map(_studentListingFromSnapshot);
  }

  // Add Student to classroom collection
  Future addToStudentCollection(String studentTag) async {
    var test =
        FirebaseFirestore.instance.collection('mainCollection/$uid/students');

    return await test.add({'name': studentTag});
  }
}
