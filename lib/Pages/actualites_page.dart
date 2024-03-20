import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import 'const.dart'; // Assurez-vous d'importer correctement votre fichier const.dart

class ActualitesPage extends StatefulWidget {
  @override
  _ActualitesPageState createState() => _ActualitesPageState();
}

class _ActualitesPageState extends State<ActualitesPage> {
  final Dio dio = Dio();

  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    getNews(); // Appel de la fonction pour récupérer les actualités au moment de l'initialisation de la page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(

        title: Text(
          'Actualités',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Nombre de colonnes dans le GridView
        crossAxisSpacing: 12.0, // Espacement horizontal entre les éléments du GridView
        mainAxisSpacing: 12.0, // Espacement vertical entre les éléments du GridView
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return GestureDetector(
          onTap: () {
            _launchUrl(Uri.parse(article.url ?? ""));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!), // Bordure grise
              borderRadius: BorderRadius.circular(8.0), // Bord arrondi
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: article.urlToImage != null &&
                      article.urlToImage!.isNotEmpty
                      ? Image.network(
                    article.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      // En cas d'erreur lors du chargement de l'image, affichez l'image locale
                      return Image.asset(
                        'assets/image/artus.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/image/artus.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    article.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,)

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    article.publishedAt ?? "",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getNews() async {
    final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=fr&category=business&apiKey=$NEWS_API_KEY');
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
      articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url ');
    }
  }
}
