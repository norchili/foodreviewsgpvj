import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgpvjreviews/Bloc/bloc.dart';
import 'package:foodgpvjreviews/User/model/user.dart' as model_user;
import 'package:foodgpvjreviews/User/ui/screens/sign_up_screen.dart';
import 'package:foodgpvjreviews/User/ui/widgets/login_gradient_back.dart';
import 'package:foodgpvjreviews/User/ui/widgets/logo_social_network.dart';
import 'package:foodgpvjreviews/User/ui/widgets/text_input.dart';
import 'package:foodgpvjreviews/User/ui/widgets/text_input_password.dart';
import 'package:foodgpvjreviews/food_gpvj_main_app.dart';
import 'package:foodgpvjreviews/responses/sign_in_response.dart';
import 'package:foodgpvjreviews/widgets/custom_button.dart';
import 'package:foodgpvjreviews/widgets/error_alert_dialog.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  late double screenWidht;
  UserBloc? userBloc;
  bool isUrlLogoSet = false;
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPassword;

  @override
  void initState() {
    //Se ejecuta solo una vez y se ejetua al inicio
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    screenWidht = MediaQuery.of(context)
        .size
        .width; //Obtenemos el tamaño exacto de la pantalla del movil
    return _handleCurrentSession();
  }

  //Metodo para establecer la pantalla de inicio
  //en base a si está o no autenticado con google
  Widget _handleCurrentSession() {
    return StreamBuilder(
        stream: userBloc!
            .authStatus, //Solicitamos conocer el estatus de la sesion de Firebase
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          //snapshot contiene nuestro objeto User de Firebase
          if (!snapshot.hasData || snapshot.hasError) {
            return signInGoogleUI(); //Si no hay datos en User pide que se autentique
          } else {
            return const FoodGPVJMainApp(); //Si hay datos de Usuario autenticado pasa a la pantalla principal de la app de FoodGPVJ
          }
        });
  }

  Widget signInGoogleUI() {
    //_controllerEmail = TextEditingController();
    //_controllerPassword = TextEditingController();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const LoginGradientBack(),
          Container(
              width: screenWidht,
              margin:
                  const EdgeInsets.only(top: 150.0, left: 15.0, right: 15.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                      width: screenWidht,
                      child: const Text("Inicia sesión",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Comfortaa",
                              color: Colors.black,
                              fontWeight: FontWeight.w700))),
                  space(1.0, screenWidht),
                  SizedBox(
                      width: screenWidht,
                      //margin: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                      child: const Text("¡Es un gusto verte de nuevo!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFFBBBCC2),
                              fontWeight: FontWeight.bold))),
                  space(50.0, screenWidht),
                  TextInput(
                    hintText: "example@gmail.com",
                    inputType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    prefixIconData: Icons.email_outlined,
                    fontSize: 14.0,
                    titleText: 'Correo electrónico',
                  ),
                  space(20.0, screenWidht),
                  TextInputPassword(
                    hintText: "Contraseña",
                    controller: _controllerPassword,
                    prefixIconData: Icons.lock_outlined,
                    fontSize: 14.0,
                    titleText: 'Contraseña',
                  ),
                  space(50.0, screenWidht),
                  CustomButton(
                    text: "Ingresar",
                    fontSize: 16.0,
                    onPressed: () {
                      userBloc!.signOut();
                      userBloc!
                          .signInWithEmailAndPassword(
                              _controllerEmail.text, _controllerPassword.text)
                          .then((response) {
                        updateUserOnCloudFirebase(response);
                      });
                    },
                    //width: 300.0,
                    height: 60.0,
                  ),
                  space(10.0, screenWidht),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("¿No tienes una cuenta?",
                            style: TextStyle(
                                fontSize: 11.0, color: Color(0xFFBBBCC2))),
                        TextButton(
                          child: const Text("  Crear cuenta",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFFFE7813),
                                  fontWeight: FontWeight.w700)),
                          onPressed: () {
                            //Ir a panta de Registro nuevo de usuario
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const SignUpScreen()));
                          },
                        )
                      ]),
                  space(20.0, screenWidht),
                  SizedBox(
                      width: screenWidht,
                      child: const Text(
                        "------- Ó accede con -------",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFBBBCC2)),
                      )),
                  space(15.0, screenWidht),
                  SocialNetworkLogo(
                    pathLogo: "images/google.jpg",
                    onPresed: () {
                      userBloc!.signOut();
                      userBloc!.signIn().then((response) {
                        updateUserOnCloudFirebase(response);
                      });
                    },
                    widht: screenWidht,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context, SignInResponse response) {
    String contentText;
    String title;

    if (response.error == SignInError.cancelled) {
      title = "Cancelado...";
      contentText = "Autenticación con Google cancelada.";
    } else if (response.error == SignInError.userNotFound ||
        response.error == SignInError.wrongPassword ||
        response.error == SignInError.invalidCredential) {
      title = "Error de acceso";
      contentText = "Correo ó contraseña incorrecta.";
    } else if (response.user == null) {
      title = "Deslogueado";
      contentText = "No existe un usuario logueado";
    } else {
      title = "Error";
      contentText = "Ocurrió un error al iniciar sesión";
    }

    return showDialog<void>(
      context: context,
      builder: (_) => ErrorAlertDialog(title: title, contentText: contentText),
    );
  }

  Widget space(double heigth, double width) {
    return SizedBox(
      width: width,
      height: heigth,
    );
  }

  void updateUserOnCloudFirebase(SignInResponse response) {
    if (response.error == null && response.user != null) {
      userBloc!.updateUserData(model_user.User(
          userId: response.user!.uid.toString(),
          name: response.user!.displayName.toString(),
          email: response.user!.email.toString(),
          photoURL: response.user!.photoURL.toString()));
      const CircularProgressIndicator();
    } else {
      //mostrar cuadro de error
      _showErrorDialog(context, response);
    }
  }
}
