import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teamgram_poc/ProgressHUD.dart';
import 'package:teamgram_poc/api/api_service.dart';
import 'package:teamgram_poc/models/login_model.dart';
import 'package:teamgram_poc/extensions/extensions.dart';
import 'package:teamgram_poc/pages/domains_view.dart';

import 'note_item_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel requestModel;

  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20),
                    ]),
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text("Login",
                          style: Theme.of(context).textTheme.headline2),
                      SizedBox(height: 20),
                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => requestModel.email = input,
                        /*validator: (input) =>
                            !input.contains("@") ? "Email id is null" : null,*/
                        decoration: new InputDecoration(
                            hintText: "UserName or Email address",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(Icons.verified_user,
                                color: Theme.of(context).accentColor)),
                      ),
                      SizedBox(height: 20),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => requestModel.password = input,
                        validator: (input) => input.length < 3
                            ? "Password should be more than 3 characters"
                            : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(Icons.lock,
                                color: Theme.of(context).accentColor),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                        onPressed: () {
                          if (validateAndSave()) {
                            setState(() {
                              isApiCallProcess = true;
                            });

                            APIService apiService = new APIService();
                            apiService.login(requestModel).then((domains) {
                              setState(() {
                                isApiCallProcess = false;
                              });

                              if (!domains.isNullOrEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Login Successfull.");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoteItemView(
                                            domains: domains,
                                          )),
                                );
                              } else {
                                Fluttertoast.showToast(msg: "Login failed.");
                              }
                            });
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      )),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }
}
