import 'package:flutter/material.dart';
import 'package:home_management/models/bill.dart';
import 'package:home_management/services/db_helper.dart';
import 'package:home_management/pages/add_bill_page.dart';
import 'package:intl/intl.dart';

class BillListPage extends StatefulWidget {
   final String billType;
  const BillListPage({Key? key, required this.billType}) : super(key: key);

  @override
  State<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends State<BillListPage> {
   late Future<List<Bill>> _bills;

  @override
  void initState() {
    super.initState();
     _bills = DBHelper.getBillsByType(widget.billType);
  }
    @override
    void didUpdateWidget(BillListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
     _bills = DBHelper.getBillsByType(widget.billType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.billType} Bills')),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(bill.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ${bill.status}',
                              ),
                              Text('Due Date: ${DateFormat('dd/MM/yyyy').format(bill.dueDate)}',),
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
                            status: value == true ? 'paid' : 'pending',
                            type: bill.type,
                          );
                           setState(() {_bills = DBHelper.getBillsByType(widget.billType);});
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddBillPage(bill: bill,)));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                           showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text('Are you sure you want to delete this bill?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await DBHelper.deleteBill(bill.id);
                                      setState(() {_bills = DBHelper.getBillsByType(widget.billType);});
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            });}
                        ),
                      ],
                    ),
                  );

                  });;
          } else{
            return const Center(
              child: Text('No bills found.');
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