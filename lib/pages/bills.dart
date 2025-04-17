import 'package:flutter/material.dart';
import 'package:home_management/pages/bill_list_page.dart';

class Bills extends StatefulWidget {
  // Constructor for the Bills widget

  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {

  void _filterBills(String query) {
  setState(() {
    _filteredBills = _allBills
        .where((bill) => bill.toLowerCase().contains(query.toLowerCase()))
        .toList();
  });
}
  // List to store all bill names
  final List<String> _allBills = [
    "lightbill",
    "waterbill",
    "internetbill",
    "tvbill",
    "Gas Bill",
    "Electricity Bill",
    "Phone Bill",
    "Cable Bill",
  ];

  // List to store the filtered bill names based on search input
  List<String> _filteredBills = [];

  // Controller for the search bar text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBills = _allBills;
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
                    const SizedBox(
                      height: 10,
                    ),
                    _searchBar(
                      searchController: _searchController,
                      filterBills: _filterBills,
                      filteredBills: _filteredBills,
                      allBills: _allBills,
                    ),
                  ],
                )))),
        floatingActionButton: floatingActionButton(context: context));
  }
}

GestureDetector floatingActionButton({required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, "home");
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

// search bar for filtering bills
Widget _searchBar({
  required TextEditingController searchController,
  required Function(String) filterBills,
  required List<String> filteredBills,
  required List<String> allBills,
}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search bills',
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: filterBills,
          ),
          const SizedBox(
            height: 10,
          ),
          //list of bills to display on the screen.
          SizedBox(
            height: 500,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: filteredBills.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BillListPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        filteredBills[index],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );


              },
                ),
          ),
        ],
      ));
}


