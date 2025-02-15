class CanvasItemModel {
  int id;
  String type;
  String content;
  double x;
  double y;
  double width;
  double height;

  CanvasItemModel({
    required this.id,
    required this.type,
    required this.content,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }
}
