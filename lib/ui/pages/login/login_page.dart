import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:capital_tours_mobile/ui/pages/login/widgets/inputs.login.dart';
import 'package:capital_tours_mobile/ui/pages/login/widgets/login_buttons.dart';
import 'package:capital_tours_mobile/widgets/colors.dart';
import 'package:localstore/localstore.dart';

import '../../../library/api.library.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();

  final passwordloginController = TextEditingController();

  final numeroPlacaController = TextEditingController();

  final emailController = TextEditingController();

  final passwordRegisterController = TextEditingController();

  FocusNode userdNode = FocusNode();

  FocusNode passwordLoginNode = FocusNode();

  FocusNode numeroPlacaNode = FocusNode();

  FocusNode emailNode = FocusNode();

  FocusNode passwordRegisterNode = FocusNode();

  bool isLoginForm = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heigthScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Stack(
          children: [
            Container(
              width: widthScreen,
              height:
                  heigthScreen >= 650 ? heigthScreen - 300 : heigthScreen - 350,
              decoration: const BoxDecoration(
                color: primaryAppColor,
              ),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 60, top: heigthScreen >= 668 ? 75 : 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(25),
                        elevation: 20,
                        child:
                            Image.asset('assets/images/logo.png', width: 150),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: heigthScreen * 0.35,
              left: widthScreen * 0.05,
              right: widthScreen * 0.05,
              child: Column(
                children: [
                  Material(
                    elevation: 20,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: widthScreen - 40,
                      height: heigthScreen - (heigthScreen / 2 + 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      LoginButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoginForm = true;
                                          });
                                        },
                                        text: 'Iniciar Sesión',
                                        textColor: isLoginForm
                                            ? lightColor
                                            : darkColor,
                                        color: isLoginForm
                                            ? greencolor
                                            : lightColor, // Cambia el color según isLoginForm.
                                        width: 140,
                                      ),
                                      LoginButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoginForm = false;
                                          });
                                        },
                                        text: 'Registrarse',
                                        textColor: !isLoginForm
                                            ? lightColor
                                            : darkColor,
                                        color: !isLoginForm
                                            ? greencolor
                                            : lightColor, // Cambia el color según !isLoginForm.
                                        width: 140,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            const Divider(),
                            Visibility(
                              visible: isLoginForm,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: InputLogin(
                                      focusNode: userdNode,
                                      controller: userController,
                                      labelText: 'Usuario',
                                      cursorColor: darkColor,
                                      labelStyle: const TextStyle(
                                        color: darkColor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: InputLogin(
                                      focusNode: passwordLoginNode,
                                      controller: passwordloginController,
                                      labelText: 'Contraseña',
                                      cursorColor: darkColor,
                                      obscureText: true,
                                      labelStyle: const TextStyle(
                                        color: darkColor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  LoginButton(
                                    onPressed: () => initLogin(),
                                    text: 'Iniciar Sesión',
                                    color: primaryAppColor,
                                    width: 150,
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !isLoginForm,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: InputLogin(
                                      focusNode: emailNode,
                                      controller: emailController,
                                      labelText: 'Email',
                                      cursorColor: darkColor,
                                      labelStyle: const TextStyle(
                                        color: darkColor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: InputLogin(
                                      focusNode: numeroPlacaNode,
                                      controller: numeroPlacaController,
                                      labelText: 'Numero Placa',
                                      cursorColor: darkColor,
                                      labelStyle: const TextStyle(
                                        color: darkColor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.badge,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: InputLogin(
                                      focusNode: passwordRegisterNode,
                                      controller: passwordRegisterController,
                                      labelText: 'Contraseña',
                                      obscureText: true,
                                      cursorColor: darkColor,
                                      labelStyle: const TextStyle(
                                        color: darkColor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: darkColor,
                                      ),
                                    ),
                                  ),
                                  LoginButton(
                                    onPressed: () => signup(),
                                    text: 'Registrarse',
                                    color: primaryAppColor,
                                    width: 150,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.transparent,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  initLogin() {
    if (userController.text == "" || passwordloginController.text == "") {
      Fluttertoast.showToast(
        msg: 'Todos los campos son obligatorios',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.yellow,
        textColor: Colors.grey.shade600,
      );
    } else {
      var data = {
        "email": userController.text.trim(),
        "password": passwordloginController.text,
      };
      Apiv2()
          .exec("auth-movil/login", data: data, method: "PUT", auth: false)
          .then((response) {
        if (response.isNotEmpty) {
          final db = Localstore.instance;
          db.collection("session").doc("init").set(response);
          Get.toNamed('/welcome');
        }
      });
    }
  }

  signup() {
    if (emailController.text == "" ||
        passwordRegisterController.text == "" ||
        numeroPlacaController.text == "") {
      Fluttertoast.showToast(
        msg: 'Todos los campos son obligatorios',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.yellow,
        textColor: Colors.grey.shade600,
      );
    } else {
      var data = {
        "email": emailController.text.trim(),
        "password": passwordRegisterController.text,
        "numero_placa": numeroPlacaController.text.toUpperCase(),
      };
      Apiv2()
          .exec("auth-movil/signup", data: data, method: "POST", auth: false)
          .then((response) {
        if (response.isNotEmpty) {
          setState(() {
            isLoginForm = true;
            emailController.text = "";
            numeroPlacaController.text = "";
            passwordRegisterController.text = "";
          });
        }
      });
    }
  }
}
