import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notificaciones/DbTask.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:notificaciones/convert.dart';
import 'package:notificaciones/tabla.dart';
import 'package:notificaciones/updatetask.dart';
import 'package:notificaciones/user.dart';

class Details extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  final String fecha;
  final String hora;
  final String detalles;
  final String estado;
  final String photo;

  const Details(
      {Key key,
      this.id,
      this.title,
      this.body,
      this.fecha,
      this.hora,
      this.detalles,
      this.estado,
      this.photo})
      : super(key: key);


  @override
  _DetailsState createState() => _DetailsState(
      id: id,
      body: body,
      title: title,
      detalles: detalles,
      estado: estado,
      fecha: fecha,
      hora: hora,
      photo: photo);
}

class _DetailsState extends State<Details> {
  final int id;
  final String title;
  final String body;
  final String fecha;
  final String hora;
  final String detalles;
  final String estado;
  final String photo;

  _DetailsState(
      {this.title,
      this.body,
      this.fecha,
      this.hora,
      this.detalles,
      this.estado,
      this.photo,
      this.id});

  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;

  //variables notificacion
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;


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

  SingleChildScrollView dataTable(List<MapTask> Mapeo) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Card(
            elevation: 5.0,
            child: Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width - 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                body,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.tealAccent),
                                textAlign: TextAlign.justify,
                              ),
                            ]),
                      ),
                      Expanded(
                        child: Column(children: <Widget>[
                          Image(
                            image:
                                Convertir.imageFromBase64sString(photo).image,
                          )
                        ]),
                      ),
                    ]),
                    SizedBox(height: 25),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            "Details: ",
                            style:
                                TextStyle(fontSize: 23.0, color: Colors.cyan),
                          ),
                        ]),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          SizedBox(height: 20),
                          Expanded(
                            child: Text(
                              detalles,
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.cyan),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        ]),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(left: 25, right: 25),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBox(height: 30),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Date & Hour",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 30),
                                      )
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Text(
                                      fecha + " " + hora,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 30),
                                    ),
                                  ]),
                                ],
                              )),
                        ]),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 35,
                              onPressed: () {
                                _eliminar();
                              }),
                          IconButton(
                              icon: Icon(Icons.update),
                              color: Colors.teal,
                              iconSize: 35,
                              onPressed: () {
                                _actualizar();
                              }),
                        ])
                  ],
                )),
          ),
        ));
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: GetTask,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshList();
                  print("Refresh");
                })
          ],
        ),

        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[list()])));
  }

  void _eliminar() async{
    MapTask map =
        MapTask(id, title, body, detalles, fecha, hora, "cancelado", photo);
    dbTask.update(map);
    await flutterLocalNotificationsPlugin.cancel(id);
    Navigator.pop(context, MaterialPageRoute(builder: (context) => User()));
  }

  void _actualizar() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateTask(
                  id: id,
                  photo: photo,
                  hora: hora,
                  fecha: fecha,
                  estado: "activo",
                  detalles: detalles,
                  body: body,
                  title: title,
                )));
  }
}
