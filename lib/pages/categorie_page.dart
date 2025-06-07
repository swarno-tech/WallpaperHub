import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperhub/data/wallpaper_model.dart';
import 'package:wallpaperhub/widgets/wallpaper.dart';
import 'package:http/http.dart' as http;

class CategoriePage extends StatefulWidget {
  final String categoryName;
  const CategoriePage({super.key, required this.categoryName});

  @override
  State<CategoriePage> createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  List<WallpaperModel> wallpapers = [];
  getCategoryWallpaper(String query) async {
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=30"),
      headers: {
        "Authorization":
            "zTpJHKqQiIGJqJRl7NpAJ6pzOhB9Xf4xiPWYjsLZfCFn9axWRqP5ArFb",
      },
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel(
        portrait: element['src']['portrait'],
      );
      wallpapers.add(wallpaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCategoryWallpaper(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
            children: [
              TextSpan(text: "Wallpaper"),
              TextSpan(
                text: "Hub",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: wallpaperList(wallpapers, context)));
  }
}
