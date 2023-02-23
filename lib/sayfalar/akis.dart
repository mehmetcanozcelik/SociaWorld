// ignore_for_file: prefer_const_constructors
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:socialapp/widgetlar/gonderiKarti.dart';

class Akis extends StatefulWidget {
  const Akis({Key key}) : super(key: key);

  @override
  State<Akis> createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler = [];

  _akisGonderileriniGetir() async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciID;
    List<Gonderi> gonderiler =
        await FirestoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _akisGonderileriniGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SociaWorld"),
        centerTitle: true,
      ),
      body: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _gonderiler.length,
          itemBuilder: (context, index) {
            Gonderi gonderi = _gonderiler[index];
            return FutureBuilder(
                future: FirestoreServisi().KullaniciGetir(gonderi.yayinlayanID),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }

                  Kullanici gonderiSahibi = snapshot.data;

                  return GonderiKarti(
                      gonderi: _gonderiler[index], yayinlayan: gonderiSahibi);
                });
          }),
    );
  }
}
