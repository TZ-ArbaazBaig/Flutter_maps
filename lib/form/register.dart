import 'package:currency_converter/form/data_provider.dart';
import 'package:currency_converter/form/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// https://reqres.in/api/register

void main() => runApp(
  
  ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child:const MyApp()
    
    ),
  );

  // const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Autocomplete',
      // theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const Register(),
            supportedLocales:const [
        Locale('en'),
        Locale('hi'),
      ],
      localizationsDelegates:const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      locale: context.watch<DataProvider>().selectLocale,
    );
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

bool _hidePassword = true;

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);

    TextDirection textDirection = currentLocale.languageCode == 'hi' 
        ? TextDirection.rtl 
        : TextDirection.ltr;
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
       appBar: AppBar(
        title:const Text("Login"),
      //   leading: Builder(
      //   builder: (BuildContext context) {
      //     return IconButton(
      //       icon: const Icon(Icons.menu),
      //       onPressed: () {
      //         Scaffold.of(context).openDrawer();  
      //       },
      //     );
      //   },
      // ),
        actions: [
          DropdownMenu(
            initialSelection: context.watch<DataProvider>().selectLocale,
            onSelected: (value){
            context.read<DataProvider>().changeLanguagee(value as String);
            },
            dropdownMenuEntries:DataProvider.languages.map((language)=>
             DropdownMenuEntry(
              value: language['language'], 
              label: language['name'],
              )).toList() 
            )
        ],
       ),
           body: SingleChildScrollView(
          child: 
          Container(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 217, 76, 66),
                Color.fromARGB(255, 121, 18, 18),
                Color.fromARGB(255, 39, 27, 27),
              ], begin: Alignment.topLeft, end: Alignment.topRight),
              // borderRadius:
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Login here",
                    style: TextStyle(color: Colors.white, fontSize: 36, height: 5),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.email,
                            style: const TextStyle(color: Color.fromARGB(255, 121, 18, 18), fontSize: 23.0,fontWeight: FontWeight.bold)),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              // contentPadding: EdgeInsets.all(10),
                              hintText: AppLocalizations.of(context)!.hintemail,
                              suffixIcon: const Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(AppLocalizations.of(context)!.password,
                            style: const TextStyle(color: Color.fromARGB(255, 121, 18, 18), fontSize: 23.0,fontWeight: FontWeight.bold)),
                        TextField(
                          controller: passwordController,
                          obscureText: _hidePassword,
                          decoration: InputDecoration(
                              hintText:  AppLocalizations.of(context)!.hintemail,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: Icon(_hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                AppLocalizations.of(context)!.forgotpassword,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 25.0,),
                        Container(
                          height: 50,
                          decoration:  BoxDecoration(
                              gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 217, 76, 66),
                            Color.fromARGB(255, 121, 18, 18),
                            Color.fromARGB(255, 39, 27, 27),
                          ],
                          begin: Alignment.topLeft,end:Alignment.topRight,
                          ),
                          borderRadius:BorderRadius.circular(30)
                          ),
          
                          width: MediaQuery.of(context).size.width,
                          child:Center(
                            child:  Text(AppLocalizations.of(context)!.signin ,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            )
                            ),
                          ),
                        ),
                         SizedBox(height: MediaQuery.of(context).size.height/9,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.donthaveaccount,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const SignUp()));
                                },
                                child:Text(
                                  AppLocalizations.of(context)!.donthaveaccount,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons
      children: [
        ElevatedButton(
          onPressed: () {
            // OK Button Action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.okp)),
            );
          },
          child: Text(AppLocalizations.of(context)!.okb),
        ),
        const SizedBox(width: 20), // Add spacing between the buttons
        ElevatedButton(
          onPressed: () {
            // Cancel Button Action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.cancelp)),
            );
          },
          child: Text(AppLocalizations.of(context)!.cancelb),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red color for the Cancel button
          ),
        ),
      ],
    )
                            ],
                          )
                        ],)
                      ],
                    ),
                  ),
                ),
          
                //   ),
          
                //  SizedBox(height: 20,),
                //   ElevatedButton(onPressed: (){}, child: Text("Submit",style: TextStyle(fontSize:20,color: Colors.black),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:currency_converter/form/data_provider.dart';
// import 'package:currency_converter/form/sign_up.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:provider/provider.dart';

// void main() => runApp(
//   ChangeNotifierProvider(
//     create: (context) => DataProvider(),
//     child: const MyApp(),
//   ),
// );

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Map Autocomplete',
//       debugShowCheckedModeBanner: false,
//       home: const Register(),
//       supportedLocales: const [
//         Locale('en'),
//         Locale('hi'),
//         Locale('ar'), // Add Arabic locale here
//       ],
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       locale: context.watch<DataProvider>().selectLocale,
//       // Change the text direction based on the selected locale
//       builder: (context, child) {
//         return Directionality(
//           textDirection: context.watch<DataProvider>().selectLocale.languageCode == 'ar'
//               ? TextDirection.rtl
//               : TextDirection.ltr,
//           child: child!,
//         );
//       },
//     );
//   }
// }

// class Register extends StatefulWidget {
//   const Register({Key? key}) : super(key: key);

//   @override
//   _RegisterState createState() => _RegisterState();
// }

// TextEditingController emailController = TextEditingController();
// TextEditingController passwordController = TextEditingController();

// bool _hidePassword = true;

// class _RegisterState extends State<Register> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         actions: [
//           DropdownMenu(
//             initialSelection: context.watch<DataProvider>().selectLocale,
//             onSelected: (value) {
//               context.read<DataProvider>().changeLanguagee(value as String);
//             },
//             dropdownMenuEntries: DataProvider.languages.map((language) => DropdownMenuEntry(
//               value: language['language'],
//               label: language['name'],
//             )).toList(),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(top: 30),
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 217, 76, 66),
//                 Color.fromARGB(255, 121, 18, 18),
//                 Color.fromARGB(255, 39, 27, 27),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.topRight,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Text(
//                   "Login here",
//                   style: TextStyle(color: Colors.white, fontSize: 36, height: 5),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(AppLocalizations.of(context)!.email,
//                           style: const TextStyle(
//                               color: Color.fromARGB(255, 121, 18, 18),
//                               fontSize: 23.0,
//                               fontWeight: FontWeight.bold)),
//                       TextField(
//                         controller: emailController,
//                         decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)!.hintemail,
//                             suffixIcon: const Icon(Icons.email_outlined)),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(AppLocalizations.of(context)!.password,
//                           style: const TextStyle(
//                               color: Color.fromARGB(255, 121, 18, 18),
//                               fontSize: 23.0,
//                               fontWeight: FontWeight.bold)),
//                       TextField(
//                         controller: passwordController,
//                         obscureText: _hidePassword,
//                         decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)!.hintemail,
//                             suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _hidePassword = !_hidePassword;
//                                   });
//                                 },
//                                 icon: Icon(_hidePassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility))),
//                       ),
//                       const SizedBox(
//                         height: 12.0,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Center(
//                             child: Text(
//                               AppLocalizations.of(context)!.forgotpassword,
//                               style: const TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 25.0,
//                       ),
//                       Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [
//                               Color.fromARGB(255, 217, 76, 66),
//                               Color.fromARGB(255, 121, 18, 18),
//                               Color.fromARGB(255, 39, 27, 27),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.topRight,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         width: MediaQuery.of(context).size.width,
//                         child: Center(
//                           child: Text(AppLocalizations.of(context)!.signin,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                               )),
//                         ),
//                       ),
//                       SizedBox(height: MediaQuery.of(context).size.height / 9),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 AppLocalizations.of(context)!.donthaveaccount,
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w400),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => const SignUp()));
//                                 },
//                                 child: Text(
//                                   AppLocalizations.of(context)!.donthaveaccount,
//                                   style: const TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
