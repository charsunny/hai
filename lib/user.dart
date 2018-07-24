import 'package:flutter/material.dart';
import 'package:hai/poem.dart';
import 'package:hai/section.dart';
import 'package:hai/sectiondata.dart';

class UserPage extends StatefulWidget {
  final String title;

  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold (
        appBar: AppBar(
          title: Text("收藏"), 
          backgroundColor: Colors.black87,
          bottom: TabBar(
            tabs: [
              Tab(text: '字句'),
              Tab(text: '诗词'),
            ],
        ),),
        body: TabBarView (
          physics:NeverScrollableScrollPhysics(),
          children: [
            SectionPage(items: []),
            PoemPage(items: [])
          ]
        ),
    ));
  }
}
