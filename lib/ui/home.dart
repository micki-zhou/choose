import 'package:choose/config/my_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.theme,
      body: Center(
        child: Column(
          children: [_addFoodInput(), _confirmButton()],
        ),
      ),
    );
  }

  Widget _addFoodInput() {
    return TextField(
      onChanged: null,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    );
  }

  Widget _confirmButton() {
    return TextButton(
      onPressed: null,
      child: Text('确定'),
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }
}
