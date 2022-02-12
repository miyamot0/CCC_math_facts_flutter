import 'package:flutter/material.dart';
import 'package:covcopcomp_math_fact/models/teacher.dart';

class TeacherTile extends StatelessWidget {
  final Teacher teacher;

  TeacherTile({Key? key, required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[100],
          ),
          title: Text(teacher.name),
          subtitle: Text(teacher.school),
        ),
      ),
    );
  }
}
