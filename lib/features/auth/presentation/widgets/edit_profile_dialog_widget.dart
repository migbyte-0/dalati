import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final Future<void> Function(String) onUpdate;

  const EditProfileDialog({
    Key? key,
    required this.controller,
    required this.title,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form

  TextInputType get keyboardType {
    return widget.title == 'Phone Number'
        ? TextInputType.phone
        : TextInputType.name;
  }

  int? get maxLength {
    return widget.title == 'Phone Number' ? 9 : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.title}'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey, // Associate the Form with a GlobalKey
              child: TextFormField(
                controller: widget.controller,
                decoration:
                    InputDecoration(hintText: "Enter new ${widget.title}"),
                keyboardType: keyboardType,
                maxLength: maxLength,
                validator: (value) {
                  // Validation logic for phone number
                  if (widget.title == 'Phone Number' &&
                      (value == null ||
                          !value.startsWith('5') ||
                          value.length != 9)) {
                    return 'Phone number must start with 5 and have 9 digits';
                  }
                  return null;
                },
              ),
            ),
      actions: <Widget>[
        if (!_isLoading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    try {
                      await widget.onUpdate(widget.controller.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating: $e')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                        Navigator.of(context).pop();
                      }
                    }
                  }
                },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
