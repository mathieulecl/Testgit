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
  void iniState(){
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ('Actualités'),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          onTap: (){
            _launchUrl(
              Uri.parse(article.url ?? ""),
            );
          } ,
          leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
              ? Image.network(
            article.urlToImage!,
            height: 250,
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              // En cas d'erreur lors du chargement de l'image, affichez l'image locale
              return Image.asset(
                'assets/image/artus.jpg',
                height: 250,
                width: 100,
                fit: BoxFit.cover,
              );
            },
          )
              : Image.asset(
            'assets/image/artus.jpg',
            height: 250,
            width: 100,
            fit: BoxFit.cover,
          ),


          title: Text(
            article.title ?? "",
          ),
          subtitle: Text(article.publishedAt ?? "",),
        );
      },
    );
  }

  Future<void> getNews() async {
    final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=fr&category=business&apiKey=$NEWS_API_KEY'
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List <Article> newsArticle =
      articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle=newsArticle.where((a) => a.title != "[Removed]").toList();
      articles=newsArticle;

    });
  }

  @override
  void initState() {
    super.initState();
    getNews(); // Appel de la fonction pour récupérer les actualités au moment de l'initialisation de la page
  }

  Future<void> _launchUrl(Uri url) async{
    if (!await launchUrl(url)){
      throw Exception('Could not launch $url ');
    }
  }
}
