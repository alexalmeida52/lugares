import 'package:f3_lugares/components/place_item.dart';
import 'package:f3_lugares/data/my_data.dart';
import 'package:f3_lugares/models/LugaresProvader.dart';
import 'package:f3_lugares/models/country.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryPlacesScreen extends StatelessWidget {
  //Country country;
  // CountryPlacesScreen(this.country);

  @override
  Widget build(BuildContext context) {
    final country = ModalRoute.of(context)!.settings.arguments as Country;

    final ls = LugaresProvider().getPlaces();
    print('lugares ${ls.length}');
    final countryPlaces = DUMMY_PLACES.where((places) {
      return places.paises.contains(country.id);
    }).toList();

    return Consumer<LugaresProvider>(
      builder: (context, lugares, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(country.title),
        ),
        body: ListView.builder(
            itemCount: lugares.getPlacesByCountryId(country.id).length,
            itemBuilder: (ctx, index) {
              return PlaceItem(lugares.getPlacesByCountryId(country.id)[index], false, index);
            }),
      );
    });
  }
}
