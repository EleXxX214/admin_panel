import 'package:admin_panel/addons/addrestaurant.dart';
import 'package:admin_panel/addons/restaurant_list.dart';
import 'package:admin_panel/addons/suggestions.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? selectedPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: Center(
          child: Row(
        children: [
          Container(
            width: 250,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.blue[200]),
            child: Column(children: [
              ListTile(
                title: const Text("Restauracje"),
                onTap: () {
                  setState(() => selectedPage = "restauracje");
                },
              ),
              ListTile(
                title: const Text("Sugestie"),
                onTap: () {
                  setState(() => selectedPage = "suggestions");
                },
              ),
              ListTile(
                title: const Text("Użytkownicy"),
                onTap: () {
                  selectedPage = "uzytkownicy";
                },
              ),
              const ListTile(title: Text("Wyloguj")),
            ]),
          ),
          Expanded(child: Builder(
            builder: (context) {
              if (selectedPage == "restauracje") {
                return RestaurantList(onAddPressed: () {
                  setState(() {
                    selectedPage = "dodaj_restauracje";
                  });
                });
              } else if (selectedPage == "dodaj_restauracje") {
                return AddRestaurant(
                  turnBack: () {
                    setState(
                      () {
                        selectedPage = "restauracje";
                      },
                    );
                  },
                );
              } else if (selectedPage == "suggestions") {
                return SuggestionsPage();
              }

              return const Text("Wybierz coś!");
            },
          ))
        ],
      )),
    );
  }
}
