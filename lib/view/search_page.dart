import 'package:article/view/articles.dart';
import 'package:flutter/material.dart';
import '../viewmodels/article_list_viewmodel.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text('Search'),

        ),
        body: Container(
child: Column(
  children: [
        Container(
      height: 45,

      alignment: Alignment.center,


      decoration: BoxDecoration(
          color:  Colors.black,
          border: Border.all(
              color:   Colors.white,
              width: 1
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      margin: EdgeInsets.only(top:10,bottom: 10,right: 10),
      padding: EdgeInsets.only(left:10),

      child: TextField(

        style: TextStyle(

            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w400),
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search articles here...',
          hintStyle: TextStyle(

              color: Colors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.w400),
          border: InputBorder.none,
        ),

        autofocus: true,
        textInputAction: TextInputAction.none,

      )



    ),

 InkWell(

          onTap: () {
            if(_searchController.text=='')
              {

              }
            else
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ArticlesListPage(_searchController.text)),
                );
              }

          },
          child:      Container(
              height: 45,

              alignment: Alignment.center,


              decoration: BoxDecoration(
                  color:  Colors.black,
                  border: Border.all(
                      color:   Colors.white,
                      width: 1
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.only(top:10,bottom: 10,right: 10),
              padding: EdgeInsets.only(left:10),
              child:  Text(
              "Search",
              style: TextStyle(

                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),

          ))
      ),

  ],
)
        )
    );
  }


}
