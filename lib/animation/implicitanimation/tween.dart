// import 'package:flutter/material.dart';



// class Twen extends StatefulWidget {
//   const Twen({ Key? key }) : super(key: key);

//   @override
//   _TweenState createState() => _TweenState();
// }

// class _TweenState extends State<Twen> with SingleTickerProviderStateMixin{
//   late Animation animation;
//   late AnimationController animationController;

//   @override
//   void initState() {
  
//     super.initState();

//    animationController=AnimationController(vsync: this,duration:const Duration(seconds: 4));

//     animation=Tween(begin: 0.0, end: 200.0).animate(animationController);

//     animationController.addListener((){
//         print(animation.value);
//     });

//     animationController.forward();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:BuildUi(),
//     );
//   }

//   Widget BuildUi(){
//     return Column(
//       children: [],
//     );
//   }
// }








import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Star Alignment')),
        backgroundColor: Colors.blue,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bottom-left star
              Positioned(
                left: -40, // Adjust position for left bottom
                bottom: 0,
                child: Image.asset('assets/images/Star 70.png', width: 40, height: 40),
              ),
              // Top star
              Positioned(
                top: -40, // Adjust position for top star
                child: Image.asset('assets/images/Star 71.png', width: 50, height: 50),
              ),
              // Bottom-right star
              Positioned(
                right: -40, // Adjust position for right bottom
                bottom: 0,
                child: Image.asset('assets/images/Star 64.png', width: 40, height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

