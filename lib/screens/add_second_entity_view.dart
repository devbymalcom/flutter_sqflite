import 'package:flutter/material.dart';
import 'package:flutter_sqflite/main.dart';

import '../models/second_entity.dart';

class AddSecondEntityView extends StatefulWidget {
  const AddSecondEntityView(
      {super.key, required this.action, this.secondEntity});

  final String action;
  final SecondEntity? secondEntity;

  @override
  State<AddSecondEntityView> createState() => _AddSecondEntityViewState();
}

class _AddSecondEntityViewState extends State<AddSecondEntityView> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _saveSecondEntity() {
    if (widget.secondEntity != null) {
      databaseService.saveSecondEntity(
        SecondEntity(
          id: widget.secondEntity!.id,
          name: nameController.text,
          description: descriptionController.text,
        ),
      );
    } else {
      databaseService.saveSecondEntity(
        SecondEntity(
          name: nameController.text,
          description: descriptionController.text,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.secondEntity != null) {
      nameController.text = widget.secondEntity!.name;
      descriptionController.text = widget.secondEntity!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('${widget.action} Second Entity'),
        centerTitle: true,
      ),
      body: Column(children: [
        const SizedBox(height: 12.0),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 12.0),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Description',
          ),
        ),
        const SizedBox(height: 12.0),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty) {
              _saveSecondEntity();
              Navigator.pop(context);
            }
          },
          child: Text(widget.secondEntity != null
              ? 'Update Second Entity'
              : 'Save Second Entity'),
        ),
      ]),
    );
  }
}
