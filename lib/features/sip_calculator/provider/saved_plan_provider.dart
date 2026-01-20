import 'package:flutter/material.dart';
import 'package:sip_calculator/features/sip_calculator/model/saved_plan.dart';
import 'package:sip_calculator/utils/colors.dart';

class SavedPlansProvider extends ChangeNotifier {
  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  final List<String> filters = ['All', 'High Value', 'Long Term', 'Recent'];

  final List<SavedPlan> _plans = [];

  List<SavedPlan> get plans {
    switch (_selectedFilter) {
      case 'High Value':
        return _plans.where((e) => e.monthlyAmount >= 25000).toList();
      case 'Long Term':
        return _plans.where((e) => e.years >= 10).toList();
      case 'Recent':
        return _plans.take(2).toList();
      default:
        return _plans;
    }
  }

  void addPlan(SavedPlan plan) {
    _plans.insert(0, plan); // recent on top
    notifyListeners();
  }

  void removePlan(SavedPlan plan) {
    _plans.remove(plan);
    notifyListeners();
  }

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
