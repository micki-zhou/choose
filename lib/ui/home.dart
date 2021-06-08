import 'dart:math';

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
  int preRandomIndex = 0;
  int randomIndex = -1;
  int currentLooperCount = 0;
  int maxLooperCount = 50;
  var random = Random();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 18.0, end: 28.0).animate(curvedAnimation);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (currentLooperCount <= maxLooperCount) {
          animationController.reverse();
        } else {
          currentLooperCount = 0;
        }
      } else if (status == AnimationStatus.dismissed) {
        if (currentLooperCount <= maxLooperCount) {
          int index = random.nextInt(10);
          if (index == preRandomIndex) {
            randomIndex = index + 1;
            preRandomIndex = randomIndex;
          } else {
            randomIndex = index;
            preRandomIndex = randomIndex;
          }
          animationController.forward();
          currentLooperCount++;
        }
      }
    });
    animation.addListener(() {
      setState(() {});
    });
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
            children: [
              _middleView(),
              _startButton(),
              _addFoodInput(),
              _confirmButton()
            ],
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
              _itemText(testArr[i], i),
              if (i + 1 < testArr.length) _itemText(testArr[i + 1], i + 1)
            ],
          ));
          i += 2;
          type = 1;
        } else {
          row.add(
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _itemText(testArr[i], i),
            if (i + 1 < testArr.length) _itemText(testArr[i + 1], i + 1),
            if (i + 2 < testArr.length) _itemText(testArr[i + 2], i + 2)
          ]));
          i += 3;
          type = 0;
        }
      }
    }
    return row;
  }

  Widget _itemText(String content, int index) {
    return Text(content,
        style: TextStyle(
          color: (index == randomIndex) ? MyColors.selectedItem : Colors.white,
          fontSize: (index == randomIndex) ? animation.value : 18,
        ));
  }

  Widget _addFoodInput() {
    return TextField(
      onChanged: null,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    );
  }

  Widget _startButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextButton(
        onPressed: () {
          int index = random.nextInt(testArr.length);
          randomIndex = index;
          preRandomIndex = randomIndex;
          animationController.forward();
        },
        child: Text('开启'),
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.white)),
      ),
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
