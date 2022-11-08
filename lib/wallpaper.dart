import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'fullscreen.dart';

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
 
  
  List images = [];
  int page = 1;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
 
    
   
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
    
        headers: {'Authorization': '563492ad6f91700001000001c75e8317e8174352a8c62d1cc566d20c'}).then((value) {
      Map result = jsonDecode(value.body);
      // print(result);
      setState(() {
        images = result["photos"];
      });
       print(images);
    });

    
  }

  loadmore() async {
    
    setState(() {
      page = page + 1;
      loading = true;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {'Authorization': '563492ad6f91700001000001c75e8317e8174352a8c62d1cc566d20c'}).then(
        (value) {
        
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result["photos"]);
      });
    });

    setState(() {
      loading = false;
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         
          Expanded(
            child: Container(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(
                                      imageurl: images[index]['src']['large2x'],
                                    )));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          images[index]['src']['tiny'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child:  Center(
                child: loading? Center(child: CircularProgressIndicator()) :Text('Load More',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}