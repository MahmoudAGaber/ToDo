import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/Model/toDoListModel.dart';
import 'package:to_do/Service/LocalNotificationService.dart';
import 'package:to_do/ViewModel/toDoListViewModel.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class DrawerScreen extends StatefulWidget {
  ToDoListModel toDoListModel;
  bool add;
  DrawerScreen(this.add, this.toDoListModel);
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  ToDoListViewModel? toDoListViewModel;

  List<Color> circleColor = [
    Color(0xffFF008D),
    Color(0xff0DC4F4),
    Color(0xffCF28A9),
    Color(0xff3D457F),
    Color(0xff00CF1C),
    Color(0xffFFEE00),
  ];

   Color? selectedColor;
   int? index;
   isSelected(index){
     this.index = index;
   }
   bool isSelecte = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDescController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  DateTime scheduleTime = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    if (!widget.add) {
      for (int i=1; i< circleColor.length; i++){
        if(widget.toDoListModel.color == circleColor[i]){
          isSelected(i);
        }
      }
      selectedColor = widget.toDoListModel.color;
      _taskNameController.text = widget.toDoListModel.taskName;
      _taskDescController.text = widget.toDoListModel.taskDesc;
      _dateController.text = widget.toDoListModel.date;
      _timeController.text = widget.toDoListModel.time;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      toDoListViewModel = Provider.of(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * .8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.9),
              Color.fromRGBO(202, 235, 254, 0.6),
            ]),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 30, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.add ? "NEW TASK" : "Update Task",
                  style: TextStyle(fontSize: 22, color: Color(0xff181743)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              6, (index) => ColorShape(index)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      TextFormField(
                        controller: _taskNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Task Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Name of the task",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _taskDescController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Task Description';
                          }
                          return null;
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Description of the task",
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      TextFormField(
                        controller: _dateController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Date';
                          }
                          return null;
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Select Date",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        onTap: () {
                          _showDatePicker(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      TextFormField(
                        controller: _timeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Time';
                          }
                          return null;
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Select Time",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        onTap: () {
                          _showTimePicker(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Selector<ToDoListViewModel, bool>(
                          selector: (context, provider) => provider.getLoading,
                          builder: (context, loading, child) {
                            return loading
                                ? const Center(
                                    child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(),
                                  ))
                                : widget.add
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(37, 77, 222, 1),
                                              Color.fromRGBO(0, 255, 255, 1)
                                            ])),
                                        child: TextButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              if(selectedColor != null){
                                                toDoListViewModel?.addTask(
                                                    ToDoListModel(
                                                        id:
                                                        "${DateTime.now()}",
                                                        color: selectedColor!,
                                                        taskName:
                                                        _taskNameController.text,
                                                        taskDesc:
                                                        _taskDescController.text,
                                                        date: _dateController.text,
                                                        time: _timeController.text),
                                                    "toToTask");

                                                _scheduleNotification(_taskNameController.text);
                                                Navigator.of(context).pop();
                                              }
                                              else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Please select a color',)));
                                              }

                                            }
                                          },
                                          child: Text(
                                            'Add',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          style: TextButton.styleFrom(
                                            fixedSize: Size(150, 50),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28)),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                toDoListViewModel!.removeTask(widget.toDoListModel,"toToTask");
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            style: TextButton.styleFrom(
                                              fixedSize: Size(120, 50),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(28)),
                                              backgroundColor: Color(0xffE30000),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                gradient: LinearGradient(colors: [
                                                  Color.fromRGBO(37, 77, 222, 1),
                                                  Color.fromRGBO(0, 255, 255, 1)
                                                ])),
                                            child: TextButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  toDoListViewModel!.updateTask(
                                                      ToDoListModel(
                                                          id:"${widget.toDoListModel.id}",
                                                          color: selectedColor!,
                                                          taskName:
                                                          _taskNameController.text,
                                                          taskDesc:
                                                          _taskDescController.text,
                                                          date: _dateController.text,
                                                          time: _timeController.text)
                                                  , "toToTask");
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Text(
                                                'Update',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              style: TextButton.styleFrom(
                                                fixedSize: Size(140, 50),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(28)),
                                                backgroundColor: Colors.transparent,
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                          })),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = _selectedTime.format(context);

      });
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        final currentTime = DateTime.now();
         scheduleTime = tz.TZDateTime.from(currentTime, tz.local);

        _dateController.text = DateFormat("dd-MMM-yyyy").format(_selectedDate);
      });
    }
  }

  void _scheduleNotification(taskName) {

    DateTime parsedTime = DateFormat('hh:mm a').parse(_timeController.text);
    DateTime parsedDate = DateFormat('dd-MMM-yyyy').parse(_dateController.text);

    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    final currentTime = tz.TZDateTime.now(tz.local);

    // Calculate the scheduled time, adding 1 minute to the current time
    final scheduledTime = combinedDateTime;

    // Schedule the notification
    LocalNotificationService().scheduleNotification(
      title: taskName,
      body: 'Remember you have a task now ${_timeController.text}',
      scheduledNotificationDateTime: scheduledTime,
    );
  }

  Widget ColorShape(index){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = circleColor[index];
          isSelected(index);
        });

      },
      child: Container(
        height: 34,width: 34,
        decoration: BoxDecoration(
            color: circleColor[index],
            borderRadius: BorderRadius.circular(50),
            border: this.index == index ?  Border.all(color: Colors.grey,width: 2) : null
    )
    )
    );
  }
}
