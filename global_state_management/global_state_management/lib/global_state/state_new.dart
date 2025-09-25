import 'package:flutter/material.dart';

class CounterModel {
  int value;
  String label;
  Color color;

  CounterModel({
    required this.value,
    required this.label,
    required this.color,
  });
}

class GlobalState with ChangeNotifier {
  final List<CounterModel> _counters = [];

  List<CounterModel> get counters => _counters;

  void addCounter() {
    _counters.add(CounterModel(
      value: 0,
      label: 'Counter ${_counters.length + 1}',
      color: Colors.primaries[_counters.length % Colors.primaries.length],
    ));
    notifyListeners();
  }

  void removeCounter(int index) {
    if (index >= 0 && index < _counters.length) {
      _counters.removeAt(index);
      notifyListeners();
    }
  }

  void incrementCounter(int index) {
    if (index >= 0 && index < _counters.length) {
      _counters[index].value++;
      notifyListeners();
    }
  }

  void decrementCounter(int index) {
    if (index >= 0 && index < _counters.length && _counters[index].value > 0) {
      _counters[index].value--;
      notifyListeners();
    }
  }
}