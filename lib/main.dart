import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ass_four/db_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AppProvider();
      },
      child: MaterialApp(
        home: Screen1(User('hamza ahmed', 'hamza20@gmail.com')),
      ),
    );
  }
}

class SpHelper {
  SpHelper._();
  static SpHelper spHelper = SpHelper._();
  SharedPreferences sharedPreferences;
  initSharedPrefrences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  writeSometingToSharedPrefrences(String name, int age, bool isMale) {
    sharedPreferences.setString('name', name);
    sharedPreferences.setInt('age', age);
    sharedPreferences.setBool('isMale', isMale);
  }

  Map getUserDate() {
    String name = sharedPreferences.getString('name');
    int age = sharedPreferences.getInt('age');
    bool isMale = sharedPreferences.getBool('isMale');
    return {'name': name, 'age': age, 'isMale': isMale};
  }
}

class NewLecture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}

class Screen1 extends StatefulWidget {
  User user;
  Screen1(this.user);
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<Screen1>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
  }

  void add() {
    setState(() {
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return NewTaskk();
              },
            ));
          });
    });
  }

  void choiceAction(String choice) {
    if (choice == Menu.AllTasks) {
      print('AllTasks');
    } else if (choice == Menu.CompleteTasks) {
      print('CompleteTasks');
    } else if (choice == Menu.InCompleteTasks) {
      print('InCompleteTasks');
    }
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Menu.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              text: 'All Tasks',
            ),
            Tab(
              text: 'Complete \n Tasks',
            ),
            Tab(
              text: 'InComplete \n Tasks',
            )
          ],
          isScrollable: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [AllTasks(), CompleteTasks(), InCompleteTasks()],
            ),
          ),
        ],
      ),
    );
  }
}

class AllTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: tasksList.map((e) => TaskWidget(e)).toList(),
        ),
      ),
    );
  }
}

class CompleteTasks extends StatefulWidget {
  @override
  _CompleteTasksState createState() => _CompleteTasksState();
}

class _CompleteTasksState extends State<CompleteTasks> {
  myFun() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
          children: tasksList
              .where((element) => element.isComplete == true)
              .map((e) => TaskWidget(e, myFun))
              .toList()),
    );
  }
}

class InCompleteTasks extends StatefulWidget {
  @override
  _InCompleteTasksState createState() => _InCompleteTasksState();
}

class _InCompleteTasksState extends State<InCompleteTasks> {
  myFun() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
            children: tasksList
                .where((element) => element.isComplete == false)
                .map((e) => TaskWidget(e, myFun))
                .toList()),
      ),
    );
  }
}

class User {
  String name;
  String email;
  User(this.name, this.email);
}

class Menu {
  static const String AllTasks = 'AllTasks';
  static const String CompleteTasks = 'CompleteTasks';
  static const String InCompleteTasks = 'InCompleteTasks';

  static const List<String> choices = <String>[
    AllTasks,
    CompleteTasks,
    InCompleteTasks
  ];
}

List<Task> tasksList = [
  Task('playing football', true),
  Task('praying asser', true),
  Task('have launch', false),
  Task('studying', false),
  Task('Watching tv', false),
  Task('programming', true),
  Task('shopping', true),
];

class TaskWidget extends StatefulWidget {
  Task task;
  Function function;
  TaskWidget(this.task, [this.function]);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Delete();
                    },
                  ));
                }),
            Text(widget.task.taskName),
            Checkbox(
                value: widget.task.isComplete,
                onChanged: (value) {
                  this.widget.task.isComplete = !this.widget.task.isComplete;
                  setState(() {});
                  widget.function();
                })
          ],
        ),
      ),
    );
  }
}

class NewTaskk extends StatefulWidget {
  @override
  _NewTaskkState createState() => _NewTaskkState();
}

class _NewTaskkState extends State<NewTaskk> {
  bool isComplete = false;
  String taskName;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: (value) {
                this.taskName = value;
              },
            ),
            Checkbox(
                value: isComplete,
                onChanged: (value) {
                  this.isComplete = value;
                  setState(() {});
                }),
            RaisedButton(
                child: Text('Add New Task'),
                onPressed: () {
                  tasksList.add(Task(this.taskName, this.isComplete));
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

class Delete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation AlertDialog"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () async {
                final ConfirmAction action = await _asyncConfirmDialog(context);
                print("Confirm Action $action");
              },
              child: const Text(
                "Show Alert",
                style: TextStyle(fontSize: 20.0),
              ),
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete This Contact?'),
        content: const Text('This will delete the contact from your device.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          FlatButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}

class Task {
  String taskName;
  bool isComplete;
  Task(this.taskName, this.isComplete);
  toJson() {
    return {
      DBHelper.taskNameColumnName: this.taskName,
      DBHelper.taskIsCompleteColumnName: this.isComplete ? 1 : 0
    };
  }
}

class AppProvider extends ChangeNotifier {
  String name = 'hamza';
  String address = 'gaza';
  setValues(String name, String address) {
    this.name = name;
    this.address = address;
    notifyListeners();
  }

  changeName(String newName) {
    this.name = newName;
    notifyListeners();
  }
}
