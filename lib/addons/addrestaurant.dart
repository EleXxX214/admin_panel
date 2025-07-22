import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant(
      {super.key, required this.turnBack, this.docId, this.initialData});

  final VoidCallback turnBack;
  final String? docId;
  final Map<String, dynamic>? initialData;

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
final TextEditingController menuUrlController = TextEditingController();

class _AddRestaurantState extends State<AddRestaurant> {
  Logger logger = Logger();
  Uint8List? logoImage;
  List<PlatformFile> galleryImages = [];
  bool initialized = false;

  // Dodane do obsługi filtrów
  List<String> availableFilters = [];
  List<String> selectedFilters = [];
  bool filtersLoading = true;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    // Pobierz filtry z Firestore
    FirebaseFirestore.instance.collection('filters').get().then((snapshot) {
      setState(() {
        availableFilters = snapshot.docs.map((doc) {
          if (doc.data().containsKey('food_type') &&
              doc['food_type'] != null &&
              doc['food_type'].toString().isNotEmpty) {
            return doc['food_type'].toString();
          } else if (doc.data().containsKey('name') &&
              doc['name'] != null &&
              doc['name'].toString().isNotEmpty) {
            return doc['name'].toString();
          } else {
            return doc.id;
          }
        }).toList();
        filtersLoading = false;
        // Jeśli edycja, ustaw wybrane filtry
        if (widget.initialData != null) {
          selectedFilters = [
            widget.initialData!["filter1"],
            widget.initialData!["filter2"],
            widget.initialData!["filter3"],
            widget.initialData!["filter4"],
            widget.initialData!["filter5"],
          ].whereType<String>().where((f) => f.isNotEmpty).toList();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized && widget.initialData != null) {
      nameController.text = widget.initialData!["name"] ?? "";
      addressController.text = widget.initialData!["address"] ?? "";
      descriptionController.text = widget.initialData!["description"] ?? "";
      mondayController.text = widget.initialData!["monday"] ?? "";
      tuesdayController.text = widget.initialData!["tuesday"] ?? "";
      wednesdayController.text = widget.initialData!["wednesday"] ?? "";
      thursdayController.text = widget.initialData!["thursday"] ?? "";
      fridayController.text = widget.initialData!["friday"] ?? "";
      saturdayController.text = widget.initialData!["saturday"] ?? "";
      sundayController.text = widget.initialData!["sunday"] ?? "";
      menuUrlController.text = widget.initialData!["menuUrl"] ?? "";
      isVisible = widget.initialData!["isVisible"] ?? true;
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance.collection("restaurants");

    void pickPhoto() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.first.bytes != null) {
        final imageBytes = result.files.first.bytes!;
        logger.d("Picked logo size: ${imageBytes.length}");

        // Limit rozmiaru — np. 5MB
        if (imageBytes.lengthInBytes > 8 * 3000 * 3000) {
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

    void pickGalleryPhotos() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );
      if (result != null) {
        setState(
          () {
            galleryImages =
                result.files.where((file) => file.bytes != null).toList();
          },
        );
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
                              TextField(
                                controller: menuUrlController,
                                decoration:
                                    const InputDecoration(hintText: "URL menu"),
                              ),
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
                              Row(
                                children: [
                                  const Text("Restauracja widoczna:"),
                                  Switch(
                                    value: isVisible,
                                    onChanged: (val) {
                                      setState(() {
                                        isVisible = val;
                                      });
                                    },
                                  ),
                                ],
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
                              ElevatedButton(
                                  onPressed: pickGalleryPhotos,
                                  child:
                                      const Text("Dodaj zdjęcia do karuzeli")),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: galleryImages.map((file) {
                                  return Image.memory(
                                    file.bytes!,
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                  );
                                }).toList(),
                              ),
                              const Divider(),
                              const Text("Filtry (max 5):"),
                              filtersLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  : Wrap(
                                      spacing: 8,
                                      children: availableFilters.map((filter) {
                                        final isSelected =
                                            selectedFilters.contains(filter);
                                        return FilterChip(
                                          label: Text(filter),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            setState(() {
                                              if (selected) {
                                                if (selectedFilters.length <
                                                    5) {
                                                  selectedFilters.add(filter);
                                                }
                                              } else {
                                                selectedFilters.remove(filter);
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                              TextButton(
                                onPressed: () async {
                                  if (selectedFilters.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Wybierz przynajmniej jeden filtr!")),
                                    );
                                    return;
                                  }
                                  final restaurantData = {
                                    'name': nameController.text.trim(),
                                    'address': addressController.text.trim(),
                                    'description':
                                        descriptionController.text.trim(),
                                    'menuUrl': menuUrlController.text.trim(),
                                    'monday': mondayController.text.trim(),
                                    'tuesday': tuesdayController.text.trim(),
                                    'wednesday':
                                        wednesdayController.text.trim(),
                                    'thursday': thursdayController.text.trim(),
                                    'friday': fridayController.text.trim(),
                                    'saturday': saturdayController.text.trim(),
                                    'sunday': sundayController.text.trim(),
                                    'isVisible': isVisible,
                                    // Zawsze ustaw filter1–filter5, brakujące jako pusty string
                                    for (int i = 0; i < 5; i++)
                                      'filter${i + 1}':
                                          i < selectedFilters.length
                                              ? selectedFilters[i]
                                              : '',
                                  };

                                  try {
                                    String restaurantId;
                                    if (widget.docId != null) {
                                      // Tryb edycji
                                      await FirebaseFirestore.instance
                                          .collection("restaurants")
                                          .doc(widget.docId)
                                          .update(restaurantData);
                                      restaurantId = widget.docId!;
                                    } else {
                                      // Dodawanie nowej restauracji
                                      final docRef = await FirebaseFirestore
                                          .instance
                                          .collection("restaurants")
                                          .add(restaurantData);
                                      restaurantId = docRef.id;
                                    }

                                    if (logoImage != null) {
                                      await FirebaseStorage.instance
                                          .ref(
                                              "restaurants_photos/$restaurantId/logo.jpg")
                                          .putData(logoImage!);
                                    }

                                    for (int i = 0;
                                        i < galleryImages.length;
                                        i++) {
                                      final image = galleryImages[i];
                                      await FirebaseStorage.instance
                                          .ref(
                                              "restaurants_photos/$restaurantId/$i.jpg")
                                          .putData(image.bytes!);
                                    }

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
                                    menuUrlController.clear();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(widget.docId != null
                                            ? "Restauracja zaktualizowana"
                                            : "Restauracja dodana"),
                                      ),
                                    );
                                    setState(() {
                                      logoImage = null;
                                      galleryImages.clear();
                                    });
                                    widget.turnBack();
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Błąd: $e")),
                                    );
                                  }
                                },
                                child: Text(widget.docId != null
                                    ? "Zapisz zmiany"
                                    : "Dodaj restauracje"),
                              )
                            ],
                          ),
                        ))))));
  }
}
