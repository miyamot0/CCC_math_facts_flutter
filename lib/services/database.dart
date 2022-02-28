/* 
    The MIT License
    Copyright February 1, 2022 Shawn Gilroy/Louisiana State University
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/models/record_ccc_mfacts.dart';
import 'package:covcopcomp_math_fact/models/usermodel.dart';

import '../models/student.dart';
import '../models/teacher.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Path generator, student information
  String _studentInformationPath() {
    return 'mainCollection/$uid/students';
  }

  // Path generator, student performance
  String _studentPerformancePath(RecordMathFacts record) {
    return 'performanceCollection/${record.tid}/${record.target}/students/${record.id}';
  }

  // Stream for user data
  Stream<UserData> get userData {
    return FirebaseFirestore.instance
        .collection('mainCollection')
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  // Stream for current students
  Stream<List<Student>> get students {
    return FirebaseFirestore.instance
        .collection(_studentInformationPath())
        .snapshots()
        .map(_studentListingFromSnapshot);
  }

  // Map for snapshot, list of students for home page
  List<Student> _studentListingFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((d) {
      Map<String, dynamic> data = d.data() as Map<String, dynamic>;

      return Student(
          name: data['name'].toString() ?? '',
          setSize: data['setSize'].toString() ?? '',
          target: data['target'].toString() ?? '',
          set: data['set'].toString() ?? '',
          id: d.id ?? '',
          randomized: data['random'],
          orientationPreference: data['hasPreference'] ?? false,
          preferredOrientation: data['preferredOrientation'].toString() ?? '',
          metric: data['metric'].toString() ?? '');
    }).toList();
  }

  // Map for snapshot, specific to teacher user data
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

  // Add Student to classroom collection
  Future addToStudentCollection(Student student) async {
    return await FirebaseFirestore.instance
        .collection(_studentInformationPath())
        .add({
      'name': student.name,
      'setSize': student.setSize,
      'target': student.target,
      'set': student.set,
      'random': student.randomized,
      'hasPreference': student.orientationPreference,
      'preferredOrientation': student.preferredOrientation,
      'metric': student.metric
    });
  }

  // Add student performance to collection
  Future addToStudentPerformanceCollection(RecordMathFacts record) async {
    return await FirebaseFirestore.instance
        .collection(_studentPerformancePath(record))
        .add({
      'tid': record.tid,
      'id': record.id,
      'setSize': int.parse(record.setSize),
      'set': record.set,
      'target': record.target,
      'dateTimeStart': record.dateTimeStart,
      'dateTimeEnd': record.dateTimeEnd,
      'errCount': record.errCount,
      'nRetries': record.nRetries,
      'nCorrectInitial': record.nCorrectInitial,
      'delaySec': record.delaySec,
      'sessionDuration': record.sessionDuration,
      'totalDigits': record.totalDigits,
      'correctDigits': record.correctDigits
    });
  }

  // Update a student's programming
  Future updateStudentInCollection(Student student) async {
    return await FirebaseFirestore.instance
        .collection(_studentInformationPath())
        .doc(student.id)
        .set({
      'name': student.name,
      'setSize': int.parse(student.setSize),
      'set': int.parse(student.set),
      'target': student.target,
      'random': student.randomized,
      'hasPreference': student.orientationPreference,
      'preferredOrientation': student.preferredOrientation,
      'metric': student.metric
    });
  }

  // Update a teacher's working defaults
  Future updateTeacherInCollection(Teacher teacher) async {
    return await FirebaseFirestore.instance
        .collection('mainCollection')
        .doc(uid)
        .set({
      'school': teacher.school,
      'teacherName': teacher.name,
      'grade': teacher.grade
    });
  }
}
