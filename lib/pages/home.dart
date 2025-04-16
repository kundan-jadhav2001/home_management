import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Importants",
                  style: normal25Blue(),
                ),
                const SizedBox(
                  height: 10,
                ),
                types(context: context),
                Text(
                  "Status",
                  style: normal25Blue(),
                ),
                const SizedBox(
                  height: 10,
                ),
                status(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

SizedBox types({required BuildContext context}) {
  return SizedBox(
    height: 400,
    child: GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      children: [
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "bills");
            },
            child: typesButton(text: "Bills", iconData: Icons.money)),
        typesButton(text: "Object's location", iconData: Icons.shelves),
        typesButton(
            text: "Documents", iconData: Icons.document_scanner_outlined),
        typesButton(text: "Addresses", iconData: Icons.room_outlined),
      ],
    ),
  );
}

Container typesButton({required String text, required IconData iconData}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        Icon(
          iconData,
          color: Colors.pink,
          size: 50,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: normal25Blue(),
        ),
      ],
    ),
  );
}

SizedBox status() {
  return SizedBox(
      height: 170,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: [
            statusButton(
              name: "Lights-Hall",
              iconData: Icons.lightbulb_outline_rounded,
              onDevices: 2.toString(),
              offDevices: 0.toString(),
            ),
            statusButton(
              name: "Fans-Kitchen",
              iconData: Icons.ac_unit_outlined,
              onDevices: 0.toString(),
              offDevices: 0.toString(),
            ),
            statusButton(
              name: "TVs",
              iconData: Icons.tv,
              onDevices: 2.toString(),
              offDevices: 0.toString(),
            ),
            statusButton(
              name: "Other Devices",
              iconData: Icons.devices_other_outlined,
              onDevices: 2.toString(),
              offDevices: 0.toString(),
            ),
          ],
        ),
      ));
}

Container statusButton(
    {required String name,
    required IconData iconData,
    required String onDevices,
    required String offDevices}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        Icon(
          iconData,
          color: Colors.pink,
          size: 50,
        ),
        Text(name, textAlign: TextAlign.center, style: normal25Blue()),
        Row(
          spacing: 20,
          children: [
            Row(
              children: [
                Text(
                  "On : ",
                  style: normal15Blue(),
                ),
                Text(
                  onDevices,
                  textAlign: TextAlign.center,
                  style: normal15Blue(),
                ),
              ],
            ),
            Text(
              "|",
              style: normal15Blue(),
            ),
            Row(
              children: [
                Text(
                  "Off : ",
                  style: normal15Blue(),
                ),
                Text(
                  offDevices,
                  style: normal15Blue(),
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}

TextStyle normal15Blue() {
  return TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
    color: Colors.blue,
    decoration: TextDecoration.none,
  );
}

TextStyle normal25Blue() {
  return TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 25,
    color: Colors.blue,
    decoration: TextDecoration.none,
  );
}
