import 'dart:convert';

class PoemItem {

  PoemItem({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
  });

  bool operator ==(o) => o is PoemItem && o.id == id && o.title == title;
  int get hashCode => title.hashCode;
  
  final int id;
  final String title;
  final String content;
  String imageUrl;

  PoemItem.fromString(String str) : 
    this.fromJson(json.decode(str));

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };

  PoemItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        imageUrl = json['imageUrl'];
}
