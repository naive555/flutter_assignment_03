import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoScreen extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _TodoState();
  }
}

class _TodoState extends State<TodoScreen> {
  List<Todo> todoList;
  List<Todo> doneList;
  Firestore _store = Firestore();
  int todoCount = 0;
  int doneCount = 0;
  int tabIndex = 0;

  void getList() async{
    await provider.open('todo.db');
    provider.getAllTodo().then((todoList) {
      setState(() {
        this.todoList = todoList;
        this.todoCount = todoList.length;
      });
    });
    provider.getAllDone().then((doneList) {
      setState(() {
        this.doneList = doneList;
        this.doneCount = doneList.length;
      });
    });
  }

 @override
 Widget build(BuildContext context) {
   getList();
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
            setState(() {});
            return _store.collection('todo').where('done', isEqualTo: 1).getDocuments().then((d) {
              d.documents.forEach((f) {
                f.reference.delete();
              });
            });
            },
          ),
        ]
      ),
      body: StreamBuilder(),
      // body: Center(
      //     child: tabIndex == 0
      //     ? todoCount > 0
      //     ? ListView.builder(
      //           itemCount: todoCount,
      //           itemBuilder: (context, int index) {
      //             return Column(
      //               children: <Widget>[
      //                 ListTile(
      //                   title: Text(
      //                     this.todoList[index].title,
      //                   ),
      //                   trailing: Checkbox(
      //                       onChanged: (bool boolean) {
      //                         setState(() {
      //                           todoList[index].done = boolean;
      //                         });
      //                         provider.update(todoList[index]);
      //                       },
      //                       value: todoList[index].done
      //                       ),
      //                     )
      //                   ],
      //                 );
      //               },
      //             )
      //           : Text('No data found..')
      //       : doneCount > 0 ?
      //         ListView.builder(
      //           itemCount: doneCount,
      //           itemBuilder: (context, int index) {
      //             return Column(
      //               children: <Widget>[
      //                 ListTile(
      //                   title: Text(
      //                     this.doneList[index].title,
      //                   ),
      //                   trailing: Checkbox(
      //                       onChanged: (bool boolean) {
      //                         setState(() {
      //                           doneList[index].done = boolean;
      //                         });
      //                         provider.update(doneList[index]);
      //                       },
      //                       value: doneList[index].done
      //                       ),
      //                     )
      //                   ],
      //                 );
      //               },
      //             )
      //           : Text('No data found..')
      //     ),
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