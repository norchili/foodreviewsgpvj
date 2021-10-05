import 'package:flutter/material.dart';

class FoodPlace {
  final String? id;
  final String name;
  final String description;
  final String urlImage;
  int likes;
  final String? category;
  final List<String>? usersLiked;
  bool liked;

  //final User? userOwner;

  FoodPlace(
      {Key? key,
      this.id,
      required this.name,
      required this.description,
      this.urlImage = "https://imgur.com/eJsTDCs",
      this.likes = 0,
      this.category,
      this.liked = false,
      this.usersLiked});
}
