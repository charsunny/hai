class PoemItem {
  PoemItem({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
  });
  
  final int id;
  final String title;
  final String content;
  String imageUrl;

  PoemItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        imageUrl = json['imageUrl'];
}
