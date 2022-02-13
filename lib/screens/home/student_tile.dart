import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:flutter/material.dart';

class StudentTile extends StatelessWidget {
  final Student student;

  const StudentTile({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[100],
          ),
          title: Text(student.name),
          subtitle:
              Text("Target: ${student.target}, Set Size: ${student.setSize}"),
        ),
      ),
    );
  }
}