class MapTask{
  int control;
  String title;
  String body;
  String fecha;
  String hora;
  String detalles;
  String estado;
  String photo;

  MapTask(this.control, this.title, this.body, this.detalles, this.fecha,this.hora, this.estado, this.photo);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'control': control,
      'title': title,
      'body': body,
      'fecha': fecha,
      'hora': hora,
      'detalles': detalles,
      'estado': estado,
      'photo': photo
    };
    return map;
  }
  MapTask.fromMap(Map<String, dynamic> map){
    control = map['control'];
    title = map['title'];
    body = map['body'];
    fecha = map['fecha'];
    hora = map['hora'];
    detalles = map['detalles'];
    estado = map['estado'];
    photo = map['photo'];
  }
}