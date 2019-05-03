import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return FirestoreState();
  }
}

class FirestoreState extends State<FirestoreScreen> {
  Firestore _store = Firestore.instance;

  Widget listdata() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  snapshot.data.documents.elementAt(index).data["title"]),
              );
            },
          );
        } else {
          return Text("No data found");
        }
      },
      stream: _store.collection("book").snapshots(),
    );
  }

  @override
  Widget build(BuildContext context) {
    listdata();
    return null;
  }
  
}