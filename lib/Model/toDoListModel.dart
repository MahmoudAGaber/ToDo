import 'dart:ui';

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ToDoListModel extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  Color color;

  @HiveField(2)
  String taskName;

  @HiveField(3)
  String taskDesc;

  @HiveField(4)
  String date;

  @HiveField(5)
  String time;

  ToDoListModel({required this.id,required this.color, required this.taskName, required this.taskDesc, required this.date, required this.time});


  factory ToDoListModel.json(Map json,List<ToDoListModel> localList){
    return ToDoListModel(
        id: json['id'],
        color: json['color'],
        taskName: json['taskName'],
        taskDesc: json['taskDesc'],
        date: json['date'],
        time: json['time']
    );

  }

  static List<ToDoListModel> ListFromJson(List listFromJson,List<ToDoListModel> listFromLocal) {
    return listFromJson.map((e) => ToDoListModel.json(e,listFromLocal)).toList();
  }

}
