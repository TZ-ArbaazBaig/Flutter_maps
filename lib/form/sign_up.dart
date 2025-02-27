// import 'package:currency_converter/form/register.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // import 'package:provider/provider.dart';



// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmController = TextEditingController();

//   bool _hidePassword = true;
//   // bool _chidePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.only(
//           top: 30,
//         ),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(colors: [
//             Color.fromARGB(255, 217, 76, 66),
//             Color.fromARGB(255, 121, 18, 18),
//             Color.fromARGB(255, 39, 27, 27),
//           ], begin: Alignment.topLeft, end: Alignment.topRight),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text(
//                 AppLocalizations.of(context)!.signup,
//                 style: const TextStyle(color: Colors.white, fontSize: 36, height: 4),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding:
//                     const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),

//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                          AppLocalizations.of(context)!.name ,
//                           style: const TextStyle(
//                               color: Color.fromARGB(255, 121, 18, 18),
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         TextFormField(
//                           // controlleremailController: ,
//                           decoration: InputDecoration(
//                             label: Text(
//                               AppLocalizations.of(context)!.entname,
//                               style: const TextStyle(
//                                   // color: Color.fromARGB(255, 121, 18, 18),
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please Enter the Name";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           AppLocalizations.of(context)!.email,
//                           style: const TextStyle(
//                               color: Color.fromARGB(255, 121, 18, 18),
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         TextFormField(
//                           // controlleremailController: ,
//                           decoration: InputDecoration(
//                               label: Text(
//                             AppLocalizations.of(context)!.hintemail,
//                             style: const TextStyle(
//                                 // color: Color.fromARGB(255, 121, 18, 18),
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold),
//                           )),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return AppLocalizations.of(context)!.hintemail;
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           AppLocalizations.of(context)!.password,
//                           style: TextStyle(
//                               color: Color.fromARGB(255, 121, 18, 18),
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                               label: Text(
//                             AppLocalizations.of(context)!.hintpassword,
//                             style:const TextStyle(
//                                 // color: Color.fromARGB(255, 121, 18, 18),
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold),
//                           )),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return AppLocalizations.of(context)!.plzenteremail;
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(
//                           height: 7,
//                         ),
//                          Text(
//                           AppLocalizations.of(context)!.cpassword,
//                           style:const TextStyle(
//                               color: Color.fromARGB(255, 121, 18, 18),
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         TextFormField(
//                           controller: confirmController,
//                           obscureText: _hidePassword,
//                           decoration: InputDecoration(
//                             suffix: IconButton(
//                               onPressed: () {
//                                 setState(() {
                                  
//                                   _hidePassword=!_hidePassword;
                                  
//                                 });
//                               },
//                               // padding: EdgeInsets.zero,
//                               icon: Icon(
//                                 _hidePassword? Icons.visibility_off:Icons.visibility, size: 20),
//                               iconSize: 10,
//                             ),
//                             label: Text( AppLocalizations.of(context)!.cpassword,style:const TextStyle(
//                                 // color: Color.fromARGB(255, 121, 18, 18),
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold),),
//                             labelStyle:const TextStyle(
//                                 fontSize: 16,
//                                 color: Color.fromARGB(255, 47, 44, 44)),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please confirm your password';
//                             }
//                             if (value != passwordController.text) {
//                               return "Password Didn Match";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(
//                           height: 25.0,
//                         ),
//                                ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   const Color.fromARGB(255, 121, 18, 18),
//                               foregroundColor: Colors.white,
//                               fixedSize: const Size(320, 50)),
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text('Passwords match!')),
//                               );
//                             }
//                           },
//                           child: Text(
//                             AppLocalizations.of(context)!.signup,
//                             style: TextStyle(fontSize: 23),
//                           ),
//                         ),

//                         SizedBox(
//                           height: MediaQuery.of(context).size.height / 100,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                   AppLocalizations.of(context)!.alreadyhaveanaccount,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const Register()));
//                                   },
//                                   child:Text(
//                                     AppLocalizations.of(context)!.signin,
//                                     style: const TextStyle(
//                                         color: Colors.blue,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
                 
//                 ),
//               ),
//             ),


        
//           ],
//         ),
//       ),
//     ));
//   }
// }
import 'package:currency_converter/form/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  bool _hidePassword = true;

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
      title: const Text('Sign Up'),  
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();  
            },
          );
        },
      ),
      
    ),
        drawer: Drawer(
          
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Divider(),
            const ListTile(
              title: Text('English'),
              
            ),
            const ListTile(
              title: Text('Arabic'),
              
            ),
          ],
        ),
      ),
      
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 217, 76, 66),
                  Color.fromARGB(255, 121, 18, 18),
                  Color.fromARGB(255, 39, 27, 27),
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.signup,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      height: 4,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              AppLocalizations.of(context)!.name,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 121, 18, 18),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text(
                                  AppLocalizations.of(context)!.entname,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter the Name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            Text(
                              AppLocalizations.of(context)!.email,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 121, 18, 18),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text(
                                  AppLocalizations.of(context)!.hintemail,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.hintemail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            // Text(
                            //   AppLocalizations.of(context)!.password,
                            //   style:const TextStyle(
                            //     color: Color.fromARGB(255, 121, 18, 18),
                            //     fontSize: 22,
                            //     fontWeight: FontWeight.bold),
                            // ),
                            // TextFormField(
                            //   controller: passwordController,
                            //   obscureText: true,
                            //   decoration: InputDecoration(
                            //     label: Text(
                            //       AppLocalizations.of(context)!.hintpassword,
                            //       style: const TextStyle(
                            //         fontSize: 18.0,
                            //         fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return AppLocalizations.of(context)!.plzenteremail;
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // const SizedBox(height: 7),
                            Text(
                              AppLocalizations.of(context)!.cpassword,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 121, 18, 18),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: confirmController,
                              obscureText: _hidePassword,
                              decoration: InputDecoration(
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20,
                                  ),
                                ),
                                label: Text(
                                  AppLocalizations.of(context)!.cpassword,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordController.text) {
                                  return "Password Didn't Match";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 121, 18, 18),
                                  foregroundColor: Colors.white,
                                  fixedSize: const Size(320, 50)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Passwords match!'),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.signup,
                                style:const TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 100),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.alreadyhaveanaccount,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Register(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.signin,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
