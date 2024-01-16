import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/contactModel.dart';
import '../utilities/dbHelper.dart';

DateTime now = DateTime.now();

class AddContacts extends StatefulWidget {
  Function refreshList;
  final Contact? contact;
  final String task;
  final int? id;

  AddContacts(
      {super.key,
      required this.task,
      required this.refreshList,
      this.contact,
      required this.id});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddContacts> {
  _AddTaskState({this.title, this.date, this.priority});

  final _formKey = GlobalKey<FormState>();
  String? title, priority;

  String? date;
  TextEditingController dateController = TextEditingController();
  final List<String> _priorities = ["Friends", "Office", "Family"];
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DatabaseHelper.instance;

    title = widget.task.toString();
    date = date;
    priority = priority;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.task.isEmpty ? "Add Contact" : "Update Conatct",
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              labelText: "Contact",
                              labelStyle: const TextStyle(
                                  fontSize: 20, color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          textInputAction: TextInputAction.next,
                          validator: (val) => (val.toString().isEmpty)
                              ? "Please add a contact"
                              : null,
                          onSaved: (val) => title = val.toString(),
                          initialValue: title,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.blueGrey),
                          decoration: InputDecoration(
                              labelText: "Number ",
                              labelStyle: const TextStyle(
                                  fontSize: 20, color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.pinkAccent),
                                  borderRadius: BorderRadius.circular(10))),
                          textInputAction: TextInputAction.next,
                          validator: (val) => (val.toString().isEmpty)
                              ? "Please add a number"
                              : null,
                          onSaved: (val) {
                            date = val;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: DropdownButtonFormField(
                          iconEnabledColor: Theme.of(context).primaryColor,
                          iconSize: 25,
                          isDense: true,
                          dropdownColor: Colors.white,
                          items: _priorities
                              .map((String priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(
                                    priority,
                                    style: const TextStyle(
                                        color: Colors.blueGrey, fontSize: 18),
                                  )))
                              .toList(),
                          icon:
                              const Icon(Icons.arrow_drop_down_circle_outlined),
                          validator: (val) =>
                              (val == null) ? "Please add a Label" : null,
                          onSaved: (val) => priority = val.toString(),
                          decoration: InputDecoration(
                              labelText: "Label",
                              labelStyle: const TextStyle(
                                  fontSize: 20, color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onChanged: (val) {
                            setState(() {
                              priority = val.toString();
                            });
                          },
                          value: priority,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * .07,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0XFF06BAD9),
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          icon: Icon(
                            widget.task.isEmpty
                                ? Icons.person_add_alt_1
                                : Icons.update,
                            size: 40,
                            color: const Color(0XFF06BAD9),
                          ),
                          onPressed: () {
                            _addTask();
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              widget.task.isNotEmpty
                  ? Container(
                      height: MediaQuery.of(context).size.height * .07,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0XFF06BAD9),
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_forever_rounded,
                          size: 40,
                          color: Color(0XFF06BAD9),
                        ),
                        onPressed: () {
                          _delete();
                        },
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  int _convertDateToMilliseconds(String dateString) {
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(dateString);
      return parsedDate.millisecondsSinceEpoch;
    } catch (e) {
      print("Error parsing date: $e");
      return 0; // Handle error appropriately
    }
  }

  _addTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Contact task;

      task = Contact(
        title: title,
        date: date.toString(),
        priority: priority,
        id: widget.id,
      );
      print("date to add: ${task.date}");
      widget.task.isEmpty
          ? _dbHelper.insertContact(task)
          : _dbHelper.updateContact(task, title!, widget.id!, priority!, date!);

      widget.refreshList();

      Navigator.pop(context);
    }
  }

  _delete() {
    if (widget.task.isNotEmpty) {
      _dbHelper.deleteContact(widget.id as int);
      widget.refreshList();
      Navigator.pop(context);
    }
  }
}
