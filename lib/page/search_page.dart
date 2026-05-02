import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'meal_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<dynamic> results = [];
  bool loading = false;

  void searchMeals() async {
    final keyword = controller.text.trim();
    if (keyword.isEmpty) return;
    setState(() => loading = true);
    try {
      results = await ApiService.searchMeals(keyword);
    } catch (e) {
      results = [];
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cari Masakan")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Masukkan kata kunci...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchMeals,
                ),
              ),
              onSubmitted: (_) => searchMeals(),
            ),
            SizedBox(height: 16),
            if (loading) CircularProgressIndicator(),
            if (!loading && results.isEmpty && controller.text.isNotEmpty)
              Text("Maaf, masakan tidak ditemukan."),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final meal = results[index];
                  return ListTile(
                    leading: Image.network(meal['strMealThumb']),
                    title: Text(meal['strMeal']),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => MealDetailPage(mealId: meal['idMeal']),
                      ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
