// import 'package:flutter/material.dart';
// import 'dart:math';


// void main()
// {
//   runApp(const MaterialApp(
//     home:RotateImages180()
//   ));
// }

// class RotateImages180 extends StatefulWidget {
//   const RotateImages180({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RotateImages180State createState() => _RotateImages180State();
// }

// class _RotateImages180State extends State<RotateImages180> with TickerProviderStateMixin {
//   late AnimationController _rotationController;
//   late AnimationController _zoomController;
//   late Animation<double> _zoomAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Rotation Controller
//     _rotationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..repeat(); // Repeats indefinitely

//     // Zoom Controller (subtle 30% zoom in and out every second)
//     _zoomController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000), // Smooth zooming every second
//     )..repeat(reverse: true);

//     // Tween for scaling effect
//     _zoomAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(_zoomController);
//   }

//   @override
//   void dispose() {
//     _rotationController.dispose();
//     _zoomController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Combined list of rotating images with the exact order
//     final List<String> rotatingImages = [
//       'assets/images/Group 8.png',  // Forward rotating image
//       'assets/images/Star 62.png',  // Backward rotating image
//       'assets/images/Star 63.png',  // Backward rotating image
//       'assets/images/Component 1.png',  // Backward rotating image
//       'assets/images/Star 71.png',  // Backward rotating image
//       'assets/images/Group 9.png',  // Forward rotating image
//       'assets/images/Component 6.png',  // Backward rotating image
//       'assets/images/Group 10.png',  // Forward rotating image
//       'assets/images/Star 67.png',  // Backward rotating image
//       'assets/images/Group 11.png',  // Forward rotating image
//       'assets/images/Component 7.png',  // Backward rotating image
//       'assets/images/Star 69.png',  // Backward rotating image
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Selective Zoom on Rotating Images'),
//       ),
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
          
//             Image.asset(
//               'assets/images/Group 1171276187.png', 
//               width: 240,
//               height: 240,
//             ),

//             // Rotating Images with Zoom Effect
//             AnimatedBuilder(
//               animation: _zoomAnimation,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _zoomAnimation.value, // Zoom in and out
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       // Rotating images
//                       ...rotatingImages.asMap().entries.map((entry) {
//                         final index = entry.key;
//                         final imagePath = entry.value;

//                         // Determine if the image is forward or backward rotating
//                         final bool isForwardRotation =
//                             imagePath == 'assets/images/Group 8.png' ||
//                             imagePath == 'assets/images/Group 9.png' ||
//                             imagePath == 'assets/images/Group 10.png' ||
//                             imagePath == 'assets/images/Group 11.png';

//                         // Set image size for forward and backward rotating images
//                         final double imageSize = isForwardRotation ? 70 : 50;

//                         // Calculate angle for rotation
//                         final double angle = (2 * pi / rotatingImages.length) * index;

//                         return AnimatedBuilder(
//                           animation: _rotationController,
//                           builder: (context, child) {
//                             // Adjust angle for forward (clockwise) and backward (counterclockwise) rotations
//                             final double animatedAngle = angle + _rotationController.value * 2 * pi;
//                             final double radius = isForwardRotation ? 130 : 180;

//                             return Transform.translate(
//                               offset: Offset(
//                                 radius * cos(animatedAngle), // x-coordinate
//                                 radius * sin(animatedAngle), // y-coordinate
//                               ),
//                               child: Image.asset(
//                                 imagePath,
//                                 width: imageSize,
//                                 height: imageSize,
//                               ),
//                             );
//                           },
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    home: RotateImages180(),
  ));
}

class RotateImages180 extends StatefulWidget {
  const RotateImages180({super.key});

  @override
  _RotateImages180State createState() => _RotateImages180State();
}

class _RotateImages180State extends State<RotateImages180> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation Controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Repeats indefinitely

    // Zoom Controller (subtle 30% zoom in and out every second)
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Smooth zooming every second
    )..repeat(reverse: true);

    // Tween for scaling effect
    _zoomAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(_zoomController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Combined list of rotating images with the exact order
     final List<String> rotatingImages = [
      'assets/images/Group 8.png',  // Forward rotating image
      'assets/images/Star 62.png',  // Backward rotating image
      'assets/images/Star 63.png',  // Backward rotating image
      'assets/images/Component 1.png',  // Backward rotating image
      'assets/images/Star 71.png',  // Backward rotating image
      'assets/images/Group 9.png',  // Forward rotating image
      'assets/images/Component 6.png',  // Backward rotating image
      'assets/images/Group 10.png',  // Forward rotating image
      'assets/images/Star 67.png',  // Backward rotating image
      'assets/images/Group 11.png',  // Forward rotating image
      'assets/images/Component 7.png',  // Backward rotating image
      'assets/images/Star 69.png',  // Backward rotating image
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selective Zoom on Rotating Images'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/Group 1171276187.png', // Central image
              width: 240,
              height: 240,
            ),

            // Rotating Images with Zoom Effect
            AnimatedBuilder(
              animation: _zoomAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _zoomAnimation.value, // Zoom in and out
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating images (both forward and backward)
                      ...rotatingImages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final imagePath = entry.value;

                        // Calculate angle for rotation
                        final double angle = (2 * pi / rotatingImages.length) * index;

                        return AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            // Adjust angle for clockwise rotation
                            final double animatedAngle = angle + _rotationController.value * 2 * pi;
                            const double radius = 130;

                            // Calculate the offset based on the image position
                            return Transform.translate(
                              offset: Offset(
                                radius * cos(animatedAngle), // x-coordinate
                                radius * sin(animatedAngle), // y-coordinate
                              ),
                              child: Image.asset(
                                imagePath,
                                width: 70,
                                height: 70,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

