import 'package:article/view/articles.dart';
import 'package:article/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('NY Times Articles'),

      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            if (_currentPosition != null)
              Text(
                'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
                style: TextStyle(fontSize: 12),
              ),
            Text(
              "Search",

              style: TextStyle(

                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
            ),
            Divider(
              color: Colors.black,
            ),
            getimageWithNameAndOptionalArrow( "Search page"  ),

            const SizedBox(height: 50,),
            const Text(
              "Popular",
              style: TextStyle(
                  fontFamily: "Nunito",
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400),
            ),
            const Divider(
              color: Colors.black,
            ),
            getimageWithNameAndOptionalArrow( "Most Viewed"  ),

            getimageWithNameAndOptionalArrow( "Most Shared"  ),
            getimageWithNameAndOptionalArrow( "Most Emailed"  ),
          ],
        )
      )
    );
  }

  Widget getimageWithNameAndOptionalArrow(Title
     ) {
    return Container(
            color: Colors.transparent,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  InkWell(
                      onTap: () {
                        if(Title=='Search page')
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchPage()),
                            );
                          }
                      else  if(Title=='Most Viewed')
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ArticlesListPage("")),
                          );
                        }

                      },
                      child:  Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [

                            Text(
                              Title,
                              style: const TextStyle(

                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_sharp),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      )
                  ),
                  Divider(
                    color: Colors.black,
                  ),

                ]));
  }
}
