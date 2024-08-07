import 'package:flutter/material.dart';


class Todo extends ChangeNotifier {
  late List<Task> tasks = [];


  void addTask(Task newTask) {
    tasks.add(newTask);
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void taskDone(int index, bool newValue) {
    tasks[index].isDone = newValue;
    notifyListeners();
  }

  void editTask(int index, String newValue) {
    tasks[index].name = newValue;
    notifyListeners();
  }

  void clearAll() {
    tasks.clear();
    notifyListeners();
  }
}

class Task {
  late String name;
  late bool isDone;

  Task(this.name) : isDone = false;
}