import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
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
                    searchBar(),
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

Container searchBar() {
  List<String> resultList = [
    "lightbill",
    "waterbill",
    "internetbill",
    "tvbill"
  ];
  return Container(
    child: Column(
      children: [
        SearchBar(
          onChanged: (value) {
            resultList =
                resultList.where((element) => element.contains(value)).toList();
            print(resultList);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: resultList.length,
            itemBuilder: ((context, index) {
              return Text(resultList[index]);
            }),
          ),
        ),
      ],
    ),
  );
}
