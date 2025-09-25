import 'package:flutter/material.dart';
import 'dart:math';

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
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
    ));
    notifyListeners();
  }

  void changeCounterColor (int index) {
    if (index >= 0 && index < _counters.length) {
      final newColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      _counters[index].color = newColor;
      notifyListeners();
    }
  }

  void removeCounter(int index) {
    _counters.removeAt(index);
    notifyListeners();
  }

  void incrementCounter(int index) {
    _counters[index].value++;
    notifyListeners();
  }

  void decrementCounter(int index) {
    if (_counters[index].value > 0) {
      _counters[index].value--;
      notifyListeners();
    }
  }

  void reorderCounters(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final CounterModel item = _counters.removeAt(oldIndex);
    _counters.insert(newIndex, item);
    notifyListeners();
  }

  void updateCounterLabel(int index, String newLabel) {
    if (index >= 0 && index < _counters.length) {
      _counters[index].label = newLabel.isEmpty ? 'Counter ${index + 1}' : newLabel;
      notifyListeners();
    }
  }
}