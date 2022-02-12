import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covcopcomp_math_fact/models/teacher.dart';
import 'package:covcopcomp_math_fact/screens/home/teacher_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherList extends StatefulWidget {
  const TeacherList({Key? key}) : super(key: key);

  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  @override
  Widget build(BuildContext context) {
    final teachers = Provider.of<List<Teacher>>(context);

    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        return TeacherTile(teacher: teachers[index]);
      },
    );
  }
}
