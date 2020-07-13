import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'dart:convert';
import 'package:sensors/sensors.dart';


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
	
	List<double> currentAccelerationXYZ;
	
	int randomNoX=0;
	
	int randomNoY=0;
	
	int randomNoXY=0;
	
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
	
	onHorizontalDragStart(DragStartDetails details) {
		print("started at" + details.globalPosition.toString());
	}
	
	
	onHorizontalDragCancel() {
		print("drag cancel");
	}
	
	onHorizontalDragUpdate(DragUpdateDetails details) {
		print("2. y:" + details.delta.dy.toString() + "x:" + details.delta.dx.toString());
		var data = {"event_type": "move_right", "delta_x": (10*(details.delta.dx)).toString()};
		randomNoX+=1;
		if (randomNoX%3==0)
			try
			{
				makePostRequest(data, "/move_right/");
			}
			catch(Exception)
			{}
		
		
	}
	
	onVerticalDragUpdate(DragUpdateDetails details) {
		var data = {"event_type": "move_up", "delta_y": (10*(details.delta.dy)).toString()};
		print("1. y:" + details.delta.dy.toString() + "x:" + details.delta.dx.toString());
		randomNoY+=1;
		if (randomNoY%3==0)
			try{
				makePostRequest(data, "/move_up/");
			}
			catch(Exception)
			{}
		
		
	}
	
	onPanUpdate(DragUpdateDetails details) {
		var data = {"event_type": "move_cursor",
			"delta_y": (30*(details.delta.dy)).toString(),
			"delta_x": (30*(details.delta.dx)).toString()
		};
		print("1. y:" + details.delta.dy.toString() + "x:" + details.delta.dx.toString());
		randomNoXY+=1;
		if (randomNoXY%5==0)
			try{
				makePostRequest(data, "/move_cursor/");
			}
			catch(e)
			{
				print("error is" +e.toString());
			}
	}
	
	
	
	@override
	Widget build(BuildContext context) {
		
		currentAccelerationXYZ = new List<double>(3);
		
		var actualContainer = new Container(
			width: 320,
			height: 320,
			decoration: myBoxDecoration(),
		);
		
		
		// setMotionListener(); will be used if phone is used as mouse
		
		
		var gestureDetectWrapperWidget = GestureDetector(
			child: actualContainer,
			onTap: onTap,
			onDoubleTap: onDoubleTap,
//			onHorizontalDragStart: onHorizontalDragStart,
//			onHorizontalDragCancel: onHorizontalDragCancel,
//			onHorizontalDragUpdate: onHorizontalDragUpdate,
//			onVerticalDragUpdate: onVerticalDragUpdate,
			onPanUpdate: onPanUpdate,
		);
		return gestureDetectWrapperWidget;
	}
	
	void setMotionListener() {
		accelerometerEvents.listen((AccelerometerEvent event) {
			if  (currentAccelerationXYZ[0]==null)
			{
				currentAccelerationXYZ[0] = event.x;
				currentAccelerationXYZ[1] = event.y;
				currentAccelerationXYZ[2] = event.z;
			}
			
			else
			{
				print(
					(event.x-currentAccelerationXYZ[0]).toString()+"," +
						(event.y-currentAccelerationXYZ[1]).toString()+"," +
						(event.z-currentAccelerationXYZ[2]).toString()
				);
			}
			
		});
		
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
