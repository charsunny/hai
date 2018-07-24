import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hai/page_transform.dart';
import 'package:hai/sectiondata.dart';
import 'dart:ui';
import 'package:share/share.dart';

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
        padding: const EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 20.0),
        child : Text(
          item.content.trim(),
          style: textTheme.caption.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 15.0,
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
            fontSize: 18.0
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    var height =  MediaQuery.of(context).size.height;

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

class PoemPage extends StatelessWidget {
  PoemPage({
    @required this.items,
  });

  final List<PoemItem> items;
  final controller = PageController(viewportFraction: 1.0);
  void _incrementCounter () {

  }
  void _sharePoem() {
    Share.share("xxxxx");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
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
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          SizedBox(height: 40.0,width: 10.0,),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            mini: true,
            onPressed: _sharePoem,
            child: new Icon(Icons.share),
          ),
          SizedBox(height: 20.0,width: 10.0,),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            mini: true,
            onPressed: _incrementCounter,
            child: new Icon(Icons.favorite),
          ),
        ],
      ) ,
    );
  }
}