import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/api/api_service.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/screens/Leave_History.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:file_picker/file_picker.dart';

class LeaveRequestForm extends StatefulWidget {
  const LeaveRequestForm({super.key});

  @override
  _LeaveRequestFormState createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _leaveDate = DateTime.now();
  TimeOfDay _leaveFromTime = TimeOfDay.now();
  TimeOfDay _leaveToTime = TimeOfDay.now();
  String _description = '';
  String _leavePeriod = '';
  String? _selectedFile;
  List<DropdownMenuItem<String>> _leaveTypeItems = [];

  final TextEditingController _leaveDateController = TextEditingController();
  final TextEditingController _leaveFromTimeController =
      TextEditingController();
  final TextEditingController _leaveToTimeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _leaveDateController.text = '${_leaveDate.toLocal()}'.split(' ')[0];
    _leaveFromTimeController.text = _leaveFromTime.format(context);
    _leaveToTimeController.text = _leaveToTime.format(context);
  }

  @override
  void initState() {
    super.initState();
    _loadLeaveTypes();
  }

  @override
  void dispose() {
    _leaveDateController.dispose();
    _leaveFromTimeController.dispose();
    _leaveToTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaveTypes() async {
    final leaveTypes = await _fetchLeaveTypes();
    setState(() {
      _leaveTypeItems = leaveTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type['id'].toString(),
          child: SizedBox(
            width: double.infinity, // Ensure the item has space to fit
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                type['nameAr'],
                overflow: TextOverflow.ellipsis, // Safeguard against overflow
              ),
            ),
          ),
        );
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchLeaveTypes() async {
    final token = await ApiService().getSavedToken();
    if (token != null) {
      try {
        final response = await ApiService().getLeaveType(token);

        // Debug the response structure
        print('API Response for Leave Types: $response');

        // Access the `response` field directly
        if (response.containsKey('response') && response['response'] != null) {
          return List<Map<String, dynamic>>.from(response['response']);
        } else {
          print('Leave types are null or missing from response.');
          return [];
        }
      } catch (e) {
        print('Error fetching leave types: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch leave types: $e')),
        );
      }
    }
    return [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _leaveDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _leaveDate = picked;
        _leaveDateController.text = '${_leaveDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? _leaveFromTime : _leaveToTime,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _leaveFromTime = picked;
          _leaveFromTimeController.text = _leaveFromTime.format(context);
        } else {
          _leaveToTime = picked;
          _leaveToTimeController.text = _leaveToTime.format(context);
        }
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });
    } else {
      print("File selection canceled.");
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'leaveDate': _leaveDate.toIso8601String(),
        'leaveFromTime': _leaveFromTime.format(context),
        'leaveToTime': _leaveToTime.format(context),
        'description': _description,
        'leaveType': _leavePeriod,
        'attachedFile': _selectedFile,
      };

      final token = await ApiService().getSavedToken();
      if (token != null) {
        context.read<GenericBloc>().add(SubmitLeaveRequest(data: requestData));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Token not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenericBloc(),
      child: BlocListener<GenericBloc, GenericState>(
        listener: (context, state) {
          if (state is GenericLoading) {
            // Show a loading indicator (optional)
          } else if (state is GenericLoaded) {
            final successMessage =
                state.data['message'] ?? 'Request submitted!';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(successMessage)),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LeaveHistoryScreen()),
            );
          } else if (state is GenericError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                        currentLocale: Localizations.localeOf(context),
                        token: ''),
                  ),
                );
              },
            ),
            title: Text(
              LocalizationService.translate('new_leave'),
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LeaveHistoryScreen()),
                  );
                },
                child: Text(
                  LocalizationService.translate('leave_history'),
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
                      labelText: LocalizationService.translate('leave_type'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    isExpanded: true, // Expands dropdown to avoid overflow
                    items: _leaveTypeItems,
                    onChanged: (value) {
                      setState(() {
                        _leavePeriod = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationService.translate(
                            'select_leave_type');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('leave_date'),
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
                    controller: _leaveDateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationService.translate(
                            'select_leave_date');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('leave_period'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    isExpanded: true, // Expands dropdown to avoid overflow
                    items: [
                      DropdownMenuItem(
                        value: 'working_hours',
                        child: Text(
                            LocalizationService.translate('working_hours')),
                      ),
                      DropdownMenuItem(
                        value: 'full_day',
                        child: Text(LocalizationService.translate('full_day')),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _leavePeriod = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationService.translate(
                            'select_leave_period');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText:
                          LocalizationService.translate('leave_from_time'),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(context, true),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: _leaveFromTimeController,
                    validator: (value) {
                      if (_leavePeriod != 'full_day' &&
                          (value == null || value.isEmpty)) {
                        return LocalizationService.translate(
                            'select_start_time');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: LocalizationService.translate('leave_to_time'),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(context, false),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: _leaveToTimeController,
                    validator: (value) {
                      if (_leavePeriod != 'full_day' &&
                          (value == null || value.isEmpty)) {
                        return LocalizationService.translate('select_end_time');
                      }
                      return null;
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationService.translate(
                            'enter_valid_description');
                      }
                      return null;
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
