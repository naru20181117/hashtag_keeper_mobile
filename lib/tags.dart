// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       home: MyHomePage(title: 'Hashtags Keeper'),
//     );
//   }
// }

class TagsPage extends StatefulWidget {
  TagsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TagsPage> {
  List<String> _input = [];

  void _incrementHash() {
    setState(() {
      _input.add('#hashtag');
    });
  }

  void _decleaseHash(index) {
    setState(() {
      _input.removeAt(index);
    });
  }

  void _editText(index, text) {
    setState(() {
      _input[index] = text;
    });
  }

  // void _copyHash(value) {
  //   setState(() {
  //     final data = ClipboardData(text: value);
  //     await Clipboard.setData(data);
  //     print("コピーしたよ");
  //   });
  // }

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
              "Ready to have hashtags",
            ),
            ..._input.map((i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => _decleaseHash(_input.indexOf(i)),
                          child: Icon(Icons.close)),
                      Container(
                        child: TextField(
                          onChanged: (text) =>
                              _editText(_input.indexOf(i), text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'New hashtag',
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Text(
                        '$i',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      ElevatedButton(
                          onPressed: _incrementHash, child: Icon(Icons.copy)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
            ),
            // Spacer(flex: 4),
            ElevatedButton(
              child: const Text('まとめてコピー'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange[200],
                onPrimary: Colors.black,
                elevation: 8,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementHash,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
