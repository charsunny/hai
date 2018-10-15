import 'package:flutter/material.dart';
import 'user.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'poem.dart';
import 'section.dart';
import 'poemitem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

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
    return MyHomePage(key: appStateKey,);
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

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  
  List<PoemItem> collections = [];
  List<PoemItem> poems = [];
  List<PoemItem> favPoems = [];
  List<PoemItem> favSections = [];

  TabController _tabBarController;

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
      fluwx.register(appId: 'wx8d80d52485f4cb05');
      _tabBarController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  Future<bool> _loaddata() async {
    var prefs = await SharedPreferences.getInstance();
    PoemData().sectionIndex = prefs.getInt("selSection") == null ? 0 : prefs.getInt("selSection");
    PoemData().poemIndex = prefs.getInt("selPoem") == null ? 0 :  prefs.getInt("selPoem");
    var favp = prefs.getStringList("favp") == null ? [] : prefs.getStringList("favp");
    var favs = prefs.getStringList("favs") == null ? [] : prefs.getStringList("favs");
    if (favp != null) {
      PoemData().favPoems = favp.map((f) => PoemItem.fromString(f)).toList();
    }
    if (favs != null) {
      PoemData().favSections = favs.map((f) => PoemItem.fromString(f)).toList();
    }
    var val = await rootBundle.loadString('assets/configs/image.json');
    var list1 =json.decode(val);
    var val1 = await rootBundle.loadString('assets/configs/collection.json');
    var list = json.decode(val1);
    List<PoemItem> list2 = list.map<PoemItem>((l) {
      PoemItem item = PoemItem.fromJson(l);
      var idx = list.indexOf(l);
      var image = list1[idx % list1.length];
      item.imageUrl = image["list"][0]["big"];
      return item;
    }).toList();
    var val2 =  await rootBundle.loadString('assets/configs/article.json');
    var list3 = json.decode(val2);
    List<PoemItem> list4= [];
    list3.forEach((l) {
      var lp = l["data"];
      lp.forEach((p) {
        PoemItem item = PoemItem.fromJson(p);
        var idx = lp.indexOf(p);
        var image = list1[(list1.length - idx - 1) % list1.length];
        item.imageUrl = image["list"][0]["big"];
        list4.add(item);
      });
    });
    PoemData().collections = list2;
    PoemData().poems = list4;
    print('data loaded ${list4.length}');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        fontFamily: 'shusong',
        primarySwatch: Colors.pink,
        primaryColorBrightness: Brightness.light,
      ),
      home: FutureBuilder(
        future: _loaddata(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data) {
            return CupertinoTabScaffold (
                tabBuilder: (content, index) {
                  var widget;
                  if (index == 1) {
                    widget = SectionPage(fav: false);
                  } else if (index == 0) {
                    widget = PoemPage(fav: false);
                  } else {
                    widget = UserPage();
                  }
                  return  widget;
                },
                tabBar: CupertinoTabBar(
                  iconSize: 28.0,
                  activeColor: Colors.pink,
                  //backgroundColor: Color(0x33FFFFFF),
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('诗歌')),
                    BottomNavigationBarItem(icon: Icon(Icons.bookmark), title: Text('字句')),
                    BottomNavigationBarItem(icon: Icon(Icons.account_box), title: Text('我的')),
                  ],
                )
            );
          } else {
            return Scaffold(
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
            );
          }
        },
      )
    );
  }
}
