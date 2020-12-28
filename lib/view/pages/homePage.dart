import 'package:oopsiemovie/actionpost.dart';
import 'package:oopsiemovie/dramapost.dart';
import 'package:oopsiemovie/horrorpost.dart';
import 'package:oopsiemovie/komedipost.dart';
import 'package:oopsiemovie/recentpost.dart';
import 'package:oopsiemovie/searchpost.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List list;
  HomePage({this.list});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height * 0.3,
                  width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/bg.jpg"),
                          fit: BoxFit.fitWidth)),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0.0, -(height * 0.3 - height * 0.26)),
              child: Container(
                width: width,
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: DefaultTabController(
                    length: 6,
                    child: Column(
                      children: <Widget>[
                        TabBar(
                          isScrollable: true,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          unselectedLabelColor: Colors.grey[400],
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.transparent,
                          tabs: <Widget>[
                            Tab(
                              child: Text("Search"),
                            ),
                            Tab(
                              child: Text("Recent Post"),
                            ),
                            Tab(
                              child: Text("Action"),
                            ),
                            Tab(
                              child: Text("Comedy"),
                            ),
                            Tab(
                              child: Text("Horror"),
                            ),
                            Tab(
                              child: Text("Drama"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: height * 0.6,
                          child: TabBarView(
                            children: <Widget>[
                              PostFilter(),
                              RecentPost(),
                              ActionPost(),
                              KomediPost(),
                              HorrorPost(),
                              DramaPost(),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
