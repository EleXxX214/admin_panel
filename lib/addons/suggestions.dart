import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sugestie"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("suggests").snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data?.docs[index]["name"] ?? ""),
                subtitle: Text(snapshot.data?.docs[index]["description"] ?? ""),
                trailing: IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("suggests")
                        .doc(snapshot.data?.docs[index].id)
                        .delete();
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
