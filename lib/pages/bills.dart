import 'package:flutter/material.dart';
import 'package:home_management/pages/add_bill_page.dart';
import '../services/db_helper.dart';
import 'package:home_management/models/bill.dart';
import 'package:intl/intl.dart';

import 'add_bill_type.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  List<String> _billTypes = [];
  String? _selectedType;
  String? _selectedStatus;
  DateTime? _selectedDate;
  double? _selectedAmountMin;
  double? _selectedAmountMax;

  @override
  void initState() {
    super.initState();
    _loadBillTypes();
  }

  Future<List<Bill>> _getBills() async {
    List<Bill> bills = await DBHelper.getBills();
    return bills.where((bill) {
      if (_selectedStatus != null && bill.status != _selectedStatus) {
        return false;
      }
      if (_selectedType != null && bill.type != _selectedType) {
        return false;
      }
      if (_selectedDate != null &&
          bill.dueDate.day != _selectedDate!.day &&
          bill.dueDate.month != _selectedDate!.month &&
          bill.dueDate.year != _selectedDate!.year) {
        return false;
      }
      if (_selectedAmountMin != null && bill.amount < _selectedAmountMin!) {
        return false;
      }
      if (_selectedAmountMax != null && bill.amount > _selectedAmountMax!) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> _loadBillTypes() async {
    _billTypes = await DBHelper.getBillTypes();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBillTypePage()))
                  },
              icon: Icon(Icons.add_circle))
        ],
      ),
      body: SafeArea(
          child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              height: size.height,
              child: SingleChildScrollView(
                  child: Column(children: [
                const SizedBox(height: 20),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        hint: const Text('Type'),
                        value: _selectedType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedType = newValue;
                          });
                        },
                        items: <String>['All', ..._billTypes]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value == 'All' ? null : value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        hint: const Text('Status'),
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
                          if (pickedDate != null &&
                              pickedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        child: SizedBox(
                          width: 100,
                          child: InputDecorator(
                            decoration:
                                const InputDecoration(labelText: 'Due Date'),
                            child: Text(
                              _selectedDate == null
                                  ? 'Select Date'
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Min',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedAmountMin =
                                  value.isNotEmpty ? double.parse(value) : null;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Max'),
                          onChanged: (value) {
                            _selectedAmountMax =
                                value.isNotEmpty ? double.parse(value) : null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Bill>>(
                    future: _getBills(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No bills found.'));
                      } else {
                        List<Bill> bills = snapshot.data!;
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: bills.length,
                            itemBuilder: (context, index) {
                              final bill = bills[index];
                              return Card(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(bill.name),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Status: ${bill.status}',
                                            ),
                                            Text(
                                              'Due Date: ${DateFormat('dd/MM/yyyy').format(bill.dueDate)}',
                                            ),
                                            Text(
                                              'Amount: \$${bill.amount.toStringAsFixed(2)}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      value: bill.status == 'paid',
                                      onChanged: (bool? value) async {
                                        await DBHelper.updateBill(
                                          id: bill.id,
                                          name: bill.name,
                                          dueDate: bill.dueDate,
                                          amount: bill.amount,
                                          status: value == true
                                              ? 'paid'
                                              : 'pending',
                                          type: bill.type,
                                          reminder: bill.reminder,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddBillPage(
                                                        billTypes: _billTypes,
                                                        bill: bill)));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await DBHelper.deleteBill(bill.id);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }),
              ])))),
    );
  }
}
