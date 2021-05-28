import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './tags.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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
        '/': (BuildContext context) => MyHomePage(title: 'Hashtags Keeper'),
        '/tags': (BuildContext context) => TagsPage(title: 'Hashtag'),
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
  List<QueryDocumentSnapshot> hashLists = [];

  CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');

  var _inputController = TextEditingController();
  var _texts = [];

  void _incrementHash() async {
    await categorys.doc().set({'title': '', 'tags': []});
    _getHash();
    print('-increase---------------');
    // setState(() {
    //   _input.add('#hashtag');
    // });
  }

  void _decleaseHash(index, documentId) async {
    print('----delete------');
    print(documentId);
    print(index);
    await categorys.doc(documentId).delete();
    setState(() {
      hashLists.removeAt(index);
    });
  }

  void _editText(id, text) async {
    await categorys.doc(id).set({'title': text});
    _inputController = text;
    print('------update----');
    // setState(() {
    //   hashLists. = hashlist.docs;
    // });
  }

  Future<void> _saveText(id, text) async {
    print('------------------');
    print(text);
    print(hashLists);
    await FirebaseFirestore.instance.collection('categorys').doc(id).set(text);
    // setState(() {
    //   hashLists. = hashlist.docs;
    // });
  }

  Future<void> _saveHash(category) async {
    await categorys // コレクションID
        .doc('category')
        .set({'name': category}) // データ
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> _handleCategoryTap(key) {
    Navigator.of(context).pushNamed('/tags', arguments: key.id);
  }

  void _copyHash(value) async {
    String hashtags = value.join(' ');
    final data = ClipboardData(text: hashtags);
    await Clipboard.setData(data);
    print("コピー!");
  }

  void _getHash() async {
    final hashlist = await categorys.get();
    print('------------------------------');
    print(hashlist.docs.map((a) => a.data()['title']));
    setState(() {
      hashLists = hashlist.docs;
    });
  }

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
            ...hashLists.map((document) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => _decleaseHash(
                              hashLists.indexOf(document), document.id),
                          child: Icon(Icons.close)),
                      Container(
                        child: TextField(
                          // controller: _inputController,
                          // controller: document['title'],
                          onChanged: (text) => _editText(document.id, text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'New hashtag',
                          ),
                          autofocus: true,
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                        // child: Text(document.data()['title'] ?? 'default'),
                      ),
                      ElevatedButton(
                        onPressed: () => _handleCategoryTap(document),
                        child: Icon(Icons.chevron_right_rounded),
                      ),
                      ElevatedButton(
                          onPressed: () =>
                              _copyHash(document['tags'].cast<String>()),
                          child: Icon(Icons.copy)),
                      ElevatedButton(
                          onPressed: () => _saveText(document.id, hashLists),
                          child: Icon(Icons.add)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () => _getHash(),
              child: Icon(Icons.get_app_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
