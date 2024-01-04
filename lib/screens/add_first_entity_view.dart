import 'package:flutter/material.dart';
import 'package:flutter_sqflite/main.dart';

import '../models/first_entity.dart';
import '../models/second_entity.dart';

class AddFirstEntityView extends StatefulWidget {
  const AddFirstEntityView({super.key, required this.action, this.firstEntity});

  final String action;
  final FirstEntity? firstEntity;

  @override
  State<AddFirstEntityView> createState() => _AddFirstEntityViewState();
}

class _AddFirstEntityViewState extends State<AddFirstEntityView> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _saveFirstEntity() {
    if (widget.firstEntity != null) {
      databaseService.saveFirstEntity(
        FirstEntity(
          id: widget.firstEntity!.id,
          name: nameController.text,
          description: descriptionController.text,
          secondEntityId: widget.firstEntity!.secondEntityId,
        ),
      );
    } else {
      databaseService.saveFirstEntity(
        FirstEntity(
          name: nameController.text,
          description: descriptionController.text,
          secondEntityId: widget.firstEntity!.secondEntityId,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.firstEntity != null) {
      nameController.text = widget.firstEntity!.name;
      descriptionController.text = widget.firstEntity!.description;
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
        title: Text('${widget.action} First Entity'),
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
        StreamBuilder(
          stream: databaseService.onSecondEntities(),
          builder: (BuildContext context,
              AsyncSnapshot<List<SecondEntity>> snapshot) {
            if (snapshot.hasData) {
              List<SecondEntity> data = snapshot.data ?? [];
              final aircrafts = data.map(
                (e) {
                  return e.id;
                },
              ).toList();
              if (data.isEmpty) {
                return const Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Second Entity found.\nAdd at least one entity to continue',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.0),
                      ]),
                );
              }

              return DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Second Entity',
                ),
                value: widget.firstEntity != null
                    ? widget.firstEntity!.id
                    : aircrafts.first,
                onChanged: (value) {
                  setState(() {
                    widget.firstEntity!.id = value;
                  });
                },
                items: aircrafts.map((aircraft) {
                  return DropdownMenuItem(
                    value: aircraft,
                    child: Text(aircraft.toString()),
                  );
                }).toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty) {
              _saveFirstEntity();
              Navigator.pop(context);
            }
          },
          child: Text(widget.firstEntity != null
              ? 'Update First Entity'
              : 'Add First Entity'),
        ),
      ]),
    );
  }
}
