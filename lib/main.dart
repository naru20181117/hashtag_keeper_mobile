import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './tags.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
// void main() async {
//   await Firebase.initializeApp();
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(App());
// }

// class App extends StatefulWidget {
//   // Create the initialization Future outside of `build`:
//   @override
//   _AppState createState() => _AppState();
// }

// class _AppState extends State<App> {
//   // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire:
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           // return SomethingWentWrong();
//         }

//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return MyApp();
//         }

//         // Otherwise, show something whilst waiting for initialization to complete
//         // return Loading();
//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        '/': (context) => MyHomePage(title: 'Hashtags Keeper'),
        '/tags': (context) => TagsPage(title: 'Hashtag'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _input = [];

  CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');

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

  Future<void> addCategory() {
    // await Firebase.initializeApp();
    return categorys
        .add({
          'category': 'aaa',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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
        title: Text(widget.title ?? 'default'),
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
                          onPressed: addCategory, child: Icon(Icons.copy)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
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
