import 'package:f3_lugares/models/FavoritoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/place_item.dart';
import '../data/my_data.dart';

class FavoritosScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritoProvider>(
      builder: (context, favoritos, child) {
        return favoritos.getLugares.isEmpty ? Center(child: Text('Você não possui favoritos')) : ListView.builder(
          itemCount: favoritos.getLugares.length,
          itemBuilder: (ctx, index) {
            return PlaceItem(favoritos.getLugares[index], false, index);
          }
        );
      }
    );
  }
}
