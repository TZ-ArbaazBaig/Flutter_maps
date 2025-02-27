// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';



// class FullAddress extends StatefulWidget {
//   const FullAddress({ Key? key }) : super(key: key);

//   @override
//   _FullAddressState createState() => _FullAddressState();
// }

// class _FullAddressState extends State<FullAddress> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:Text("Adress")
//       ),
//       body:GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }