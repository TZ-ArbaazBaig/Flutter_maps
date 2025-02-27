import 'dart:convert';
import 'dart:typed_data';
import 'package:currency_converter/demo_api/display_model.dart';
import 'package:currency_converter/demo_api/job_model.dart';
import 'package:currency_converter/demo_api/login_model.dart';
import 'package:currency_converter/demo_api/multi_data_model.dart';
import 'package:currency_converter/demo_api/post_model.dart';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class ApiService{
   final http.Client client;

   ApiService({required this.client});

  Future<DisplayModel?> displayModel () async {
    
        var url=Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
        var responce=await client.get(url);
        if(responce.statusCode == 200)
        {
          DisplayModel model=DisplayModel.fromJson(json.decode(responce.body));
          return model;
        }
        else{
        throw Exception('Failed to load data: ${responce.statusCode}');

        }

      
    
    // return null;

  }
  Future<List<Postmodel>?> getPosts()
  async{
    var url=Uri.parse("https://jsonplaceholder.typicode.com/posts/");
    var responce=await client.get(url);
    if(responce.statusCode==200)
    {
      List<Postmodel> model=List<Postmodel>.from(jsonDecode(responce.body).map((e)=>Postmodel.fromJson(e)));
      return model;
    }
    else{
      throw Exception("error");
    }
    // return null;

  }

  Future <MultiData?> getMulti()async{
      var url=Uri.parse("https://reqres.in/api/unknown");
      var response=await client.get(url);
      if(response.statusCode == 200)
      {
        MultiData model=MultiData.fromJson(jsonDecode(response.body));
        return model;
      }
      else{
        throw Exception("error");
      }
  }

  Future<LoginM?> getTokec(String email,String password)async{

    var url=Uri.parse("https://reqres.in/api/login");
    var response=await client.post(url,body:{
      "email":email,
      "password":password
    } );
    if(response.statusCode == 200)
    {
       LoginM model=LoginM.fromJson(jsonDecode(response.body));
       return model;
    }
    else{
      throw Exception("error");
    }

  }
  

  Future<JobM?> createJob(String name,String job)async{
    var url=Uri.parse("https://reqres.in/api/users");
    var response=await client.post(url,body:{
      
    "name": name,
    "job": job

    });
    if(response.statusCode==201 || response.statusCode==200)
    {
        JobM model=JobM.fromJson(jsonDecode(response.body));
        return model;
    }
    else{
      throw Exception("error");
    }

  }

  Future<dynamic> uploadImg(Uint8List bytes,String filename)async{
    var url =Uri.parse("https://api.escuelajs.co/api/v1/files/upload");
    // var response = await client.post(url,body:{

    // });
    var request = http.MultipartRequest('Post',url);
    var multi=http.MultipartFile('file', http.ByteStream.fromBytes(bytes), bytes.length,filename: filename);
    request.files.add(multi);
    var response=await request.send();

    if(response.statusCode==201)
    {
      var data =await response.stream.bytesToString();
      return json.decode(data);
    }
    else{
      throw Exception("error");
    }
  }

}
  