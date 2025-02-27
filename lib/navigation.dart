// import 'package:currency_converter/g-maps/geo_fencing.dart';
// import 'package:currency_converter/g-maps/live_track.dart';
// import 'package:flutter/material.dart';



// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Side Navigation',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LiveTrack(),
//         // '/': (context) => LiveTrack(),
//         '/projects': (context) => GoogleMapScreen(),
//       },
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(title: Text('Home Screen')),
//       drawer: AppDrawer(), // Drawer added here
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate to About Screen
//             Navigator.pushNamed(context, '/about');
//           },
//           child: Text('Go to About Screen'),
//         ),
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text('John Doe'),
//             accountEmail: Text('johndoe@example.com'),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 50),
//             ),
//           ),
//           ListTile(
//             title: Text('Home'),
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//           ListTile(
//             title: Text('About'),
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/about');
//             },
//           ),
//           ListTile(
//             title: Text('Projects'),
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/projects');
//             },
//           ),
//           Divider(),
//           ListTile(
//             title: Text('Logout'),
//             onTap: () {
//               // Handle logout functionality
//               Navigator.pop(context); // Close the drawer
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
