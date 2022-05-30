import 'package:f3_lugares/models/place.dart';
import 'package:flutter/material.dart';

class FavoritoProvider extends ChangeNotifier {
  List<Place> _lugares = [];
  
  List<Place> get getLugares => _lugares;

  void add(Place place) {
    _lugares.add(place);
    notifyListeners();
  }
}
