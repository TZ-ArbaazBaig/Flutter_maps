import 'package:currency_converter/demo_api/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

 void main()
 {
  runApp(const MaterialApp(
    home: UploadImage(),
  ));
 }
class UploadImage extends StatefulWidget {
  const UploadImage({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String? image;
  Future<void> imagePicker() async {
    final pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        Uint8List bytes=await pickFile.readAsBytes();
        var data =await ApiService(client: http.Client()).uploadImg(bytes,pickFile.name);
        if (kDebugMode) {
          print(data);
        }
        
    setState(()  {
        image = data['location'];
    });
      } else {
        if (kDebugMode) {
          print("no image picker");
        }
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

           image==""?const SizedBox():
             Container(
              height: 200,width:200,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(image.toString()))
              ),
              // child: ,
             ),

            Text(image.toString()),
            const Text("Upload image"),
            ElevatedButton(onPressed: (){
              imagePicker();
            }, child: const Text("Upload")),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut();
            },child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}