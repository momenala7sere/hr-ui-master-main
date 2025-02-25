import 'package:flutter/material.dart';
import 'package:hr/features/hr/components/CustomButton.dart';
import 'package:intl/intl.dart';

import '../component/DateField.dart';


class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateField(
          controller: _fromDateController,
          labelText: 'From Date',
          onTap: () => _selectDate(context, _fromDateController),
        ),
        const SizedBox(height: 16),
        DateField(
          controller: _toDateController,
          labelText: 'To Date',
          onTap: () => _selectDate(context, _toDateController),
        ),
        const SizedBox(height: 16),
        CustomButton(
          label: 'Search',
          icon: Icons.search,
          onPressed: () {
            // Handle search logic here
          },
        ),
      ],
    );
  }
}