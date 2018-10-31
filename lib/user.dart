import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'poem.dart';
import 'section.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';


class UserPage extends StatelessWidget {

  UserPage({
    Key key,
  }):super(key: key);

  Widget _getAndroidWidget(BuildContext context) {
    if (Platform.isIOS) {
      return Divider();
    }
    return ListTile(
      leading: Icon(Icons.credit_card),
      enabled: true,
      title: Text('Buy Water', style: TextStyle(fontSize: 15.0),),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(builder: (context) {
            return DefaultTabController(
              length: 2,
              child:Scaffold(
                appBar: AppBar(
                  elevation: 2.0,
                  backgroundColor: Colors.white,
                  title: Text('Buy Water', style: TextStyle(fontFamily: 'yuesong', fontSize: 17.0),),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(text: '微信'),
                      Tab(text: '支付宝'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Center(
                      
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 100.0),
                        child: Image.asset('assets/images/wepay.png'),
                      ) 
                    ),
                    Center(
                      
                      child: Padding(
                        padding:EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 100.0),
                        child: Image.asset('assets/images/alipay.png'),
                      ) 
                    )
                  ],
                )
            ));
          }) 
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('我的', style: TextStyle(fontFamily: 'yuesong', fontSize: 17.0),),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: ListTile(
              leading: CircleAvatar(
                minRadius: 24.0,
                maxRadius: 26.0,
                foregroundColor: Colors.pink,
                backgroundColor: Colors.black12,
                backgroundImage: ExactAssetImage("assets/images/haizi.jpg",),
              ),
              title: Text('海子的诗', style: TextStyle(fontSize: 20.0, color: Colors.black                  , fontWeight: FontWeight.bold),),
              subtitle: Text('天空一无所有 为何给我安慰', style: TextStyle(fontSize: 13.0, color: Colors.black54),),
              trailing: Icon(Icons.chevron_right),
            ),
            
          ),
          // actions: <Widget>[
          //   IconButton(icon: Icon(Icons.settings), onPressed: () {
          //     Share.share("海子的诗，app下载地址：https://charsunny.com/haizi");
          //   },)
          // ],
        ),
        body: ListView (
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8.0),),
            // ListTile(
            //   leading: Icon(Icons.message),
            //   title: Text('我的消息', style: TextStyle(fontSize: 15.0),),
            //   trailing: Icon(Icons.chevron_right),
            // ),
            // Divider(color: Colors.black12, height: 1.0,),
            ListTile(
              leading: Icon(Icons.book),
              enabled: true,
              title: Text('收藏诗歌', style: TextStyle(fontSize: 15.0),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) {
                    return PoemPage(fav: true,);
                  }) 
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              enabled: true,
              title: Text('收藏字句', style: TextStyle(fontSize: 15.0),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) {
                    return SectionPage(fav: true,);
                  }) 
                );
              },
            ),
            Divider(color: Colors.black12, height: 1.0,),
            ListTile(
              leading: Icon(Icons.contact_mail),
              enabled: true,
              title: Text('联系作者', style: TextStyle(fontSize: 15.0),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 2.0,
                        backgroundColor: Colors.white,
                        title: Text('联系作者', style: TextStyle(fontFamily: 'yuesong', fontSize: 17.0),),
                      ),
                      body: Center(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ExactAssetImage("assets/images/icon.jpg",), 
                                fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              border: new Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Text("微博: @charsunny"),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text("微信: @charsunny"),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text("邮箱: charsunny@gmail.com"),
                          Padding(padding: EdgeInsets.all(4.0)),
                          Text("如有任何建议或意见，请联系我。"),
                          Padding(padding: EdgeInsets.all(100.0)),
                        ],
                      )),
                    );
                  }) 
                );
              },
            ),
             ListTile(
              leading: Icon(Icons.live_help),
              enabled: true,
              title: Text('关于应用', style: TextStyle(fontSize: 15.0),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 2.0,
                        backgroundColor: Colors.white,
                        title: Text('关于应用', style: TextStyle(fontFamily: 'yuesong', fontSize: 17.0),),
                      ),
                      body: Center(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Text("陌生人\n感谢你和我一样\n面朝大海\n春暖花开 \n\n新朋友\n祝愿你和我一样\n享受诗歌\n热爱生活", style: TextStyle(fontSize: 17.0, color: Colors.black),),
                          Padding(padding: EdgeInsets.all(8.0)),
                          Text("—— 使用Flutter学习编写", style: TextStyle(fontSize: 13.0, color: Colors.black87),),
                          Padding(padding: EdgeInsets.all(100.0)),
                        ],
                      )),
                    );
                  }) 
                );
              },
            ),
            Divider(color: Colors.black12, height: 1.0,),
            ListTile(
              leading: Icon(Icons.notifications),
              enabled: true,
              title: Text('应用评分', style: TextStyle(fontSize: 15.0),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                LaunchReview.launch(
                  androidAppId: "com.charsunny.haizi",
                  iOSAppId: "1340405483"
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              enabled: true,
              title: Text('分享应用', style: TextStyle(fontSize: 15.0),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Share.share("海子的诗，app下载地址：https://charsunny.com/haizi");
              },
            ),
            _getAndroidWidget(context)
          ],
        ),
    );
  }
}
