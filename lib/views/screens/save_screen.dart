import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<String> favoritePlanets = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePlanets = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _removeFromFavorites(String planetName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePlanets.remove(planetName);
    });
    await prefs.setStringList('favorites', favoritePlanets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Favorite Planets",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _loadFavorites, // Pull-to-refresh feature
        child: favoritePlanets.isEmpty
            ? Center(
                child: Text(
                  "No favorites yet!",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: favoritePlanets.length,
                itemBuilder: (context, i) {
                  return Card(
                    color: Colors.deepPurple.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          favoritePlanets[i],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _removeFromFavorites(favoritePlanets[i]),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
