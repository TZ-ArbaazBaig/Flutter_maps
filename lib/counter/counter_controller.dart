import 'package:currency_converter/counter/counter_model.dart';

class CounterController {
  final CounterModel _model;

  CounterController(this._model);

  int get counter => _model.counter;

  void increment() => _model.increment();

  void decrement() => _model.decrement();

  void reset() => _model.reset();
}