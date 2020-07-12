import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notificaciones/tabla.dart';
import 'package:notificaciones/user.dart';
import 'dart:core';
import 'dart:async';
import 'DbTask.dart';
import 'MapTask.dart';
import 'convert.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  //variables
  final formkey = new GlobalKey<FormState>();
  DateTime _dateTime;
  DateTime program;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  Future<int> getid;
  int id;
  String title;
  String body;
  String fecha;
  String hora;
  String detalles;
  String estado="activo";
  String image;
  String hr;
  String min;
  int _selectedItem = 0;

  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;
  List getcon;
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerBody = TextEditingController();
  TextEditingController controllerDetalles = TextEditingController();
  TextEditingController controllerFecha = TextEditingController();
  TextEditingController controllerHora = TextEditingController();
  TextEditingController controllerPhoto = TextEditingController();
  bool vh;
  bool vf;


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

  void cleanData() {
    _dateTime = null;
    program =null;
    getid=null;
    id=0;
    title = "";
    body = "";
    fecha = "";
    hora = "";
    detalles = "";
    image = "";
    hr = "";
    min = "";
    controllerTitle.text = "";
    controllerBody.text = "";
    controllerDetalles.text = "";
    controllerFecha.text = "";
    controllerHora.text = "";
    controllerPhoto.text = "";
    vh = true;
    vf = true;
  }

  ImageGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return image;
    });
  }

  ImageCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return image;
    });
  }

  //Select the image
  Future<void> _selectphoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Make a choise!",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.cyan,
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      ImageGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  GestureDetector(
                    child: Text(
                      "Camera",
                    ),
                    onTap: () {
                      ImageCamera(context);
                    },
                  )
                ]),
              ));
        });
  }

  void verificar() async {
    refreshList();
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      MapTask map = MapTask(null, title, body, detalles, fecha, hora, "activo", image);
      dbTask.insert(map);
      refreshList();
      getcon=await dbTask.getControl();
      Map<String, dynamic> getcon2= getcon[getcon.length-1].toMap();
      id=int.parse(getcon2['control'].toString());
      print(id);
    }
    cleanData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("INSERT A NEW TASK"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: true,
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
                    TextFormField(
                      controller: controllerFecha,
                      enabled: vh,
                      decoration: InputDecoration(
                          labelText: _dateTime == null
                              ? "Nothing has been picked yet"
                              : "Date"),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate:
                          _dateTime == null ? DateTime.now() : _dateTime,
                          firstDate: DateTime(2001),
                          lastDate: DateTime(2030),
                        ).then((date) {
                          setState(() {
                            _dateTime = date;
                            print(_dateTime);
                            fecha = _dateTime.toString().substring(0, 10);
                            controllerFecha.text = fecha;
                            vf = false;
                          });
                        });
                      },
                      validator: (val) =>
                      val.length == 0 ? 'Enter a Date' : null,
                      onSaved: (val) => fecha = val.toString(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: controllerHora,
                      enabled: vh,
                      decoration: InputDecoration(
                          labelText: hora == null
                              ? "Nothing has been picked yet"
                              : "Hour"),
                      onTap: () {
                        showTimePicker(
                            context: (context),
                            initialTime:
                            TimeOfDay.fromDateTime(DateTime.now()))
                            .then((h) {
                          setState(() {
                            hr = h.toString().substring(10, 12);
                            min = h.toString().substring(13, 15);
                            hora = h.toString().substring(10, 15);
                            controllerHora.text = hora;
                            vh = false;
                          });
                        });
                      },
                      validator: (val) =>
                      val.length == 0 ? 'Enter a Hour' : null,
                      onSaved: (val) => hora = val.toString(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: controllerPhoto,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Photo",
                      ),
                      validator: (val) =>
                      val.length == 0
                          ? 'Debes subir una imagen'
                          : controllerPhoto.text == "Campo lleno"
                          ? null
                          : "Solo imagenes",
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      color: Colors.cyan,
                      onPressed: () {
                        _selectphoto(context);
                      },
                      child: Text(
                        "Select image",
                        textAlign: TextAlign.center,
                      ),
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
                          verificar();
                          print("1");
                          print(title);
                          print("2");
                          print(body);
                          print("3");
                          print(detalles);
                          print("4");
                          print(hora);
                          print("5");
                          print(fecha);
                          print("photo");
                          print(image);
                        })
                  ],
                ))),
      ),
    );
  }

    void _onSelected(int index) {
      setState(() {
        _selectedItem = index;
      });
    }


}
