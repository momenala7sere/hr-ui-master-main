import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart'; // For localization
import 'package:intl/intl.dart';
import 'package:hr/screens/home/HomePage.dart';



class LeaveHistoryApp extends StatelessWidget {
  const LeaveHistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeaveHistoryScreen(),
    );
  }
}

class LeaveHistoryScreen extends StatelessWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GenericBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(LocalizationService.translate('leaves_history')),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
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
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchForm(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
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
    return BlocListener<GenericBloc, GenericState>(
      listener: (context, state) {
        if (state is GenericLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Loading...')),
          );
        } else if (state is GenericLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Results: ${state.data}')),
          );
        } else if (state is GenericError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _fromDateController,
            decoration: InputDecoration(
              labelText: LocalizationService.translate('from_date'),
              hintText: LocalizationService.translate('date_format_hint'),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () => _selectDate(context, _fromDateController),
              ),
            ),
            onTap: () => _selectDate(context, _fromDateController),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _toDateController,
            decoration: InputDecoration(
              labelText: LocalizationService.translate('to_date'),
              hintText: LocalizationService.translate('date_format_hint'),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () => _selectDate(context, _toDateController),
              ),
            ),
            onTap: () => _selectDate(context, _toDateController),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final fromDate = _fromDateController.text;
                final toDate = _toDateController.text;

                if (fromDate.isEmpty || toDate.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select both dates.')),
                  );
                  return;
                }

                // Dispatch Bloc event to fetch vacation history
                context.read<GenericBloc>().add(FetchVacationHistory(
                      fromDate: _dateFormat.parse(fromDate),
                      toDate: _dateFormat.parse(toDate),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffCE5E52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    LocalizationService.translate('search'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
