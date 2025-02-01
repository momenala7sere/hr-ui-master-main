
import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onTap;

  const DateField({
    required this.controller,
    required this.labelText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'dd-MM-yyyy',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: onTap,
        ),
      ),
      onTap: onTap,
      readOnly: true,
    );
  }
}

