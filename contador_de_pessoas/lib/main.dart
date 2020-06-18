import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _people = 0;
  String _infoText = "Pode Entrar!";

  void changePeople(int delta) {
    setState(() {
      _people += delta;

      if(_people < 0) {
        _infoText = 'Mundo invertido?!';
      } else if (_people >= 10) {
        _infoText = 'Lotado!';
      } else {
        _infoText = 'Pode Entrar!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("images/mine.png", fit: BoxFit.cover, height: 1000.0),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text("Pessoas: $_people",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0))
                  ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    child: Text("+1",
                        style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(5.0, 5.0))
                            ])),
                    onPressed: () {
                      changePeople(1);
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    child: Text("-1",
                        style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(5.0, 5.0))
                            ])),
                    onPressed: () {
                      changePeople(-1);
                    }),
              )
            ],
          ),
          Text("$_infoText",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0))
                  ])),
        ])
      ],
    );
  }
}
