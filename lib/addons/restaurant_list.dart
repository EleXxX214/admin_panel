import 'package:admin_panel/addons/addrestaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key, required this.onAddPressed});
  final VoidCallback onAddPressed;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  String? editingDocId;
  Map<String, dynamic>? editingData;

  void startEditing(String docId, Map<String, dynamic> data) {
    setState(() {
      editingDocId = docId;
      editingData = data;
    });
  }

  void stopEditing() {
    setState(() {
      editingDocId = null;
      editingData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    // Jeśli edytujemy restaurację, pokaż formularz edycji
    if (editingDocId != null && editingData != null) {
      return Scaffold(
        body: AddRestaurant(
          turnBack: stopEditing,
          docId: editingDocId,
          initialData: editingData,
        ),
      );
    }

    // Widok listy restauracji
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.onAddPressed,
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
                  final data = docs[index].data();
                  final name = data['name'] ?? "Bez Nazwy";
                  final docId = docs[index].id.trim();

                  return Card(
                      child: ListTile(
                    tileColor: Colors.grey[200],
                    title: Text(name),
                    leading: buildRestaurantLogo(docId),
                    trailing: MenuAnchor(
                      builder: (BuildContext context, MenuController controller,
                          Widget? child) {
                        return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: const Icon(Icons.more_vert));
                      },
                      menuChildren: <Widget>[
                        MenuItemButton(
                          onPressed: () {
                            startEditing(docId, data);
                          },
                          child: const Text("Edytuj"),
                        ),
                        MenuItemButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    "Czy na pewno chcesz usunąć restaurację?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Anuluj"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FirebaseFirestore.instance
                                          .collection("restaurants")
                                          .doc(docId)
                                          .delete();
                                    },
                                    child: Text("Usuń restaurację $name"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Usuń"),
                        )
                      ],
                    ),
                  ));
                },
              );
            }));
  }
}
