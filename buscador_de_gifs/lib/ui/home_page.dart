import 'dart:convert';

import 'package:buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _baseUrl = 'https://api.giphy.com/v1/gifs/';
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty) {
      response = await http.get(
          '${_baseUrl}trending?api_key=gkCz3XRloFHdhFyWt2zcjjOe0TyrUnlx&limit=20&rating=G');
    } else {
      response = await http.get(
          '${_baseUrl}search?api_key=gkCz3XRloFHdhFyWt2zcjjOe0TyrUnlx&q=$_search&limit=25&offset=$_offset&rating=G&lang=en');
    }

    return json.decode(response.body);
  }

  int getItemsCount(List list) {
    if (_search == null) {
      return list.length;
    } else {
      return list.length + 1;
    }
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((res) {
      print(res);
    });
  }

  Widget _createGifTable(context, snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: getItemsCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Pesquisar",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
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
                            strokeWidth: 5.0),
                      );

                    default:
                      if (snapshot.hasError) {
                        return Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Erro ao carregar dados",
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.red),
                            ));
                      } else {
                        return _createGifTable(context, snapshot);
                      }
                  }
                },
              ),
            )
          ],
        ));
  }
}
