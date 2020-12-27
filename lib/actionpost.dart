import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './detail.dart';

void main() {
  runApp(new MaterialApp(
    //title: "My Store",
    home: new ActionPost(),
  ));
}

class ActionPost extends StatefulWidget {
  @override
  _ActionPostState createState() => new _ActionPostState();
}

class _ActionPostState extends State<ActionPost> {
  Future<List> getData() async {
    final response = await http.get("https://oopsie-movie.000webhostapp.com/webservices/get_action.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  //var posturl = list['https://oopsie-movie.000webhostapp.com/penulis/Upload/Image/']['file_gambar'];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return new Container(
          padding: const EdgeInsets.all(3.0),
          child: new GestureDetector(
            onTap: ()=>Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context)=> new Detail(list:list , index: index,)
              )
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(list[index]['judul']),
                leading: new Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60 / 2),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://oopsie-movie.000webhostapp.com/penulis/Upload/Image/' +
                              '${list[index]['gambar']}'),
                    ),
                  ),
                ),
                subtitle: new Text("Upload pada : ${list[index]['tgl']}\nPenulis : ${list[index]['namapenulis']}"),
              ),
            ),
            ),
          );
      },
    );
  }
}