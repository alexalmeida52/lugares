import 'package:f3_lugares/components/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/place_item.dart';
import '../models/LugaresProvader.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LugaresProvider>(
        builder: (context, lugares, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Gerenciar'),
          ),
          body: ListView.builder(
              itemCount: lugares.getPlaces().length,
              itemBuilder: (ctx, index) {
                return PlaceItem(lugares.getPlaces()[index], true, index);
              }),
          drawer: MainDrawer(),
        );
      });
  }
}
