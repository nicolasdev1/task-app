// 'json to dart' ajuda na criação de classes para trabalhar com json no dart
class Item {
  String title;
  bool done;

  Item({this.title, this.done});

  // recebe o Map String
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  // retorna o Map String
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['done'] = this.done;

    return data;
  }

}