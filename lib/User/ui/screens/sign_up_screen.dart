import 'package:flutter/material.dart';
import 'package:foodgpvjreviews/Bloc/bloc.dart';
import 'package:foodgpvjreviews/User/model/user.dart';
import 'package:foodgpvjreviews/User/ui/widgets/login_gradient_back.dart';
import 'package:foodgpvjreviews/User/ui/widgets/logo_social_network.dart';
import 'package:foodgpvjreviews/User/ui/widgets/text_input.dart';
import 'package:foodgpvjreviews/responses/sign_in_response.dart';
import 'package:foodgpvjreviews/widgets/custom_button.dart';
import 'package:foodgpvjreviews/widgets/error_alert_dialog.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreen();
  }
}

class _SignUpScreen extends State<SignUpScreen> {
  late final UserBloc userBloc;
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerName;
  late TextEditingController _controllerPassword;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerName = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    double screenWidht = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const LoginGradientBack(),
          Container(
              margin:
                  const EdgeInsets.only(top: 180.0, left: 15.0, right: 15.0),
              child: ListView(children: <Widget>[
                Column(
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
                    space(1.0, screenWidht),
                    Flexible(
                        child: SizedBox(
                            width: screenWidht,
                            //margin: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                            child: const Text(
                                "¡Crea una cuenta para continuar!",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xFFBBBCC2),
                                    fontWeight: FontWeight.bold)))),
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
                    TextInput(
                      hintText: "Nombre completo",
                      inputType: TextInputType.name,
                      controller: _controllerName,
                      prefixIconData: Icons.person_outlined,
                      fontSize: 14.0,
                      titleText: 'Nombre',
                    ),
                    space(20.0, screenWidht),
                    TextInput(
                      hintText: "Contraseña",
                      inputType: TextInputType.visiblePassword,
                      controller: _controllerPassword,
                      prefixIconData: Icons.lock_outlined,
                      fontSize: 14.0,
                      titleText: 'Nombre',
                    ),
                    CustomButton(
                      text: "Crear cuenta",
                      fontSize: 16.0,
                      onPressed: () {
                        //Metodo para regitrar usuario nuevo en Firebase
                      },
                      height: 60.0,
                    ),
                    space(15.0, screenWidht),
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
                      widht: screenWidht,
                      pathLogo: "images/google.jpg",
                      onPresed: () {
                        userBloc.signOut();
                        userBloc.signIn().then((response) {
                          if (response.error == null && response.user != null) {
                            userBloc.updateUserData(User(
                                userId: response.user!.uid.toString(),
                                name: response.user!.displayName.toString(),
                                email: response.user!.email.toString(),
                                photoURL: response.user!.photoURL.toString()));
                            const CircularProgressIndicator();
                          } else {
                            //mostrar cuadro de error
                            _showErrorDialog(context, response);
                          }
                        });
                      },
                    ),
                  ],
                )
              ]))
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
      userBloc.updateUserData(User(
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
