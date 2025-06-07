import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaperhub/data/categories_data.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhub/data/wallpaper_model.dart';
import 'package:wallpaperhub/pages/categorie_page.dart';
import 'package:wallpaperhub/pages/search_page.dart';
import 'package:wallpaperhub/widgets/wallpaper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  List<WallpaperModel> wallpapers = [];
  var searchController = TextEditingController();
  //function
  getWallpaper() async {
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=30&page=1"),
      headers: {
        "Authorization":
            "zTpJHKqQiIGJqJRl7NpAJ6pzOhB9Xf4xiPWYjsLZfCFn9axWRqP5ArFb",
      },
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element['src']['portrait']);
      WallpaperModel wallpaperModel = WallpaperModel(
        portrait: element['src']['portrait'],
      );
      wallpapers.add(wallpaperModel);
    });
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getWallpaper();
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
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              if (searchController.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Search valid things"),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SearchPage(
                                        searchText: searchController.text,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.search, size: 30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "Made By ",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: " Alvin",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CategoriePage(
                                      categoryName:
                                          categoriData[index]['name'] as String,
                                    );
                                  },
                                ),
                              );
                            },
                            child: CategoryWidget(
                              imageName: categoriData[index]['name'] as String,
                              url: categoriData[index]['url'] as String,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    wallpaperList(wallpapers, context),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String imageName;
  final String url;
  const CategoryWidget({super.key, required this.imageName, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: Image.asset(url, height: 100, width: 80, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.circular(8),
              color: Colors.black26,
            ),
            alignment: Alignment.center,
            height: 100,
            width: 80,
            child: Text(
              imageName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
