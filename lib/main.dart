import 'package:flutter/material.dart';
import 'user.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'poem.dart';
import 'section.dart';
import 'poemitem.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

final GlobalKey<MyHomePageState> appStateKey = new GlobalKey<MyHomePageState>();

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        fontFamily: 'shusong',
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(key: appStateKey,)
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  MyHomePage({Key key}) :super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with AfterLayoutMixin<MyHomePage> {
  
  int sectionIndex = 0;
  int poemIndex = 0;

  List<PoemItem> collections = [];
  List<PoemItem> poems = [];
  List<PoemItem> favPoems = [];
  List<PoemItem> favSections = [];

  bool _isLoading = true;

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height == 812.0 || size.width == 812.0) {
        return true;
      }
    }
    return false;
  }

  changeSections( List<PoemItem> sections) {
    setState(() {
        this.favSections = sections;  
    });
  }

  changePoems( List<PoemItem> poems) {
    setState(() {
        this.favPoems = poems;  
    });
  }

  @override
  void initState() {
      super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (_isLoading) {
        SharedPreferences.getInstance().then((prefs) {
          var sidx = prefs.getInt("selSection");
          var pidx = prefs.getInt("selPoem");
          var favp = prefs.getStringList("favp");
          var favs = prefs.getStringList("favs");
          if (favp != null) {
            favPoems = favp.map((f) => PoemItem.fromString(f)).toList();
          }
          if (favs != null) {
            favSections = favs.map((f) => PoemItem.fromString(f)).toList();
          }
          setState(() {
            this.sectionIndex = sidx; 
            this.poemIndex = pidx;
            this.favPoems = favPoems;
            this.favSections = favSections;
          });
          loadData();
        });
      }
  }

  void loadData() {
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
            _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new MaterialApp(
        theme: new ThemeData(
          fontFamily: 'shusong',
          primarySwatch: Colors.pink,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: <Widget>[
            Container(
              child: Image.asset("assets/splash.png"),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 240.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                ),
              ) 
            )
        ],)
        )
      );
    }
    var paddingBottom = _isIPhoneX(MediaQuery.of(context)) ? 40.0 : 0;
    return new MaterialApp(
      theme: new ThemeData(
        fontFamily: 'shusong',
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold (
          body: TabBarView (
            physics:NeverScrollableScrollPhysics(),
            children: [
              SectionPage(items: collections, selIndex: sectionIndex,),
              PoemPage(items: poems, selIndex: poemIndex,),
              UserPage(favPoems:favPoems, favSections: favSections),
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
      ))
    );
  }
}
