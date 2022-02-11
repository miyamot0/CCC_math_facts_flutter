import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference mainCollection =
      FirebaseFirestore.instance.collection('mainCollection');

  // Update teacher's data
  Future updateTeacherData(
      String school, String teacherName, String grade) async {
    return await mainCollection
        .doc(uid)
        .set({'school': school, 'teacherName': teacherName, 'grade': grade});
  }
}
