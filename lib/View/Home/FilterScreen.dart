import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/Model/toDoListModel.dart';
import 'package:to_do/Service/LocalNotificationService.dart';
import 'package:to_do/ViewModel/toDoListViewModel.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class FilterScreen extends StatefulWidget {

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
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
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  DateTime scheduleTime = DateTime.now();
  DateTime? _selectedDate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(_selectedDate);
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
          const EdgeInsets.only(left: 18, right: 18, top: 60, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter",
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
                                :Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(37, 77, 222, 1),
                                    Color.fromRGBO(0, 255, 255, 1)
                                  ])),
                              child: TextButton(
                                onPressed: () async {
                                  await toDoListViewModel!.filterToDoList(_dateController.text,selectedColor);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Filter',
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


  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    _selectedDate =  DateTime.now();

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        final currentTime = DateTime.now();
        scheduleTime = tz.TZDateTime.from(currentTime, tz.local);

        _dateController.text = DateFormat("dd-MMM-yyyy").format(_selectedDate!);
      });
    }
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
