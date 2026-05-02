import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MealDetailPage extends StatelessWidget {
  final String mealId;
  MealDetailPage({required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Masakan")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchMealDetail(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final meal = snapshot.data!;
            List<Widget> ingredients = [];
            for (int i = 1; i <= 20; i++) {
              final ingredient = meal['strIngredient$i'];
              final measure = meal['strMeasure$i'];
              if (ingredient != null && ingredient.isNotEmpty) {
                ingredients.add(Text("$ingredient - $measure"));
              }
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal['strMealThumb']),
                  SizedBox(height: 8),
                  Text(meal['strMeal'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Kategori: ${meal['strCategory']}"),
                  Text("Area: ${meal['strArea']}"),
                  SizedBox(height: 16),
                  Text("Instruksi:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(meal['strInstructions']),
                  SizedBox(height: 16),
                  Text("Bahan-bahan:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...ingredients,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
