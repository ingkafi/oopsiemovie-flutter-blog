import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class DetailSeacrh extends StatefulWidget {
  final list;
  final index;
  DetailSeacrh({this.list, this.index});
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<DetailSeacrh> {
  Future<List> getKomen() async {
    final response = await http.get(
        "https://oopsie-movie.000webhostapp.com/webservices/get_komen.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Stack(
            children: <Widget>[
              Container(
                height: height * 0.55,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://oopsie-movie.000webhostapp.com/penulis/Upload/Image/' +
                                '${widget.list[widget.index].gambar}'),
                        fit: BoxFit.fitWidth)),
              ),
              Container(
                width: width,
                margin: EdgeInsets.only(top: height * 0.5),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.list[widget.index].judul}",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.people),
                        Text("  ${widget.list[widget.index].namapenulis}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.movie),
                        Text("  ${widget.list[widget.index].namakategori}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        Text("  ${widget.list[widget.index].tgl}"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Review",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${widget.list[widget.index].isi_post}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5),
                    ),
                    Text(
                      "\n\nKomentar :",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List>(
                        future: getKomen(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text('none');
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return Text('wait');
                            case ConnectionState.done:
                              return snapshot.hasData
                                  ? new ItemComment(
                                      list: snapshot.data,
                                      index: widget.list[widget.index].idpostingan)
                                  : new Center(
                                      child: new CircularProgressIndicator(),
                                    );
                            default:
                              return Text('Default');
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemComment extends StatelessWidget {
  final List list;
  final index;
  ItemComment({this.list, this.index});
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      
        shrinkWrap: true,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          if (list[i]['idpostingan'] == index) {
            return Container(
                child: new Card(
              child: Container(
                child: new Container(
                  padding: const EdgeInsets.all(8),
                  child: new Text(list[i]['isi'],
                      style: new TextStyle(fontSize: 12)),
                ),
              ),
            ));
          } else {
            return Container();
          }
        });
  }
}
