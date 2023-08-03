



import 'package:flutter/material.dart';
import 'package:to_do/Model/toDoListModel.dart';
import 'package:hive/hive.dart';
import 'package:to_do/Service/LocalToDoListStorage.dart';


class ToDoListViewModel extends ChangeNotifier{

  List<ToDoListModel>? toDoLit = [];
  ToDoListModel? toDoListModel;
  Color selectedColor = Colors.transparent;
  bool isAdd = true;
  bool isFilter = false;
  bool _loading = false;
  bool isLoading = false;
  bool get getLoading => _loading;
  LocalToDoListStorage localStorageRepo = LocalToDoListStorage();



  Future<void> getToDoTask(ToDoListModel toDoListModel)async{
    this.toDoListModel = toDoListModel;
        isAdd = false;
        notifyListeners();
  }


  Future<void> getAllToDoList(String boxName)async{
    Box box = await localStorageRepo.openBox(boxName);
    toDoLit = localStorageRepo.getToDoList(box);
    notifyListeners();
  }




  Future<void> addTask(ToDoListModel taskItem,String boxName)async{
    Box box = await localStorageRepo.openBox(boxName);
    localStorageRepo.addItem(box,taskItem);
    toDoLit = box.values.cast<ToDoListModel>().toList();

    print(toDoLit![0].id);

    notifyListeners();
  }



  Future<void> removeTask(ToDoListModel taskItem,String boxName)async{
    Box box = await localStorageRepo.openBox(boxName);
    toDoLit?.remove(localStorageRepo.removeItem(box,taskItem));
      toDoLit = box.values.cast<ToDoListModel>().toList();

    notifyListeners();
  }

  Future<void> updateTask(ToDoListModel taskItem,String boxName)async{
    Box box = await localStorageRepo.openBox(boxName);
    localStorageRepo.updateItem(box, taskItem);
    toDoLit = box.values.cast<ToDoListModel>().toList();

    notifyListeners();
  }


  Future<void> filterToDoList(String? date, Color? color) async {
    List<ToDoListModel>? tempList = [];

    for (int i = 0; i< toDoLit!.length; i++){

      if((date == toDoLit![i].date && color == toDoLit![i].color)){
        tempList.add(toDoLit![i]);
      }

      if (date != null && color == null && date == toDoLit![i].date ) {
        tempList.add(toDoLit![i]);
      }

      if (color != null && date != toDoLit![i].date && color == toDoLit![i].color) {
        tempList.add(toDoLit![i]);
      }
    }

    toDoLit!.clear();
    isFilter = true;
    toDoLit = tempList;
    notifyListeners();
  }


  void toggleLoading(bool loading){
    _loading = loading;
    notifyListeners();
  }

}