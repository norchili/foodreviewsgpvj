import 'package:flutter/material.dart';

class User {
  final String? userId;
  final String name;
  final String email;
  final String photoURL;
  //final List<FoodPlace>? myPlaces;
  //final List<FoodPlace>? myFavoriteFoodPlaces;

  User(
      {Key? key,
      this.userId,
      //this.myFavoritePlaces,
      //this.myPlaces,
      required this.name,
      required this.email,
      required this.photoURL});
}
