import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Map planet;

  DetailScreen({super.key, required this.planet});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animationController.forward();
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool isFavorite = false;

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePlanets = prefs.getStringList('favorites') ?? [];

    setState(() {
      isFavorite = favoritePlanets.contains(widget.planet['name']);
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePlanets = prefs.getStringList('favorites') ?? [];

    setState(() {
      if (isFavorite) {
        favoritePlanets.remove(widget.planet['name']);
      } else {
        favoritePlanets.add(widget.planet['name']);
      }
      isFavorite = !isFavorite;
    });

    await prefs.setStringList('favorites', favoritePlanets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detail Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: _toggleFavorite,
              icon: (isFavorite)
                  ? Icon(Icons.bookmark)
                  : Icon(Icons.bookmark_border))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Image.network(
                widget.planet['image'],
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text("Failed to load image");
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.planet['name'],
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            SizedBox(height: 10),
            Text(
              widget.planet['description'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
