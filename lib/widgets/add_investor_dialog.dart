import 'package:flutter/material.dart';
import '../models/investor.dart';

class AddInvestorDialog extends StatefulWidget {
  final Function(Investor) onAdd;

  const AddInvestorDialog({super.key, required this.onAdd});

  @override
  State<AddInvestorDialog> createState() => _AddInvestorDialogState();
}

class _AddInvestorDialogState extends State<AddInvestorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _industryController = TextEditingController();
  final _rangeController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Investor'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company'),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _industryController,
                decoration: const InputDecoration(labelText: 'Industry'),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _rangeController,
                decoration: const InputDecoration(
                  labelText: 'Investment Range (M)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submitForm, child: const Text('Add')),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final investor = Investor(
        name: _nameController.text,
        company: _companyController.text,
        industry: _industryController.text,
        investmentRange: double.parse(_rangeController.text),
        bio: _bioController.text,
      );
      widget.onAdd(investor);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _industryController.dispose();
    _rangeController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
