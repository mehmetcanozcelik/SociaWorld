//@dart=2.9
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/storageServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class Yukle extends StatefulWidget {
  const Yukle({Key key}) : super(key: key);

  @override
  State<Yukle> createState() => _YukleState();
}

class _YukleState extends State<Yukle> {
  File dosya;
  bool yukleniyor = false;

  TextEditingController aciklamaText = TextEditingController();
  TextEditingController konumText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() : gonderiFormu();
  }

  Widget yukleButonu() {
    return IconButton(
        icon: Icon(
          Icons.file_upload,
          size: 50.0,
        ),
        onPressed: () {
          fotografSec();
        });
  }

  Widget gonderiFormu() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Gönderi Oluştur",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              setState(() {
                dosya = null;
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: [
          IconButton(
              onPressed: _gonderiOlustur,
              icon: Icon(
                Icons.send,
                color: Colors.purple[800],
              ))
        ],
      ),
      body: ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.file(
                dosya,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: aciklamaText,
            decoration: InputDecoration(
                hintText: "Açıklama Ekle",
                contentPadding: EdgeInsets.only(left: 15.0, right: 15.0)),
          ),
          TextFormField(
            controller: konumText,
            decoration: InputDecoration(
                hintText: "Konum",
                contentPadding: EdgeInsets.only(left: 15.0, right: 15.0)),
          ),
        ],
      ),
    );
  }

  void _gonderiOlustur() async {
    if (!yukleniyor) {
      setState(() {
        yukleniyor = true;
      });
      String resimURL = await StorageServisi().gonderiResmiYukle(dosya);
      String aktifKullaniciId =
          Provider.of<YetkilendirmeServisi>(context, listen: false)
              .aktifKullaniciID;

      await FirestoreServisi().gonderiOlustur(
          gonderiResmiUrl: resimURL,
          aciklama: aciklamaText.text,
          yayinlayanId: aktifKullaniciId,
          konum: konumText.text);
      setState(() {
        yukleniyor = false;
        aciklamaText.clear();
        konumText.clear();
        dosya = null;
      });
    }
  }

  fotografSec() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Gönderi Oluştur"),
            children: [
              SimpleDialogOption(
                child: Text("Fotoğraf Çek"),
                onPressed: () {
                  fotografCek();
                },
              ),
              SimpleDialogOption(
                child: Text("Galeriden Yükle"),
                onPressed: () {
                  galeridenSec();
                },
              ),
              SimpleDialogOption(
                child: Text("İptal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  fotografCek() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });
  }

  galeridenSec() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });
  }
}
