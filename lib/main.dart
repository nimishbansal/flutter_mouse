import 'package:flutter/material.dart';

void main() => runApp(MyApp());

BoxDecoration myBoxDecoration() {
  // It is used to apply border to a widget
  return BoxDecoration(
      border: Border.all(),
      color: Colors.green,
      borderRadius: BorderRadius.all(Radius.circular(4))
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  
  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              color: Colors.black,
              decoration: myBoxDecoration(),
            ),
            Text(
                "Your wireless mouse"
            ),
          ],
        ),
      ),
    );
  }
}
