import 'package:flutter/material.dart';
import '../widgets/idea_form.dart';

class IdeaSubmissionScreen extends StatelessWidget {
  const IdeaSubmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Idea Submission')),
      body: Padding(padding: const EdgeInsets.all(16.0), child: IdeaForm()),
    );
  }
}
