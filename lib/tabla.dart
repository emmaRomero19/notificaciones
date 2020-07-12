import 'package:flutter/material.dart';
import 'package:notificaciones/DbTask.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:notificaciones/convert.dart';

class Tabla extends StatefulWidget {
  @override
  _TablaState createState() => _TablaState();
}

class _TablaState extends State<Tabla> {
  int id;
  String title;
  String body;
  String fecha;
  String hora;
  String detalles;
  String estado;
  String photo;
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
      GetTask = dbTask.getTable();
    });
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<MapTask> mp) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  "id",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
              ),
              DataColumn(
                label: Text("State",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              ),
              DataColumn(
                label: Text("Title",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              ),
              DataColumn(
                label: Text("Body",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              ),
              DataColumn(
                label: Text("Date",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              ),
              DataColumn(
                label: Text("Hour",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              ),
              DataColumn(
                label: Text("Details",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              ),
              DataColumn(
                label: Text("Photo",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent)),
              )
            ],
            rows: mp
                .map((mp) => DataRow(cells: [
                      DataCell(Text(mp.control.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal))),
                      DataCell(Text(mp.estado.toString(),
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.teal))),
                      DataCell(Text(mp.title.toString(),
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.teal))),
                      DataCell(
                        Text(mp.body.toString(),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.teal)),
                      ),
                      DataCell(Text(mp.fecha.toString(),
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.teal))),
                      DataCell(Text(mp.hora.toString(),
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.teal))),
                      DataCell(Text(mp.detalles.toString(),
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.teal))),
                      DataCell(
                        Convertir.imageFromBase64sString(mp.photo),
                      ),
                    ]))
                .toList(),
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
    refreshList();
    return Scaffold(
        appBar: new AppBar(
          title: Text("Basic SQL operations"),
          backgroundColor: Colors.cyan,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshList();
                  print("Refresh");
                })
          ],
        ),
        body: new Container(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    list(),
                    //NavDrawer(),
                  ],
                ),
              ]),
        ));
  }
}
