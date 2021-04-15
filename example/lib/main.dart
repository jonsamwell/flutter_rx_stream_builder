import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_rx_stream_builder/flutter_rx_stream_builder.dart';

class RandomThemeManager {
  final Subject<ThemeData> _themeData = BehaviorSubject.seeded(
      ThemeData.light().copyWith(primaryColor: Colors.yellow));

  Stream<ThemeData> get themeData => _themeData;

  void initialise() {
    Stream.fromIterable(Iterable.generate(5000, (n) => n))
        .interval(const Duration(seconds: 2))
        .map((_) => ThemeData.light().copyWith(
            primaryColor:
                Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                    .withOpacity(1.0)))
        .listen((theme) => _themeData.add(theme));
  }
}

void main() {
  final themeManager = RandomThemeManager();
  themeManager.initialise();
  runApp(MyApp(themeManager.themeData));
}

class MyApp extends StatelessWidget {
  final Stream<ThemeData> _themeData$;

  const MyApp(this._themeData$) : super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder<ThemeData>(
      stream: _themeData$,
      builder: (context, snapshot) => MaterialApp(
        title: 'RxStreamBuilder Demo',
        theme: snapshot.data,
        home: MyHomePage('Rx StreamBuilder Demo Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
    this.title,
  ) : super();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
