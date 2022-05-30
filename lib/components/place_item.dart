import 'package:f3_lugares/components/LugarForm.dart';
import 'package:f3_lugares/models/place.dart';
import 'package:f3_lugares/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/LugaresProvader.dart';

class PlaceItem extends StatelessWidget {
  final Place place;
  final int index;
  final bool isControl;

  const PlaceItem(this.place, this.isControl, this.index);

  void _selectPlace(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
          AppRoutes.PLACES_DETAIL,
          arguments:
              place, //passar um map com chave valor para passar mais de um argumento
        )
        .then((value) => {
              if (value == null) {} else {print(value)}
            });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectPlace(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              ClipRRect(
                //bordas na imagem
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  place.imagemUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                //só funciona no contexto do Stack - posso posicionar o elemento
                right: 10,
                bottom: 20,
                child: Container(
                  width: 300,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: Text(
                    place.titulo,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                    softWrap: true, //quebra de lina
                    overflow: TextOverflow.fade, //case de overflow
                  ),
                ),
              ),
              if(isControl) 
                Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        place.titulo,
                                        style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Container(child: LugarForm(place, index)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                              'Lugar atualizado com sucesso!',
                              textAlign: TextAlign.center,
                            )),
                          );
                        },
                        child: Icon(Icons.edit),
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () {
                          final lugaresProvider = context.read<LugaresProvider>();
                          lugaresProvider.removePlace(index);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                              'Lugar removido com sucesso!',
                              textAlign: TextAlign.center,
                            )),
                          );
                        },
                        child: Icon(Icons.close),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                    ],
                  )
                ),
            ]),
            //Text(place.titulo),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.star),
                      SizedBox(
                        width: 6,
                      ),
                      Text('${place.avaliacao}/5')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.attach_money),
                      SizedBox(
                        width: 6,
                      ),
                      Text('custo: R\$${place.custoMedio}')
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
