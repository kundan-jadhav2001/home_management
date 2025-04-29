import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/db_helper.dart';
import 'package:home_management/models/bill.dart';

class AddBillPage extends StatefulWidget {
  final List<String> billTypes;
  final Bill? bill;
  const AddBillPage({Key? key, required this.billTypes, this.bill})
      : super(key: key);

  @override
  _AddBillPageState createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _reminderController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedReminder;

  final List<String> _reminderOptions = [
    'None',
    '1 day before',
    '2 days before',
    '1 week before',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.bill != null) {
      _loadBillData();
    }
  }

  void _loadBillData() {
    _nameController.text = widget.bill!.name;
    _amountController.text = widget.bill!.amount.toString();
    _selectedDate = widget.bill!.dueDate;
    _selectedReminder = widget.bill!.reminder;
  }

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
    if (widget.bill == null) {
      //add new bill type
      if (widget.billTypes.contains(_nameController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('There is already a type with that name.')),
        );
        return;
      } else {
        await DBHelper.insertBillType(_nameController.text);
      }

      Navigator.pop(context);
    } else {
      if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('All the fields are required')));
        return;
      }

      if (widget.bill!.id == null) {
        await DBHelper.insertBill(
          name: _nameController.text,
          dueDate: _selectedDate,
          amount: double.parse(_amountController.text),
          status: 'pending',
          type: widget.bill!.type,
          reminder: _selectedReminder,
        );
      } else {
        await DBHelper.updateBill(
          id: widget.bill!.id,
          name: _nameController.text,
          dueDate: _selectedDate,
          amount: double.parse(_amountController.text),
          status: widget.bill!.status,
          type: widget.bill!.type,
          reminder: _selectedReminder,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bill == null ? 'Add New Bill Type' : 'Add/Edit Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.bill == null) ...[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Bill Type Name'),
              ),
            ] else ...[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Bill Name'),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: widget.bill!.type,
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
                    widget.bill!.type = newValue!;
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
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveBill,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _reminderController.dispose();
    super.dispose();
  }
}