import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:notificaciones/delete.dart';
import 'package:notificaciones/details.dart';
import 'package:notificaciones/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'DbTask.dart';
import 'convert.dart';
import 'tabla.dart';
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
  String fecha;
  String hora;
  String detalles;
  String estado;
  String photo;
  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;
  int _selectedItem = 0;

  DateTime program;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  int nid;
  String ntitle;
  String nbody;
  String nfecha;
  String nhora;
  String ndetalles;
  String nestado="activo";
  String nimage;
  String programDate;


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
    //notificación
    initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings();
    initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  void refreshList() {
    setState(() {
      GetTask = dbTask.getTask();
    });
  }

  void _onSelected(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  void _showNotification(DateTime date, int nid, String ntitle, String nbody, String ndetalles)async{
    await _simpleScheduleNotification(date, nid, ntitle, nbody, ndetalles);
  }
  Future<void> _simpleScheduleNotification(DateTime date, int nid, String ntitle, String nbody, String ndetalles) async{
    var androidPlataformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_description',
        importance: Importance.Max,
        priority: Priority.Max,
        ticker: 'Test Ticker'
    );

    var IOSPlataformChannelSpecifics = IOSNotificationDetails();

    var plataformChannelSpecifics = NotificationDetails(
        androidPlataformChannelSpecifics, IOSPlataformChannelSpecifics);

    //await flutterLocalNotificationsPlugin.schedule(id, title, body, scheduleDate, notificationDetails);
    print(date);
    await flutterLocalNotificationsPlugin.schedule(nid, ntitle, nbody, date, plataformChannelSpecifics, payload: nid.toString(), );
    print(nid);
    print(ntitle);
    print(nbody);
    print(nid);
  }

  Future _onSelectNotification(String id) async{
    debugPrint(id.toString());
    int n=int.parse(id);
    print(n);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Delete(id: n)));
    Fluttertoast.showToast(msg: id.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.cyan,
        textColor: Colors.white,
        fontSize: 25.0);
    print("cancelada");

  }



  @override
  Widget build(BuildContext context) {
    refreshList();
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
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  itemCount: snapshot.data.length,
                  staggeredTileBuilder: (int index) {
                    return new StaggeredTile.count(1, index.isEven ? 1.5 : 1.8);
                  },
                  itemBuilder: (BuildContext context, int index) {
                      ntitle=snapshot.data[index].title;
                      nbody=snapshot.data[index].body;
                      nid=snapshot.data[index].control;
                      nfecha=snapshot.data[index].fecha;
                      nhora=snapshot.data[index].hora;
                      ndetalles=snapshot.data[index].detalles;
                      nestado="activo";
                      nimage=snapshot.data[index].photo;
                      programDate= ("$nfecha $nhora:00.000");
                      print(programDate);
                      program=dateFormat.parse(programDate);
                      program=DateTime.parse(programDate);
                      print(program);
                      _showNotification(program, nid, ntitle, nbody, ndetalles);
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Details(
                                            id: snapshot.data[index].control,
                                            title: snapshot.data[index].title,
                                            body: snapshot.data[index].body,
                                            detalles:
                                                snapshot.data[index].detalles,
                                            estado: snapshot.data[index].estado,
                                            fecha: snapshot.data[index].fecha,
                                            hora: snapshot.data[index].hora,
                                            photo: snapshot.data[index].photo,
                                          )));
                            },
                            child: Card(
                              child: SingleChildScrollView(padding: EdgeInsets.all(5.0),
                                scrollDirection: Axis.vertical,
                                child: Container(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                        child: Image(
                                      image: Convertir.imageFromBase64sString(
                                              snapshot.data[index].photo)
                                          .image,
                                      height: index.isEven ? 145 : 175,
                                    )),
                                    Text(snapshot.data[index].hora.toString(),
                                        style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 33.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(snapshot.data[index].fecha.toString(),
                                        style: TextStyle(
                                          color: Colors.cyan,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Wrap(
                                        spacing: 10.0,
                                        direction: Axis.horizontal,
                                        runAlignment: WrapAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].title
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.teal),
                                          ),
                                        ])
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Task'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            title: Text('Data Base'),
          ),
        ],
        currentIndex: _selectedItem,
        selectedItemColor: Colors.cyan,
        onTap: (_selectedItem) {
          if (_selectedItem == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewTask()));
          }
          else if(_selectedItem == 2){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Tabla()));
          }
        },
      ),
    );
  }

  Future<void> closeSesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('_sesion', false);
    setState(() {
      name = name;
      email = email;
    });
    print("cerrar");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Registro()));
  }
}
