import 'package:flutter/material.dart';

void main() {
  runApp(const Accordian());
}

class Accordian extends StatelessWidget {
  const Accordian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title:const Text("Accordion Example")),
        body: ListView(
          children: const [
            ExpansionTile(
              title: Text("Section 1"),
              children: [
                ListTile(title: Text("ItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItemItem 1")),
                ListTile(title: Text("Item 2")),
              ],
            ),
            ExpansionTile(
              title: Text("Section 2"),
              children: [
                ListTile(title: Text("Item 3")),
                ListTile(title: Text("Item 4")),
              ],
            ),
            ExpansionTile(
              title: Text("Section 3"),
              children: [
                ListTile(title: Text("Item 5")),
                ListTile(title: Text("Item 6")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
