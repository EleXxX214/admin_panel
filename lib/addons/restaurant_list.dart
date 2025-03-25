import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    //______________________________
    //        logger
    //______________________________
    // ignore: unused_local_variable
    var logger = Logger();

    Widget buildRestaurantLogo(String docId) {
      return FutureBuilder(
          future: FirebaseStorage.instance
              .ref("restaurants_photos/$docId/logo.jpg")
              .getDownloadURL(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Icon(Icons.broken_image);
            }

            final imageUrl = snapshot.data!;
            return Image.network(
              imageUrl,
              fit: BoxFit.contain,
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        )),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("restaurants")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text("Błąd");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index]
                      .data(); // Pobiera wszystkie dane z restauracji do 'data'
                  final name =
                      data['name'] ?? "Bez Nazwy"; // Pobiera nazwe restauracji
                  final docId = docs[index].id.trim();

                  return ListTile(
                    title: Text(name),
                    leading: buildRestaurantLogo(docId),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  );
                },
              );
            }));
  }
}
