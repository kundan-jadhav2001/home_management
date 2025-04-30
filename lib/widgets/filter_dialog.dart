import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, dynamic> filters;
  final List<String> billTypes;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterDialog({
    Key? key,
    required this.filters,
    required this.billTypes,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedType;
  String? _selectedStatus;
  DateTime? _selectedDate;
  double? _selectedAmountMin;
  double? _selectedAmountMax;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.filters['type'];
    _selectedStatus = widget.filters['status'];
    _selectedDate = widget.filters['date'];
    _selectedAmountMin = widget.filters['amountMin'];
    _selectedAmountMax = widget.filters['amountMax'];
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
      _selectedDate = null;
      _selectedAmountMin = null;
      _selectedAmountMax = null;
    });
     widget.onFiltersChanged({
      'type': null,
      'status': null,
      'date': null,
      'amountMin': null,
      'amountMax': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filters'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Type'),
              value: _selectedType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              items: <String>['All', ...widget.billTypes]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value == 'All' ? null : value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
              items: <String>['All', 'pending', 'paid', 'canceled']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value == 'All' ? null : value,
                  child: Text(value),
                );
              }).toList(),
            ),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Due Date'),
                child: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Min Amount'),
              onChanged: (value) {
                setState(() {
                  _selectedAmountMin =
                      value.isNotEmpty ? double.parse(value) : null;
                });
              },
              controller: _selectedAmountMin != null ? TextEditingController(text: _selectedAmountMin.toString()) : null,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Max Amount'),
              onChanged: (value) {
                setState(() {
                  _selectedAmountMax =
                      value.isNotEmpty ? double.parse(value) : null;
                });
              },
                 controller: _selectedAmountMax != null ? TextEditingController(text: _selectedAmountMax.toString()) : null,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Clear'),
          onPressed: () {
           _clearFilters();
          },
        ),
        TextButton(
          child: const Text('Apply'),
          onPressed: () {
            widget.onFiltersChanged({
              'type': _selectedType,
              'status': _selectedStatus,
              'date': _selectedDate,
              'amountMin': _selectedAmountMin,
              'amountMax': _selectedAmountMax,
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}