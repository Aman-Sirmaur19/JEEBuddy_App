import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'college_predictor_screen.dart';

class ExamSelectionScreen extends StatelessWidget {
  const ExamSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          title: const Text('Select Exam'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          children: [
            _customListTile(
              context: context,
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          const CollegePredictorScreen(exam: 'B.Tech'))),
              title: 'JEE Mains - B.Tech',
              subtitle: 'NITs, IIITs & GFTIs',
            ),
            const SizedBox(height: 10),
            _customListTile(
              context: context,
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          const CollegePredictorScreen(exam: 'B.Arch'))),
              title: 'JEE Mains - B.Arch',
              subtitle: 'NITs & GFTIs',
            ),
            const SizedBox(height: 10),
            _customListTile(
              context: context,
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          const CollegePredictorScreen(exam: 'Advanced'))),
              title: 'JEE Advanced',
              subtitle: 'IITs',
            ),
          ],
        ),
      ),
    );
  }

  Widget _customListTile({
    required BuildContext context,
    required void Function() onTap,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: const Icon(Icons.school_outlined, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle,
          style: TextStyle(
            letterSpacing: .5,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          )),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }
}
