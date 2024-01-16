import 'package:contactsbuddy/models/contactModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utilities/dbHelper.dart';

class AddContacts extends StatefulWidget {
  final Function refreshList;
  final Contact contact;
  AddContacts({this.contact, this.refreshList});
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContacts> {
  final _formKey = GlobalKey<FormState>();
  String _title, _priority;
  int _status;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ["Friends", "Family", "Office"];
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DatabaseHelper.instance;

    if (widget.contact != null) {
      _title = widget.contact.title;
      _date = widget.contact.date;
      _priority = widget.contact.priority;

    }
    _status = 0;

    _dateController.text = _dateFormat.format(_date);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
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
              SizedBox(
                height: 20,
              ),
              Text(
                widget.contact == null ? "Add Contact" : "Update Contact",
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(

                        margin: EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),


                          decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(fontSize: 20,
                                  color: Colors.blueGrey),
                              border: OutlineInputBorder(

                                  borderRadius: BorderRadius.circular(10))),
                          textInputAction: TextInputAction.next,
                          validator: (val) =>
                          (val.isEmpty) ? "Please enter the name" : null,
                          onSaved: (val) => _title = val,
                          initialValue: _title,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.blueGrey),
                          decoration: InputDecoration(
                              labelText: "Number",
                              labelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Colors.pinkAccent ),
                                  borderRadius: BorderRadius.circular(10))),
                          textInputAction: TextInputAction.next,
                          onTap: _datePicker,
                          controller: _dateController,
                          readOnly: true,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
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
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18),

                              )))
                              .toList(),
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          validator: (val) =>
                          (val == null) ? "Please add a label" : null,
                          onSaved: (val) => _priority = val,

                          decoration: InputDecoration(


                              labelText: "Label",
                              labelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onChanged: (val) {
                            setState(() {
                              _priority = val;
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            widget.contact ==null? Icons.add_ic_call_rounded: Icons.update,
                            size: 40,
                            color: Color(0XFF06BAD9),
                          ),
                          onPressed: () { _addTask(); },
                        ),
                        height: MediaQuery.of(context).size.height * .07,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0XFF06BAD9),
                            ),
                            borderRadius: BorderRadius.circular(10)),

                      ),
                    ],
                  )
              ),

              SizedBox(
                height: 20,
              ),
              widget.contact != null
                  ? Container(
                child: IconButton(
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    size: 40,
                    color: Color(0XFF06BAD9),
                  ),
                  onPressed: () { _delete(); },
                ),
                height: MediaQuery.of(context).size.height * .07,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0XFF06BAD9),
                    ),
                    borderRadius: BorderRadius.circular(10)),
              )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );


  }

  _datePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (date != null && date != _date) {
      _date = date;
    }
    _dateController.text = _dateFormat.format(date);
  }

  _addTask() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Contact contact = Contact(
          title: _title, date: _date, priority: _priority,);
      if (widget.contact == null) {
        _dbHelper.insertContact(contact);
      } else {
        contact.id = widget.contact.id;
        _dbHelper.updateContact(contact);
      }
      widget.refreshList();
      print('status is $_status');

      Navigator.pop(context);
    }
  }

  _delete() {
    if (widget.contact != null) {
      _dbHelper.deleteContact(widget.contact.id);
    }
    widget.refreshList();
    Navigator.pop(context);
  }
}
