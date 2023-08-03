import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:to_do/View/Home/DrawerScreen.dart';
import 'package:to_do/Model/toDoListModel.dart';
import 'package:to_do/View/Home/FilterScreen.dart';
import 'package:to_do/ViewModel/toDoListViewModel.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ToDoListViewModel? toDoListViewModel;
  ToDoListModel? toDoListModel;
  bool add = true;
  bool filter = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      toDoListViewModel = Provider.of(context, listen: false);
      toDoListViewModel?.getAllToDoList("toToTask");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState?.openEndDrawer();
                    filter = true;
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,width: 17,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromRGBO(254, 30, 154, 1),
                                  Color.fromRGBO(254, 166, 76, 1)
                                ]
                            ),
                          borderRadius: BorderRadius.circular(2)
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        height: 6,width: 27,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            colors: [
                              Color.fromRGBO(254, 30, 154, 1),
                            Color.fromRGBO(254, 166, 76, 1)
                            ]
                          ),
                            borderRadius: BorderRadius.circular(2)
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
            title: Text(
              "TODO",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(254, 166, 76, 0.15),
          ),
          floatingActionButton: Container(
            height: 68,
            width: 68,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 255, 255, 1),
                    Color.fromRGBO(37, 77, 222, 1)
                  ]
                )
              ),
              child: Builder(
                builder: (context) => Consumer<ToDoListViewModel>(
                  builder: (context,provider,child){
                    return FloatingActionButton(
                      onPressed: () {
                        filter = false;
                        provider.isAdd = true;
                        Scaffold.of(context).openEndDrawer();
                      },
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(
                        Icons.add,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

           endDrawer:Consumer<ToDoListViewModel>(
               builder: (context,provider,child){
                 return filter
                     ? FilterScreen()
                     :DrawerScreen(provider.isAdd,provider.toDoListModel
                     ?? ToDoListModel(id: "", color: Color(0), taskName: '', taskDesc: '', date: '', time: '')
                 );
                 },
           ),
          body: Consumer<ToDoListViewModel>(
            builder: (context,provider,child){
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(254, 166, 76, 0.15),
                        Color.fromRGBO(254, 30, 154, 0.4),
                        Color.fromRGBO(37, 77, 222, 0.4),
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      provider.isFilter
                          ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(onPressed: (){
                              provider.isFilter = false;
                              provider.getAllToDoList("toToTask");
                      }, icon: Icon(Icons.clear)),
                          )
                          :Container(),
                      provider.toDoLit!.isEmpty
                          ? Center(child: Text("No data to show !!!",
                        style: TextStyle(fontSize: 20,color: Colors.white),),)
                      :ListView.builder(
                        shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: provider.toDoLit?.length ?? 0,
                          itemBuilder: (context, index) {
                            var data = provider.toDoLit?[index];
                            if(data!=null) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 4, bottom: 8),
                                child: Container(
                                  height: 75,
                                  child: Builder(
                                    builder: (context) =>
                                        GestureDetector(
                                          onTap: () {
                                            filter = false;
                                            provider.getToDoTask(data);
                                            _scaffoldKey.currentState?.openEndDrawer();
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12, right: 12, top: 6, bottom: 6),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: data.color,
                                                          radius: 12,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            data.taskDesc,
                                                            style: TextStyle(fontSize: 16),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        data.date,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400),
                                                      ),
                                                      SizedBox(height: 2,),
                                                      Text(
                                                        data.time,
                                                        style: TextStyle(
                                                            color: Colors.grey, fontSize: 14),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              );
                            }
                            else {
                              return Container();
                            }

                          }),
                    ],
                      ),
                ),
              );
            },
          ));
  }


}
