import 'package:flutter/material.dart';
import 'package:home_management/pages/add_bill_page.dart';
import 'package:home_management/widgets/filter_dialog.dart';
import 'package:home_management/pages/edit_bill_page.dart';
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

  Map<String, dynamic> _filters = {
    'type': null,
    'status': null,
    'date': null,
    'amountMin': null,
    'amountMax': null,
  };

  @override
  void initState() {
    super.initState();
    _loadBillTypes();
  }

  Future<List<Bill>> _getBills() async {
    List<Bill> bills = await DBHelper.getBills();
    return bills.where((bill) {
      if (_filters['status'] != null && bill.status != _filters['status']) {
        return false;
      }
      if (_filters['type'] != null && bill.type != _filters['type']) {
        return false;
      }
      if (_filters['date'] != null &&
          bill.dueDate.day != (_filters['date'] as DateTime).day &&
          bill.dueDate.month != (_filters['date'] as DateTime).month &&
          bill.dueDate.year != (_filters['date'] as DateTime).year) {
        return false;
      }
      if (_filters['amountMin'] != null &&
          bill.amount < (_filters['amountMin'] as double)) {
        return false;
      }
      if (_filters['amountMax'] != null && bill.amount > (_filters['amountMax'] as double)) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> _loadBillTypes() async {
    _billTypes = await DBHelper.getBillTypes();
  }

  String _getFilterButtonText() {
    List<String> activeFilters = [];

    if (_filters['type'] != null) {
      activeFilters.add('Type: ${_filters['type']}');
    }
    if (_filters['status'] != null) {
      activeFilters.add('Status: ${_filters['status']}');
    }
    if (_filters['date'] != null) {
      activeFilters.add('Date: ${DateFormat('yyyy-MM-dd').format(_filters['date'])}');
    }
    if (_filters['amountMin'] != null) {
      activeFilters.add('Min: ${_filters['amountMin']}');
    }
    if (_filters['amountMax'] != null) {
      activeFilters.add('Max: ${_filters['amountMax']}');
    }

    if (activeFilters.isEmpty) {
      return 'Filter';
    } else {
      return activeFilters.join(', ');
    }
  }

  void _showFilterDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          billTypes: _billTypes, 
          filters: _filters,
          onFiltersChanged: (newFilters) => setState(() {
             _filters = newFilters;}),
        );
      },
    );

    if (result != null) {
      setState(() { _filters = result;});
    }
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  child: Text(_getFilterButtonText()),
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
                                          type: bill.type, reminder: bill.reminder
                                        );
                                        setState(() {

                                        });


                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => EditBillPage(
                                              billTypes: _billTypes,
                                              bill: bill
                                            )));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBillPage(billTypes: _billTypes)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

