import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/contactModel.dart';
import '../utilities/dbHelper.dart';
import 'addContact.dart';

class MyContacts extends StatefulWidget {
  const MyContacts({super.key});

  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  late Future<List<Contact>> _contactList;
  late DatabaseHelper _dbHelper;

  String contactListSearch = "";
  String todoListSearch = "";

  void _refreshTaskList() async {
    setState(() {
      _contactList = _dbHelper.fetchContacts(contactListSearch);
    });
  }

  void _refreshSearchList() async {
    setState(() {
      _contactList = _dbHelper.fetchContacts(todoListSearch);
    });
  }

  @override
  void initState() {
    _dbHelper = DatabaseHelper.instance;
    _refreshTaskList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddContacts(
                        refreshList: _refreshTaskList,
                        task: todoListSearch,
                        id: null)));
          },
          child: const Icon(Icons.person_add_alt_1),
        ),
        body: FutureBuilder(
          future: _contactList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print("${snapshot.data} sapshot----.. $_contactList ");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //   FutureBuilder(
            // future: _contactList,
            // builder: (context, snapshot) {
            //   if (snapshot.connectionState == ConnectionState.waiting) {
            //     print("Waiting for data...");
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (snapshot.hasError) {
            //     print("Error11: ${snapshot.error}");
            //     return Center(
            //       child: Text('Error: ${snapshot.error}'),
            //     );
            //   } else if (!snapshot.hasData || snapshot.data == null) {
            //     print("No data or empty data");
            //     return const Center(
            //       child: Text('No contacts found.'),
            //     );
            //   }
            List<Contact> cList;
            return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 25,
                ),
                itemCount: 1 + snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Buddy",
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Search your Contact from here",
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            setState(() async {
                              todoListSearch = value;
                              cList = await _dbHelper.fetchContacts(value);
                              print(cList.length);
                              _refreshSearchList();
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Search',
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon:
                                  Icon(Icons.search, color: Color(0XFF06BAD9)),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                  return _buildTask(snapshot.data![index - 1]);
                });
          },
        ));
  }

  Widget _buildTask(Contact task) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Material(
          color: Colors.transparent,
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(226, 106, 183, 250),
                        Color.fromARGB(255, 80, 149, 252),
                      ]),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0XFF515151).withOpacity(.25),
                        blurRadius: 6,
                        offset: const Offset(2, 5))
                  ],
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      task.title != null ? "${task.title}" : "Contact",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  subtitle: Text("${task.date} . ${task.priority}",
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () async {
                            final Uri uri = Uri(
                              scheme: 'sms',
                              path: '${task.date}',
                            );
                            print("message launch: $uri");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          }),
                      IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () async {
                          final Uri uri = Uri.parse('tel:${task.date}');

                          print("calling $uri");
                          try {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              print('Could not launch dialer');
                            }
                          } catch (e) {
                            print("exception occured: ${e.toString()}");
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddContacts(
                          task: task.title.toString(),
                          refreshList: _refreshTaskList,
                          id: task.id),
                    ),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: task.priority == "Family"
                        ? const Color.fromARGB(255, 245, 45, 31)
                        : task.priority == "Office"
                            ? const Color.fromARGB(255, 4, 25, 119)
                            : const Color.fromARGB(255, 216, 227, 18),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
