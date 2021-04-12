import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teamgram_poc/ProgressHUD.dart';
import 'package:teamgram_poc/api/api_service.dart';
import 'package:teamgram_poc/models/domain_model.dart';
import 'package:teamgram_poc/models/login_model.dart';
import 'package:teamgram_poc/extensions/extensions.dart';
import 'package:teamgram_poc/pages/domains_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel requestModel;
  String otp;
  bool isApiCallProcess = false;

  var _apiService = new APIService();

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
                      Image(
                        image: AssetImage('images/logo/teamgram-600px.png'),
                        width: 150,
                      ),
                      SizedBox(height: 20),
                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => requestModel.email = input,
                        /*validator: (input) =>
                            !input.contains("@") ? "Email id is null" : null,*/
                        decoration: new InputDecoration(
                            hintText: "Username",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            prefixIcon:
                                Icon(Icons.verified_user, color: Colors.grey)),
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
                                    color: Colors.grey.withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Colors.grey.withOpacity(0.2),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: ElevatedButton(
                          child: Text('Log in'),
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isApiCallProcess = true;
                              });

                              _apiService.login(requestModel).then((domains) {
                                setState(() {
                                  isApiCallProcess = false;
                                });

                                if (!domains.isNullOrEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Login Successfull.");
                                  _apiService
                                      .showTwoFADialog()
                                      .then((value) => {
                                            if (value)
                                              {otpDialogBox(context, domains)}
                                            else
                                              {gotoDomainView(context, domains)}
                                          });
                                } else {
                                  Fluttertoast.showToast(msg: "Login failed.");
                                }
                              });
                            }
                          },
                        ),
                      ),
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

  gotoDomainView(BuildContext context, List<DomainModel> domains) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DomainView(
                domains: domains,
              )),
    );
  }

  otpDialogBox(BuildContext context, List<DomainModel> domains) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 6,
                onChanged: (value) {
                  otp = value;
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _apiService.twoFACodeValidate(otp).then((valid) {
                    if (valid) {
                      Fluttertoast.showToast(msg: "Pin doğru.");
                      gotoDomainView(context, domains);
                    } else {
                      Fluttertoast.showToast(msg: "Pin yanlış.");
                    }
                  });
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }
}
