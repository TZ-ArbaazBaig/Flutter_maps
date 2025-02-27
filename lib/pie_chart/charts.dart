import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


void main()
{
  runApp(const MaterialApp(
    home: Chartsection(),
  ));
}

class Chartsection extends StatelessWidget {
const Chartsection({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Charts(),
    );
  }
}

class Charts extends StatefulWidget {
  const Charts({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    return Center(
      child: PieChart(
        PieChartData(
          sections: pieChartSection(),
          // centerSpaceColor:Colors.red
          sectionsSpace: 0.0,
          centerSpaceRadius: 0
        ),
        ),
    );

  }
    List<PieChartSectionData> pieChartSection(){
      List<Color> colors =[
        Colors.red,
        Colors.green,
        Colors.grey,
        Colors.blue,
      ];
      List<String> title=[
        "a",
        "b","c","d"
      ];
      return List.generate(4,(i){
      double value=(i+1)*10;
      return PieChartSectionData(
        value: value,
        title:title[i],
        color: colors[i],
        radius:120,
        badgeWidget:Icon(Icons.add_chart_outlined)
        // title: '$value'
      );
      } 
      );


    }
}