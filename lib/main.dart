import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodgpvjreviews/Bloc/bloc.dart';
import 'package:foodgpvjreviews/User/ui/screens/login_screen.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong(error: snapshot.error);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  final Object? error;
  const SomethingWentWrong({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _error =
        error == null ? error.toString() : "No hay datos en el error";
    return Scaffold(
        body: Center(
            child: Text(
                "Error al conectar con Firebase, revisa tu conexion a Internet \nError: $_error")));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MaterialApp(
          theme: ThemeData(
              // Color por default es blue
              // Font por default es Comfortaa
              primarySwatch: Colors.blue,
              fontFamily: 'Comfortaa'),
          home: const LoginScreen(),
        ),
        bloc: UserBloc());
  }
}
