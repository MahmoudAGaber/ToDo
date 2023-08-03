
import 'package:hive/hive.dart';
import 'package:to_do/Model/toDoListModel.dart';

class LocalToDoListStorage{

  @override
  Future<Box> openBox(String boxName)async{
    Box box = await Hive.openBox<ToDoListModel>(boxName);
    return box;
  }

  @override
  List<ToDoListModel> getToDoList(Box box){
    return box.values.toList() as List<ToDoListModel>;
  }

  @override
  Future<ToDoListModel> addItem(Box box,ToDoListModel responseModel)async{
    await box.put(responseModel.id,responseModel);
    return responseModel;
  }

  @override
  Future<ToDoListModel> updateItem(Box box,ToDoListModel responseModel)async{
    await box.put(responseModel.id, responseModel);
    return responseModel;
  }
  
  @override
  Future<ToDoListModel> removeItem(Box box,ToDoListModel responseModel)async{
    await box.delete(responseModel.id);
    return responseModel;
  }

}