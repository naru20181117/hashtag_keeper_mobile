// import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TagsPage());
}

class TagsPage extends StatefulWidget {
  TagsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}

class _MyHomePageState extends State<TagsPage> {
  var _title = '';
  List<String> _tags = [];

  CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');

  void _incrementHash() {
    setState(() {
      _tags.add('#hashtag');
    });
  }

  void _decleaseHash(index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _editText(index, text) {
    setState(() {
      _tags[index] = text;
    });
  }

  Future<String> _getTitle(documentId) async {
    DocumentSnapshot titleGet = await categorys.doc(documentId).get();
    print(titleGet);
    Map<String, dynamic> record = titleGet.data();
    setState(() {
      _title = record['title'];
      print(record['tags'].map((a) => a.toString()));
      print(record['tags']);
      _tags = record['tags'].cast<String>();
    });
  }

  void _copyHash(value) async {
    final data = ClipboardData(text: '#' + value);
    await Clipboard.setData(data);
    print("コピー!");
  }

  @override
  Widget build(BuildContext context) {
    final _tagId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ready to have hashtags",
            ),
            ..._tags.map((i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => _decleaseHash(_tags.indexOf(i)),
                          child: Icon(Icons.close)),
                      Container(
                        child: TextField(
                          onChanged: (text) =>
                              _editText(_tags.indexOf(i), text),
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
                          onPressed: () => _copyHash(i),
                          child: Icon(Icons.copy)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
            ),
            // Spacer(flex: 4),
            ElevatedButton(
              onPressed: () => _getTitle(_tagId),
              child: const Text('まとめてコピー（仮）'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange[200],
                onPrimary: Colors.black,
                elevation: 8,
              ),
            ),
            ElevatedButton(
              onPressed: () => _getTitle(_tagId),
              child: const Text('アップデート'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange[200],
                onPrimary: Colors.black,
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
