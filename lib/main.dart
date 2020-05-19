import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];

    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTextEditingController = TextEditingController();

  // função que add um item
  void addItem() {
    // se o vlaor do input for vazio não passa pelo setState
    if (newTextEditingController.text.isEmpty) return;

    // setState que adiciona os items na lista
    setState(() {
      widget.items.add(
        Item(
          title: newTextEditingController.text,
          done: false,
        ),
      );
      
      // limpa o input depois de adicionar o valor a lista
      newTextEditingController.clear();

      // toda vez que adicionar um item é necessário chamar o método saveItem para salva-lo
      saveItem();
    });
  }

  // função que remove um item
  void removeItem(int index) {
    setState(() {
      widget.items.removeAt(index);

      // toda vez que remover um item temos que chamar o método saveItem
      saveItem();
    });
  }

  // função que vai carregar os dados do shared_preferences 'Future' significa que a função vai vir do futuro, não vai ser Real Time
  Future loadItem() async {
    var prefs = await SharedPreferences.getInstance();
    var dataTasks = prefs.getString('dataTasks');

    if (dataTasks != null) {
      // os dados vem como string e passamos eles para Json
      // jsonDecode codifica os dados de uma lista para Json
      Iterable decodedJson = jsonDecode(dataTasks);

      // map percorre o item, que no caso é 'item'
      List<Item> result = decodedJson.map((item) => Item.fromJson(item)).toList();

      setState(() {
        widget.items = result;
      });
    }

  }

  saveItem() async {
    var prefs = await SharedPreferences.getInstance();

    // jsonEncode codifica o json em uma lista
    await prefs.setString('dataTasks', jsonEncode(widget.items));
  }

  // chama o construtor do HomePageState para carregar os items toda vez que a aplicação iniciar (inicia somente uma vez)
  _HomePageState() {
    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // titulo do AppBar
        title: TextFormField(
          controller: newTextEditingController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelText: "Nova tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          // constante que armazena a chamada do item
          final item = widget.items[index];

          // dismissible permite arrastar os items do CheckboxList
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;

                  // toda vez que alteramos um item, chamamos o método saveItem
                  saveItem();
                });
              },
            ),

          key: Key(item.title),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            removeItem(index);
          },
          );
        },
      ),
      
      // botão de add flutuante no canto inferior direito
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
