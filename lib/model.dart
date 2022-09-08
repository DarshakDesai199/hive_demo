import 'package:hive_flutter/adapters.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class NotesModel {
  final String? title;
  final String? content;
  final DateTime? date;
  late bool? time;

  NotesModel({this.title, this.content, this.date, this.time});
}
