// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, deprecated_member_use, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/hesapolustur.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool yukleniyor = false;
  late String email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        body: Stack(
          children: [
            _sayfaElemanlari(),
            _yuklemeAnimasyonu(),
          ],
        ));
  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: [
          FlutterLogo(
            size: 90.0,
          ),
          SizedBox(
            height: 80.0,
          ),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email adresinizi girin",
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
            onSaved: (girilenDeger) => email = girilenDeger!,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Şifrenizi girin",
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
            onSaved: (girilenDeger) => sifre = girilenDeger!,
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _girisYap,
                  child: Text(
                    "Giriş Yap",
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
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HesapOlustur()));
                  },
                  child: Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      primary: Colors.purple,
                      backgroundColor: Colors.purple[600]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("veya")),
          SizedBox(
            height: 15.0,
          ),
          Icon(Icons.add_to_home_screen_sharp),
          Center(
              child: InkWell(
            onTap: _googleIleGiris,
            child: Text(
              "Google ile Giriş Yap",
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("Şifremi Unuttum")),
        ],
      ),
    );
  }

  void _girisYap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    if (_formAnahtari.currentState!.validate()) {
      _formAnahtari.currentState!.save();
      setState(() {
        yukleniyor = true;
      });

      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.toString());
      }
    }
  }

  void _googleIleGiris() async {
    var _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    setState(() {
      yukleniyor = true;
    });

    try {
      Kullanici kullanici = await _yetkilendirmeServisi.googleIleGiris();
      if (kullanici != null) {
        Kullanici? firestoreKullanici =
            await FirestoreServisi().KullaniciGetir(kullanici.id);
        if (firestoreKullanici == null) {
          FirestoreServisi().KullaniciOlustur(
              id: kullanici.id,
              email: kullanici.email,
              kullaniciAdi: kullanici.kullaniciAdi,
              fotoUrl: kullanici.fotoUrl);
        }
      }
    } catch (hata) {
      setState(() {
        yukleniyor = false;
      });
      uyariGoster(hataKodu: hata.toString());
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Böyle bir kullanıcı bulunmamaktadır.";
    } else if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir.";
    } else if (hataKodu == "ERROR_WRONG_PASSWORD") {
      hataMesaji = "Şifreniz hatalıdır.";
    } else if (hataKodu == "ERROR_USER_DISABLED") {
      hataMesaji = "Kullanıcı engellenmiştir.";
    } else {
      hataMesaji = "Bir hata oluştu. $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState!.showSnackBar(snackBar);
  }
}
