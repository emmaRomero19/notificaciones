import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:notificaciones/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'DbTask.dart';
import 'deletetask.dart';
import 'newtask.dart';

class User extends StatefulWidget {
  final String name;
  final String email;

  const User({Key key, this.name, this.email}) : super(key: key);

  @override
  _UserState createState() => _UserState(name: name, email: email);
}

class _UserState extends State<User> {
  String name;
  String email;

  _UserState({this.name, this.email});

  int id;
  String title;
  String body;
  String hora;
  String minutos;
  String segundos;
  String detalles;
  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbTask = DBTask();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      GetTask = dbTask.getTask();
    });
  }

  SingleChildScrollView dataTable(List<MapTask> GetTask) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              columns: [
                DataColumn(label: Text("id")),
                DataColumn(label: Text("title")),
                DataColumn(label: Text("body")),
                DataColumn(label: Text("hora")),
                DataColumn(label: Text("min")),
                DataColumn(label: Text("seg")),
                DataColumn(label: Text("detalles"))
              ],
              rows: GetTask.map((task) => DataRow(cells: [
                    DataCell(Text(task.control.toString())),
                    DataCell(Text(task.title.toString())),
                    DataCell(Text(task.body.toString())),
                    DataCell(Text(task.hora.toString())),
                    DataCell(Text(task.minutos.toString())),
                    DataCell(Text(task.segundos.toString())),
                    DataCell(Text(task.detalles.toString()))
                  ])).toList())),
    );
  }

  Widget tabla() {
    return Expanded(
        child: FutureBuilder(
      future: GetTask,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return dataTable(snapshot.data);
        }
        if (snapshot.data == null || snapshot.data.length == 0) {
          return Text("Not data founded");
        }
        return CircularProgressIndicator();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          centerTitle: true,
          title: Text(
            'Welcome $name!',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshList();
                  print("Refresh");
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            child: FutureBuilder(
              future: GetTask,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Cargando información..."),
                    ),
                  );
                } else {
                  return StaggeredGridView.countBuilder(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                      Orientation.portrait
                      ? 2
                      : 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      itemCount: snapshot.data.length,
                      staggeredTileBuilder: (int index){
                        return new StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                      },
                      itemBuilder: (BuildContext context, int index) {
                      return new Card(
                          child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(snapshot.data[index].hora.toString() +
                              ":" +
                              snapshot.data[index].minutos.toString() +
                              ":" +
                              snapshot.data[index].segundos.toString(),
                          style: TextStyle(color: Colors.cyan, fontSize: 33.0, fontWeight: FontWeight.bold,)),
                          Text(snapshot.data[index].title.toString(), style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic, color: Colors.teal),)
                        ],
                      ));
                    },
                  );
                }
              },
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.cyan,
            overlayColor: Colors.black12,
            overlayOpacity: 0.6,
            children: [
              SpeedDialChild(
                  child: Icon(
                    Icons.add_alert,
                    color: Colors.white,
                  ),
                  label: "New Task",
                  backgroundColor: Colors.teal,
                  labelStyle: TextStyle(color: Colors.white),
                  labelBackgroundColor: Colors.teal,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewTask()));
                  }),
              SpeedDialChild(
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  label: "Delete Task",
                  backgroundColor: Colors.red,
                  labelStyle: TextStyle(color: Colors.white),
                  labelBackgroundColor: Colors.red,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewTask()));
                  }),
            ]));
  }

  Future<void> closeSesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('_sesion', false);
    setState(() {
      name = '';
      email = '';
    });
    print("cerrar");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Registro()));
  }
}
