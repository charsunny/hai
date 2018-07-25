import 'package:flutter/material.dart';
import 'page_transform.dart';
import 'poemitem.dart';
import 'dart:ui' show ImageFilter;
import 'dart:convert';
import 'main.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SectionPageItem extends StatelessWidget {
  SectionPageItem({
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
          0.0,
          yTranslation,
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
        child: Text(
          item.content,
          style: textTheme.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 18.0,
            height: 1.6
          ),
          maxLines: 12,
          textAlign: TextAlign.center,
        ),
      )
    );

    var titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
        child: Text(
          "—— " + item.title.replaceAll("\n", " "),
          style: textTheme.title.copyWith(
            color: Colors.white70, 
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            fontStyle: FontStyle.italic
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );

    return Positioned(
      bottom: 34.0,
      left: 8.0,
      right: 8.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          categoryText,
          titleText,
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
        0.5,
        0.5 + (pageVisibility.pagePosition / 2),
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

class SectionPage extends StatefulWidget {
  SectionPage({
    Key key,
    @required this.items,
    @required this.selIndex,
  }):super(key: key);
  final int selIndex;
  final List<PoemItem> items;
  @override
  _SectionPageState createState() => _SectionPageState(items: items, selIndex: selIndex);
}

class _SectionPageState extends State<SectionPage> with AfterLayoutMixin<SectionPage>, AutomaticKeepAliveClientMixin<SectionPage>  {
  _SectionPageState({
    @required this.items,
    @required this.selIndex,
  });

  int selIndex;
  var isFav = false;
  final List<PoemItem> items;
  final controller = PageController(viewportFraction: 1.0);

  @override
  bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    controller.jumpToPage(selIndex);
    List<PoemItem>  sections =  appStateKey.currentState.favSections;
    PoemItem item = items[selIndex];
    bool fav = false;
    sections.forEach((f) {
      if (f.id == item.id) {
        fav = true;
      }
    });
    setState(() {
        isFav = fav;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            onPageChanged: (page) {
              List<PoemItem> sections =  appStateKey.currentState.favSections;
              SharedPreferences.getInstance().then((pref) {
                  pref.setInt("selSection", page);
              });
              PoemItem item = items[page];
              bool fav = false;
              print(sections);
              sections.forEach((f) {
                if (f.id == item.id) {
                  fav = true;
                }
              });
              setState(() {  
                selIndex = page;  
                isFav = fav;  
              });
              //appStateKey.currentState.setSectionPage(page);
            },
            scrollDirection: Axis.vertical,
            controller: controller,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final pageVisibility =
                  visibilityResolver.resolvePageVisibility(index);
              return SectionPageItem(
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
          List<PoemItem> sections =  appStateKey.currentState.favSections;
          PoemItem item = items[selIndex];
          bool fav = false;
          sections.forEach((f) {
            if (f.id == item.id) {
              fav = true;
            }
          });
          fav ? sections.remove(item) : sections.add(item);
          setState(() {
              isFav = !fav;  
          });
          appStateKey.currentState.changeSections(sections); 
          SharedPreferences.getInstance().then((prefs) {
            List<String> list = sections.map((f) => json.encode(f)).toList();
            prefs.setStringList("favs",  list).then((succ) {
              
            });
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