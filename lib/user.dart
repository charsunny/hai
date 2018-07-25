import 'package:flutter/material.dart';
import 'poem.dart';
import 'section.dart';
import 'poemitem.dart';
import 'package:share/share.dart';


class UserPage extends StatelessWidget {

  UserPage({
    Key key,
    @required this.favSections,
    @required this.favPoems,
  }):super(key: key);

  final List<PoemItem> favPoems;
  final List<PoemItem> favSections;

  @override
  Widget build(BuildContext context) {
    Widget sp =  Container(
      color: Colors.black87,
      child: Center(
        child: Text(
          '暂无收藏',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
        )),
      ),
    );
    if (favSections.length > 0) {
      sp = SectionPage(items: favSections, selIndex: 0,);
    }
    Widget pp =  Container(
      color: Colors.black87,
      child: Center(
        child: Text(
          '暂无收藏',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white70,
          ),
        ),
      ),
    );
    if (favPoems.length > 0) {
      pp = PoemPage(items: favPoems, selIndex: 0,);
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold (
        appBar: AppBar(
          title: TabBar(
              tabs: [
                Tab(text: '字句 ( ${favSections.length} )'),
                Tab(text: '诗词 ( ${favPoems.length} )'),
              ],
          ), 
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share), color: Colors.white, onPressed: () {
              Share.share("海子的诗，app下载地址：https://charsunny.com/haizi");
            },)
          ],
          backgroundColor: Colors.black87,
          ),
        body: TabBarView (
          physics:NeverScrollableScrollPhysics(),
          children: [
            sp,
            pp
          ]
        ),
        drawer: Drawer(
          child:  Column(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage("assets/images/haizi.jpg",), 
                            fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          border: new Border.all(
                            color: Colors.pink,
                            width: 2.0,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5.0),),
                      Text(
                        "海子的诗",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: "yuesong"
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5.0),),
                      Text(
                        "天空一无所有 为何给我安慰",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white70
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.pink,
                ),
              ),
              Expanded(
                child:  Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    '陌生人\n感谢你和我一样\n面朝大海\n春暖花开 \n\n新朋友\n祝愿你和我一样\n享受诗歌\n热爱生活',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.3,
                    ),
                  ),
                ), 
                flex: 1,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child:  Text('使用flutter业余时间编写，如有问题和需求，请联系@charsunny')
              )
            ],
          ),
        ),
    ));
  }
}
