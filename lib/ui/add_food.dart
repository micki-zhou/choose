import 'package:choose/config/my_colors.dart';
import 'package:choose/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<Offset> animation;
  late Animation<double> slide;

  late List<String> foodList = [];

  String tipStr = "Hi , \n你想添加什么菜品 ?";
  String hintStr = "请输入菜品";
  String foodStr = "";

  void getFoodList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    foodList = sharedPreferences.getStringList('food')!;
    // print("add food: " + foodList.toString());
  }

  @override
  void initState() {
    super.initState();
    getFoodList();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutBack);
    animation =
        Tween(begin: Offset(0, 0), end: Offset(0, -3)).animate(curvedAnimation);
    slide = Tween(begin: 200.0, end: 50.0).animate(curvedAnimation)
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
      body: Column(
        children: [
          _backHome(context),
          Container(
            padding: EdgeInsets.fromLTRB(30, slide.value, 30, 0),
            child: Column(
              children: <Widget>[
                _textTip(),
                _textField(),
                _confirmBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTip() {
    return Container(
      width: 500,
      child: Text(
        tipStr,
        style: TextStyle(color: Colors.white, fontSize: 25),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: TextField(
        onChanged: (value) {
          foodStr = value;
        },
        decoration: InputDecoration(
          hintText: hintStr,
          isCollapsed: true,
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _confirmBtn() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (foodStr.isNotEmpty) {
            foodList.add(foodStr);
            saveFood();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomePage();
            }), (route) => false);
          } else {
            print('foodStr is null');
          }
        },
        child: Text('确定'),
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 18),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(MyColors.selectedItem),
        ),
      ),
    );
  }

  Widget _backHome(context) {
    return Row(
      children: [
        ButtonTheme(
          minWidth: 50,
          child: TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return HomePage();
              }), (route) => false);
            },
            child: Icon(
              Icons.navigate_before,
              size: 50,
              color: Colors.white,
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(0, 20, 0, 0))),
          ),
        ),
      ],
    );
  }

  void saveFood() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('food', foodList);
  }
}
