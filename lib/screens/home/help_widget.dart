import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        const Text(
          'App Usage Guidelines',
          style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Adding a New Student to Group/Class',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
            'Students can be easily added to the dashboard by selected the button with the \'+\' symbol on the home screen. From there, you can supply a name for the student, which types of tasks to assign (e.g., math facts, addition), which sets of items to assign (18 variations are included), how many problems to present from the set, whether to randomize which items in the set are present, whether to present problems vertically or horizontally, and whether to focus on accuracy or fluency.',
            style: TextStyle(fontSize: 18.0)),
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Editing Personal Settings (Classroom)',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
            'At any time, you can edit your personal settings (e.g., name, school) by pressing the settings button in the appbar. The settings button in the appbar pertains to the teacher, while the settings button in the student area refers to respective students.',
            style: TextStyle(fontSize: 18.0)),
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Editing a Student\'s Assigned Programming (In-App)',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
            'It is likely that, over time, you may choose to update a student\'s current programming (e.g., changing from a focus on accuracy, to fluency for addition math facts). Settings for an individual student can be done by pressing the settings icon for the respective student. From this menu, you will be able to modify both the skill targeted as well as how Cover Copy Compare will be presented.',
            style: TextStyle(fontSize: 18.0)),
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Viewing a Student\'s Progress (In-App)',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Text(
            'Student progress is updated in realtime and can be viewed in the app by pressing the red charting button to the right of the student\'s information. This will bring up a visual chart of the student\'s performance, highlight the specific type of data being targeted (e.g., Accuracy for Math Facts Addition, fluency for Math Facts Subtraction). Additionally, the aimline designated for the student will be drawn atop of their current programming.',
            style: TextStyle(fontSize: 18.0)),
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Working with the App Remotely (Via Website)',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 15.0,
        ),
        RichText(
            text: TextSpan(children: [
          const TextSpan(
              text:
                  'Occasionally, teachers/team leaders may find it easier to manage student programming remotely (i.e., not having to update individually using a tablet). Teachers/team leaders may log into their account at the following location: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              )),
          TextSpan(
              text: 'https://miyamot0.github.io/ccc_math_facts.github.io/',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 18.0,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  try {
                    await launch("https://miyamot0.github.io/ccc_math_facts.github.io/");
                  } catch (e) {
                    //print(e.toString());
                  }
                })
        ])),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
