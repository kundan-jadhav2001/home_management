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
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _statusController = TextEditingController();
  final _typeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = 'pending'; // Default value

  @override
  void initState() {
    super.initState();
    if (widget.bill != null) {
      _billId = widget.bill!.id;
      _nameController.text = widget.bill!.name;
      _amountController.text = widget.bill!.amount.toString();
      _typeController.text = widget.bill!.type;
      _selectedStatus = widget.bill!.status;
      _dueDate = widget.bill!.dueDate;
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
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Bill type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bill type';
                  }
                  return null;
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
                          type: _typeController.text));
                      Navigator.pop(context);
                    } else {
                       await DBHelper.updateBill(
                        id: widget.bill!.id,
                        name: _nameController.text,
                        dueDate: _dueDate!,
                        amount: double.parse(_amountController.text),
                        status: _selectedStatus,
                        type: _typeController.text,
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
    _typeController.dispose();
  }
}