import 'package:flutter/material.dart';
import '../viewmodels/article_list_viewmodel.dart';

class ArticlesListPage extends StatefulWidget {
  String ? query;


  ArticlesListPage(this.query, {super.key});

  @override
  _ArticlesListPageState createState() => _ArticlesListPageState();
}

class _ArticlesListPageState extends State<ArticlesListPage> {
  final ArticleListViewModel _articleListViewModel = ArticleListViewModel();

  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if(widget.query!.isNotEmpty) {
      _performSearch(widget.query!);
    }
    else
      {
        _articleListViewModel.fetchArticles();
        _scrollController.addListener(_scrollListener);
      }

  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _articleListViewModel.fetchArticles();
    }
  }


  void _performSearch(String query) {
    print(query);
    _articleListViewModel.searchArticles(query);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Articles'),

      ),
      body: StreamBuilder<List<ArticleViewModel>>(
        stream: _articleListViewModel.articlesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData)
          {
            final articles = snapshot.data!;
            return  ListView.builder(
              controller: _scrollController,
              itemCount: widget.query!.isNotEmpty?  articles.length: articles.length + 1,
              itemBuilder: (context, index) {
                if(widget.query!.isNotEmpty)
                  {

                      final article = articles[index];
                      return ListTile(
                        title: Text(article.title),
                        subtitle: Text(article.abstract),
                      );

                  }
                else{
                  if (index < articles.length) {
                    final article = articles[index];
                    return ListTile(
                      title: Text(article.title),
                      subtitle: Text(article.abstract),
                    );
                  } else {
                    return _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox();
                  }
                }

              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching articles'),
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
