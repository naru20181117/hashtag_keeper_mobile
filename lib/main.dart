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
        '/tags': (BuildContext context) => TagsPage(),
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
  List<dynamic> _tags = [];

  CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');

  var _inputController = TextEditingController();
  var _texts = [];
  var txt = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getHash();
  }

  void _incrementHash() async {
    await categorys.doc().set({'title': '', 'tags': []});
    _getHash();
  }

  void _decleaseHash(index, documentId) async {
    await categorys.doc(documentId).delete();
    _getHash();
  }

  void _editText(id, text, tags) async {
    await categorys.doc(id).update({'title': text, 'tags': tags});
    _getHash();
  }

  Future<void> _handleCategoryTap(key) {
    _getHash();
    Navigator.of(context).pushNamed('/tags', arguments: key);
  }

  void _copyHash(value) async {
    String hashtags = value.join(' ');
    final data = ClipboardData(text: hashtags);
    await Clipboard.setData(data);
    print("コピー!");
  }

  void _getHash() async {
    final hashlist = await categorys.get();
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
            if (hashLists.isEmpty)
              Text("Ready to have hashtags Titles\n Click HERE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  )),
            ...hashLists.map((document) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => _decleaseHash(
                              hashLists.indexOf(document), document.id),
                          child: Icon(Icons.close)),
                      Container(
                        child: TextField(
                          controller:
                              TextEditingController(text: document['title']),
                          onSubmitted: (txt) => _editText(document.id, txt,
                              document['tags'].cast<String>()),
                          decoration: InputDecoration(
                            hintText: 'New hashtag',
                          ),
                          autofocus: true,
                          readOnly: false,
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                      ElevatedButton(
                        onPressed: () => {
                          _editText(document.id, txt,
                              document['tags'].cast<String>()),
                          _handleCategoryTap(document),
                        },
                        child: Icon(Icons.chevron_right_rounded),
                      ),
                      ElevatedButton(
                          onPressed: () =>
                              _copyHash(document['tags'].cast<String>()),
                          child: Icon(Icons.copy)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
