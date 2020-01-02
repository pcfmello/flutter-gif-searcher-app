import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response = await http.get(_search == null
        ? "https://api.giphy.com/v1/gifs/trending?api_key=TBBxN2L0xO3LUlDJ2jvz5ACOnyZVGcgL&limit=20&rating=G"
        : "https://api.giphy.com/v1/gifs/search?api_key=TBBxN2L0xO3LUlDJ2jvz5ACOnyZVGcgL&q=$_search&limit=20&offset=$_offset&rating=G&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise aqui...",
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
              )),
          Expanded(
              child: FutureBuilder<Map>(
                  future: _getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return buildResponseMessage(
                              "Erro ao carregar os GIFS");
                        }

                        return _createGifTable(context, snapshot);
                    }
                  }))
        ]));
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"], height: 300.0, fit: BoxFit.cover,),
          );
        });
  }
}

Widget buildResponseMessage(String message) {
  return Center(
    child: Text(message,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
        textAlign: TextAlign.center),
  );
}
