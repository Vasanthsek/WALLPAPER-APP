import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';



class FullScreen extends StatefulWidget {
  final String imageurl;
  
  FullScreen({Key? key, required this.imageurl,}) : super(key: key);
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool finished = false;
  bool loading = false;
  bool initial = true;
  Future<void> setwallpaper() async {
    setState(() {
         initial = false;
         loading = true;
       }); 
    int location = WallpaperManager.HOME_SCREEN;

    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
     bool result =
       await WallpaperManager.setWallpaperFromFile(file.path, location);
       setState(() {
         finished = true;
         loading = false;
       }); 


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: Container(
              
              child: Image.network(widget.imageurl,fit: BoxFit.cover,),
            ),
          ),
          
          InkWell(
            onTap: () {
              setwallpaper();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  if(loading)
                  const Center(child: CircularProgressIndicator(),),
                  if(finished)
                  const Center(child:Icon(IconData(0xe156, fontFamily: 'MaterialIcons'))),
                  if(initial)
      
                  const Center(
                    child:  Text('Set Wallpaper',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

