import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewTodoListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewTodoListState();
  }
}

class NewTodoListState extends State<NewTodoListScreen>{
  final _formkey = GlobalKey<FormState>();
  final textController = TextEditingController();
  Firestore _store = Firestore.instance;
  int _id = 0;
  int _maxId = 0;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Subject',
              ),
              controller: textController,
              validator: (value){
                if(value.isEmpty){
                  return 'Please fill subject';
                }
              }
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () async {
                _formkey.currentState.validate();
                if (textController.text.length > 0) {
                  QuerySnapshot getDoc = await _store.collection('todo').getDocuments();
                  List<DocumentSnapshot> document = getDoc.documents;
                  int docCount = document.length;
                  _id += 1;
                  if (docCount > 0){
                    if (_id > 1){
                      getDoc.documents.forEach((d){
                        if (d.data['_id'] > _maxId){
                          _maxId = d.data['_id'];
                        }
                        _id = _maxId + 1;
                      });
                    } else {
                      getDoc.documents.forEach((d){
                        if (d.data['_id'] > _maxId){
                          _maxId = d.data['_id'];
                        }
                        _id = _maxId + 1;
                      });
                    }
                  }
                  await _store.collection('todo').document(_id.toString()).setData({
                    '_id': _id,
                    'title': textController.text,
                    'done': 0,
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      )
    );
  }
}