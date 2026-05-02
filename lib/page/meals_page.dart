import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'meal_detail_page.dart';

class MealsPage extends StatefulWidget {
  final String category;
  MealsPage({required this.category});

  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  late Future<List<dynamic>> meals;

  @override
  void initState() {
    super.initState();
    meals = ApiService.fetchMealsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Masakan: ${widget.category}")),
      body: FutureBuilder<List<dynamic>>(
        future: meals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final meal = data[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(meal['strMealThumb']),
                    title: Text(meal['strMeal']),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => MealDetailPage(mealId: meal['idMeal']),
                      ));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
