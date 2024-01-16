// import 'package:contactsbuddy_master/models/contactModel.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import '../screens/addContact.dart';
// import '../utilities/dbHelper.dart';
// import '../screens/addContact.dart';

// class CheckBoxWid extends StatefulWidget {
//   Function refreshList;
//   final Contact contact;
//    late DatabaseHelper _dbHelper;
  
//   CheckBoxWid({super.key, required this.refreshList, required this.contact});

//   @override
//   State<CheckBoxWid> createState() => _CheckBoxWidState();
// }

// class _CheckBoxWidState extends State<CheckBoxWid> {
//   get _dbHelper => null;

 

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(),
//         child: Material(
//           color: Colors.transparent,
//           elevation: 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 20.0, horizontal: 10.0),
//                 decoration: BoxDecoration(
//                   gradient: widget.contact.isDone!
//                       ? const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                               Color.fromARGB(226, 106, 183, 250),
//                               Color.fromARGB(255, 80, 149, 252),
//                             ])
//                       : const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                               Color.fromARGB(217, 142, 241, 67),
//                               Color.fromARGB(255, 29, 255, 195),
//                             ]),
//                   borderRadius: BorderRadius.circular(20.0),
//                   boxShadow: [
//                     BoxShadow(
//                         color: const Color(0XFF515151).withOpacity(.25),
//                         blurRadius: 6,
//                         offset: const Offset(2, 5))
//                   ],
//                 ),
//                 child: ListTile(
//                   title: Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: Text(
//                       widget.contact.title != null ? "${widget.contact.title}" : "Contact",
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   subtitle: Text("${widget.contact.date} . ${widget.contact.priority}",
//                       style: const TextStyle(
//                         fontSize: 15,
//                       )),
//                   trailing: Checkbox(
//                     value: widget.contact.isDone!,
//                     onChanged: (val) {
//                       setState(() {
//                         widget.contact.isDone = val;
//                       });

//                       _dbHelper.markDone(widget.contact., widget.contact.id!);
//                       _refreshTaskList();

//                       print("task: ${task.id} marked!");
//                     },
//                     activeColor: const Color(0XFF52001B),
//                   ),
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => AddContacts(
//                           task: task.title.toString(),
//                           refreshList: _refreshTaskList,
//                           id: task.id),
//                     ),
//                   ),
//                   leading: !task.isDone!
//                       ? Icon(
//                           Icons.person,
//                           color: task.priority == "Family"
//                               ? Colors.red
//                               : task.priority == "Office"
//                                   ? const Color.fromARGB(214, 1, 47, 83)
//                                   : const Color(0XFF0AA51A),
//                         )
//                       : Icon(
//                           Icons.check,
//                           color: task.priority == "Family"
//                               ? Colors.red
//                               : const Color(0XFF0E1D35),
//                         ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 5),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
