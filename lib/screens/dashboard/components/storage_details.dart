import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/article.dart';
import 'const.dart'; // Assurez-vous d'importer correctement votre fichier const.dart

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatefulWidget {

  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  _StorageDetailsState createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  final Dio dio = Dio();
  late List<Article> articles;

  @override
  void initState() {
    super.initState();
    getNews();// Appel de la fonction pour récupérer les actualités au moment de l'initialisation de la page
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Répartition des crypto dans le monde",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          SizedBox(height: defaultPadding),
          Text(
            "Nos Articles",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.teal[100],
            ),
          ),
          Container(
            height: 400, // Taille spécifique pour la ListView
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    _launchUrl(Uri.parse(article.url ?? ""));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: defaultPadding),
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: primaryColor.withOpacity(0.15)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultPadding),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money), // Ajout de l'icône d'argent
                        SizedBox(width: defaultPadding),
                        // Image de l'article
                        if (article.urlToImage != null &&
                            article.urlToImage!.isNotEmpty)
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(defaultPadding),
                            child: Image.asset(
                              'assets/images/artus.png', // Chemin de l'image locale
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(width: defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre de l'article
                              Text(
                                article.title ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.teal[50],
                                ),
                              ),
                              // Description de l'article ou autre détail
                              Text(
                                article.description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
