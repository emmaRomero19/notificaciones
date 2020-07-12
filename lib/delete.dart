import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notificaciones/DbTask.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:notificaciones/convert.dart';
import 'package:notificaciones/details.dart';
import 'package:notificaciones/newtask.dart';
import 'package:notificaciones/tabla.dart';
import 'package:notificaciones/updatetask.dart';
import 'package:notificaciones/user.dart';

class Delete extends StatefulWidget {
  final int id;

  const Delete({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  _DeleteState createState() => _DeleteState(
        id: id,
      );
}

class _DeleteState extends State<Delete> {
  final int id;

  _DeleteState({this.id});

  String title;
  String body;
  String detalles;
  String estado="completo";
  String fecha;
  String hora;
  String photo;

  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;

  //variables notificacion
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbTask = DBTask();
    isUpdating = false;
    ref();
  }

  void ref(){
    setState(() {
      GetTask = dbTask.getColumn(id);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id.toString()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () async {
                ref();
                print("aqui se cancela $id");
                MapTask map = MapTask(id, title, body, detalles, fecha, hora, "completo", photo);
                dbTask.update(map);
                await flutterLocalNotificationsPlugin.cancel(id);
                print("yes");
                GetTask=dbTask.getTask();
                Navigator.pop(context, MaterialPageRoute(builder: (context) => User()));

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
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 1
                          : 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  itemCount: snapshot.data.length,
                  staggeredTileBuilder: (int index) {
                    return new StaggeredTile.count(1, index.isEven ? 1.8 : 1.8);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    title =snapshot.data[index].title;
                    body=snapshot.data[index].body;
                    detalles=snapshot.data[index].detalles;
                    fecha=snapshot.data[index].fecha;
                    hora=snapshot.data[index].hora;
                    photo= snapshot.data[index].photo;
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: InkWell(
                            child: Card(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(5.0),
                            scrollDirection: Axis.vertical,
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                    child: Image(
                                  image: Convertir.imageFromBase64sString(
                                          snapshot.data[index].photo)
                                      .image,
                                  height: index.isEven ? 200 : 200,
                                )),
                                SizedBox(height: 50),
                                Text("TAREA COMPLETADA",
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 38.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(snapshot.data[index].hora.toString(),
                                    style: TextStyle(
                                      color: Colors.cyan,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(snapshot.data[index].fecha.toString(),
                                    style: TextStyle(
                                      color: Colors.cyan,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  snapshot.data[index].title.toString(),
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.teal),
                                ),
                                Text(
                                  snapshot.data[index].body.toString(),
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.teal),
                                ),
                                Text(
                                  snapshot.data[index].detalles.toString(),
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.teal),
                                ),
                              ],
                            )),
                          ),
                          elevation: 5.0,
                        )));
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
