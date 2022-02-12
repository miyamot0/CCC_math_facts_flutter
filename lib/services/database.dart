import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/models/teacher.dart';

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

  List<Teacher> _teacherListFromSnapshot(QuerySnapshot snapshot) {
    print(snapshot.size);

    return snapshot.docs.map((d) {
      return Teacher(
          name: d['teacherName'] ?? '',
          school: d['school'] ?? '',
          grade: d['grade'] ?? '');
    }).toList();
  }

  Stream<List<Teacher>> get teachers {
    return mainCollection.snapshots().map(_teacherListFromSnapshot);
  }
}
