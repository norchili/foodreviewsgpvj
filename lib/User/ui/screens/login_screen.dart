import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgpvjreviews/Bloc/bloc.dart';
import 'package:foodgpvjreviews/User/model/user.dart' as model_user;
import 'package:foodgpvjreviews/User/ui/widgets/login_gradient_back.dart';
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
          Column(
            children: <Widget>[
              Flexible(
                  child: Container(
                      width: screenWidht,
                      margin: const EdgeInsets.only(
                          top: 200.0, left: 20.0, right: 20.0),
                      child: const Text("Vamos a empezar",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))),
              Flexible(
                  child: Container(
                      width: screenWidht,
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0),
                      child: const Text("Crea una cuenta para continuar",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFFBBBCC2),
                              fontWeight: FontWeight.bold)))),
              CustomButton(
                text: "CREAR CUENTA",
                fontSize: 20.0,
                onPressed: () {
                  userBloc!.signOut();
                  userBloc!.signIn().then((value) {
                    userBloc!.updateUserData(model_user.User(
                        userId: value!.user!.uid.toString(),
                        name: value.user!.displayName.toString(),
                        email: value.user!.email.toString(),
                        photoURL: value.user!.photoURL.toString()));
                  });
                },
                //width: 300.0,
                height: 70.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
