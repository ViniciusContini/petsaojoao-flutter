import 'package:flutter/cupertino.dart';
import 'carousel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petsaojoao/models/back_pet_found/buttom_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PetFoundBoard extends StatefulWidget {
  String valor;

  PetFoundBoard({this.valor});
  @override
  _PetFoundBoardState createState() => _PetFoundBoardState();
}

class _PetFoundBoardState extends State<PetFoundBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            CarouselWithIndicatorDemo(),
            InfoPetFoundBoard(valor1: widget.valor),
            IconsForContact(),
            ThisYourPet(),
          ],
        ),
      ),
    );
  }
}

class InfoPetFoundBoard extends StatefulWidget {
  String valor1;

  InfoPetFoundBoard({this.valor1});
  @override
  _InfoPetFoundBoardState createState() => _InfoPetFoundBoardState();
}

class _InfoPetFoundBoardState extends State<InfoPetFoundBoard> {
  void _recuperarDados(id) async{
  String url = "localhost:3000/found/${id}";
  http.Response response = await http.get(url);

  Map<String, dynamic> retorno = json.decode( response.body );
  String tutor_id = retorno["tutor_id"].toString();
  String anonymous = retorno["anonymous"].toString();
  String lat = retorno["lat"].toString();
  String lng = retorno["lng"].toString();
  String note = retorno["note"].toString();
  String createdAt = retorno["createdAt"].toString();
  String updatedAt = retorno["updatedAt"].toString();

  String url1 = "localhost:3000/tutors/${tutor_id}";
  http.Response response1 = await http.get(url);

  Map<String, dynamic> retorno1 = json.decode( response.body );
  String tutor_name = retorno1["tutor_name"].toString();

  }

  final _labelPetFoundBoard = "Pet encontrado";
  final _fontFamilyRoboto = 'Roboto';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              _labelPetFoundBoard,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                fontFamily: _fontFamilyRoboto,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("dia: Hora: "),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Text(
              "Quem encontrou: ${widget.valor1}",
              style: TextStyle(fontFamily: _fontFamilyRoboto),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        )
      ],
    );
  }
}

class IconsForContact extends StatefulWidget {
  @override
  _IconsForContactState createState() => _IconsForContactState();
}

class _IconsForContactState extends State<IconsForContact> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              buttomFunctions().launchWhatsapp();
            },
            child: Icon(
              MdiIcons.whatsapp,
              color: Colors.black54,
              size: 50.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              buttomFunctions().makeCall();
            },
            child: Icon(
              Icons.call,
              color: Colors.black54,
              size: 50.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              buttomFunctions().createEmail();
            },
            child: Icon(
              Icons.email,
              color: Colors.black54,
              size: 50.0,
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      Divider(),
      SizedBox(height: 30),
    ]);
  }
}

class ThisYourPet extends StatefulWidget {
  @override
  _ThisYourPetState createState() => _ThisYourPetState();
}

class _ThisYourPetState extends State<ThisYourPet> {
  final _fontFamilyRoboto = 'Roboto';
  final _labelThisPet = "ESTE PET É SEU?";
  final _labelNegative = "NÃO";
  final _labelPositive = "SIM";
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        _labelThisPet,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamilyRoboto,
          fontSize: 16,
        ),
      ),
      SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton.icon(
              textColor: Colors.white,
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.blueAccent,
              onPressed: () {},
              label: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  _labelNegative,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: _fontFamilyRoboto,
                  ),
                ),
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(3.0))),
          FlatButton.icon(
              textColor: Colors.white,
              icon: Icon(Icons.location_on),
              color: Colors.blueAccent,
              onPressed: () {},
              label: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  _labelPositive,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: _fontFamilyRoboto,
                  ),
                ),
              ),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(3.0))),
        ],
      )
    ]);
  }
}

