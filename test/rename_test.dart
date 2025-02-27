import 'package:currency_converter/counter/counter_controller.dart';
import 'package:currency_converter/counter/counter_model.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Counter App Unit Tests', () {
    late CounterModel model;
    late CounterController controller;

    setUp(() {
      model = CounterModel();
      controller = CounterController(model);
    });

    test('Initial counter value should be 0', () {
      expect(controller.counter, equals(0));
    });

    test('Increment counter', () {
      controller.increment();
      final val=controller.counter;
      expect(val, equals(1));
    });

    test('Decrement counter', () {
      controller.increment(); // Increment first
      controller.decrement(); // Then decrement
      expect(controller.counter, equals(0));
    });

    test('Decrement should not go below 0', () {
      controller.decrement(); // Decrement at initial state
      expect(controller.counter, equals(0));
    });

    test('Reset counter', () {
      controller.increment();
      controller.increment();
      controller.reset();
      expect(controller.counter, equals(0));
    });
  });
}
