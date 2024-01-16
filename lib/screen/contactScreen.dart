import 'package:contactsbuddy/screen/addContact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/contactModel.dart';
import '../utilities/dbHelper.dart';

class MyContacts extends StatefulWidget {
  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  Future<List<Contact>> _contactList;
  DatabaseHelper _dbHelper;

  String contactListSearch="";

  get completedContact => null;

  void _refreshContactList() async {
    setState(() {
      _contactList = _dbHelper.fetchContact(contactListSearch);
    });
  }

  @override
  void initState() {
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _refreshContactList();
    return Scaffold(

        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddContacts(
                      refreshList: _refreshContactList,
                    )
                )
            );
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: _contactList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedContact = snapshot.data
                .where((Contact contact) => contact?.status == 1)
                .toList()
               .length;

            return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 25,
                ),
                itemCount: 1+snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "My Contacts",
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Completed $completedContact of ${snapshot.data.length}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            setState(() {
                              contactListSearch = value;
                            });
                          },
                          decoration: InputDecoration(

                              labelText: 'Search',
                              labelStyle: TextStyle(
                                  color: Colors.white),
                              prefixIcon: Icon(Icons.search,
                                  color: Color(0XFF06BAD9)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              )),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],

                    );
                  }
                  return _buildContact(snapshot.data[index - 1]);
                });
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildContact(Contact contact) {

    String date="";

    if(contact?.date!=null){
      date=_dateFormat.format(contact.date);
    }


    return Padding(
      padding: EdgeInsets.symmetric(),
      child: Material(

        color: Colors.transparent,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
              decoration: BoxDecoration(
                gradient: contact?.status==0? LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: const [Color(0XFF70A9FF), Color(0XFF90BCFF),]):LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: const [Color(0XFFFFC026 ), Color(0XFFFFA21D ),]),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0XFF515151).withOpacity(.25),
                      blurRadius: 6,
                      offset: Offset(2, 5))
                ],
              ),
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    contact?.title!=null ? contact.title : "Contact" ,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                ),
                subtitle:
                Text("${date} . ${contact?.priority}",
                    style: TextStyle(
                      fontSize: 15,
                    )),
                trailing: Checkbox(
                  onChanged: (val) {

                    contact?.status = val ? 1 : 0;

                    _dbHelper.updateContact(contact);
                    _refreshContactList();
                  },
                  value: contact?.status == 1 ? true : false,
                  activeColor: Color(0XFF52001B),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddContacts(
                      contact: contact,
                      refreshList: _refreshContactList,
                    ),
                  ),
                ),

                leading:contact?.status==0? Icon(Icons.group, color: contact?.priority == "Friends" ?
                Colors.red : contact?.priority=="Family"? Color(0XFF0776CA):
                Color(0XFF0AA51A),):Icon(Icons.check, color: contact?.priority == "Friends" ?
                Colors.red : Color(0XFF0E1D35),),
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
            SizedBox(
              height: 20,
            ),

          ],

        ),

      ),

    );

  }
}