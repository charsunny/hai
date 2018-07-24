import 'package:flutter/material.dart';
import 'package:hai/page_transform.dart';
import 'package:hai/sectiondata.dart';
import 'dart:ui';
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
        padding: const EdgeInsets.fromLTRB(60.0, 30.0, 60.0, 20.0),
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
    @required this.items,
    @required this.selIndex,
  });
  final int selIndex;
  final List<PoemItem> items;
  @override
  SectionPageState createState() => SectionPageState(items: items, selIndex: selIndex);
}

class SectionPageState extends State<SectionPage> with AfterLayoutMixin<SectionPage>, AutomaticKeepAliveClientMixin<SectionPage>  {
  SectionPageState({
    @required this.items,
    @required this.selIndex,
  });

  int selIndex;
  final List<PoemItem> items;
  final controller = PageController(viewportFraction: 1.0);

  @override
  bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    controller.jumpToPage(selIndex);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            onPageChanged: (page) {
              SharedPreferences.getInstance().then((pref) {
                  pref.setInt("selSection", selIndex);
              });
              setState(() {
                selIndex = page;                
              });
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
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          SizedBox(height: 40.0,width: 10.0,),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            mini: true,
            onPressed: () {
            },
            child: new Icon(Icons.share),
          ),
          SizedBox(height: 20.0,width: 10.0,),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            mini: true,
            onPressed: () {

            },
            child: new Icon(Icons.favorite),
          ),
        ]
      )
    );
  }
}