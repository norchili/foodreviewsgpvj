import 'package:flutter/material.dart';
import 'package:foodgpvjreviews/Bloc/bloc.dart';
import 'package:foodgpvjreviews/widgets/custom_button.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class FoodGPVJMainApp extends StatelessWidget {
  const FoodGPVJMainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);
    return Scaffold(
        body: Stack(alignment: AlignmentDirectional.bottomStart, children: [
      CustomButton(
          text: "Cerrar Sesion",
          fontSize: 20.0,
          onPressed: () {
            userBloc.signOut();
          },
          height: 70.0)
    ]));
  }
}
