import 'package:flutter/material.dart';
import 'package:chat/models/microlearning.dart';

class MicrolearningProvider extends ChangeNotifier {
  List<MicroLearning> _microlearnings = [];

  List<MicroLearning> get microlearnings => _microlearnings;

  void setMicrolearnings(List<MicroLearning> list) {
    _microlearnings = list;
    notifyListeners();
  }

  void clear() {
    _microlearnings = [];
    notifyListeners();
  }
}