import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

BoxDecoration myBoxDecoration() {
	// It is used to apply border to a widget
	return BoxDecoration(
		border: Border.all(color: Colors.red, width: 10),
		color: Colors.green,
		borderRadius: BorderRadius.all(Radius.elliptical(30,30))
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

class MyMouseContainerWidget extends StatefulWidget{
	
	@override
	MyMouseContainerWidgetState createState() => MyMouseContainerWidgetState();
	
}

class MyMouseContainerWidgetState extends State<MyMouseContainerWidget> {
	
	Future<HttpClientResponse> makePostRequest(Map<String, dynamic> jsonMap, String path) async {
//		Map<String, dynamic> jsonMap = {
//			'homeTeam': {'team': 'Team A'},
//			'awayTeam': {'team': 'Team B'},
//		};
		String jsonString = json.encode(jsonMap); // encode map to json
//		String paramName = 'param'; // give the post param a name
		String formBody = Uri.encodeQueryComponent(jsonString);
		List<int> bodyBytes = utf8.encode(formBody); // utf8 encode
		
		HttpClient httpclient = new HttpClient();
//		HttpClientRequest request = await httpclient.post("192.168.0.107", 8000,"/tap/");
		HttpClientRequest request = await httpclient.post("192.168.0.107", 8000, path);
		// it's polite to send the body length to the server
		request.headers.set('Content-Length', bodyBytes.length.toString());
		request.add(bodyBytes);
		return await request.close();
	}
	
	void onTap()
	{
		var data = {"event_type": "single_tap"};
		makePostRequest(data, "/tap/");
	}
	void onDoubleTap()
	{
		var data = {"event_type": "double_tap"};
		makePostRequest(data, "/double_tap/");
	}
	
	
	@override
	Widget build(BuildContext context) {
		var actualContainer = new Container(
			width: 320,
			height: 320,
			decoration: myBoxDecoration(),
		);
		
		var gestureDetectWrapperWidget = GestureDetector(
			child: actualContainer,
			onTap: onTap,
			onDoubleTap: onDoubleTap,
		);
		return gestureDetectWrapperWidget;
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
						MyMouseContainerWidget(),
						Text(
							"Your wireless mouse"
						),
					],
				),
			),
		);
	}
}
