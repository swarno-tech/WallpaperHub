import 'package:flutter/material.dart';
import 'package:wallpaperhub/data/wallpaper_model.dart';
import 'package:wallpaperhub/pages/image_page.dart';

Widget wallpaperList(List<WallpaperModel> wallpapers, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      childAspectRatio: 0.6,
      children: wallpapers.map((wallpaper) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ImagePage(imageUrl: wallpaper.portrait,);
                },
              ),
            );
          },
          child: GridTile(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: Image.network(wallpaper.portrait, fit: BoxFit.cover),
            ),
          ),
        );
      }).toList(), //list of widget
    ),
  );
}
