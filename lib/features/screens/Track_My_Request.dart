import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr/state_management/generic_bloc.dart';
import 'package:hr/state_management/generic_event.dart';
import 'package:hr/state_management/generic_state.dart';
import 'package:hr/state_management/localization_service.dart';
import 'package:intl/intl.dart';

class TrackMyRequest extends StatefulWidget {
  const TrackMyRequest({super.key});

  @override
  _TrackMyRequestState createState() => _TrackMyRequestState();
}

class _TrackMyRequestState extends State<TrackMyRequest> {
  DateTime? fromDate;
  DateTime? toDate;
  String requestType = 'All';

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
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
              const SnackBar(content: Text('Loading...')),
            );
          } else if (state is GenericLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Results Loaded: ${state.data}')),
            );
          } else if (state is GenericError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocalizationService.translate('track_my_requests')),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocalizationService.translate('from_date')),
                GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: AbsorbPointer(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: fromDate == null
                            ? LocalizationService.translate('from_date')
                            : DateFormat('yyyy-MM-dd').format(fromDate!),
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(LocalizationService.translate('to_date')),
                GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: AbsorbPointer(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: toDate == null
                            ? LocalizationService.translate('to_date')
                            : DateFormat('yyyy-MM-dd').format(toDate!),
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(LocalizationService.translate('request_type')),
                DropdownButton<String>(
                  value: requestType,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      requestType = newValue!;
                    });
                  },
                  items: <String>['All', 'Return From Reservation', 'Vacation']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(LocalizationService.translate(value)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GenericBloc>().add(FetchVacationHistory(
                            fromDate: fromDate,
                            toDate: toDate,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffCE5E52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          LocalizationService.translate('search'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
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
