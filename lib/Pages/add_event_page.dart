import 'package:flutter/material.dart';

class AddEditEventPage extends StatefulWidget {
  final Map<String, dynamic>? eventData;
  final String userId; // Add userId parameter


  const AddEditEventPage({Key? key, this.eventData, required this.userId}) : super(key: key);

  @override
  _AddEditEventPageState createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.eventData?['NAME'] ?? '');
    _categoryController = TextEditingController(text: widget.eventData?['CATEGORY'] ?? '');
    _descriptionController = TextEditingController(text: widget.eventData?['DESCRIPTION'] ?? '');
    _dateController = TextEditingController(text: widget.eventData?['DATE'] ?? '');
    _locationController = TextEditingController(text: widget.eventData?['LOCATION'] ?? '');
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'EVENT_FIREBASE_ID': 'temPiDiNtTatFiEld', // Include firebase ID
        'NAME': _nameController.text,
        'CATEGORY': _categoryController.text,
        'DESCRIPTION': _descriptionController.text,
        'DATE': _dateController.text,
        'LOCATION': _locationController.text,
        'USER_ID': widget.userId, // Include userId
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventData == null ? 'Add Event' : 'Edit Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEvent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Category cannot be empty' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDate,
                validator: (value) => value!.isEmpty ? 'Date cannot be empty' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Location cannot be empty' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
