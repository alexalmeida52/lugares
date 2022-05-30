// Multi Select widget
// This widget is reusable
import 'package:f3_lugares/models/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<Country> items;
  final List<Country> selectedItems;
  const MultiSelect(
      {Key? key, required this.items, required this.selectedItems})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  List<Country> _selectedItems = [];

  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectedItems.isNotEmpty) {
      _selectedItems = widget.selectedItems;
    }
    super.initState();
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(Country itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecione os países'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item.title),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Confirmar'),
          onPressed: _submit,
        ),
      ],
    );
  }
}
