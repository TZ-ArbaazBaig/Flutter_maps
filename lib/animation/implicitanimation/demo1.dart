import 'dart:async';

import 'package:flutter/material.dart';




class Demo1 extends StatefulWidget {
  const Demo1({ Key? key }) : super(key: key);

  @override
  _Demo1State createState() => _Demo1State();
}

class _Demo1State extends State<Demo1> {
  var _width=200.0;
  var _height=100.0;

  bool flag=true;
  bool isVisible=true;
@override
void initState(){
  super.initState();
  // Timer(Duration(seconds: 4),(){
  //     Time();
  // });

}

// void Time(){
//   setState(() {
// isVisible=false;
//   });
// }
  var opacity=1.0;
  // Color bgcolor=Colors.blue;

  Decoration myDecor=BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children:[


              // animateOpacity(),
              // CrossFade()
              HeroAnimate(),
          ]
        ),
      )
    );
    
  }

  Widget Animator(){
    return Column(
      children: [

                  AnimatedContainer(
              duration: Duration(seconds:2),
              width:_width,
              height:_height,
              // color: bgcolor,
              curve: Curves.bounceInOut,
              decoration:myDecor ,
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                setState(() {
                if(flag)
                {
                _width=100.0;
                _height=200.0;
                // bgcolor=Colors.black;
                myDecor=BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red
                );
                 flag=false;
                }else{
                  _width=200.0;
                _height=100.0;
                // bgcolor=Colors.blue;
                myDecor=BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue
                );
                flag=true;
                }
                  
                });

              }, child: Text("Click")),
      ],
    );
    
  }

  Widget animateOpacity(){
     return Column(
      children: [
        
        AnimatedOpacity(
          opacity: opacity, 
          duration: Duration(seconds:2),
          curve: Curves.bounceOut,
          child: Container(
            width: 200,
            height: 100,
            color: Colors.black,
          ),
          ),
          ElevatedButton(onPressed: (){
            setState(() {
              if(flag)
              {
              opacity=0.0;
              isVisible=false;

              }
              else{
                opacity=1.0;
                isVisible=true;
              }
            });
          }, child: Text("change")),
      ],
      
      );
  }

  Widget CrossFade(){
      return
        Column(
          children: [
            AnimatedCrossFade(
              firstChild: Animator(), 
              secondChild: animateOpacity(), 
              crossFadeState: isVisible? CrossFadeState.showFirst:CrossFadeState.showSecond,
               duration: Duration(seconds:2)),
          ],
        );

          //  ElevatedButton(onPressed: (){
          //   setState(){

          //   }
          //  }, child: Text("toggle"))
      
  }


  Widget HeroAnimate()
  {
    return Column(
      children: [

      ],
    );
  }
}