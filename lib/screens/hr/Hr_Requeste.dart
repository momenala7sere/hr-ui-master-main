import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/features/screens/Hr_History.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:file_picker/file_picker.dart';

class HrRequestForm extends StatefulWidget {
  const HrRequestForm({super.key});

  @override
  _HrRequestFormState createState() => _HrRequestFormState();
}

class _HrRequestFormState extends State<HrRequestForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _leaveDate = DateTime.now();
  String _description = '';
  String? _selectedFile;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _leaveDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _leaveDate) {
      setState(() {
        _leaveDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });

      print("Selected File: ${result.files.single.path}");
    } else {
      print("File selection canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenericBloc(),
      child: BlocListener<GenericBloc, GenericState>(
        listener: (context, state) {
          if (state is GenericLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing...')),
            );
          } else if (state is GenericLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success: ${state.data}')),
            );
          } else if (state is GenericError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              LocalizationService.translate('new_hr_request'),
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HrHistoryRequestScreen(),
                    ),
                  );
                },
                child: Text(
                  LocalizationService.translate('hr_request_history'),
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('request_type'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'support_letter',
                        child: Text(
                            LocalizationService.translate('support_letter')),
                      ),
                      DropdownMenuItem(
                        value: 'experience_certificate',
                        child: Text(
                          LocalizationService.translate(
                              'experience_certificate'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'company_email',
                        child: Text(
                          LocalizationService.translate('company_email'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'company_badge',
                        child: Text(
                            LocalizationService.translate('company_badge')),
                      ),
                    ],
                    onChanged: (value) {
                      // Handle change
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('request_date'),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () => _selectDate(context),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: '${_leaveDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('directed_to'),
                      hintText: LocalizationService.translate('optional'),
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('description'),
                      hintText:
                          LocalizationService.translate('enter_description'),
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: _pickFile,
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
                                color: Color.fromARGB(255, 112, 112, 112),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 35,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<GenericBloc>().add(
                                      SubmitLeaveRequest(data: {
                                        'leaveDate':
                                            _leaveDate.toIso8601String(),
                                        'description': _description,
                                        'file': _selectedFile,
                                      }),
                                    );
                              }
                            },
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
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              side: const BorderSide(
                                color: Color(0xffCE5E52),
                                width: 1.0,
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
      ),
    );
  }
}
