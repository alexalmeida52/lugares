import 'package:f3_lugares/data/my_data.dart';
import 'package:f3_lugares/models/country.dart';
import 'package:f3_lugares/models/place.dart';
import 'package:f3_lugares/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

import '../models/LugaresProvader.dart';
import '../utils/CustomRangeTextInputFormatter.dart';
import 'multi_select.dart';

class LugarForm extends StatefulWidget {
  final Place? placeEditing;
  final int? index;
  LugarForm(this.placeEditing, this.index);

  @override
  State<LugarForm> createState() => _LugarFormState();
}

class _LugarFormState extends State<LugarForm> {
  final _tituloController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _custoMedioController = TextEditingController();
  final _recomendacaoController = TextEditingController();
  List<bool> errors = [false, false, false, false, false, false];
  String paisId = '';

  List<String> recomendacoes = [];

  _submitForm() {
    final titulo = _tituloController.text;
    final avaliacao = _avaliacaoController.text;
    final imagemUrl = _imagemUrlController.text;
    final custoMedio = _custoMedioController.text;

    setState(() {
      if (titulo.isEmpty) {
        errors[0] = true;
      }
      if (imagemUrl.isEmpty) {
        errors[1] = true;
      }
      if (recomendacoes.isEmpty) {
        errors[2] = true;
      }
      if (avaliacao.isEmpty) {
        errors[3] = true;
      }
      if (custoMedio.isEmpty) {
        errors[4] = true;
      }
      if (_selectedItems.isEmpty) {
        errors[5] = true;
      }
    });

    if (titulo.isEmpty ||
        imagemUrl.isEmpty ||
        recomendacoes.isEmpty ||
        avaliacao.isEmpty ||
        custoMedio.isEmpty ||
        _selectedItems.isEmpty) {
      return;
    }

    errors = [false, false, false, false, false, false];

    final lugaresProvider = context.read<LugaresProvider>();

    final lugar = new Place(
        id: lugaresProvider.getId(),
        paises: _selectedItems.map((e) => e.id).toList(),
        titulo: titulo,
        imagemUrl: imagemUrl,
        recomendacoes: recomendacoes,
        avaliacao: double.parse(avaliacao),
        custoMedio: double.parse(custoMedio));

    lugaresProvider.addPlace(lugar);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        'Adicionado com sucesso!',
        textAlign: TextAlign.center,
      )),
    );

    Navigator.of(context).pushReplacementNamed(AppRoutes.HOME, arguments: true);
  }

  void setInputError(value, inputNumber) {
    setState(() {
      errors[inputNumber] = value.isEmpty ? true : false;
    });
  }

  addRecomendacao() {
    String value = _recomendacaoController.text;
    setState(() {
      recomendacoes.add(value);
    });
  }

  removerRecomendacao(index) {
    setState(() {
      recomendacoes.removeAt(index);
    });
  }

  removerPais(index) {
    setState(() {
      _selectedItems.removeAt(index);
    });
  }

  List<Map<String, dynamic>> ls = [];

  @override
  void initState() {
    Map<String, String> myMap = Map.fromIterable(DUMMY_COUNTRIES,
        key: (e) => e.id, value: (e) => e.title);
    myMap.forEach((key, value) {
      ls.add({
        'value': '$key',
        'label': '$value',
      });
    });

    if (widget.placeEditing != null) {
      print(widget.placeEditing);
      setState(() {
        _selectedItems = DUMMY_COUNTRIES.where((e) => widget.placeEditing!.paises.contains(e.id)).toList();
        _tituloController.text = widget.placeEditing!.titulo;
        _avaliacaoController.text = widget.placeEditing!.avaliacao.toString();
        _imagemUrlController.text = widget.placeEditing!.imagemUrl;
        _custoMedioController.text = widget.placeEditing!.custoMedio.toString();
        recomendacoes = widget.placeEditing!.recomendacoes;
      });
    }

    super.initState();
  }

  setPais(value) {
    paisId = value;
  }

  List<Country> _selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<Country> _items = DUMMY_COUNTRIES;

    final List<Country>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: _items, selectedItems: _selectedItems);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: <Widget>[
          Row(
            children: [
              ElevatedButton(
                child: Row(
                  children: [
                    const Text('Selecionar países'),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
                onPressed: _showMultiSelect,
                style: ElevatedButton.styleFrom(
                    primary: errors[5] && _selectedItems.isEmpty
                        ? Colors.red
                        : Colors.green),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 50.0,
              ),
              child: _selectedItems.isEmpty
                  ? null
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _selectedItems.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (ctx, index) {
                        return Chip(
                          elevation: 5,
                          padding: EdgeInsets.all(2),
                          backgroundColor: Colors.green,
                          label: Text(
                            _selectedItems[index].title,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          deleteIcon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          deleteButtonTooltipMessage: 'Remover país',
                          onDeleted: () {
                            removerPais(index);
                          },
                        );
                      },
                    ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Container(
          //     child: SelectFormField(
          //         type: SelectFormFieldType.dropdown, // or can be dialog
          //         labelText: 'Country',
          //         items: ls.toList(),
          //         onChanged: (val) => {paisId = val})),
          TextField(
            onChanged: (value) => {setInputError(value, 0)},
            controller: _tituloController,
            decoration: InputDecoration(
              labelText: 'Lugar',
              helperText: errors[0] ? '*Campo obrigatório' : null,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errors[0] ? Colors.red : Colors.green.shade200,
                    width: 2.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) => {setInputError(value, 1)},
            controller: _imagemUrlController,
            decoration: InputDecoration(
              labelText: 'Imagem url',
              helperText: errors[1] ? '*Campo obrigatório' : null,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errors[1] ? Colors.red : Colors.green.shade200,
                    width: 2.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              TextField(
                controller: _recomendacaoController,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        addRecomendacao();
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  labelText: 'Recomendações',
                  helperText: errors[2] ? '*Campo obrigatório' : null,
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: errors[2] && recomendacoes.isEmpty
                            ? Colors.red
                            : Colors.green.shade200,
                        width: 2.0),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                ),
                child: recomendacoes.isEmpty
                    ? null
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: recomendacoes.length,
                        itemBuilder: (ctx, index) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Chip(
                              elevation: 5,
                              padding: EdgeInsets.all(2),
                              backgroundColor: Colors.purple,
                              label: Text(
                                recomendacoes[index],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              deleteIcon: Icon(Icons.close),
                              deleteButtonTooltipMessage:
                                  'Remover recomendação',
                              onDeleted: () {
                                removerRecomendacao(index);
                              },
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              if (value.isNotEmpty && int.parse(value) > 5) {
                _avaliacaoController.value = TextEditingValue(text: '5');
              }

              setInputError(value, 3);
            },
            controller: _avaliacaoController,
            decoration: InputDecoration(
              labelText: 'Avaliação',
              helperText: errors[3] ? '*Campo obrigatório' : null,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errors[3] ? Colors.red : Colors.green.shade200,
                    width: 2.0),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ], // Only numbers can be entered
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) => {setInputError(value, 4)},
            controller: _custoMedioController,
            decoration: InputDecoration(
              labelText: 'Custo médio',
              helperText: errors[4] ? '*Campo obrigatório' : null,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errors[4] ? Colors.red : Colors.green.shade200,
                    width: 2.0),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  if (widget.placeEditing != null) {
                    final lugaresProvider = context.read<LugaresProvider>();

                    Place placeTemp = new Place(
                        id: widget.placeEditing!.id,
                        paises: _selectedItems.map((e) => e.id).toList(),
                        titulo: widget.placeEditing!.titulo,
                        imagemUrl: widget.placeEditing!.imagemUrl,
                        recomendacoes: recomendacoes,
                        avaliacao: widget.placeEditing!.avaliacao,
                        custoMedio: widget.placeEditing!.custoMedio);
                    lugaresProvider.updatePlace(placeTemp, widget.index);

                    
                    Navigator.pop(context);
                  } else {
                    _submitForm();
                  }
                },
                child: widget.placeEditing != null
                    ? Text('Atualizar')
                    : Text('Adicionar')),
          ),
        ]),
      ),
    );
  }
}
