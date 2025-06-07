import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/wallpaper_model.dart';
import 'package:wallpaperhub/widgets/wallpaper.dart';
 
class SearchPage extends StatefulWidget {
  final String searchText;
  const SearchPage({super.key, required this.searchText});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<WallpaperModel> wallpapers = [];
  var searchController = TextEditingController();
  getSearchWallpaper(String query) async {
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
    searchController.text = widget.searchText;
    getSearchWallpaper(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(30),
                ),
                elevation: 2.0,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Color(0xfff5f8fd)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: Color(0xfff5f8fd)),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        wallpapers = [];
                        getSearchWallpaper(searchController.text);
                        setState(() {});
                      },
                      icon: Icon(Icons.search, size: 30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              wallpaperList(wallpapers, context),
            ],
          ),
        ),
      ),
    );
  }
}
