import 'package:flutter/material.dart';

// ignore: must_be_immutable
class JobNavigate extends StatefulWidget {
  String id;
  String name;
  String job;
  String create;
  JobNavigate({ Key? key,required this.id,required this.name,required this.job,required this.create}) : super(key: key);

  @override
  _JobNavigateState createState() => _JobNavigateState();
}

class _JobNavigateState extends State<JobNavigate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("id: ${widget.id}"),
            Text("name: ${widget.name}"),
            Text("Jobm: ${widget.job}"),
            Text("Created: ${widget.create}"),
          ],
        ),
      ),
    );
  }
}