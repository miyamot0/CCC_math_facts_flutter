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

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference mainCollection =
      FirebaseFirestore.instance.collection('mainCollection');

  final CollectionReference performanceCollection =
      FirebaseFirestore.instance.collection('performanceCollection');

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
        set: data['set'].toString() ?? '',
        id: d.id ?? '',
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
  Future addToStudentCollection(
      String studentTag, String setSize, String target, int setNum) async {
    return await FirebaseFirestore.instance
        .collection('mainCollection/$uid/students')
        .add({
      'name': studentTag,
      'setSize': setSize,
      'target': target,
      'set': setNum.toString()
    });
  }

  Future addToStudentPerformanceCollection(RecordMathFacts record) async {
    var test = FirebaseFirestore.instance.collection(
        'performanceCollection/${record.tid}/${record.target}/students/${record.id}');

    return await test.add({
      'tid': record.tid,
      'id': record.id,
      'setSize': record.setSize,
      'target': record.target,
      'dateTimeStart': record.dateTimeStart,
      'dateTimeEnd': record.dateTimeEnd,
      'errCount': record.errCount,
      'nRetries': record.nRetries,
      'nCorrectInitial': record.nCorrectInitial,
      'delaySec': record.delaySec,
      'sessionDuration': record.sessionDuration
    });
  }

  Future updateStudentInCollection(String studentTag, String setSize,
      String target, String set, String iid) async {
    var test = FirebaseFirestore.instance
        .collection('mainCollection/$uid/students')
        .doc(iid);

    return await test.set(
        {'name': studentTag, 'setSize': setSize, 'set': set, 'target': target});
  }

  // Update teacher's data
  Future addTeacherDataInsert(
      String school, String teacherName, String grade) async {
    return await mainCollection
        .doc(uid)
        .set({'school': school, 'teacherName': teacherName, 'grade': grade});
  }

  // Update teacher's data
  Future updateTeacherData(
      String school, String teacherName, String grade) async {
    return await mainCollection
        .doc(uid)
        .set({'school': school, 'teacherName': teacherName, 'grade': grade});
  }
}
