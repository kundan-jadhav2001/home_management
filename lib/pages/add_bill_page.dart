import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/db_helper.dart';

import 'package:intl/intl.dart';

class AddBillPage extends StatefulWidget {
  final Bill? bill;
  const AddBillPage({Key? key, this.bill}) : super(key: key);

  @override
  _AddBillPageState createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  int _billId = 0;
  DateTime? _dueDate;
  static const List<String> _billTypes = ['Electricity', 'Water', 'Internet', 'Rent', 'Gas', 'Phone'];
  static const List<String> _reminderOptions = ['None', '1 day', '3 days', '7 days'];
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String _selectedStatus = 'pending'; // Default value
  String? _selectedReminder;
  int _selectedReminderValue = 0;

  @override
  void initState() {
    super.initState();
    if (widget.bill != null) {
      _billId = widget.bill!.id;
      _nameController.text = widget.bill!.name;
      _amountController.text = widget.bill!.amount.toString();
      _selectedType = widget.bill!.type;
      _selectedStatus = widget.bill!.status;
      _dueDate = widget.bill!.dueDate;
      _selectedReminder = _reminderOptions.firstWhere(
        (option) => _getReminderValue(option) == widget.bill!.reminder,
        orElse: () => 'None',
      );
      _selectedReminderValue = widget.bill!.reminder;

    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bill == null ? 'Add Bill' : 'Update Bill'),
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
              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _dueDate) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  child: Text(
                    _dueDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_dueDate!),
                  ),),
              ),
               DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Bill type'),
                items: _billTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                 onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a bill type' : null,

              ),
              DropdownButtonFormField<String>(
                value: _selectedReminder,
                decoration: const InputDecoration(labelText: 'Reminder'),
                items: _reminderOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedReminder = newValue;
                    _selectedReminderValue = _getReminderValue(_selectedReminder!);
                  });
                },
              ),
              TextFormField(
                  controller : _amountController,
                  decoration : const InputDecoration(labelText: 'Amount'),
                  keyboardType : TextInputType.number,
                  validator : (value) {
                    if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: <String>['pending', 'paid', 'canceled']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.bill == null) {
                      await DBHelper.insertBill(Bill(
                          id: 0,
                          name: _nameController.text,
                          dueDate: _dueDate!,
                          amount: double.parse(_amountController.text),
                          status: _selectedStatus,
                          type: _selectedType!,
                          reminder: _selectedReminderValue));
                      Navigator.pop(context);
                    } else {
                       await DBHelper.updateBill(
                        id: widget.bill!.id,
                        name: _nameController.text,
                        dueDate: _dueDate!,
                        amount: double.parse(_amountController.text),
                        status: _selectedStatus,
                        reminder: _selectedReminderValue,
                        type: _selectedType!,
                      );
                      Navigator.pop(context);

                    }
                    
                  }
                },
                child: Text(widget.bill == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _disposeControllers() {
    _nameController.dispose();
    _amountController.dispose();
    _statusController.dispose();
  }

  int _getReminderValue(String option) {
    switch (option) {
      case '1 day': return 1;
      case '3 days': return 3;
      case '7 days': return 7;
      default: return 0;
    }
  }

}