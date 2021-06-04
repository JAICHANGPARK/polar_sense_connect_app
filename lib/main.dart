import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    _flutterBlue
        .scan(
      timeout: Duration(seconds: 10),
    )
        .listen((event) {
      if (event.device.name.contains("Polar")) {
        print(">>> find device");
      }
    });
  }

  Future onSetPermission() async {
    if (await Permission.location.status.isDenied) {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onSetPermission().then((value) {
      _flutterBlue
          .scan(
        timeout: Duration(seconds: 10),
      )
          .listen((event) {
        if (event.device.name.contains("Polar")) {
          print(">>> find device");
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: StreamBuilder(
        stream: _flutterBlue.isScanning,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("스캔중 :)"),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              );
            }
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
