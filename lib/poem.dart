import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'page_transform.dart';
import 'poemitem.dart';
import 'dart:ui' show ImageFilter;
import 'dart:convert';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class PoemPageItem extends StatelessWidget {
  PoemPageItem({
    @required this.item,
    @required this.pageVisibility,
  });

  final PoemItem item;
  final PageVisibility pageVisibility;
  
  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double yTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues( 
          yTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var categoryText = _applyTextEffects(
      translationFactor: 300.0,
      child: Padding (
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 60.0),
        child : Text(
          item.content.trim(),
          style: textTheme.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 17.0,
            height: 1.4
          ),
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
        ),
      )
    );

    var titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          item.title,
          style: textTheme.title.copyWith(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: 'yuesong',
            letterSpacing: 5.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Positioned(
      top: 32.0,
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleText,
          new Expanded (
            flex: 1,
            child: SingleChildScrollView (
              child: categoryText,
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      item.imageUrl,
      fit: BoxFit.cover,
      alignment: FractionalOffset(
        0.5 + (pageVisibility.pagePosition / 3),
        0.5 ,
      ),
    );

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x33000000),
          ],
        ),
      ),
    );

    var blurFilyer = BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: new Container(
        decoration: new BoxDecoration(color: Colors.black45.withOpacity(0.1)),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 0.0,
      ),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(0.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            blurFilyer,
            imageOverlayGradient,
            _buildTextContainer(context),
          ],
        ),
      ),
    );
  }
}

class PoemPage extends StatefulWidget {
  PoemPage({
    Key key,
    @required this.items,
    @required this.selIndex,
  }):super(key: key);
  final int selIndex;
  final List<PoemItem> items;
  
  @override
  _PoemPageState createState() => _PoemPageState(items: items, selIndex: selIndex);
}

class _PoemPageState extends State<PoemPage> with AfterLayoutMixin<PoemPage>, AutomaticKeepAliveClientMixin<PoemPage> {
  _PoemPageState({
    @required this.items,
    @required this.selIndex,
  });
  int selIndex;
  final List<PoemItem> items;
  var isFav = false;
  final controller = PageController(viewportFraction: 1.0);

  @override
  bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    controller.jumpToPage(selIndex);
    List<PoemItem> favPoems = appStateKey.currentState == null ? [] : appStateKey.currentState.favPoems;
    PoemItem item = items[selIndex];
    bool fav = false;
    favPoems.forEach((f) {
      if (f.id == item.id) {
        fav = true;
      }
    });
    setState(() {
        isFav = fav;  
    });
  }

  // void _sharePoem() {
  //   PoemItem item = items[selIndex];
  //   Share.share(item.title + "\n" + item.content);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            onPageChanged: (page) {
              List<PoemItem> favPoems =  appStateKey.currentState.favPoems;
              SharedPreferences.getInstance().then((pref) {
                  pref.setInt("selPoem", page);
              });
              PoemItem item = items[page];
              bool fav = false;
              favPoems.forEach((f) {
                if (f.id == item.id) {
                  fav = true;
                }
              });
              setState(() {
                selIndex = page;  
                isFav = fav;  
              });
            },
            scrollDirection: Axis.horizontal,
            controller: controller,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final pageVisibility =
                  visibilityResolver.resolvePageVisibility(index);
              return PoemPageItem(
                item: item,
                pageVisibility: pageVisibility,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isFav ? Colors.white : Colors.pink,
        foregroundColor: Colors.white,
        mini: true,
        onPressed: () {
          List<PoemItem> favPoems =  appStateKey.currentState.favPoems;
          PoemItem item = items[selIndex];
          bool fav = false;
          favPoems.forEach((f) {
            if (f.id == item.id) {
              fav = true;
            }
          });
          fav ? favPoems.remove(item) : favPoems.add(item);
          setState(() {
              isFav = !fav;  
          });
          appStateKey.currentState.changePoems(favPoems);
          SharedPreferences.getInstance().then((prefs) {
            List<String> list = favPoems.map((f) => json.encode(f)).toList();
            prefs.setStringList("favp",  list);
          });
        },
        child: new Icon(
          Icons.favorite,
          size: 28.0,
          color: isFav ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}