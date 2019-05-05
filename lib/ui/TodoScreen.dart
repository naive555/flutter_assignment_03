import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoScreen extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _TodoState();
  }
}

class _TodoState extends State<TodoScreen> {
  Firestore _store = Firestore();
  int tabIndex = 0;

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
        title: Text('Todo'),
        actions: <Widget>[
          IconButton(
          icon: Icon(
            tabIndex == 0 
            ? Icons.add 
            : Icons.delete,
          ),
          onPressed: () async {
            tabIndex == 0
            ? Navigator.pushNamed(context, '/newTodoList')
            : _store.collection('todo').where('done', isEqualTo: 1).getDocuments().then((d) {
                d.documents.forEach((f) {
                  f.reference.delete();
                });
              });
            setState(() {});
            },
          ),
        ]
      ),
      body: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
           if (snapshot.hasData) {
              if (tabIndex == 0){
                if (snapshot.data.documents.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      int id = snapshot.data.documents.elementAt(index).data['_id'];
                      bool done = snapshot.data.documents.elementAt(index).data['done'] == 1;
                      String title = snapshot.data.documents.elementAt(index).data['title'];
                      String documentId = snapshot.data.documents.elementAt(index).documentID;
                      return CheckboxListTile(
                        title: Text(title),
                        value: done,
                        onChanged: (bool done) {
                          setState(() {
                            _store.collection('todo').document(documentId).setData({'_id': id, 'title': title, 'done': 1});
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No data found..'),
                  );
                }
              } else {
                if (snapshot.data.documents.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      int id = snapshot.data.documents.elementAt(index).data['_id'];
                      bool done = snapshot.data.documents.elementAt(index).data['done'] != 0;
                      String title = snapshot.data.documents.elementAt(index).data['title'];
                      String documentId = snapshot.data.documents.elementAt(index).documentID;
                      return CheckboxListTile(
                        title: Text(title),
                        value: done,
                        onChanged: (bool done) {
                          setState(() {
                            _store.collection('todo').document(documentId).setData({'_id': id, 'title': title, 'done': 0});
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No data found..'),
                  );
                }
              }
            } else {
              return Center(
                child: Text('No data found..'),
              );
            }
        },
        stream: _store.collection('todo').where('done', isEqualTo: tabIndex).snapshots(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.list),
              title: new Text('Task'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.done_all),
              title: new Text('Completed'),
            ),
          ],
          onTap: (int i) {
              setState(() {
                tabIndex = i;
              });
            },
        ),
   );
 }
}