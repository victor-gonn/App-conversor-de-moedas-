

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance?format=json&key=eb9e41d2";

void main() async {
 runApp(MaterialApp(
    home: Home(),
          theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
          debugShowCheckedModeBanner: false,
    ));

}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

late double dolar;
late double euro ;

void _realChanged(text) {
      if(text.isEmpty) {
      _clearAll();
      return;
    }
  double real = double.parse(text);
  dolarController.text = (real/dolar).toStringAsFixed(2);
  euroController.text = (real / euro).toStringAsFixed(2);
}

void _dolarChanged(String text) {
      if(text.isEmpty) {
      _clearAll();
      return;
    }
  double dolar = double.parse(text);
  realController.text = (dolar * this.dolar).toStringAsPrecision(2);
  euroController.text = (dolar * this.dolar/euro).toStringAsPrecision(2);
}

void _euroChanged(String text) {
      if(text.isEmpty) {
      _clearAll();
      return;
    }
  double euro = double.parse(text);
  realController.text = (euro* this.dolar).toStringAsPrecision(2);
  dolarController.text = (euro * this.euro/ dolar).toStringAsPrecision(2);
}

void _clearAll() {
  realController.clear();
  dolarController.clear();
  euroController.clear();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Conversor \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: Text('Carregando dados',
            style: TextStyle(
              color: Colors.amber, 
              fontSize: 25),
              ),
              );
              default:
              if(snapshot.hasError) {
                return Center(child: Text('Erro ao carregar',
            style: TextStyle(
              color: Colors.amber, 
              fontSize: 25),
              ),
              );
              } else {
                dolar = snapshot.data?["results"] ["currencies"] ["USD"] ["buy"];
                euro = snapshot.data?["results"] ["currencies"] ["EUR"] ["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on,size: 120, color: Colors.amber,),
                      Divider(),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Doláres", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro", "€", euroController, _euroChanged),
                    ], 
                  ),
                  );
              }
          }
        }, ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController control, Function(String) e) {
  return TextField(
                        controller: control,
                        decoration: InputDecoration(
                          labelText: label,
                          prefixText: prefix,
                          labelStyle: TextStyle(color: Colors.amber, fontSize: 20),
                          border: OutlineInputBorder()
                          
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                        keyboardType: TextInputType.number,
                        onChanged: e,
                      );
}