import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/Controller/newscontroller.dart';
import 'package:newsapp/Model/newsmodel.dart';
import 'package:url_launcher/url_launcher.dart';

// Move NewsCard class before NewsView
class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({required this.article, Key? key}) : super(key: key);

  Future<void> _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: InkWell(
        onTap: () => _launchURL(article.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.network(
                  article.urlToImage!,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 350,
                      color: Colors.grey[300],
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),

            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    article.description ?? 'No Description',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.source, size: 16),
                      SizedBox(width: 4),
                      Text(
                        article.source ?? 'Unknown Source',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Spacer(),
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 4),
                      Text(
                        _formatDate(article.publishedAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }
}

class NewsView extends StatelessWidget {
  final NewsController controller = Get.put(NewsController());

  NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Categories Horizontal ListView
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(category.icon),
                            SizedBox(width: 4),
                            Text(category.name),
                          ],
                        ),
                        selected: controller.selectedCategory.value ==
                            category.name.toLowerCase(),
                        onSelected: (_) => controller.changeCategory(category.name),
                        backgroundColor: Colors.grey[200],
                        selectedColor: Colors.blue[100],
                        labelStyle: TextStyle(color: Colors.black87),
                      ),
                    );
                  },
                )),
          ),

          // News Articles ListView
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                onRefresh: () async {
                  try {
                    await controller.refreshNews();
                    Get.snackbar(
                      'Success',
                      'News updated successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.8),
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.all(8),
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to refresh news: ${e.toString()}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.8),
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.all(8),
                    );
                  }
                },
                child: controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.articles.isEmpty
                            ? 1
                            : controller.articles.length,
                        itemBuilder: (context, index) {
                          if (controller.articles.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height - 150,
                              child: Center(
                                child: Text('No articles available'),
                              ),
                            );
                          }
                          return NewsCard(article: controller.articles[index]);
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}