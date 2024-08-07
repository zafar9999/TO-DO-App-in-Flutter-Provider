import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do4/models/todo.dart';
import 'package:to_do4/theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Todo()),
    ],
    child: MaterialApp(
      home: TodoApp(),
      theme: appTheme,
    ),
  ));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("TO-DO APP", style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            children: [
        
              CustomTextFieldWidget(_textEditingController),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(_textEditingController)
                ],
              ),
              SizedBox(height: 25,),
              ListOfTasksWidget()
        
        
            ],
          ),
        ),
      ),
    );
  }
}





class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget(this._textEditingController, {super.key});

  final TextEditingController _textEditingController;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 100,

      minLines: 1,
      maxLines: 3,

      controller: widget._textEditingController,

      style: Theme.of(context).textTheme.labelSmall,
      cursorColor: Theme.of(context).primaryColorDark,

      decoration: InputDecoration(

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
        ),

        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
        ),

        suffixIcon: IconButton(
          icon: Icon(Icons.clear,
          color: Theme.of(context).primaryColorDark),
          onPressed: () {
            setState(() {
              widget._textEditingController.text = "";
            });
          },
        ),

        labelText: "Create a task",
        labelStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}


class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget(this._textEditingController, {super.key});

  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          if (_textEditingController.text.length > 0) {
            context.read<Todo>().addTask(Task(_textEditingController.text));
            _textEditingController.text = "";
          }
        },

        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColorDark),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
        ),

        child: Text("Create", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w300),)
    );
  }
}



class ListOfTasksWidget extends StatelessWidget {
  const ListOfTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).primaryColorDark,
        border: Border.all(width: 1, color: Theme.of(context).primaryColorDark)
      ),

        child: Column(
          children: [

            Expanded(
              child: ListView.builder(
              itemCount: context.watch<Todo>().tasks.length,
              itemBuilder: (context, index) {
                return TaskWidget(index);
              }
                        ),
            ),

            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: (){
                      var model = context.read<Todo>();
                      for (int index = 0; index < model.tasks.length; index++) {
                        model.taskDone(index, true);
                      }
                    },

                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                    ),

                    child: Text("Check All", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColorDark),)
                ),
                ElevatedButton(
                    onPressed: (){
                      var model = context.read<Todo>();
                      for (int index = 0; index < model.tasks.length; index++) {
                        model.taskDone(index, false);
                      }
                    },

                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                    ),

                    child: Text("Uncheck All", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColorDark),)
                ),

                ElevatedButton(
                    onPressed: (){
                      context.read<Todo>().clearAll();
                    },

                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                    ),

                    child: Text("Remove All", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColorDark),)
                ),
              ],
            )
      ]
        ),

    );
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget(this.index, {super.key});

  final int index;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  bool _editingEnabled = false;
  String _savedTaskName = "";

  void enableEditing(String newSavedTaskName) {
    setState(() {
      _editingEnabled = true;
      _savedTaskName = newSavedTaskName;
    });
  }

  void disableEditing() => setState((){_editingEnabled = false;});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor))
      ),
      child: _editingEnabled ? EditingEnabledWidget(index: widget.index, savedTaskName: _savedTaskName, callbackFunction: disableEditing,) : NormalWidget(index: widget.index, callbackFunction: enableEditing)

    );
  }
}



class NormalWidget extends StatefulWidget {
  const NormalWidget({required this.index, required this.callbackFunction, super.key});

  final int index;
  final Function(String) callbackFunction;

  @override
  State<NormalWidget> createState() => _NormalWidgetState();
}

class _NormalWidgetState extends State<NormalWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
            children: [
              Expanded(child: Text("- "+context.watch<Todo>().tasks[widget.index].name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w300, fontSize: 20),)),
              context.watch<Todo>().tasks[widget.index].isDone ?
              IconButton(
                icon: Icon(Icons.check_box, size: 30,color: Theme.of(context).primaryColor,),
                onPressed: (){
                  context.read<Todo>().taskDone(widget.index, false);
                },
              ) :
              IconButton(
                icon: Icon(Icons.check_box_outline_blank, size: 30,color: Theme.of(context).primaryColor,),
                onPressed: (){
                  context.read<Todo>().taskDone(widget.index, true);
                },
              ),
            ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
              onPressed: () => widget.callbackFunction(context.read<Todo>().tasks[widget.index].name)
            ),
            IconButton(
              icon: Icon(Icons.clear, color: Theme.of(context).primaryColor,),
              onPressed: (){
                context.read<Todo>().removeTask(widget.index);
              },
            )
          ],
        )
      ],
    );
  }
}


class EditingEnabledWidget extends StatefulWidget {
  const EditingEnabledWidget({required this.index, required this.savedTaskName, required this.callbackFunction, super.key});

  final int index;
  final String savedTaskName;
  final Function callbackFunction;

  @override
  State<EditingEnabledWidget> createState() => _EditingEnabledWidgetState();
}

class _EditingEnabledWidgetState extends State<EditingEnabledWidget> {
  late  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController =  TextEditingController(text: widget.savedTaskName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          TextField(
          maxLength: 100,

          minLines: 1,
          maxLines: 3,

          controller: _textEditingController,

          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).primaryColor),
          cursorColor: Theme.of(context).primaryColor,

          decoration: InputDecoration(

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),

            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),

            suffixIcon: IconButton(
              icon: Icon(Icons.clear,
                  color: Theme.of(context).primaryColor),
              onPressed: () {
                setState(() {
                  _textEditingController.text = "";
                });
              },
            ),

            labelText: "Edit",
            labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).primaryColor),
          ),
        ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
          onPressed: (){
            widget.callbackFunction();
          },

          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
          ),

          child: Text("Cancel", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w300, color: Theme.of(context).primaryColorDark),)
          ),

          SizedBox(width: 5,),

          ElevatedButton(
              onPressed: (){
                if (_textEditingController.text.length > 0) {
                  context.read<Todo>().editTask(widget.index, _textEditingController.text);
                  widget.callbackFunction();
                }
              },

              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
              ),

              child: Text("Done", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w300, color: Theme.of(context).primaryColorDark),)
          ),
        ]
      )

      ]
      ),
    );
  }
}