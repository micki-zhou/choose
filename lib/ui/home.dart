import 'dart:math';

import 'package:choose/config/my_colors.dart';
import 'package:choose/ui/add_food.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  int preRandomIndex = 0;
  int randomIndex = -1;
  int currentLooperCount = 0;
  int maxLooperCount = 50;
  var random = Random();
  String btnStr = '开启';

  late List<String> foodList = [];

  void getFoodList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    foodList = sharedPreferences.getStringList('food')!;
  }

  @override
  void initState() {
    super.initState();
    getFoodList();
    animationController =
        AnimationController(duration: Duration(milliseconds: 60), vsync: this);
    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween(begin: 18.0, end: 22.0).animate(curvedAnimation);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (currentLooperCount <= maxLooperCount) {
          animationController.reverse();
        } else {
          currentLooperCount = 0;
          btnStr = '重选';
        }
      } else if (status == AnimationStatus.dismissed) {
        if (currentLooperCount <= maxLooperCount) {
          int index = random.nextInt(foodList.length);
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
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Wrap(
              spacing: 60,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _getMiddleViewChild(),
            ),
            Positioned(bottom: 60, right: 0, child: _startButton()),
            Positioned(
              bottom: 10,
              right: 0,
              child: _addFoodButton(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getMiddleViewChild() {
    List<Widget> itemArr = List.empty(growable: true);
    if (foodList.isNotEmpty) {
      int i = 0;
      int type = 0;
      while (i < foodList.length) {
        if (type == 0) {
          itemArr.add(_itemText(foodList[i], i));
          if (i + 1 < foodList.length) {
            itemArr.add(_itemText(foodList[i + 1], i + 1));
          }
          i += 2;
          type = 1;
        } else {
          itemArr.add(_itemText(foodList[i], i));
          if (i + 1 < foodList.length) {
            itemArr.add(_itemText(foodList[i + 1], i + 1));
          }
          if (i + 2 < foodList.length) {
            itemArr.add(_itemText(foodList[i + 2], i + 2));
          }
          i += 3;
          type = 0;
        }
      }
    }
    return itemArr;
  }

  Widget _itemText(String content, int index) {
    return Text(content,
        style: TextStyle(
          color: (index == randomIndex) ? MyColors.selectedItem : Colors.white,
          fontSize: (index == randomIndex) ? animation.value : 18,
        ));
  }

  Widget _startButton() {
    return TextButton(
      onPressed: () {
        if (foodList.isNotEmpty) {
          int index = random.nextInt(foodList.length);
          randomIndex = index;
          preRandomIndex = randomIndex;
          if (animationController.status == AnimationStatus.completed) {
            animationController.reverse();
          }
          animationController.forward();
        }
      },
      child: Text(btnStr),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
        backgroundColor: MaterialStateProperty.all(MyColors.selectedItem),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, 5, 20, 5)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20)))),
      ),
    );
  }

  Widget _addFoodButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddFoodPage();
        }));
      },
      child: Text('新增'),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, 5, 20, 5)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20)))),
      ),
    );
  }
}
