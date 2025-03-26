import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: widget.turnBack,
          ),
        ),
        body: Center(
            child: SizedBox(
          width: 400,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Nazwa"),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: "Adres"),
              ),
              SizedBox(
                  width: 400,
                  height: 240,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: "Opis"),
                  )),
              const Divider(),
              const Text("Godziny otwarcia"),
              const Divider(),
              TextField(
                controller: mondayController,
                decoration: const InputDecoration(hintText: "Poniedziałek"),
              ),
              TextField(
                controller: tuesdayController,
                decoration: const InputDecoration(hintText: "Wtorek"),
              ),
              TextField(
                controller: wednesdayController,
                decoration: const InputDecoration(hintText: "Środa"),
              ),
              TextField(
                controller: thursdayController,
                decoration: const InputDecoration(hintText: "Czwartek"),
              ),
              TextField(
                controller: fridayController,
                decoration: const InputDecoration(hintText: "Piątek"),
              ),
              TextField(
                controller: saturdayController,
                decoration: const InputDecoration(hintText: "Sobota"),
              ),
              TextField(
                controller: sundayController,
                decoration: const InputDecoration(hintText: "Niedziela"),
              ),
              Divider(),
              TextButton(
                onPressed: () {},
                child: const Text("Dodaj restauracje"),
              )
            ],
          ),
        )));
  }
}
