import 'package:esperto/models/tasks.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../theme.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final tasksCollection = Hive.box<Task>('tasks');
  List<Task> tasks = <Task>[];
  bool addNew = false;
  final addNewController = TextEditingController();
  final searchController = TextEditingController();
  bool showCompletedOnly = false;
  late FocusNode focusNode;
  String editId = "";

  _TasksPageState() {
    tasks = tasksCollection.values.toList();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.backColor,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: DarkTheme.backColor,
        title: SafeArea(
          top: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 40,
            child: TextField(
                autofocus: false,
                cursorColor: DarkTheme.borderColor,
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {
                    tasks = tasksCollection.values
                        .where((e) => e.task
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  });
                },
                onChanged: (value) {
                  setState(() {
                    tasks = tasksCollection.values
                        .where((e) => e.task
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  });
                },
                style: const TextStyle(
                    height: 1, fontSize: 14.0, color: DarkTheme.fontColor),
                textAlignVertical: const TextAlignVertical(y: 0.6),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    filled: true,
                    fillColor: DarkTheme.backColor,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: DarkTheme.borderColor,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: DarkTheme.borderColor,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    hintStyle: const TextStyle(
                      color: DarkTheme.fontColor,
                    ),
                    suffixIcon: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    child: Icon(
                                        showCompletedOnly
                                            ? Icons.check_box_outlined
                                            : Icons.error_outline,
                                        color: DarkTheme.borderColor),
                                    onTap: () => setState(() {
                                          showCompletedOnly =
                                              !showCompletedOnly;
                                        })),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: DarkTheme.borderColor),
                    hintText: "Search")),
          ),
        ),
      ),
      body: Stack(
        children: [
          Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                    "Add Your To-dos Here. You Can Also Reorder Them By Dragging a To-Do  😉",
                    style:
                        TextStyle(color: DarkTheme.borderColor, fontSize: 24),
                    textAlign: TextAlign.center,
                  ))
                : ReorderableListView(
                    padding: const EdgeInsets.only(bottom: 60),
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      for (final task
                          in tasks
                              .where((e) => e.completed == showCompletedOnly)
                              .toList()
                            ..sort((a, b) {
                              return a.sequence.compareTo(b.sequence);
                            }))
                        Container(
                          key: Key(task.id),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: DarkTheme.backColor,
                            border: Border.all(color: DarkTheme.borderColor),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            trailing: GestureDetector(
                                onTap: () {
                                  tasksCollection.delete(task.id);
                                  setState(() {
                                    tasks = tasksCollection.values.toList();
                                  });
                                },
                                child: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: DarkTheme.borderColor,
                                  size: 18,
                                )),
                            tileColor: DarkTheme.backColor,
                            leading: Transform.scale(
                              scale: 1.2,
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor:
                                        DarkTheme.borderColor),
                                child: Checkbox(
                                  shape: const CircleBorder(),
                                  checkColor: DarkTheme.backColor,
                                  activeColor: DarkTheme.borderColor,
                                  value: task.completed,
                                  onChanged: (value) {
                                    task.completed = !task.completed!;
                                    tasksCollection.put(task.id, task);
                                    setState(() {
                                      tasks = tasksCollection.values.toList();
                                    });
                                  },
                                ),
                              ),
                            ),
                            dense: true,
                            title: GestureDetector(
                              onTap: () {
                                addNewController.text = task.task;
                                editId = task.id;
                                FocusScope.of(context).requestFocus(focusNode);
                              },
                              child: Text(
                                task.task,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: DarkTheme.fontColor, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                    ],
                    onReorder: reorderData,
                  ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 60.0,
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: TextField(
                    focusNode: focusNode,
                    cursorColor: DarkTheme.backColor,
                    controller: addNewController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => addTask(),
                    style: const TextStyle(
                        height: 1.4,
                        fontSize: 14.0,
                        color: DarkTheme.fontColor),
                    textAlignVertical: const TextAlignVertical(y: 0.6),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: DarkTheme.borderColor,
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                                color: DarkTheme.borderColor,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                                color: DarkTheme.borderColor,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        hintStyle: const TextStyle(
                          color: DarkTheme.fontColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => addTask(),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: DarkTheme.fontColor,
                            size: 28,
                          ),
                        ),
                        prefixIcon:
                            const Icon(Icons.add, color: DarkTheme.backColor),
                        hintText: "Add Task")),
              )),
        ],
      ),
    );
  }

  void reorderData(int oldindex, int newindex) {
    var task = tasks[oldindex];
    task.sequence = newindex;
    tasksCollection.put(task.id, task);

    for (Task item in tasks) {
      if (item.id != tasks[oldindex].id) {
        if (item.sequence > newindex && newindex > oldindex) {
          item.sequence = item.sequence + 1;
        } else if (item.sequence > newindex && newindex < oldindex) {
          item.sequence = item.sequence - 1;
        } else if (item.sequence < newindex) {
          item.sequence = item.sequence - 1;
        } else {
          item.sequence =
              newindex > oldindex ? item.sequence - 1 : item.sequence + 1;
        }
        tasksCollection.put(item.id, item);
      }
    }
    setState(() {
      tasks = tasksCollection.values.toList();
    });
  }

  void addTask() {
    var id = editId == "" ? const Uuid().v4() : editId;
    if (addNewController.text == "") {
      return;
    }
    List<int> tasks = this.tasks.map((e) => e.sequence).toList();
    tasks.sort((a, b) => a.compareTo(b));
    int seq = tasks.isEmpty ? 1 : tasks.last;
    Task task = Task(
        id: id, task: addNewController.text, sequence: seq, completed: false);
    tasksCollection.put(id, task);
    addNewController.clear();
    editId = "";
    setState(() {
      this.tasks = tasksCollection.values.toList();
    });
  }
}
