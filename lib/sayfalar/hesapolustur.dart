// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_field, avoid_print, deprecated_member_use, empty_catches, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  late String kullaniciAdi, email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Hesap Oluştur"),
        ),
        body: ListView(
          children: [
            yukleniyor
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formAnahtari,
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı adınızı girin",
                          labelText: "Kullanıcı Adı:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger!.isEmpty) {
                            return "Kullanıcı adı boş bırakılamaz!";
                          } else if (girilenDeger.trim().length < 4 ||
                              girilenDeger.trim().length > 10) {
                            return "Kullanıcı adı en az 4, en fazla 10 karakter olabilir!";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          kullaniciAdi = girilenDeger!;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email adresinizi girin",
                          labelText: "Mail adresi:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger!.isEmpty) {
                            return "Email alanı boş bırakılamaz!";
                          } else if (!girilenDeger.contains("@")) {
                            return "Lütfen doğru bir mail adresi giriniz.";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          email = girilenDeger!;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Şifrenizi girin",
                          labelText: "Şifre:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.password),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger!.isEmpty) {
                            return "Şifre boş bırakılamaz!";
                          } else if (girilenDeger.trim().length < 4) {
                            return ("Şifre 4 karakterden az olamaz!");
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) {
                          sifre = girilenDeger!;
                        },
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _kullaniciOlustur,
                          child: Text(
                            "Hesap Oluştur",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              primary: Colors.purple,
                              backgroundColor: Colors.purple[800]),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    if (_formAnahtari.currentState!.validate()) {
      _formAnahtari.currentState!.save();
      setState(() {
        yukleniyor = true;
      });

      try {
        Kullanici kullanici =
            await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if (kullanici != null) {
          FirestoreServisi().KullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      } catch (hata) {
        var snackBar = SnackBar(content: Text(hata.toString()));
        _scaffoldAnahtari.currentState!.showSnackBar(snackBar);
      }
    }
  }
}
