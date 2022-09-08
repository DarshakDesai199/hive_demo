import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_demo/main.dart';
import 'package:hive_demo/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  Box<NotesModel>? boxNotes;
  final title = TextEditingController();
  final notes = TextEditingController();
  @override
  void initState() {
    boxNotes = Hive.box<NotesModel>(boxName);
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
                        controller: title,
                        decoration:
                            const InputDecoration(hintText: "Enter a Title"),
                      ),
                      TextFormField(
                        controller: notes,
                        decoration:
                            const InputDecoration(hintText: "Enter a Notes"),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        String addTitle = title.text;
                        String addNotes = notes.text;
                        DateTime addDate = DateTime.now();
                        NotesModel modelNotes = NotesModel(
                            date: addDate,
                            title: addTitle,
                            content: addNotes,
                            time: false);

                        boxNotes!.add(modelNotes);

                        Navigator.pop(context);

                        title.clear();
                        notes.clear();
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add)),
      body: ValueListenableBuilder(
        valueListenable: boxNotes!.listenable(),
        builder: (BuildContext context, Box<NotesModel> value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              var key = value.keys.toList()[index];
              var values = boxNotes!.get(key);
              return ListTile(
                title: Text("${values!.title}"),
                subtitle: Text("${values.content}"),
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
                                  const Text("Update Notes"),
                                  TextFormField(
                                    controller: title,
                                    decoration: const InputDecoration(
                                        hintText: "Enter a Title"),
                                  ),
                                  TextFormField(
                                    controller: notes,
                                    decoration: const InputDecoration(
                                        hintText: "Enter a Notes"),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String updateTitle = title.text;
                                    String updateNotes = notes.text;
                                    DateTime updateDate = DateTime.now();
                                    NotesModel update = NotesModel(
                                        date: updateDate,
                                        title: updateTitle,
                                        content: updateNotes,
                                        time: false);

                                    boxNotes!.put(key, update);

                                    Navigator.pop(context);

                                    title.clear();
                                    notes.clear();
                                  },
                                  child: const Text("Yes"),
                                ),
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
                              title: const Text("Do you Want to Delete this?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () {
                                      boxNotes!.delete(key);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
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
