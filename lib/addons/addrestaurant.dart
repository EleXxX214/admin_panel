import 'package:flutter/material.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key, required this.turnBack});

  final VoidCallback turnBack;

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

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
    );
  }
}
