// ignore_for_file: unused_import, unused_local_variable, missing_return, prefer_const_constructors, prefer_const_literals_to_create_immutables
// @dart=2.9

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/duyuru.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/tekliGonderi.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:path/path.dart' as Path;

class Bildirimler extends StatefulWidget {
  const Bildirimler({Key key}) : super(key: key);

  @override
  State<Bildirimler> createState() => _BildirimlerState();
}

class _BildirimlerState extends State<Bildirimler> {
  List<Duyuru> _duyurular;
  String _aktifKullaniciID;
  bool _yukleniyor = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aktifKullaniciID =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciID;
    duyurulariGetir();
  }

  Future<void> duyurulariGetir() async {
    List<Duyuru> duyurular =
        await FirestoreServisi().duyurulariGetir(_aktifKullaniciID);
    if (mounted) {
      setState(() {
        _duyurular = duyurular;
        _yukleniyor = false;
      });
    }
  }

  duyurulariGoster() {
    if (_yukleniyor) {
      return Center(child: CircularProgressIndicator());
    }

    if (_duyurular.isEmpty) {
      return RefreshIndicator(
        onRefresh: duyurulariGetir,
        child: Column(
          children: [
            ListTile(
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profil(
                                profilSahibiID: "LKW0isjcaRYyKrgy2rCbMEpHpSz1",
                              )));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2023/01/24/13/23/viet-nam-7741017_960_720.jpg"),
                ),
              ),
              title: RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profil(
                                      profilSahibiID:
                                          "LKW0isjcaRYyKrgy2rCbMEpHpSz1",
                                    )));
                      },
                    text: "Skytte",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                    children: [
                      TextSpan(
                          text: " gönderini beğendi.",
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ]),
              ),
              subtitle: Text("7d önce"),
              trailing: Image(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/socialapp-21e47.appspot.com/o/resimler%2Fgonderiler%2Fgonderi_d12f76f2-842a-4de5-a649-e871b1d89713.jpg?alt=media&token=9adafef1-e42a-4ef0-80cd-de4e07f6e929"),
                width: 60.0,
                height: 60.0,
              ),
            ),
            ListTile(
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profil(
                                profilSahibiID: "LKW0isjcaRYyKrgy2rCbMEpHpSz1",
                              )));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2023/01/24/13/23/viet-nam-7741017_960_720.jpg"),
                ),
              ),
              title: RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profil(
                                      profilSahibiID:
                                          "LKW0isjcaRYyKrgy2rCbMEpHpSz1",
                                    )));
                      },
                    text: "Skytte",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                    children: [
                      TextSpan(
                          text: " gönderini beğendi.",
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ]),
              ),
              subtitle: Text("9d önce"),
              trailing: Image(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/socialapp-21e47.appspot.com/o/resimler%2Fgonderiler%2Fgonderi_931c2084-6976-4a8b-95d7-a5b4015916ec.jpg?alt=media&token=462086d7-777c-4a6f-975f-4aa28f14ac80"),
                width: 60.0,
                height: 60.0,
              ),
            ),
            ListTile(
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profil(
                                profilSahibiID: "VWfvUrkOVvOlKQhjN5iTqU4SF8t2",
                              )));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2014/07/10/11/15/balloons-388973_960_720.jpg"),
                ),
              ),
              title: RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profil(
                                      profilSahibiID:
                                          "VWfvUrkOVvOlKQhjN5iTqU4SF8t2",
                                    )));
                      },
                    text: "Kaizen",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                    children: [
                      TextSpan(
                          text: " seni takip etmeye başladı.",
                          style: TextStyle(fontWeight: FontWeight.normal))
                    ]),
              ),
              subtitle: Text("1s önce"),
            )
          ],
        ),
      );
    }

    return ListView.builder(
        itemCount: _duyurular.length,
        itemBuilder: (context, index) {
          Duyuru duyuru = _duyurular[index];
          return duyuruSatiri(duyuru);
        });
  }

  duyuruSatiri(Duyuru duyuru) {
    String mesaj = mesajOlustur(duyuru.aktiviteTipi);
    return FutureBuilder(
      future: FirestoreServisi().KullaniciGetir(duyuru.aktiviteYapanId),
      builder: (context, snasphot) {
        if (!snasphot.hasData) {
          return SizedBox(
            height: 0.0,
          );
        }

        Kullanici aktiviteYapan = snasphot.data;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(aktiviteYapan.fotoUrl),
          ),
          title: Text("${aktiviteYapan.kullaniciAdi} $mesaj"),
        );
      },
    );
  }

  mesajOlustur(String aktiviteTipi) {
    if (aktiviteTipi == "begeni") {
      return "gönderini beğendi.";
    } else if (aktiviteTipi == "takip") {
      return "seni takip etti.";
    } else if (aktiviteTipi == "yorum") {
      return "gönderine yorum yaptı";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        title: Text(
          "Bildirimler",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: duyurulariGoster(),
    );
  }
}
