import 'package:f3_lugares/components/LugarForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/main_drawer.dart';

class AddLugar extends StatefulWidget {
  const AddLugar({ Key? key }) : super(key: key);

  @override
  State<AddLugar> createState() => _AddLugarState();
}

class _AddLugarState extends State<AddLugar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar lugar'),),
      body: LugarForm(null, null),
      drawer: MainDrawer(),
    );
  }
}