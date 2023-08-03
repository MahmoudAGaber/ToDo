import 'package:flutter/material.dart';
import 'package:to_do/ViewModel/toDoListViewModel.dart';
import 'package:provider/provider.dart';
import 'Model/toDoListModel.dart';
import 'Service/LocalNotificationService.dart';
import 'View/Login/Login.dart';
import 'ViewModel/userViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:timezone/data/latest.dart' as tz;
part 'main.g.dart';



SharedPreferences? prefs;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().initNotification();
  tz.initializeTimeZones();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ToDoListModelAdapter());
  prefs = await SharedPreferences.getInstance();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => UserViewModel()
          ),
          ChangeNotifierProvider(
              create: (_) => ToDoListViewModel()
          ),
        ],
        child: MyApp(),
      )
  );

}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}


