import 'package:flutter/material.dart';
import 'package:home_management/models/bill.dart';
import 'package:home_management/services/db_helper.dart';
import 'package:home_management/pages/add_bill_page.dart';
import 'package:intl/intl.dart';

class BillListPage extends StatefulWidget {
  const BillListPage({super.key});

  @override
  State<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends State<BillListPage> {
  late Future<List<Bill>> _bills;

  @override
  void initState() {
    super.initState();
    _bills = DBHelper.getBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
      ),
      body: FutureBuilder<List<Bill>>(
        future: _bills,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final bills = snapshot.data!;
            return ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                return Card(
                  child: ListTile(
                    title: Text(bill.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date: ${DateFormat('dd/MM/yyyy').format(bill.dueDate)}',
                        ),
                        Text(
                          'Amount: \$${bill.amount.toStringAsFixed(2)}',
                        ),
                        Text('Status: ${bill.status}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No bills found.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBillPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}