

import 'package:currency_converter/counter/counter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets("description", (tester)async{

    await tester.pumpWidget(const MaterialApp(
      home: CounterView(),
    ),
    );

    final ctr=find.text('0');
    expect(ctr, findsOneWidget);


   final incre=find.byKey(const Key('bold'));
   await tester.tap(incre);

   await tester.pump();

   final a=find.text('1');
   expect(a, findsOneWidget);

  });

}