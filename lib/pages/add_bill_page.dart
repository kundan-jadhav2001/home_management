import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/db_helper.dart';
import 'package:home_management/models/bill.dart';

class AddBillPage extends StatefulWidget {
  final List<String> billTypes;
  const AddBillPage({Key? key, required this.billTypes}) : super(key: key);

  @override
  _AddBillPageState createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBillType;

  DateTime _selectedDate = DateTime.now();
  String? _selectedReminder;

  final List<String> _reminderOptions = [
    'None',
    '1 day before',
    '2 days before',
    '1 week before',
  ];

  @override
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveBill() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All the fields are required')));
      return;
    }
    if (_selectedBillType == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select a Bill type')));
      return;
    }

    await DBHelper.insertBill(
      name: _nameController.text,
      dueDate: _selectedDate,
      amount: double.parse(_amountController.text),
      status: 'pending',
      type: _selectedBillType!,
      reminder: _selectedReminder,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bill'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Bill Name'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBillType,
                decoration: const InputDecoration(labelText: 'Bill Type'),
                items: widget.billTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a bill type' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBillType = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedReminder,
                decoration: const InputDecoration(labelText: 'Reminder'),
                items: _reminderOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedReminder = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveBill,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
