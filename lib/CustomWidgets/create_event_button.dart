import 'package:flutter/material.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        // Create event logic here
      },
    );
  }
}
