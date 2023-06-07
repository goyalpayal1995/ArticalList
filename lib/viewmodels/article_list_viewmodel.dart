import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';
import '../database.dart';


class ArticleListViewModel {
  final String apiKey = 'arQ1uK4JfApqpzTKozaWIZs4FAGsq7si'; // Replace with your NY Times API key
  int _pageNumber = 0;
  final _articlesController = StreamController<List<ArticleViewModel>>.broadcast();
  Stream<List<ArticleViewModel>> get articlesStream => _articlesController.stream;
  List<ArticleViewModel> _articles = [];

  Future<bool> _isDeviceOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("true");
      // You have an internet connection
      return true;
    } else {
      print("false");
      // You don't have an internet connection
      return false;
    }
  }

  Future<void> fetchArticles() async {
    try {
      final isOnline = await _isDeviceOnline();
      if (isOnline) {
        _pageNumber = 0; // Reset page number for new fetch
        _fetchArticlesFromApi();
      } else {
        _fetchArticlesFromDatabase();
      }
    } catch (error) {
      throw Exception('Error fetching articles: $error');
    }
  }

  Future<void> _fetchArticlesFromApi() async {
    _pageNumber++;
    final url =
        'https://api.nytimes.com/svc/mostpopular/v2/viewed/$_pageNumber.json?api-key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);

    final articles = List<Article>.from(jsonData['results']
        .map((articleJson) => Article.fromJson(articleJson)));

    // Save articles to the database only for the first page

      await DatabaseHelper.clearArticles();
      for (var article in articles) {
        await DatabaseHelper.insertArticle(article);
      }


    final articleViewModels =
    articles.map((article) => ArticleViewModel(article)).toList();
    _articles.addAll(articleViewModels);
    _articlesController.add(_articles);
  }

  Future<void> _fetchArticlesFromDatabase() async {
    final articles = await DatabaseHelper.getArticles();
    final articleViewModels =
    articles.map((article) => ArticleViewModel(article)).toList();
    _articles.addAll(articleViewModels);
    _articlesController.add(_articles);
  }

  void searchArticles(String query) async {

    try {
      final url =
          'https://api.nytimes.com/svc/search/v2/articlesearch.json?api-key=$apiKey&q=$query';
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);
      debugPrint("Request: Url :- ${jsonData}  }",
          wrapWidth: 1024);
      print(jsonData);
      final articles = List<Article>.from(jsonData['response']['docs']
          .map((articleJson) => Article.fromJson(articleJson)));

      final articleViewModels =
      articles.map((article) => ArticleViewModel(article)).toList();
      _articlesController.sink.add(articleViewModels);
    } catch (error) {
      _articlesController.sink.addError(error);
    }
  }

  void dispose() {
    _articlesController.close();
  }
}

class ArticleViewModel {
  final Article article;

  ArticleViewModel(this.article);

  String get title => article.title;
  String get abstract => article.abstract;
}
