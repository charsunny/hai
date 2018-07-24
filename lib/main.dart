import 'package:flutter/material.dart';
import 'package:hai/user.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:hai/poem.dart';
import 'package:hai/section.dart';
import 'package:hai/sectiondata.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        fontFamily: 'shusong',
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(title: '首页')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int currentIndex = 0;

  List<PoemItem> collections = [];
  List<PoemItem> poems = [];

  bool isLoading = true;

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height == 812.0 || size.width == 812.0) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
      super.initState();
      rootBundle.loadString('assets/configs/image.json').then((val){
        var list1 =json.decode(val);
        rootBundle.loadString('assets/configs/collection.json').then((val1){
          var list = json.decode(val1);
          List<PoemItem> list2 = list.map<PoemItem>((l) {
            PoemItem item = PoemItem.fromJson(l);
            var idx = list.indexOf(l);
            var image = list1[idx % list1.length];
            item.imageUrl = image["list"][0]["big"];
            return item;
          }).toList();
          setState(() {
            isLoading = false;
            collections = list2;
          });
        });
        rootBundle.loadString('assets/configs/article.json').then((val1){
          var list = json.decode(val1);
          List<PoemItem> list2 = [];
          list.forEach((l) {
            var lp = l["data"];
            lp.forEach((p) {
              PoemItem item = PoemItem.fromJson(p);
              var idx = lp.indexOf(p);
              var image = list1[(list1.length - idx - 1) % list1.length];
              item.imageUrl = image["list"][0]["big"];
              list2.add(item);
            });
          });
          setState(() {
            poems = list2;
          });
        });
      });
  }

  void switchTab(int idx) {
    setState(() {
      currentIndex = idx; 
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          Image.asset("assets/splash.png", width: size.width, height: size.height),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 240.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ) 
          )
      ],));
    }
    var paddingBottom = _isIPhoneX(MediaQuery.of(context)) ? 40.0 : 0.0;
    return DefaultTabController(
      length: 3,
      child: Scaffold (
        body: TabBarView (
          physics:NeverScrollableScrollPhysics(),
          children: [
            SectionPage(items: collections),
            PoemPage(items: poems),
            UserPage()
          ]
        ),
        bottomNavigationBar: new Container(
          color: Colors.black,
          constraints: BoxConstraints(minHeight: 40.0),
          padding: EdgeInsets.only(bottom: paddingBottom),
          child: new Material(
            color: Colors.black,
            child: new TabBar(
              tabs: [
                Tab(text: '字句'),
                Tab(text: '诗词'),
                Tab(text: '收藏')
              ],
            ),
          ),
        ),
    ));
  }
}
