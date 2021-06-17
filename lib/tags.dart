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
    controllers = List.generate(1, (i) => TextEditingController(text: ''));

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
    _setController();
  }

  void _copyHash(value) async {
    final data = ClipboardData(text: value);
    await Clipboard.setData(data);
    print("コピー!");
  }

  void _copyHashes() async {
    String hashtags = _tags.join(' ');
    final data = ClipboardData(text: hashtags);
    await Clipboard.setData(data);
    print("コピー!");
  }

  void _setTags() {
    setState(() {
      _tags = controllers.map((s) {
        return _setHash(s.text);
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

  void _setHash(text) {
    if (!RegExp(r'#.+').hasMatch(text)) text = '#' + text.trim();
    return text;
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
            if (controllers.isEmpty)
              Text("Ready to have hashtags\n Click HERE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                  )),
            ...controllers.map((i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () => _decleaseHash(i.text),
                          child: Icon(Icons.close)),
                      Container(
                        child: TextField(
                          controller: i,
                          onSubmitted: (text) => _editText(i.text),
                          decoration: InputDecoration(
                            hintText: 'New hashtag',
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      ElevatedButton(
                          onPressed: () => _copyHash(i.text),
                          child: Icon(Icons.copy)),
                    ])),
            ElevatedButton(
              onPressed: _incrementHash,
              child: Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () => _copyHashes(),
              child:
                  Column(children: [const Icon(Icons.copy), const Text('ALL')]),
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

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
