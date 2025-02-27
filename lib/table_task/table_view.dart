import 'package:currency_converter/table_task/table_controller.dart';
import 'package:currency_converter/table_task/table_model.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dessert Table',
      home: DessertTable(),
    );
  }
}


class DessertTable extends StatelessWidget {
  final DessertController controller = DessertController();

  DessertTable({super.key});

  @override
  Widget build(BuildContext context) {
    List<TableModel> desserts = controller.getDesserts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dessert Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const[
            DataColumn(label: Text('GST')),
            DataColumn(label: Text('SGST')),
            DataColumn(label: Text('Dessert')),
            DataColumn(label: Text('Calories')),
            DataColumn(label: Text('Fat (gm)')),
            DataColumn(label: Text('Brand')),
          ],
          rows: desserts.map((dessert) {
            return DataRow(cells: [
              DataCell(Text('${dessert.gst}%')),
              DataCell(Text('${dessert.sgst}%')),
              DataCell(Text(dessert.name)),
              DataCell(Text('${dessert.calories}')),
              DataCell(Text('${dessert.fat}')),
              DataCell(Text(dessert.brand)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
