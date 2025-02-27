import 'package:currency_converter/demo_api/api_service.dart';
import 'package:currency_converter/demo_api/job_model.dart';
import 'package:currency_converter/demo_api/job_navigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(
   const MaterialApp(home: JobHome(),)
  );
}

class JobHome extends StatefulWidget {
  const JobHome({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JobHomeState createState() => _JobHomeState();
}

class _JobHomeState extends State<JobHome> {
 
  TextEditingController job=TextEditingController();
  TextEditingController name=TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("job"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller:name,
              decoration:const InputDecoration(
                hintText: "Enter your name"
              ),
            ),
            TextField(
              controller:job,
              decoration:const InputDecoration(
                hintText: "Enter your job"
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: 
            (){
              submit(name.text,job.text);
            }, child:const Text("Submit"))
          ],
        ),
      ),
    );
  }
  JobM model=JobM();
  void submit(String name,String job) async{
    var submit= await ApiService(client: http.Client()).createJob(name, job);
    setState(() {
      model=submit!;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>JobNavigate(
       id:model.id.toString(),
       job: model.job.toString(),
       name:model.name.toString(),
       create:model.createdAt.toString()
      )));
    });

  }
}