import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_planet/views/screens/detail_screen.dart';
import 'package:galaxy_planet/views/screens/save_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List Planets = [];

  @override
  void initState() {
    super.initState();
    loadjsonfile();
  }

  loadjsonfile() async {
    String jsonData = await rootBundle.loadString('assets/json/data.json');
    List decodedData = jsonDecode(jsonData);
    setState(() {
      Planets = decodedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            "Galaxy Planet",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).isDarkMode
                    ? Icons.wb_sunny
                    : Icons.nights_stay,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SaveScreen()));
                },
                icon: Icon(Icons.bookmark))
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, i) {
            return Card(
              elevation: 2,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(planet: Planets[i])));
                },
                child: Container(
                  height: 280,
                  width: 250,
                  child: Column(
                    children: [
                      Image.network(
                        '${Planets![i]['image']}',
                        height: 250,
                      ),
                      Text(
                        "${Planets![i]['name']}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: Planets.length,
        ),
      ),
    );
  }
}
