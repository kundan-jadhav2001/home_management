import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'package:home_management/models/bill.dart';

class AddBillTypePage extends StatefulWidget {
  const AddBillTypePage({Key? key}) : super(key: key);

  @override
  _AddBillTypePageState createState() => _AddBillTypePageState();
}

class _AddBillTypePageState extends State<AddBillTypePage> {
  List<String> _billTypes = [];
  final _newTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBillTypes();
  }

  Future<void> _loadBillTypes() async {
    List<String> types = await DBHelper.getBillTypes();
    setState(() {
      _billTypes = types;
    });
  }

  Future<void> _addBillType() async {
    if (_newTypeController.text.isNotEmpty) {
      await DBHelper.insertBillType(_newTypeController.text);
      _newTypeController.clear();
      _loadBillTypes();
    }
  }

  Future<void> _editBillType(String oldType) async {
    _newTypeController.text = oldType;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Bill Type'),
            content: TextField(
              controller: _newTypeController,
              decoration: const InputDecoration(labelText: 'New Type Name'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _newTypeController.clear();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (_newTypeController.text.isNotEmpty) {
                    await _deleteBillType(oldType);
                   await DBHelper.insertBillType(_newTypeController.text);
                   _newTypeController.clear();
                   _loadBillTypes();
                    
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> _deleteBillType(String type) async {
    // Delete the bill type
    //first we should check if there are bills with that type. If so we should show an error.
    List<Bill> bills = await DBHelper.getBillsByType(type);
    if (bills.isEmpty) {
      // if no bills are found we can delete the type.
      await DBHelper.deleteBillType(type);
    } else {
      //if there are bills we should show an error
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
          content: Text(
            'Cannot delete type. There are bills of that type.')),
       );
       return;
    }
   
    setState(() {
      _billTypes.remove(type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bill Types'),
      ),
      body: ListView.builder(
        itemCount: _billTypes.length,
        itemBuilder: (context, index) {
          final type = _billTypes[index];
          return ListTile(
            title: Text(type),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editBillType(type),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteBillType(type),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add New Bill Type'),
                content: TextField(
                  controller: _newTypeController,
                  decoration: const InputDecoration(labelText: 'Type Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _newTypeController.clear();
                    },
                  ),
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      _addBillType();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _newTypeController.dispose();
    super.dispose();
  }
}