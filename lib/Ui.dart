import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'model.dart';

class UI extends StatefulWidget {
  const UI({Key? key}) : super(key: key);

  @override
  State<UI> createState() => _UIState();
}

class _UIState extends State<UI> {
  Box<NotesModel>? boxNotes;
  final title = TextEditingController();
  final notes = TextEditingController();
  bool expanded = false;
  var format = DateFormat('dd/MM/yyyy -  kk/mm');

  @override
  void initState() {
    boxNotes = Hive.box<NotesModel>(boxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 80,
            left: 10,
            right: 0,
            child: Container(
              height: height * 0.6,
              width: width * 0.9,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Welcome1.png"),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 65,
            left: 35,
            child: Text(
              "TODOS",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.85,
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                        color: Colors.white),
                    child: ValueListenableBuilder(
                      valueListenable: boxNotes!.listenable(),
                      builder:
                          (BuildContext context, Box<NotesModel> value, _) {
                        if (value != null) {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              var key = value.keys.toList()[index];
                              var values = boxNotes!.get(key);
                              var dateString = format.format(values!.date!);

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ExpansionPanelList(
                                  animationDuration:
                                      const Duration(milliseconds: 600),
                                  children: [
                                    ExpansionPanel(
                                      headerBuilder: (context, isExpanded) {
                                        return ListTile(
                                          title: Text(
                                            "Notes No. $index",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${values!.title}",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Text(
                                                "${values.content}",
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      isExpanded: values!.time!,
                                      canTapOnHeader: true,
                                      body: ListTile(
                                        title: Text(dateString),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Column(
                                                        children: [
                                                          const Text(
                                                              "Update Notes"),
                                                          TextFormField(
                                                            controller: title,
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        "Enter a Title"),
                                                          ),
                                                          TextFormField(
                                                            controller: notes,
                                                            decoration:
                                                                const InputDecoration(
                                                                    hintText:
                                                                        "Enter a Notes"),
                                                          )
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            String updateTitle =
                                                                title.text;
                                                            String updateNotes =
                                                                notes.text;
                                                            DateTime
                                                                updateDate =
                                                                DateTime.now();
                                                            NotesModel update = NotesModel(
                                                                date:
                                                                    updateDate,
                                                                title:
                                                                    updateTitle,
                                                                content:
                                                                    updateNotes,
                                                                time: expanded);

                                                            await boxNotes!.put(
                                                                key, update);

                                                            Navigator.pop(
                                                                context);

                                                            title.clear();
                                                            notes.clear();
                                                          },
                                                          child:
                                                              const Text("Add"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Do you Want to Delete this?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"),
                                                        ),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              await boxNotes!
                                                                  .delete(key);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Yes")),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  expansionCallback: (panelIndex, isExpanded) {
                                    setState(
                                      () {
                                        values.time = !values.time!;
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: -30,
                    right: 23,
                    child: FloatingActionButton(
                        backgroundColor: Colors.pinkAccent,
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
                                    onPressed: () async {
                                      String addTitle = title.text;
                                      String addNotes = notes.text;
                                      DateTime addDate = DateTime.now();
                                      NotesModel modelNotes = NotesModel(
                                          date: addDate,
                                          title: addTitle,
                                          content: addNotes,
                                          time: expanded);

                                      await boxNotes!.add(modelNotes);

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
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
