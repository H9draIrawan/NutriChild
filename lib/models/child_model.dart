import 'package:flutter/foundation.dart';

class ChildModel extends ChangeNotifier {
  int _age;
  double _weight;
  double _height;
  List<String> _allergies;
  List<String> _goals;

  ChildModel({
    required int age,
    required double weight,
    required double height,
    List<String>? allergies,
    List<String>? goals,
  })  : _age = age,
        _weight = weight,
        _height = height,
        _allergies = allergies ?? [],
        _goals = goals ?? [];

  int get age => _age;
  double get weight => _weight;
  double get height => _height;
  List<String> get allergies => List.unmodifiable(_allergies);
  List<String> get goals => List.unmodifiable(_goals);

  void updateAge(int age) {
    _age = age;
    notifyListeners();
  }

  void updateWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }

  void updateHeight(double height) {
    _height = height;
    notifyListeners();
  }

  void addAllergy(String allergy) {
    _allergies.add(allergy);
    notifyListeners();
  }

  void removeAllergy(String allergy) {
    _allergies.remove(allergy);
    notifyListeners();
  }

  void addGoal(String goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void removeGoal(String goal) {
    _goals.remove(goal);
    notifyListeners();
  }
}
