class MapTask{
  int control;
  String title;
  String body;
  String hora;
  String minutos;
  String segundos;
  String detalles;

  MapTask(this.control, this.title, this.body, this.detalles, this.hora, this.minutos, this.segundos);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'control': control,
      'title': title,
      'body': body,
      'hora': hora,
      'minutos': minutos,
      'segundos': segundos,
      'detalles': detalles,
    };
    return map;
  }
  MapTask.fromMap(Map<String, dynamic> map){
    control = map['control'];
    title = map['title'];
    body = map['body'];
    hora = map['hora'];
    minutos = map['minutos'];
    segundos = map['segundos'];
    detalles = map['detalles'];
  }
}