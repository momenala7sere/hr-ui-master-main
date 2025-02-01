import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:hr/screens/home/HomePage.dart';
import 'package:intl/intl.dart';

class VacationHistoryScreen extends StatelessWidget {
  const VacationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenericBloc()
        ..add(FetchVacationHistory()), // Fetch data initially
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocalizationService.translate('vacations_history')),
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
                    currentLocale: Localizations.localeOf(context), token: '',
                  ),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SearchForm(),
              const SizedBox(height: 16),
              BlocBuilder<GenericBloc, GenericState>(
                builder: (context, state) {
                  if (state is GenericLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GenericLoaded) {
                    final data = state.data as List<Map<String, dynamic>>;
                    return Expanded(
                      child: VacationHistoryList(historyData: data),
                    );
                  } else if (state is GenericError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(child: Text('No data available.'));
                },
              ),
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

  void _search() {
    final fromDate = _fromDateController.text.isNotEmpty
        ? _dateFormat.parse(_fromDateController.text)
        : null;
    final toDate = _toDateController.text.isNotEmpty
        ? _dateFormat.parse(_toDateController.text)
        : null;

    context.read<GenericBloc>().add(FetchVacationHistory(
          fromDate: fromDate,
          toDate: toDate,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _fromDateController,
          decoration: InputDecoration(
            labelText: LocalizationService.translate('from_date'),
            hintText: LocalizationService.translate('date_format'),
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
            hintText: LocalizationService.translate('date_format'),
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
            onPressed: _search,
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
    );
  }
}

class VacationHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> historyData;

  const VacationHistoryList({super.key, required this.historyData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: historyData.length,
      itemBuilder: (context, index) {
        final record = historyData[index];
        return VacationHistoryCard(
          id: record['id'],
          employee: record['employee'],
          requestDate: record['requestDate'],
          requestType: record['requestType'],
          from: DateFormat('dd/MM/yyyy').format(record['from']),
          to: DateFormat('dd/MM/yyyy').format(record['to']),
          status: record['status'],
        );
      },
    );
  }
}

class VacationHistoryCard extends StatelessWidget {
  final String id;
  final String employee;
  final String requestDate;
  final String requestType;
  final String from;
  final String to;
  final String status;

  const VacationHistoryCard({
    super.key,
    required this.id,
    required this.employee,
    required this.requestDate,
    required this.requestType,
    required this.from,
    required this.to,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${LocalizationService.translate('id')}: $id',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${LocalizationService.translate('employee')}: $employee',
            ),
            const SizedBox(height: 8.0),
            Text(
              '${LocalizationService.translate('request_date')}: $requestDate',
            ),
            const SizedBox(height: 8.0),
            Text(
              '${LocalizationService.translate('request_type')}: $requestType',
            ),
            const SizedBox(height: 8.0),
            Text('${LocalizationService.translate('from')}: $from'),
            const SizedBox(height: 8.0),
            Text('${LocalizationService.translate('to')}: $to'),
            const SizedBox(height: 8.0),
            Chip(
              label: Text(LocalizationService.translate(status)),
              backgroundColor: Colors.blue,
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
