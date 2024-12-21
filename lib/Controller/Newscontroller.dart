import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/newsmodel.dart';

class NewsController extends GetxController {
  var isLoading = true.obs;
  var articles = <Article>[].obs;
  var categories = <Category>[].obs;
  var selectedCategory = "general".obs;

  final String apiKey = 'e6f2a387aa7f4d6cb11c73a90242fe7a';

  @override
  void onInit() {
    loadCategories();
    fetchNews();
    super.onInit();
  }

  void loadCategories() {
    categories.value = [
      Category(name: "General", icon: "🌎"),
      Category(name: "Technology", icon: "💻"),
      Category(name: "Business", icon: "💼"),
      Category(name: "Sports", icon: "⚽"),
      Category(name: "Entertainment", icon: "🎬"),
      Category(name: "Health", icon: "🏥"),
      Category(name: "Science", icon: "🔬"),
    ];
  }

  Future<void> fetchNews() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=${selectedCategory.value}&apiKey=$apiKey'
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        
        // Clear existing articles before adding new ones
        articles.clear();
        articles.addAll(
          articlesJson.map((articleJson) => Article.fromJson(articleJson)).toList()
        );
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      throw e; // Re-throw the error to be handled by the UI
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshNews() async {
    try {
      articles.clear(); // Clear existing articles
      await fetchNews(); // Fetch new articles
    } catch (e) {
      print('Error refreshing news: $e');
      throw e; // Make sure to re-throw the error
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category.toLowerCase();
    fetchNews();
  }
}