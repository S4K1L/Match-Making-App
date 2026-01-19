import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchesController extends GetxController{

    var selectedGender = ''.obs;
  RxDouble distance = 60.0.obs;
  final min = 18.0, max = 100.0;
  var rv = const RangeValues(18, 32).obs;

  void setRange(double start, double end) {
    rv.value = RangeValues(start, end);
  }
}