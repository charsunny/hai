import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:convert';
import 'poemitem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker_saver/image_picker_saver.dart';



class SectionPageItem extends StatelessWidget {
  SectionPageItem({
    @required this.item,
  });

  final PoemItem item;

  _buildTextContainer(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var strs = item.content.split('\n').map((f) => f.trim()).toList().reversed;
    if (strs.length > 8) {
      strs = strs.toList().getRange(0, 8);
    }
    var card = Material(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      elevation: 3.0,
      color: Colors.white.withOpacity(0.8),
      child: InkWell(
        onTap: () {

        },
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: strs.map((str) => SizedBox(
              width: 34.0, 
              child: Text(
                str,
                style: textTheme.caption.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  //letterSpacing: 2.0,
                  fontSize: 20.0,
                  height: 1.1
                ),
              ),
            )).toList(),
          ) ,
        ) 
      )
    ) ;
    var qrCodeView = Positioned(
      left: 10.0,
      bottom: 10.0,
      width: 100.0,
      height: 100.0,
      child: QrImage(
        data: "https://charsunny.com/haizi/section${item.id}",
        size: 100.0,
        onError: (ex) {
          print("[QR] ERROR - $ex");
      }),
    );
    return SafeArea(child:
        Padding (
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 40.0),
        child : Stack(
          fit: StackFit.expand,
          children: [
            card,
            qrCodeView
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      item.imageUrl,
      fit: BoxFit.cover,
    );

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.8),
          ],
        ),
      ),
    );

    // var blurFilyer = BackdropFilter(
    //   filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    //   child: new Container(
    //     decoration: new BoxDecoration(color: Colors.white.withOpacity(0.3)),
    //   ),
    // );

    return SafeArea(child:Stack(
      fit: StackFit.expand,
      children: [
        image,
        //blurFilyer,
        imageOverlayGradient,
        _buildTextContainer(context),
      ],
    ));
  }
}

class SectionPage extends StatefulWidget {
  SectionPage({
    Key key,
    @required this.fav,
  }):super(key: key);
  final bool fav;
  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> with SingleTickerProviderStateMixin {
  
  int selIndex = 0;
  List<PoemItem> items;
  List<PoemItem> favPoems;

  var isFav = false;
  PoemItem selItem;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    favPoems = PoemData().favSections;
    items = widget.fav ? favPoems : PoemData().collections;
    selIndex = PoemData().sectionIndex;
    _tabController = new TabController(vsync: this, length: items.length);
    _tabController.addListener(_tabListener);
    if (!widget.fav) {
      selIndex = PoemData().sectionIndex;
      _tabController.index = selIndex;
      selItem = this.items[selIndex];
    } else {
      selIndex = 0;
      if (this.items.length > 0) {
        selItem = this.items[0];
      }
    }
    favPoems.forEach((f) {
      if (f.id == selItem.id) {
        isFav = true;
      }
    });
    setState(() {
          
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    super.dispose();
  }

  void _tabListener () {
    var item = items[_tabController.index];
    bool fav = false;
    favPoems.forEach((f) {
      if (f.id == item.id) {
        fav = true;
      }
    });
    if (!widget.fav) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt("selSection",  _tabController.index);
      });
    }
    setState(() {
        isFav = fav;  
        selItem = item;
        selIndex = _tabController.index;
    });
  }

  GlobalKey globalKey = new GlobalKey();

  // 截图boundary，并且返回图片的二进制数据。
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    //var bs64 = base64Encode(pngBytes);
    return pngBytes;
  }

  @override
  Widget build(BuildContext context) {
    if (this.items.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('收藏字句'),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 2.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40.0,
                foregroundColor: Colors.pink,
                backgroundColor: Colors.black12,
                backgroundImage: ExactAssetImage("assets/images/haizi.jpg",),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text('暂无收藏'),
              Padding(padding: EdgeInsets.all(60.0))
            ]
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('字句', style: TextStyle(fontFamily: 'yuesong', fontSize: 20.0),),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 2.0,
        actions: <Widget>[
          IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.pink : Colors.black,),
          onPressed: () {
            PoemItem item = items[selIndex];
            bool fav = false;
            favPoems.forEach((f) {
              if (f.id == item.id) {
                fav = true;
              }
            });
            fav ? favPoems.remove(item) : favPoems.add(item);
            PoemData().favSections = favPoems;
            if (!widget.fav) {
              setState(() {
                isFav = !fav;  
              });
            } else {
                setState(() {
                  isFav = true;             
                });
              }
            SharedPreferences.getInstance().then((prefs) {
              List<String> list = favPoems.map((f) => json.encode(f)).toList();
              prefs.setStringList("favs",  list);
            });
          },
        ),
        IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              var image = await _capturePng();
              var tempPath = await getTemporaryDirectory();
              await File("${tempPath.path}/temp.png").writeAsBytes(image);
              var result = await showModalBottomSheet(context: context, builder: (ctx) => BottomSheet(
                onClosing: () {
                  print('closing');
                },
                builder: (ctx) {
                  return SafeArea(child:Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        child:Center(child: Text('选择分享方式', style: TextStyle(fontSize: 18.0),)), 
                      ),
                      Divider(height: 1.0),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0), 
                          child:  Image.memory(
                            image,
                            fit: BoxFit.fitHeight,
                          )
                        )
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 16.0,
                        children: <Widget>[
                          Column(children: [
                            FloatingActionButton(
                              child: Image.asset('assets/images/wechat.png'),
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                              isExtended: true,
                              onPressed: () async {
                                print(tempPath);
                                fluwx.share(WeChatShareImageModel(
                                  image: 'file://${tempPath.path}/temp.png',
                                  scene: WeChatScene.SESSION,
                                  description: "image"
                                ));
                              },
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Text('微信好友', style: TextStyle(fontSize: 12.0),),
                          ]),
                          Column(children: [
                            FloatingActionButton(
                              child: Image.asset('assets/images/timeline.png'),
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                              isExtended: true,
                              onPressed: () async {
                                print(tempPath);
                                fluwx.share(WeChatShareImageModel(
                                  image: 'file://${tempPath.path}/temp.png',
                                  scene: WeChatScene.TIMELINE,
                                  description: "image"
                                ));
                              },
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Text('朋友圈', style: TextStyle(fontSize: 12.0),),
                          ]),
                          Column(children: [
                            FloatingActionButton(
                              child: Image.asset('assets/images/fav.png'),
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                              isExtended: true,
                              onPressed: () async {
                                print(tempPath);
                                fluwx.share(WeChatShareImageModel(
                                  image: 'file://${tempPath.path}/temp.png',
                                  scene: WeChatScene.FAVORITE,
                                  description: "image"
                                ));
                              },
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Text('微信收藏', style: TextStyle(fontSize: 12.0),),
                          ]),
                          Column(children: [
                            FloatingActionButton(
                              child: Image.asset('assets/images/link.png'),
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                              isExtended: true,
                              onPressed: () async {
                                await ImagePickerSaver.saveFile(fileData: image);
                                Navigator.of(ctx).pop();
                              },
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Text('保存图片', style: TextStyle(fontSize: 12.0),),
                          ]),
                      ],), 
                      Padding(padding: EdgeInsets.only(top: 10.0), child: Divider(height: 1.0),),
                      Container(
                        height: 50.0,
                        child: InkWell(
                          child:Center(child: Text('取消')),
                          onTap: () {
                              Navigator.of(ctx).pop();
                            }
                          )
                      )
                      
                    ],
                  ));
                },
              )
            );
          }),
        ],
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: TabBarView(
          controller: _tabController,
          children: items.map<SectionPageItem>((item) => SectionPageItem(item: item)).toList(),
      )),
    );
  }
}