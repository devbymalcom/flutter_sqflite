import 'package:flutter/material.dart';
import 'package:flutter_sqflite/db/database_service.dart';

import 'models/first_entity.dart';
import 'models/second_entity.dart';
import 'screens/add_first_entity_view.dart';
import 'screens/add_second_entity_view.dart';

late DatabaseService databaseService;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseService = DatabaseService();
  await databaseService.ready;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter SQFlite Database'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('First Entity'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Second Entity'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [FirstEntityListviewPage(), SecondEntityListviewPage()],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              label: const Text('Add 1st Entity'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFirstEntityView(
                      action: 'Add',
                    ),
                  ),
                );
              },
              heroTag: 'addFirstEntity',
              icon: const Icon(Icons.add),
            ),
            const SizedBox(height: 12.0),
            FloatingActionButton.extended(
              label: const Text('Add 2nd Entity'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddSecondEntityView(
                      action: 'Add',
                    ),
                  ),
                );
              },
              heroTag: 'addSecondEntity',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstEntityListviewPage extends StatelessWidget {
  const FirstEntityListviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FirstEntity>>(
      stream: databaseService.onFirstEntities(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No First Entity found.\nAdd at least one entity to continue',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.0),
                  ]),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final firstEntity = snapshot.data![index];
              return ListTile(
                title: Text('Name: ${firstEntity.name}'),
                subtitle: Text('Description: ${firstEntity.description}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    databaseService.deleteSecondEntity(firstEntity.id!);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFirstEntityView(
                        action: 'Edit',
                        firstEntity: firstEntity,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
//new

class SecondEntityListviewPage extends StatelessWidget {
  const SecondEntityListviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SecondEntity>>(
      stream: databaseService.onSecondEntities(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
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
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final secondEntity = snapshot.data![index];
              return ListTile(
                title: Text('Name: ${secondEntity.name}'),
                subtitle: Text('Description: ${secondEntity.description}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    databaseService.deleteSecondEntity(secondEntity.id!);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSecondEntityView(
                        action: 'Edit',
                        secondEntity: secondEntity,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
