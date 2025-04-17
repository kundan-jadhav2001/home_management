import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/db_helper.dart';
import 'package:intl/intl.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({Key? key}) : super(key: key);

  @override
  _AddBillPageState createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final _nameController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bill'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: 'Due Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a due date';
                  }
                  try {
                    DateFormat('yyyy-MM-dd').parse(value);
                  } catch (e) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await DBHelper.insertBill(Bill(id:0,
                        name: _nameController.text,
                        dueDate: DateTime.parse(_dueDateController.text),
                        amount: double.parse(_amountController.text),
                        status: _statusController.text));


                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _disposeControllers() {
    _nameController.dispose();
    _dueDateController.dispose();
    _amountController.dispose();
    _statusController.dispose();
  }
}