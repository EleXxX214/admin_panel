import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key, required this.turnBack});

  final VoidCallback turnBack;

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController mondayController = TextEditingController();
final TextEditingController tuesdayController = TextEditingController();
final TextEditingController wednesdayController = TextEditingController();
final TextEditingController thursdayController = TextEditingController();
final TextEditingController fridayController = TextEditingController();
final TextEditingController saturdayController = TextEditingController();
final TextEditingController sundayController = TextEditingController();

class _AddRestaurantState extends State<AddRestaurant> {
  Logger logger = Logger();
  Uint8List? logoImage;
  List<PlatformFile> galleryImages = [];

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance.collection("restaurants");

    void pickPhoto() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // 👈 konieczne, by załadować bytes!
      );

      if (result != null && result.files.first.bytes != null) {
        final imageBytes = result.files.first.bytes!;
        logger.d("Picked logo size: ${imageBytes.length}");

        // Limit rozmiaru — np. 5MB
        if (imageBytes.lengthInBytes > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logo za duże (max 5MB)")),
          );
          return;
        }

        setState(() {
          logoImage = imageBytes;
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: widget.turnBack,
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
                    width: 600,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration:
                                    const InputDecoration(hintText: "Nazwa"),
                              ),
                              TextField(
                                controller: addressController,
                                decoration:
                                    const InputDecoration(hintText: "Adres"),
                              ),
                              SizedBox(
                                  width: 400,
                                  height: 240,
                                  child: TextField(
                                    controller: descriptionController,
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration:
                                        const InputDecoration(hintText: "Opis"),
                                  )),
                              const Divider(),
                              const Text("Godziny otwarcia"),
                              const Divider(),
                              TextField(
                                controller: mondayController,
                                decoration: const InputDecoration(
                                    hintText: "Poniedziałek"),
                              ),
                              TextField(
                                controller: tuesdayController,
                                decoration:
                                    const InputDecoration(hintText: "Wtorek"),
                              ),
                              TextField(
                                controller: wednesdayController,
                                decoration:
                                    const InputDecoration(hintText: "Środa"),
                              ),
                              TextField(
                                controller: thursdayController,
                                decoration:
                                    const InputDecoration(hintText: "Czwartek"),
                              ),
                              TextField(
                                controller: fridayController,
                                decoration:
                                    const InputDecoration(hintText: "Piątek"),
                              ),
                              TextField(
                                controller: saturdayController,
                                decoration:
                                    const InputDecoration(hintText: "Sobota"),
                              ),
                              TextField(
                                controller: sundayController,
                                decoration: const InputDecoration(
                                    hintText: "Niedziela"),
                              ),
                              const Divider(),
                              ElevatedButton(
                                  onPressed: pickPhoto,
                                  child: const Text("Dodaj logo")),
                              if (logoImage != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.memory(
                                    logoImage!,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                  ),
                                ),
                              const Divider(),
                              TextButton(
                                  onPressed: () {},
                                  child:
                                      const Text("Dodaj zdjęcia do karuzeli")),
                              TextButton(
                                onPressed: () async {
                                  final restaurantData = {
                                    'name': nameController.text.trim(),
                                    'address': addressController.text.trim(),
                                    'description':
                                        descriptionController.text.trim(),
                                    'monday': mondayController.text.trim(),
                                    'tuesday': tuesdayController.text.trim(),
                                    'wednesday':
                                        wednesdayController.text.trim(),
                                    'thursday': thursdayController.text.trim(),
                                    'friday': fridayController.text.trim(),
                                    'saturday': saturdayController.text.trim(),
                                    'sunday': sundayController.text.trim(),
                                  };

                                  try {
                                    await db.add(restaurantData);
                                    if (!context.mounted) return;

                                    nameController.clear();
                                    addressController.clear();
                                    descriptionController.clear();
                                    mondayController.clear();
                                    tuesdayController.clear();
                                    wednesdayController.clear();
                                    thursdayController.clear();
                                    fridayController.clear();
                                    saturdayController.clear();
                                    sundayController.clear();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Restauracja dodana"),
                                      ),
                                    );
                                    widget.turnBack();
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Błąd: $e")),
                                    );
                                  }
                                },
                                child: const Text("Dodaj restauracje"),
                              )
                            ],
                          ),
                        ))))));
  }
}
