
// import 'package:currency_converter/g-maps/geo_fencing.dart';
import 'package:currency_converter/demo_api/image_picker/upload_image.dart';
import 'package:currency_converter/firebase_options.dart';
import 'package:currency_converter/sideBar.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
// import 'login_screen.dart';

void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:SidebarWithRoutesApp(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => 
      //   // SidebarWithRoutesApp() ,
      //   '/nextPage': (context) => const TodoListPage(),
      //   const T_Mainn(),
      // },
    );
  }
}
