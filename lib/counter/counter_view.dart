import 'package:currency_converter/counter/counter_controller.dart';
import 'package:currency_converter/counter/counter_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// VIEW
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVC Counter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:const CounterView(),
    );
  }
}

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterModel _model = CounterModel();
  late CounterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CounterController(_model);
  }

  void _updateView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter Value:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '${_controller.counter}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key:const Key("bold"),
                  onPressed: () {
                    _controller.increment();
                    _updateView();
                  },
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _controller.decrement();
                    _updateView();
                  },
                  child: const Text('Decrement'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _controller.reset();
                _updateView();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
