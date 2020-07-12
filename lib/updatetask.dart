import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notificaciones/DbTask.dart';
import 'package:notificaciones/MapTask.dart';
import 'package:notificaciones/convert.dart';
import 'package:notificaciones/user.dart';

class UpdateTask extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  final String fecha;
  final String hora;
  final String detalles;
  final String estado;
  final String photo;

  const UpdateTask(
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
  _UpdateTaskState createState() => _UpdateTaskState(id: id,
      body: body,
      title: title,
      detalles: detalles,
      estado: estado,
      fecha: fecha,
      hora: hora,
      photo: photo);
}

class _UpdateTaskState extends State<UpdateTask> {

  final int id;
  final String title;
  final String body;
  final String fecha;
  final String hora;
  final String detalles;
  final String estado;
  final String photo;

  _UpdateTaskState(
      {this.title,
        this.body,
        this.fecha,
        this.hora,
        this.detalles,
        this.estado,
        this.photo,
        this.id});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();
  DateTime _dateTime;
  String newtitle;
  String newbody;
  String newdetalles;
  String newphoto;
  String newfecha;
  String newhora;
  String image;
  String programDate;
  int programFecha;
  int programHora;
  int programMinutos;
  String hr;
  String min;
  var dbTask;
  bool isUpdating;
  Future<List<MapTask>> GetTask;
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
    controllerTitle.text = title;
    controllerBody.text = body;
    controllerDetalles.text = detalles;
    controllerFecha.text = fecha;
    controllerHora.text = hora;
    controllerPhoto.text = photo;

    refreshList();
  }

  void refreshList() {
    setState(() {
      GetTask = dbTask.getTask();
    });
  }

  ImageGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      newphoto = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return newphoto;
    });
  }

  ImageCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      newphoto = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return newphoto;
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
      MapTask map = MapTask(id, newtitle, newbody, newdetalles, newfecha, newhora, estado, newphoto);
      print(map);
      dbTask.update(map);
      refreshList();
      Navigator.pop(context, MaterialPageRoute(builder: (context) => User()));
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
                        onChanged: (val) => newtitle = val.toString(),
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
                        onChanged: (val) {
                          newbody = val.toString();
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
                          newdetalles = val.toString();
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: controllerFecha,
                        enabled: vh,
                        decoration: InputDecoration(
                            labelText: controllerFecha == null
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
                              newfecha = _dateTime.toString().substring(0, 10);
                              controllerFecha.text = newfecha;
                              vf = false;
                            });
                          });
                        },
                        validator: (val) =>
                        val.length == 0 ? 'Enter a Date' : null,
                        onSaved: (val) => newfecha = controllerFecha.text.toString(),
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
                              newhora = h.toString().substring(10, 15);
                              controllerHora.text = newhora;
                              vh = false;
                            });
                          });
                        },
                        validator: (val) =>
                        val.length == 0 ? 'Enter a Hour' : null,
                        onSaved: (val) => newhora = val.toString(),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: controllerPhoto,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Photo",
                        ),
                        validator: (val) => val.length == 0
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
                          child: Text("UPDATE"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.tealAccent, width: 2.0)),
                          // ignore: missing_return
                          onPressed: () async {
                            checkData();
                            verificar();
                            print("1");
                            print(newtitle);
                            print("2");
                            print(newbody);
                            print("3");
                            print(newdetalles);
                            print("4");
                            print(newhora);
                            print("5");
                            print(newfecha);
                            print("photo");
                            print(newphoto);
                          })
                    ],
                  ))),
        ));
  }

  void checkData(){
    if(newtitle==null || newtitle==""){
      newtitle=title;
    }
    if(newbody==null || newbody==""){
      newbody=body;
    }
    if(newdetalles==null || newdetalles==""){
      newdetalles=detalles;
    }
    if(newfecha==null || newfecha==""){
      newfecha=fecha;
    }
    if(newhora==null || newfecha==""){
      newhora=hora;
    }
    if(newphoto==null){
      newphoto=photo;
    }

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
