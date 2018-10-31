import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'section.dart';
import 'poemitem.dart';

class PoemSharePage extends StatefulWidget {

  PoemSharePage({
    @required this.item,
    @required this.selIndex,
    @required this.offset,
  });

  final PoemItem item;
  final int selIndex;
  final double offset;

  _PoemSharePageState createState() => _PoemSharePageState();
}

class _PoemSharePageState extends State<PoemSharePage> {

  ScrollController controller;

  GlobalKey<ScaffoldState> _globalKey;

  List<String> sentences ;

  Map<int, bool> selected = {};

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _globalKey = GlobalKey();
      controller = ScrollController(initialScrollOffset: widget.offset);
      selected[widget.selIndex] = true;
      sentences = widget.item.content.trim().split("\n").toList();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(widget.item.title),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: 2.0,
    ),
    key: _globalKey,
    backgroundColor: Colors.white,
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton.icon(label: Text('复制字句'), icon: Icon(Icons.textsms), onPressed: () {
            var str = "";
            selected.forEach((i, b) {
              if (b != null && b) {
                str += sentences[i] + "\n";
              }
            });
            
            Clipboard.setData(ClipboardData(text: str));
            _globalKey.currentState.showSnackBar(SnackBar(
              content: Text("已复制字句到剪切板。"),
              duration: Duration(seconds: 2),
            ));
          }),
          FlatButton.icon(label: Text('生成海报'), icon: Icon(Icons.photo), onPressed: () {
            var str = "";
            selected.forEach((i, b) {
              if (b != null && b) {
                str += sentences[i] + "\n";
              }
            });
            var section = PoemItem(
              id: widget.item.id,
              title: widget.item.title,
              content: str,
              imageUrl: widget.item.imageUrl
            );
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) {
                return SectionPage(fav: false, section: section,);
              }) 
            );
          })
        ],
      ),
    ),
    body:  SafeArea(child: Padding (
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: ListView.builder(
        itemExtent: 40.0,
        controller: controller,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
            onTap: () {
              if(sentences[index].trim().length == 0) {
                return;
              }
              setState(() {
                if(selected[index] == null || !selected[index]) {
                  selected[index] = true; 
                } else {
                  selected[index] = false; 
                }    
              });
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Text(sentences[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  )),
                  Icon(Icons.check, size: 20.0, color: (selected[index] == null || !selected[index]) ? Colors.transparent : Colors.pink,),
                ]
              )
            ),
          ));
        },
        itemCount: sentences.length
      ),
    )));
  }
}