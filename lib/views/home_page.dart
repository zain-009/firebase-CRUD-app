import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task1/readData/get_user_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users').orderBy('age',descending: false)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(user.email!,style: const TextStyle(fontSize: 16),)),
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.settings)),
        actions: [IconButton(onPressed: (){FirebaseAuth.instance.signOut();}, icon: const Icon(Icons.logout))],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: FutureBuilder(
              future: getDocId(),
              builder: (context,snapshot){
            return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: GetUserName(documentId: docIDs[index]),
                      tileColor: Colors.grey[200],
                    ),
                  );
                });
          }))
        ],
      )),
    );
  }
}
