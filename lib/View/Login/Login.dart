import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../Home/Home.dart';
import '../../ViewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserViewModel? userViewModel;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextEdit = TextEditingController();
  TextEditingController password = TextEditingController();



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .27,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(255, 255, 255, 1),
                      Color.fromRGBO(202, 235, 254, 0)

                    ]
                  )
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 50),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff181743)),
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35),
                          topLeft: Radius.circular(35))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 50, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 16),
                                child: Text(
                                  "Email *",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              TextFormField(
                                controller: emailTextEdit,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(25),
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Enter your Email",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 16),
                                child: Text(
                                  "Password *",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              TextFormField(
                                controller: password,
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(25),
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Enter your Password",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(37, 77, 222, 1),
                                          Color.fromRGBO(0, 255, 255, 1)
                                        ])),
                                    child: Selector<UserViewModel, bool>(
                                        selector: (context, provider) =>
                                            provider.getLoginLoading,
                                        builder: (context, loading, child) {
                                          return loading
                                              ? const Center(
                                                  child:
                                                      Padding(
                                                        padding: EdgeInsets.all(12.0),
                                                        child: CircularProgressIndicator(),
                                                      ))
                                              : TextButton(
                                                  onPressed: () async {
                                            if(_formKey.currentState!.validate()){
                                               userViewModel?.toggleLoading(true);
                                                     userViewModel?.login(
                                                    emailTextEdit.text,
                                                    password.text,
                                                    ).then((value){
                                                  if(value!=null){
                                                    Navigator.pushReplacement(context,
                                                        MaterialPageRoute(builder:(BuildContext context)=>Home()));
                                                    userViewModel!.toggleLoading(false);
                                                  }
                                                  else{
                                                    userViewModel!.toggleLoading(false);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Email or Password Incorrect',)));
                                                  }
                                                });
                                            }
                                                  },
                                                  child: Text(
                                                    'Sign In',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                      fixedSize:
                                                          Size.fromHeight(65),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          28)),
                                                      backgroundColor:
                                                          Colors.transparent),
                                                );
                                        }))),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
