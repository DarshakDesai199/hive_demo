import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  Box<String>? dataBox;
  final dataTitle = TextEditingController();
  final dataContent = TextEditingController();

  @override
  void initState() {
    dataBox = Hive.box<String>("todo");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    const Text("Add Notes"),
                    TextFormField(
                      controller: dataContent,
                      decoration: const InputDecoration(hintText: "Content"),
                    ),
                    TextFormField(
                      controller: dataTitle,
                      decoration: const InputDecoration(hintText: "Title"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () async {
                        dataBox!.put("${Random().nextInt(1000)}",
                            dataContent.text + '\n' + dataTitle.text);
                        // dataBox!.put(dataTitle.text, dataContent.text);
                        Navigator.pop(context);

                        dataTitle.clear();
                        dataContent.clear();
                      },
                      child: const Text("Yes")),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: dataBox!.listenable(),
        builder: (BuildContext context, Box<String> value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final key = value.keys.toList()[index];
              final values = dataBox!.get(key);

              return ListTile(
                title: Text(values!),
                // subtitle: Text(values!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  const Text("Update"),
                                  TextFormField(
                                    controller: dataContent,
                                    decoration: const InputDecoration(
                                        hintText: "Content"),
                                  ),
                                  TextFormField(
                                    controller: dataTitle,
                                    decoration: const InputDecoration(
                                        hintText: "Title"),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () async {
                                      await dataBox!.put(
                                          key,
                                          dataContent.text +
                                              '\n' +
                                              dataTitle.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Update"))
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Do you want to delete it?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () {
                                      dataBox!.delete(key);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"))
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
