import 'package:currency_converter/api/api_servies.dart';
import 'package:currency_converter/models/placesFrom_Gmap.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class FetchAddress extends StatefulWidget {
  const FetchAddress({ Key? key }) : super(key: key);

  @override
  _FetchAddressState createState() => _FetchAddressState();
}

class _FetchAddressState extends State<FetchAddress> {
  // final LatLng _mylocation = const LatLng(13.063894, 80.269287);
  double defaultlat = 13.063894;
  double defaultlong = 80.269287;
  final LatLng _initialPosition = const LatLng(12.9396667, 80.1572500); // Starting point
  final LatLng _mylocation = const LatLng(13.063894, 80.269287); 




  placesFrom_Gmap place=placesFrom_Gmap();
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Cuurert address")),
      body:Stack(
        children:[ GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: _mylocation,zoom: 15),
          onCameraIdle: (){
            print("idle");
            ApiServies().placesFromGmap(defaultlat, defaultlong).then((value){
                setState(() {
                  place=value;
                });
            });
          },
          onCameraMove: (CameraPosition position){
             print('Lat${position.target.latitude} and long ${position.target.longitude}');
              setState()
              {
                defaultlat=position.target.latitude;
                defaultlong=position.target.longitude;
                
              }
              },
          ),
          const Center(child: Icon(Icons.location_on, size: 50, color:Colors.red),)
     ] ),
     bottomSheet: Container(
      color:Colors.blue,
      padding:const EdgeInsets.only(top:20,bottom:30,left:20,right:20),
      child:const Row(children: [
        Icon(Icons.location_on),
        Expanded(child: Text("",style: TextStyle(fontSize:20),)),
      ],),
     ),
    );
  }
}