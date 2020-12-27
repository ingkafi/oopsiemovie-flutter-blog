import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './detail.dart';

void main() {
  runApp(new MaterialApp(
    //title: "My Store",
    home: new RecentPost(),
  ));
}

class RecentPost extends StatefulWidget {
  @override
  _RecentPostState createState() => new _RecentPostState();
}

class _RecentPostState extends State<RecentPost> {
  Future<List> getData() async {
    final response = await http.get("https://oopsie-movie.000webhostapp.com/webservices/get_recent.php");
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
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return new Container(
          padding: const EdgeInsets.all(0),
          child: new GestureDetector(
            onTap: ()=>Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context)=> new Detail(list:list , index: index,)
              )
            ),
            child: new Card(
              child: new ListTile(
                title: new Text('\n'+list[index]['judul']),
                leading: new Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10 / 2),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://oopsie-movie.000webhostapp.com/penulis/Upload/Image/' +
                              '${list[index]['gambar']}'),
                    ),
                  ),
                ),
                subtitle: new Text("Upload pada : ${list[index]['tgl']}\nPenulis : ${list[index]['namapenulis']}"+'\n'),
              ),
            ),
            ),
          );
      },
    );
  }
}