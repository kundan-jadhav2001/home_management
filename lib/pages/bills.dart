import 'package:flutter/material.dart';
import 'package:home_management/pages/bill_list_page.dart';
import 'package:home_management/pages/add_bill_page.dart';
import '../services/db_helper.dart';
import 'package:home_management/models/bill.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> { 
   static const List<String> _defaultBillTypes = ['Electricity', 'Water', 'Internet', 'Rent', 'Gas', 'Phone'];
   List<String> _billTypes = _defaultBillTypes;

  @override
  void initState() {
    super.initState();
    _loadBillTypes();
  }
  
  Future<List<String>> _getBillTypes() async {
      List<Bill> allBills = await DBHelper.getBills();
      List<String> types = [];
      if (allBills.isEmpty) {
          types = _defaultBillTypes;
      } else {
          types = allBills.map((bill) => bill.type).toSet().toList();
      }
      return types;
  }

  Future<void> _loadBillTypes() async {
    List<String> types = await _getBillTypes();
    setState(() {
      _billTypes = types.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          width: double.maxFinite,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: _billTypes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                           MaterialPageRoute(
                              builder: (context) => BillListPage(billType: _billTypes[index]),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              _billTypes[index],
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: floatingActionButton(context: context),
    );
  }
  GestureDetector floatingActionButton({required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddBillPage(billTypes: _billTypes)));

    },
    child: Tooltip(
      message: "Add New Bill",
      showDuration: Duration(seconds: 3),
      triggerMode: TooltipTriggerMode.longPress,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 40,
            ),
          ],
        ),
      ),
    ),
  );
  }
}
