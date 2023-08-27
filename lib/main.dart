import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Channel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Event Channel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const EventChannel _eventChannel = EventChannel('count_handler_event');
  static const MethodChannel _methodChannel =
      MethodChannel('count_handler_method');
  var counter;

  @override
  void initState() {
    streamTimeFromNative();
    super.initState();
  }

  void getCounters() async {
    print("getCounters()");
    await _methodChannel.invokeMethod('getCounter');
  }

  void streamTimeFromNative() {
    print("streamTimeFromNative()");
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(dynamic event) {
    //Receive Event
    var data = "Start Listing..";
    if (event.toString() != null) {
      data = event.toString();
    }
    setState(() {
      counter = data;
    });
    print("_onEvent ${event.toString()}");
  }

  void _onError(dynamic event) {
    //Receive Event
    print("_onError ${event.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  getCounters();
                },
                child: const Text('Start Counters')),
            SizedBox(
              height: 20,
            ),
            Text(
              'Counter  : ${counter}',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
