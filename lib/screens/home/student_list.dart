import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:covcopcomp_math_fact/screens/home/student_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    final List<Student> students = Provider.of<List<Student>>(context) ?? [];

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return StudentTile(student: students[index]);
      },
    );
  }
}
