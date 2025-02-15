import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class IdeaForm extends StatefulWidget {
  const IdeaForm({super.key});

  @override
  _IdeaFormState createState() => _IdeaFormState();
}

class _IdeaFormState extends State<IdeaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ideaController = TextEditingController();
  String feedback = '';
  final DbService dbService = DbService(); // Add this line

  Future<void> submitIdea() async {
    if (_formKey.currentState!.validate()) {
      String idea = _ideaController.text;
      var validationResult = await ApiService.validateIdea(idea);
      await dbService.saveIdea(idea, validationResult); // Change this line
      setState(() {
        feedback = 'Idea validated with score: ${validationResult['score']}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _ideaController,
            decoration: InputDecoration(labelText: 'Enter your business idea'),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Please enter an idea'
                        : null,
          ),
          SizedBox(height: 16),
          ElevatedButton(onPressed: submitIdea, child: Text('Submit')),
          SizedBox(height: 16),
          Text(feedback),
        ],
      ),
    );
  }
}
