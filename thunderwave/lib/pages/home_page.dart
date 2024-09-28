import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thunderwave/models/todo.dart';
import 'package:thunderwave/services/database_service.dart';
import 'package:intl/intl.dart';
class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage>{
  TextEditingController _textEditingController =  TextEditingController();
    final DatabaseService _databaseService = DatabaseService();
    Widget build(BuildContext context){
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: _buildUI(),
        floatingActionButton: FloatingActionButton(onPressed: displayTextInputDialog,backgroundColor: Theme.of(context).primaryColor,child: Icon(Icons.ads_click),),
      );
    }



PreferredSizeWidget _appBar(){
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
  title: const Text(
    "Todo",
    style: TextStyle(
      color: Colors.white,
    ),
  ),
  );
}

Widget _buildUI(){
  return SafeArea(child: Column(
    children: [
      _messageListView(),
    ],
  ));
}

Widget _messageListView() {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.80,
    width: MediaQuery.of(context).size.width,
    child: StreamBuilder(
      stream: _databaseService.getTodos(),
      builder: (context, snapshot) {
        // Check if the snapshot has data and extract it
        List todos = snapshot.data?.docs ?? [];
        
        if (todos.isEmpty) {
          return Center(
            child: Text("Add A Todo"),
          );
        }

        // Building the ListView with todos
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            // Getting the Todo object from the Firestore DocumentSnapshot
            Todo todo = todos[index].data();
            String todoId = todos[index].id;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                title: Text(todo.task),
                subtitle: Text(
                  // Corrected DateFormat with a space between date and time
                  DateFormat('dd-MM-yyyy h:mm a').format(todo.updatedOn.toDate()),
                ),
                trailing: Checkbox(
                  value: todo.isDone,
                  onChanged: (value) async {
                    // Create an updated Todo and update it in Firestore
                    Todo updatedTodo = todo.copyWith(
                      isDone: !todo.isDone,
                      updatedOn: Timestamp.now(),
                    );
                    _databaseService.updateTodo(todoId, updatedTodo);
                  },
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

void displayTextInputDialog() async {
  return showDialog(context: context, builder: (context){
    
  return AlertDialog(
    title: Text("Add Todo"),
     content: TextField(
      controller: _textEditingController,
      decoration: const InputDecoration(hintText: "Todo..."),
      
     ),
     actions:<Widget> [
      MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
        onPressed: (){
          Todo todo = Todo(task:_textEditingController.text,isDone: false,createdOn: Timestamp.now(),updatedOn:Timestamp.now());
          _databaseService.addTodo(todo);
          Navigator.pop(context);
          _textEditingController.clear(); 
        })
     ],
  );
  });
}
}