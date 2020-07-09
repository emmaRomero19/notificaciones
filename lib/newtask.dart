import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notificaciones/details.dart';

import 'DbTask.dart';
import 'MapTask.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();

  List number = [
    {'display': '00', 'value': '00'},
    {'display': '01', 'value': '01'},
    {'display': '02', 'value': '02'},
    {'display': '03', 'value': '03'},
    {'display': '04', 'value': '04'},
    {'display': '05', 'value': '05'},
    {'display': '06', 'value': '06'},
    {'display': '07', 'value': '07'},
    {'display': '08', 'value': '08'},
    {'display': '09', 'value': '09'},
    {'display': '10', 'value': '10'},
    {'display': '11', 'value': '11'},
    {'display': '12', 'value': '12'},
    {'display': '13', 'value': '13'},
    {'display': '14', 'value': '14'},
    {'display': '15', 'value': '15'},
    {'display': '16', 'value': '16'},
    {'display': '17', 'value': '17'},
    {'display': '18', 'value': '18'},
    {'display': '19', 'value': '19'},
    {'display': '20', 'value': '20'},
    {'display': '21', 'value': '21'},
    {'display': '22', 'value': '22'},
    {'display': '23', 'value': '23'},
    {'display': '24', 'value': '24'},
    {'display': '25', 'value': '25'},
    {'display': '26', 'value': '26'},
    {'display': '27', 'value': '27'},
    {'display': '28', 'value': '28'},
    {'display': '29', 'value': '29'},
    {'display': '30', 'value': '30'},
    {'display': '31', 'value': '31'},
    {'display': '32', 'value': '32'},
    {'display': '33', 'value': '33'},
    {'display': '34', 'value': '34'},
    {'display': '35', 'value': '35'},
    {'display': '36', 'value': '36'},
    {'display': '37', 'value': '37'},
    {'display': '38', 'value': '38'},
    {'display': '39', 'value': '39'},
    {'display': '40', 'value': '40'},
    {'display': '41', 'value': '41'},
    {'display': '42', 'value': '42'},
    {'display': '43', 'value': '43'},
    {'display': '44', 'value': '44'},
    {'display': '45', 'value': '45'},
    {'display': '46', 'value': '46'},
    {'display': '47', 'value': '47'},
    {'display': '48', 'value': '48'},
    {'display': '49', 'value': '49'},
    {'display': '50', 'value': '50'},
    {'display': '51', 'value': '51'},
    {'display': '52', 'value': '52'},
    {'display': '53', 'value': '53'},
    {'display': '54', 'value': '54'},
    {'display': '55', 'value': '55'},
    {'display': '56', 'value': '56'},
    {'display': '57', 'value': '57'},
    {'display': '58', 'value': '58'},
    {'display': '59', 'value': '59'},
  ];

  int id;
  String title;
  String body;
  String hora;
  String minutos;
  String segundos;
  String detalles;
  int ph;
  int pm;
  int ps;

  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerBody = TextEditingController();
  TextEditingController controllerDetalles = TextEditingController();
  TextEditingController controllerHora = TextEditingController();
  TextEditingController controllerMin = TextEditingController();
  TextEditingController controllerSeg = TextEditingController();


  //Declaracion de plugin
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
    initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);

  }

  void _showNotification()async{
    await _simpleScheduleNotification();
  }

  Future<void> _simpleScheduleNotification() async{
    var androidPlataformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_description',
        importance: Importance.Max,
        priority: Priority.Max,
        ticker: 'Test Ticker'
    );
    var IOSPlataformChannelSpecifics = IOSNotificationDetails();

    var plataformChannelSpecifics = NotificationDetails(
        androidPlataformChannelSpecifics, IOSPlataformChannelSpecifics);

    var now = new DateTime.now();
    var reprogram = now.add(Duration(hours:  ph, minutes: pm, seconds: ps));
    //await flutterLocalNotificationsPlugin.schedule(id, title, body, scheduleDate, notificationDetails);
    await flutterLocalNotificationsPlugin.schedule(10, title, body, reprogram, plataformChannelSpecifics, payload: detalles);

    Fluttertoast.showToast(msg: "Schedule at time $reprogram",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 15.0);
  }


  Future _onSelectNotification(String payload) async{
    if(payload!=null){
      debugPrint('Notification payload: $payload');
      print("eeroo");
    }
    await Navigator.push(context, new MaterialPageRoute(builder: (context)=> new Details()));

    print("call onSelect");
  }

  Future _onDidReceiveLocalNotification(int id, String title, String body, String payload) async{
    await showDialog(context: context, builder: (BuildContext context)=>CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Ok"),
          isDefaultAction: true,
          onPressed: () async{
            Navigator.of(context,rootNavigator: true).pop();
            await Navigator.pop(context, MaterialPageRoute(builder: (context)=>Details()));
          },
        ),
      ],
    ));
    print("call oneDid");
  }

  void refreshList() {
    setState(() {
      GetTask = dbTask.getTask();
    });
  }

  void cleanData() {
    controllerTitle.text = "";
    controllerBody.text = "";
    controllerDetalles.text = "";
    title = "";
    body = "";
    detalles = "";
    hora = "";
    minutos = "";
    segundos = "";
  }

  Future validar() {
    if (formkey.currentState.validate()) {
      if (hora == null || hora == "") {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: Text("Hour is Empty"),
              );
            });
      } else if (minutos == null || minutos == "") {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: Text("Minute is Empty"),
              );
            });
      } else if (segundos == null || segundos == "") {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: Text("Second is Empty"),
              );
            });
      } else {
        formkey.currentState.save();
      }
      print("1");
      print(title);
      print("2");
      print(body);
      print("3");
      print(detalles);
      print("4");
      print(hora);
      print("5");
      print(minutos);
      print("6");
      print(segundos);
      MapTask get = 
      MapTask(null, title, body, detalles, hora, minutos, segundos);
      dbTask.insert(get);
      id=0;
      ph=int.parse(hora);
      pm=int.parse(minutos);
      ps=int.parse(segundos);
    }
    setState(() {
      cleanData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("INSERT A NEW TASK"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
              key: formkey,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 35.0, right: 15.0, bottom: 35.0, left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        controller: controllerTitle,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: (TextStyle(color: Colors.teal)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (val) =>
                            val.length == 0 ? 'Enter a title ' : null,
                        onSaved: (val) => title = val.toString(),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: controllerBody,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Body',
                            labelStyle: (TextStyle(color: Colors.teal)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (val) =>
                            val.length == 0 ? 'Enter a body' : null,
                        onSaved: (val) {
                          body = val.toString();
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: controllerDetalles,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Details',
                            labelStyle: (TextStyle(color: Colors.teal)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (val) =>
                            val.length == 0 ? 'Enter a detail' : null,
                        onSaved: (val) {
                          detalles = val.toString();
                        },
                      ),
                      SizedBox(height: 10),
                      DropDownFormField(
                        required: true,
                        errorText: "error",
                        titleText: 'Hour',
                        hintText: '00',
                        value: hora,
                        onSaved: (value) {
                          setState(() {
                            hora = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            hora = value;
                          });
                        },
                        dataSource: number,
                        textField: 'display',
                        valueField: 'value',
                      ),
                      SizedBox(height: 10),
                      DropDownFormField(
                        required: true,
                        titleText: 'Minute',
                        hintText: '00',
                        value: minutos,
                        onSaved: (value) {
                          setState(() {
                            minutos = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            minutos = value;
                          });
                        },
                        dataSource: number,
                        textField: 'display',
                        valueField: 'value',
                      ),
                      SizedBox(height: 10),
                      DropDownFormField(
                        required: true,
                        titleText: 'Seconds',
                        hintText: '00',
                        value: segundos,
                        onSaved: (value) {
                          setState(() {
                            segundos = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            segundos = value;
                          });
                        },
                        dataSource: number,
                        textField: 'display',
                        valueField: 'value',
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        child: Text("Add New Task"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.tealAccent, width: 2.0)),
                          // ignore: missing_return
                          onPressed: () async {
                            print("1");
                            print(title);
                            print("2");
                            print(body);
                            print("3");
                            print(detalles);
                            print("4");
                            print(hora);
                            print("5");
                            print(minutos);
                            print("6");
                            print(segundos);
                            validar();
                            _showNotification();
                          })
                    ],
                  ))),
        ));
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.deepPurple,
        content: new Text(
          value,
          style: TextStyle(fontSize: 20.0, color: Colors.yellow),
        )));
  }


}
