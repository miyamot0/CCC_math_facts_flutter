import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/models/teacher.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference mainCollection =
      FirebaseFirestore.instance.collection('mainCollection');

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

  List<Teacher> _teacherListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((d) {
      return Teacher(
          name: d['teacherName'] ?? '',
          school: d['school'] ?? '',
          grade: d['grade'] ?? '');
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    //print(snapshot.data());
    return UserData(
        uid: uid,
        name: data['teacherName'],
        currentTarget: data['target'],
        currentSetSize: data['setSize'],
        currentGrade: data['grade'],
        currentSchool: data['school']);
  }

  Stream<List<Teacher>> get teachers {
    return mainCollection.snapshots().map(_teacherListFromSnapshot);
  }

  // Get user doc screen
  Stream<UserData> get userData {
    return mainCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
