import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgpvjreviews/Bloc/bloc.dart';
import 'package:foodgpvjreviews/User/model/user.dart' as model_user;
import 'package:foodgpvjreviews/User/ui/widgets/login_gradient_back.dart';
import 'package:foodgpvjreviews/User/ui/widgets/logo_social_network.dart';
import 'package:foodgpvjreviews/food_gpvj_main_app.dart';
import 'package:foodgpvjreviews/widgets/custom_button.dart';
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const LoginGradientBack(),
          Container(
              margin:
                  const EdgeInsets.only(top: 180.0, left: 40.0, right: 40.0),
              child: Column(
                children: <Widget>[
                  Flexible(
                      child: SizedBox(
                          width: screenWidht,
                          child: const Text("Vamos a empezar",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: "Comfortaa",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)))),
                  Flexible(
                      child: Container(
                          width: screenWidht,
                          margin: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                          child: const Text("¡Crea una cuenta para continuar!",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFFBBBCC2),
                                  fontWeight: FontWeight.bold)))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: SocialNetworkLogo(
                              pathLogo: "images/google.jpg",
                              onPresed: () {
                                userBloc!.signOut();
                                userBloc!.signIn().then((value) {
                                  userBloc!.updateUserData(model_user.User(
                                      userId: value!.user!.uid.toString(),
                                      name: value.user!.displayName.toString(),
                                      email: value.user!.email.toString(),
                                      photoURL:
                                          value.user!.photoURL.toString()));
                                });
                              },
                            )),
                        Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: SocialNetworkLogo(
                              pathLogo: "images/facebook.jpg",
                              onPresed: () {
                                userBloc!.signOut();
                                userBloc!
                                    .signInWithFacebook()
                                    .then((userCredential) {
                                  userBloc!.updateUserData(model_user.User(
                                      userId: userCredential.user!.uid,
                                      name: userCredential.user!.displayName!,
                                      email: userCredential.user!.email!,
                                      photoURL:
                                          userCredential.user!.photoURL!));
                                });
                              },
                            ))
                      ]),
                  CustomButton(
                    text: "CREAR CUENTA",
                    fontSize: 20.0,
                    onPressed: () {},
                    //width: 300.0,
                    height: 70.0,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
