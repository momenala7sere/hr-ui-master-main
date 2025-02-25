import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:hr/screens/Vacation_History.dart';

class VacationRequestForm extends StatefulWidget {
  const VacationRequestForm({super.key});

  @override
  _VacationRequestFormState createState() => _VacationRequestFormState();
}

class _VacationRequestFormState extends State<VacationRequestForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _description = '';
  String _employeeAddress = '';
  String _alternativeEmployee = '';
  String _employeePhoneNumber = '';
  String? _selectedFile; // To store the selected file path or name
  String? _vacationType; // Selected vacation type

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDateController.text = '${_startDate.toLocal()}'.split(' ')[0];
    _endDateController.text = '${_endDate.toLocal()}'.split(' ')[0];
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = '${_startDate.toLocal()}'.split(' ')[0];
        } else {
          _endDate = picked;
          _endDateController.text = '${_endDate.toLocal()}'.split(' ')[0];
        }
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'type': 'vacation_request',
        'startDate': _startDate.toIso8601String(),
        'endDate': _endDate.toIso8601String(),
        'description': _description,
        'employeeAddress': _employeeAddress,
        'alternativeEmployee': _alternativeEmployee,
        'employeePhoneNumber': _employeePhoneNumber,
        'attachedFile': _selectedFile,
        'vacationType': _vacationType,
      };

      context.read<GenericBloc>().add(SubmitData(data: requestData));
    }
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: LocalizationService.translate(label),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 0.3),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenericBloc(),
      child: BlocListener<GenericBloc, GenericState>(
        listener: (context, state) {
          if (state is GenericLoaded) {
            final successMessage =
                state.data['message'] ?? 'Request submitted!';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(successMessage)),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VacationHistoryScreen()),
            );
          } else if (state is GenericError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              LocalizationService.translate('new_vacation'),
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VacationHistoryScreen(),
                    ),
                  );
                },
                child: Text(
                  LocalizationService.translate('vacation_history'),
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('vacation_type'),
                  value: _vacationType,
                  items: [
                    DropdownMenuItem(
                        value: 'funeral',
                        child: Text(LocalizationService.translate('funeral'))),
                    DropdownMenuItem(
                        value: 'sick',
                        child: Text(LocalizationService.translate('sick'))),
                    DropdownMenuItem(
                        value: 'official',
                        child: Text(LocalizationService.translate('official'))),
                    DropdownMenuItem(
                        value: 'maternity',
                        child:
                            Text(LocalizationService.translate('maternity'))),
                    DropdownMenuItem(
                        value: 'overtime',
                        child: Text(LocalizationService.translate('overtime'))),
                    DropdownMenuItem(
                        value: 'unpaid_vacation',
                        child: Text(
                            LocalizationService.translate('unpaid_vacation'))),
                    DropdownMenuItem(
                        value: 'umrah',
                        child: Text(LocalizationService.translate('umrah'))),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _vacationType = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  controller: _startDateController,
                  decoration: _inputDecoration('start_date',
                      suffixIcon: const Icon(Icons.calendar_month)),
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  controller: _endDateController,
                  decoration: _inputDecoration('end_date',
                      suffixIcon: const Icon(Icons.calendar_month)),
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('description'),
                  maxLines: 3,
                  onChanged: (value) {
                    _description = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('employee_address'),
                  onChanged: (value) {
                    _employeeAddress = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('alternative_employee'),
                  onChanged: (value) {
                    _alternativeEmployee = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: _inputDecoration('phone_number'),
                  onChanged: (value) {
                    _employeePhoneNumber = value;
                  },
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(
                        255, 58, 58, 58), width: 0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        setState(() {
                          _selectedFile = result.files.single.name;
                        });

                        print("Selected File: ${result.files.single.path}");
                      } else {
                        print("File selection canceled.");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.attach_file),
                          const SizedBox(width: 8.0),
                          Text(
                            _selectedFile != null
                                ? _selectedFile!
                                : LocalizationService.translate('attach'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 35,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle discard
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 16,
                            color: Colors.black,
                          ),
                          label: Text(
                            LocalizationService.translate('discard'),
                            style: const TextStyle(color: Colors.black),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            side: const BorderSide(
                              color: Colors
                                  .black, // Changed from Colors.grey.shade300 to Colors.black
                              width: 0.7,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 35,
                        child: OutlinedButton.icon(
                          onPressed: () => _submitForm(context),
                          icon: const Icon(
                            Icons.save,
                            size: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          label: Text(
                            LocalizationService.translate('save'),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFCE5E52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            side: const BorderSide(
                              color: Color(0xffCE5E52),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
