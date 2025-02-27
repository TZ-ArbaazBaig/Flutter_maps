// import 'package:currency_converter/demolive.dart';
// import 'package:currency_converter/g-maps/geo_fencing.dart';
// import 'package:currency_converter/g-maps/live_track.dart';
// import 'package:flutter/material.dart';



// class SidebarWithRoutesApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) =>const LiveTrack(),
//         '/Geofencing': (context) =>const GoogleMapScreen(),
//         '/Rotation': (context) => MapScreen(),
//         // '/help': (context) => HelpPage(),
//       },
//     );
//   }
// }

// class Sidebar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, size: 40, color: Colors.blue),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Welcome, User!',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 Text(
//                   'user@example.com',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.map_outlined),
//             title:const  Text('LiveTracking'),
//             onTap: () {
//               Navigator.pushNamed(context, '/');
//             },
//           ),
//           ListTile(
//             leading:const Icon(Icons.map),
//             title:const Text('Geofencing'),
//             onTap: () {
//               Navigator.pushNamed(context, '/Geofencing');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.rounded_corner_outlined),
//             title:const Text('Rotation'),
//             onTap: () {
//               Navigator.pushNamed(context, '/Rotation');
//             },
//           ),
//         //   ListTile(
//         //     leading:const Icon(Icons.help),
//         //     title:const Text('Help'),
//         //     onTap: () {
//         //       Navigator.pushNamed(context, '/help');
//         //     },
//         //   ),
//         //  const Divider(),
//         //   ListTile(
//         //     leading:const Icon(Icons.logout),
//         //     title: Text('Logout'),
//         //     onTap: () {
//         //       Navigator.pop(context);
//         //     },
//         //   ),
//         ],
//       ),
//     );
//   }
// }
