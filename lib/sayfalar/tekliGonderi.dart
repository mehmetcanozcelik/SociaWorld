// ignore_for_file: file_names
// ignore_for_file: unused_import, unused_local_variable, missing_return, prefer_const_constructors, prefer_const_literals_to_create_immutables
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/widgetlar/gonderiKarti.dart';

class TekliGonderi extends StatefulWidget {
  final String gonderiId;
  final String gonderiSahibiId;
  const TekliGonderi({Key key, this.gonderiId, this.gonderiSahibiId})
      : super(key: key);

  @override
  State<TekliGonderi> createState() => _TekliGonderiState();
}

class _TekliGonderiState extends State<TekliGonderi> {
  Gonderi _gonderi;
  Kullanici _gonderiSahibi;
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    gonderiGetir();
  }

  gonderiGetir() async {
    Gonderi gonderi = await FirestoreServisi()
        .tekliGonderiGetir(widget.gonderiId, widget.gonderiSahibiId);
    if (gonderi != null) {
      Kullanici gonderiSahibi =
          await FirestoreServisi().KullaniciGetir(gonderi.yayinlayanID);

      setState(() {
        _gonderi = gonderi;
        _gonderiSahibi = gonderiSahibi;
        _yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        title: Text(
          "Gönderi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: !_yukleniyor
          ? GonderiKarti(
              gonderi: _gonderi,
              yayinlayan: _gonderiSahibi,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
