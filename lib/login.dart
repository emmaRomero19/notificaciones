import 'package:flutter/material.dart';
import 'package:notificaciones/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final formKey = new GlobalKey<FormState>();

  final _controlUser = TextEditingController();
  final _controlPass = TextEditingController();
  final _controlMail = TextEditingController();

  String _user;
  String _pass;
  String _mail;

  String nombre = '';
  String contrasena = '';
  String correo = '';

  String nombreShare = '';
  String correoShare = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      getPreference();
    });

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50.0,
                          child: Image.asset(
                            'assets/user.png',
                            height: 200,
                          ),
                        )),
                  ])),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.cyan,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0, left: 20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Name',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0))),
                                validator: (valor) => valor.length < 5
                                    ? 'Name is shortest'
                                    : null,
                                controller: _controlUser,
                                onSaved: (valor) => _user = valor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.lock,
                                  size: 30, color: Colors.cyan),
                              onPressed: null),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0, left: 20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0))),
                                controller: _controlPass,
                                validator: (valor) => valor.length < 3
                                    ? 'Password is shorest'
                                    : null,
                                onSaved: (valor) => _pass = valor,
                                obscureText: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.mail,
                                  size: 30, color: Colors.cyan),
                              onPressed: null),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0, left: 20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0))),
                                controller: _controlMail,
                                validator: (valor) => !valor.contains('@')
                                    ? 'Email invalid'
                                    : null,
                                onSaved: (valor) => _mail = valor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 60,
                          child: RaisedButton(
                            onPressed: () {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                setState(() {
                                  nombre = _controlUser.text;
                                  correo = _controlMail.text;
                                  guardarPreferencias();
                                });
                                sesion();
                              }
                            },
                            color: Colors.cyan,
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkState();
  }

  Future _checkState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('_sesion')) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => User(name: nombreShare, email:correoShare)));
    }
  }

  void sesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('_sesion', true);
    _checkState();
  }

  Future<void> guardarPreferencias() async {
    SharedPreferences datos = await SharedPreferences.getInstance();
    datos.setString('nombre', _controlUser.text);
    datos.setString('correo', _controlMail.text);
  }

  Future<void> getPreference() async {
    SharedPreferences datos = await SharedPreferences.getInstance();
    setState(() {
      nombreShare = datos.get('nombre') ?? nombre;
      correoShare = datos.get('correo') ?? correo;
    });
  }


}