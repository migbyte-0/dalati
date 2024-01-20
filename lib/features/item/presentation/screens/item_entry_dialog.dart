import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item.dart';
import '../bloc/item_bloc.dart';

class ItemEntryDialog extends StatefulWidget {
  final bool isLostItem;
  final String username;
  final String phoneNumber;
  final Function onItemAdded;

  const ItemEntryDialog({
    Key? key,
    required this.isLostItem,
    required this.username,
    required this.phoneNumber,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  _ItemEntryDialogState createState() => _ItemEntryDialogState();
}

class _ItemEntryDialogState extends State<ItemEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedDeviceType;
  String? _selectedVehicleType;
  String? _idNumber;
  String? _plateNumber;
  String? _missingPersonName;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isLostItem ? 'Add Lost Item' : 'Add Found Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Username: ${widget.username}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Phone Number: ${widget.phoneNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: <String>[
                      'بطاقات تعريفية',
                      'مستندات',
                      'أجهزة إلكترونية',
                      'مركبات',
                      'أشخاص',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        _selectedDeviceType = null;
                        _selectedVehicleType = null;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  if (_selectedCategory == 'بطاقات تعريفية') ...[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'ID Number'),
                      onChanged: (value) => _idNumber = value,
                    ),
                    // ID Image Upload Button
                    ElevatedButton(
                      onPressed: () {/* Upload Logic */},
                      child: const Text('Upload ID Image'),
                    ),
                  ],
                  if (_selectedCategory == 'أجهزة إلكترونية') ...[
                    DropdownButtonFormField<String>(
                      value: _selectedDeviceType,
                      decoration:
                          const InputDecoration(labelText: 'Device Type'),
                      items: ['جوال', 'لاب توب', 'تاب']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDeviceType = newValue;
                        });
                      },
                    ),
                    // Device Image Upload Button (optional)
                    ElevatedButton(
                      onPressed: () {/* Upload Logic */},
                      child: const Text('Upload Device Image'),
                    ),
                  ],
                  if (_selectedCategory == 'مركبات') ...[
                    DropdownButtonFormField<String>(
                      value: _selectedVehicleType,
                      decoration:
                          const InputDecoration(labelText: 'Vehicle Type'),
                      items: ['صالون', 'حافلة', 'شاحنه']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedVehicleType = newValue;
                        });
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Plate Number'),
                      onChanged: (value) => _plateNumber = value,
                    ),
                    // Vehicle Image Upload Button (optional)
                    ElevatedButton(
                      onPressed: () {/* Upload Logic */},
                      child: const Text('Upload Vehicle Image'),
                    ),
                  ],
                  if (_selectedCategory == 'أشخاص') ...[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Missing Person Name'),
                      onChanged: (value) => _missingPersonName = value,
                    ),
                    // Missing Person Image Upload Button (optional)
                    ElevatedButton(
                      onPressed: () {/* Upload Logic */},
                      child: const Text('Upload Person Image'),
                    ),
                  ],
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: _isSubmitting
          ? []
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _submitItem,
                child: const Text('Add'),
              ),
            ],
    );
  }

  void _submitItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      Item newItem = Item(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory!,
        name: widget.username,
        phoneNumber: widget.phoneNumber,
        description: '', // Description from the form
        isLostItem: widget.isLostItem,
        timestamp: DateTime.now(),
        // Additional fields
        idNumber: _selectedCategory == 'بطاقات تعريفية' ? _idNumber : null,
        deviceType:
            _selectedCategory == 'أجهزة إلكترونية' ? _selectedDeviceType : null,
        vehicleType:
            _selectedCategory == 'مركبات' ? _selectedVehicleType : null,
        plateNumber: _selectedCategory == 'مركبات' ? _plateNumber : null,
        missingPersonName:
            _selectedCategory == 'أشخاص' ? _missingPersonName : null,
      );

      // Add the new item logic
      BlocProvider.of<ItemBloc>(context).add(AddItemEvent(newItem));
      _formKey.currentState!.reset();
      setState(() {
        _isSubmitting = false;
      });
      widget.onItemAdded();

      Navigator.of(context).pop();
    }
  }
}
