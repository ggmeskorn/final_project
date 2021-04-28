import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_project/components/custom_surfix_icon.dart';
import 'package:final_project/components/default_button.dart';
import 'package:final_project/components/form_error.dart';
import 'package:final_project/model/user_model.dart';
import 'package:final_project/screens/mainadmin/MainAdmin.dart';
import 'package:final_project/screens/mainuser/MainUser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../my_constant.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String username;
  String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  // Future login() async {
  //   var url = '${MyConstant().domain}/homestay/login.php';
  //   var res = await http
  //       .post(url, body: {"username": user.text, "password": pass.text});
  //   if (res.statusCode == 200) {
  //     var userData = json.decode(res.body);
  //     if (userData == "ERROR") {
  //       // Navigator.pop(context);
  //     } else {
  //       if (userData['status'] == "Admin") {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => Dashboard()));
  //       }else{
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>MainUser()));
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUsernameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: <Widget>[
              Spacer(),
              GestureDetector(
                // onTap: () => Navigator.pushNamed(
                //     context, ForgotPasswordScreen.routeName),
                child: Text(
                  "ลืมรหัสผ่านใช่หรือไม่",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "เข้าสู่ระบบ",
            press: () {
              // login();
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                if (username == null ||
                    username.isEmpty ||
                    password == null ||
                    password.isEmpty) {
                } else {
                  checkAuthen();
                  // login();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<Null> checkAuthen() async {
    // var url = '${MyConstant().domain}/homestay/login.php';

    String url =
        'http://10.0.2.2/homestay/getUserWhereUser.php?isAdd=true&username=$username&password=$password';
    try {
      Response res = await Dio().get(url);

      print('res = $res');

      var result = json.decode(res.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String status = userModel.status;
          if (status == 'User') {
            routeToService(MainUser(), userModel);
          } else if (status == 'Admin') {
            routeToService(Dashboard(), userModel);
          } else {
            addError(error: kInvalidusernamesigninError);
          }
        } else {
          addError(error: kInvalidpasswordError);
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget mywidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('username', userModel.username);
    preferences.setString('email', userModel.email);
    preferences.setString('phone', userModel.phone);
    preferences.setString('unique_id', userModel.unique_id);
    preferences.setString('status', userModel.status);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => mywidget,
    );
    Navigator.pushReplacement(context, route);
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: pass,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "รหัสผ่าน",
        hintText: "ป้อนรหัสผ่าน",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: user,
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kFormusernameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kInvalidusernameError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //     borderRadius: BorderRadius.circular(28),
        // borderSide: BorderSide(color: kTextColor),
        // gapPadding: 10,,
        labelText: "ชื่อผู้ใช้",
        hintText: "กรุณากรอกชื่อผู้ใช้",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
