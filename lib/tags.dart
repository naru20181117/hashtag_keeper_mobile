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
  _TagsPageState createState() => _TagsPageState();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}

class _TagsPageState extends State<TagsPage> {
  String _id = '';
  List<dynamic> _tags = [];
  String _title = '';
  List<TextEditingController> controllers;

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _updateData();
    });
  }

  CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');

  void _updateData() async {
    setState(() {
      QueryDocumentSnapshot args = ModalRoute.of(context).settings.arguments;
      _id = args.id;
    });
    DocumentSnapshot data = await categorys.doc(_id).get();
    setState(() {
      _tags = data['tags'];
      _title = data['title'];
    });
    _setController();
  }

  void _incrementHash() async {
    setState(() {
      _tags.add('');
    });
    await categorys.doc(_id).update({'title': _title, 'tags': _tags});
    _updateData();
  }

  void _decleaseHash(text) async {
    setState(() {
      _tags.removeAt(_tags.indexOf(text));
    });
    await categorys.doc(_id).update({'title': _title, 'tags': _tags});
    _setController();
  }

  void _editText(text) async {
    _setTags();
    await categorys.doc(_id).update({'title': _title, 'tags': _tags});
  }

  void _copyHash(value) async {
    final data = ClipboardData(text: '#' + value);
    await Clipboard.setData(data);
    print("コピー!");
  }

  void _copyHashes() async {
    _setTags();
    String hashtags = _tags.join(' ');
    final data = ClipboardData(text: hashtags);
    await Clipboard.setData(data);
    print("コピー!");
  }

  void _setTags() {
    setState(() {
      _tags = controllers.map((s) {
        return s.text;
      }).toList();
    });
  }

  void _setController() {
    setState(() {
      if (_tags.isNotEmpty) {
        controllers = _tags.map((s) {
          return TextEditingController(text: s);
        }).toList();
      } else {
        controllers = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ...controllers.map((i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // controllers.indexOf(i)
                      ElevatedButton(
                          onPressed: () => _decleaseHash(i.text),
                          child: Icon(Icons.close)),
                      Container(
                        child: TextField(
                          controller: i,
                          onSubmitted: (text) => _editText(i.text),
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            hintText: 'New hashtag',
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      ElevatedButton(
                          onPressed: () => _copyHash(i.text),
                          child: Icon(Icons.copy)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
            ),
            // Spacer(flex: 4),
            ElevatedButton(
              onPressed: () => _copyHashes(),
              child: const Text('まとめてコピー（仮）'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange[200],
                onPrimary: Colors.black,
                elevation: 8,
              ),
            ),
            ElevatedButton(
              onPressed: () => _updateData(),
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

  indexOf(TextEditingController i) {}
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
