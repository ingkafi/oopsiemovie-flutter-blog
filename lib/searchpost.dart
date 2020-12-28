import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oopsiemovie/detailsearch.dart';
import 'dart:async';
import 'dart:convert';


void main() {
  runApp(new MaterialApp(
    //title: "My Store",
    home: new PostFilter(),
  ));
}

class Post {
  String idpostingan;
  String judul;
  String isi_post;
  String namapenulis;
  String tgl;
  String gambar;
  String namakategori;
 
  Post({this.idpostingan, this.judul, this.isi_post, this.namapenulis, this.tgl, this.gambar, this.namakategori});
 
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(

      idpostingan: json["idpostingan"] as String,
      judul: json["judul"] as String,
      isi_post: json["isi_post"] as String,
      namapenulis: json["namapenulis"] as String,
      tgl: json["tgl"] as String,
      gambar: json["gambar"] as String,
      namakategori: json["namakategori"] as String,
    );
  }
}
class Services {
  static const String url = 'https://oopsie-movie.000webhostapp.com/webservices/get_recent.php';
 
  static Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Post> list = parsePosts(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static List<Post> parsePosts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }
}

class PostFilter extends StatefulWidget {
  PostFilter() : super();
 
  @override
  PostFilterState createState() => PostFilterState();
}
 
class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Debouncer({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
 
class PostFilterState extends State<PostFilter> {
  // https://jsonplaceholder.typicode.com/posts
 
  final _debouncer = Debouncer(milliseconds: 500);
  List<Post> posts = List();
  List<Post> filteredPost = List();
 
  @override
  void initState() {
    super.initState();
    Services.getPosts().then((postsfromServer) {
      setState(() {
        posts = postsfromServer;
        filteredPost = posts;
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 3),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15),
                                child: Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                              ),
                              hintText: "Cari review film",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.grey[400]
                                )
                              )
                            ),
                          onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredPost = posts
                      .where((u) => (u.judul
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.namapenulis.toLowerCase().contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
            ),
                        ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredPost == null ? 0 : filteredPost.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                    padding: const EdgeInsets.all(0),
                    child: new GestureDetector(
                      onTap: ()=>Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context)=> new DetailSeacrh(list:filteredPost, index: index,)
                        )
                      ),
                      child: new Card(
                        child: new ListTile(
                          title: new Text(filteredPost[index].judul),
                          leading: new Container(
                            width: 60,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60 / 2),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://oopsie-movie.000webhostapp.com/penulis/Upload/Image/' +
                                        '${filteredPost[index].gambar}'),
                              ),
                            ),
                          ),
                          subtitle: new Text("Upload pada : ${filteredPost[index].tgl}\nPenulis : ${filteredPost[index].namapenulis}"+'\n'),
                        ),
                      ),
                      ),
          );
              },
            ),
          ),
        ],
      ),
    );
  }
}