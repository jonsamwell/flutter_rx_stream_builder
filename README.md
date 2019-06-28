# flutter_rx_stream_builder

A new Flutter package project.

## Getting Started

An rx stream builder widget that is able to pre-populate a flutter `StreamBuilder` with data from an rx stream if the stream is either a value or a replay observable.  For example the RX stream is a `BehaviorSubject` or a `ReplaySubject`.

This will slightly improve the performance as the first frame will be rendered with data rather than waiting for the stream to emit data.

A normal dart stream can also be passed to this widget and it will behave exactly the same way as a normal Flutter `StreamBuilder`

```
Widget build(BuildContext context) {
  return RxStreamBuilder<String>(
      stream: BehaviorSubject<String>.seeded("Hello"),
      builder: (context, snapshot) => Text(snapshot.data),
  );
}
```

For a more complex example see the example project

The below changes the applications theme every two seconds

```
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_rx_stream_builder/flutter_rx_stream_builder.dart';

class RandomThemeManager {
  final Subject<ThemeData> _themeData = BehaviorSubject.seeded(
      ThemeData.light().copyWith(primaryColor: Colors.yellow));

  Observable<ThemeData> get themeData => _themeData;

  void initialise() {
    Observable.fromIterable(Iterable.generate(5000, (n) => n))
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
  final Observable<ThemeData> _themeData$;

  const MyApp(this._themeData$, {Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder(
      stream: _themeData$,
      builder: (context, snapshot) => MaterialApp(
            title: 'RxStreamBuilder Demo',
            theme: snapshot.data,
            home: MyHomePage(title: 'Rx StreamBuilder Demo Page'),
          ),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```