

import 'package:choose/config/my_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List testArr = [
    '火锅',
    '炒菜',
    '串串',
    '冒菜',
    '小龙虾',
    '烧烤',
    '水果',
    '烧菜',
    '火爆肥肠',
    '小煎鸭'
  ];
  late AnimationController animationController;
  // late CurvedAnimation curvedAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc);
    animation = Tween(begin: 18.0, end: 28.0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();

  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.theme,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: Column(
            children: [_middleView(), _addFoodInput(), _confirmButton()],
          ),
        ),
      ),
    );
  }

  Widget _middleView() {
    return Column(
      children: _getMiddleViewChild(),
    );
  }

  List<Widget> _getMiddleViewChild() {
    List<Row> row = List.empty(growable: true);
    if (testArr.isNotEmpty) {
      int i = 0;
      int type = 0;
      while (i < testArr.length) {
        if (type == 0) {
          row.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _itemText(
                testArr[i],
              ),
              if (i + 1 < testArr.length) _itemText(testArr[i + 1])
            ],
          ));
          i += 2;
          type = 1;
        } else {
          row.add(
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _itemText(testArr[i]),
            if (i + 1 < testArr.length) _itemText(testArr[i + 1]),
            if (i + 2 < testArr.length) _itemText(testArr[i + 2])
          ]));
          i += 3;
          type = 0;
        }
      }
    }
    return row;
  }

  Widget _itemText(String content) {
    return Text(content, style: TextStyle(color: Colors.white, fontSize: animation.value));
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
