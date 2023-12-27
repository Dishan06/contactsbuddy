class Contact {
  int id;
  String title;
  DateTime date;
  String priority;


  Contact({this.title, this.date, this.priority, });
  Contact.withId({this.id, this.title, this.date, this.priority, });

  static const tblName = "task_table";
  static const colId = "id";
  static const colTitle = "title";
  static const colDate = "date";
  static const colPriority = "priority";


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colTitle: title,
      colPriority: priority,
      colDate: date.toIso8601String(),

    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact.withId(
        id: map[colId],
        title: map[colTitle],
        date: DateTime.parse(map[colDate]),
        priority: map[colPriority],

    );
  }
}
