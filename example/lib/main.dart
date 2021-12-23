import 'package:anchor_point_scroll_view/anchor_point_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnchorPointScrollViewState> _anchorKey = GlobalKey();
  int _currentIndex = 0;

  _onPress(int index) {
    _anchorKey.currentState?.jumpToIndex(index);
    // _anchorKey.currentState?.animatedTo(index,duration:const Duration(milliseconds: 150),curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Wrap(
          children: List.generate(10, (index) {
            return TextButton(
              onPressed: () => _onPress(index),
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: index == _currentIndex ? Colors.red : Colors.grey,
                  fontSize: index == _currentIndex ? 24 : 12,
                ),
              ),
            );
          }),
        ),
        Expanded(
          child: AnchorPointScrollView(
            key: _anchorKey,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: List.generate(10, (index) {
              return Container(
                height: 80.0 * (index+1),
                color: Colors.primaries[index],
                alignment: Alignment.center,
                child: Text(index.toString(),
                    style: const TextStyle(fontSize: 28, color: Colors.black)),
              );
            }),
          ),
        ),
      ]),
    );
  }
}
