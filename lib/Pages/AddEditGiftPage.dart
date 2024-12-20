import 'package:flutter/material.dart';

class AddEditGiftPage extends StatefulWidget {
  final Map<String, dynamic>? giftData; // For editing
  final int eventId;
  final String userId; // Add userId parameter

  const AddEditGiftPage({Key? key, this.giftData, required this.eventId, required this.userId})
      : super(key: key);

  @override
  _AddEditGiftPageState createState() => _AddEditGiftPageState();
}

class _AddEditGiftPageState extends State<AddEditGiftPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.giftData != null) {
      _nameController.text = widget.giftData!['NAME'] ?? '';
      _descriptionController.text = widget.giftData!['DESCRIPTION'] ?? '';
      _categoryController.text = widget.giftData!['CATEGORY'] ?? '';
      _priceController.text =
          widget.giftData!['PRICE']?.toStringAsFixed(2) ?? '';
      _imageUrl = widget.giftData!['IMG_URL'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveGift() async {
    if (_formKey.currentState!.validate()) {
      final giftData = {
        'GIFT_FIREBASE_ID': 'temPiDiNtTatFiEld', // Include firebase ID
        'NAME': _nameController.text.trim(),
        'DESCRIPTION': _descriptionController.text.trim(),
        'CATEGORY': _categoryController.text.trim(),
        'PRICE': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'IMG_URL': _imageUrl ?? '',
        'PLEDGED_BY': 'No one yet', // Default value
        'USER_ID': widget.userId, // Add 'USER_ID' field
        'EVENT_ID': widget.eventId,
      };

      // Pass the giftData and a flag indicating whether it's new or updated
      Navigator.pop(context, {
        'giftData': giftData,
        'isNew': widget.giftData == null,
      });
    }
  }


  Future<void> _pickImage() async {
    // TODO: Implement image picker logic
    setState(() {
      _imageUrl = 'https://cdn-icons-png.flaticon.com/512/3209/3209955.png'; // Placeholder URL
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.giftData == null ? 'Add Gift' : 'Edit Gift'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Gift Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Gift Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Gift name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required.';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter a valid price.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gift Image',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _imageUrl == null
                      ? const Text('No image selected.')
                      : Image.network(
                    _imageUrl!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Image'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveGift,
                child: Text(widget.giftData == null ? 'Add Gift' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
