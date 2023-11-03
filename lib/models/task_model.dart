class Task {
 late int? id;
 late String title;
 late String description;
 late bool isCompleted;

  Task({  this.id, required this.title, required this.description, this.isCompleted = false});

 Map<String, dynamic> toMap() {
   return {'id': id, 'title': title,'description':description,'isCompleted':isCompleted};
 }
}