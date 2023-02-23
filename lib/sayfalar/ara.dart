// ignore_for_file: prefer_const_constructors, unused_element, unused_field, missing_return
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';

class Ara extends StatefulWidget {
  const Ara({Key key}) : super(key: key);

  @override
  State<Ara> createState() => _AraState();
}

class _AraState extends State<Ara> {
  TextEditingController _aramaController = TextEditingController();
  Future<List<Kullanici>> _aramaSonucu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOlustur(),
      body: _aramaSonucu != null ? sonuclariGetir() : aramaYok(),
    );
  }

  AppBar _appBarOlustur() {
    return AppBar(
      titleSpacing: 0.0,
      backgroundColor: Colors.purple[400],
      title: TextFormField(
        onFieldSubmitted: (girilenDeger) {
          setState(() {
            _aramaSonucu = FirestoreServisi().kullaniciAra(girilenDeger);
          });
        },
        controller: _aramaController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 30.0,
            ),
            suffixIcon: IconButton(
                icon: Icon(Icons.clear_rounded),
                onPressed: () {
                  _aramaController.clear();
                  setState(() {
                    _aramaSonucu = null;
                  });
                }),
            border: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            hintText: "Kullanıcı ara",
            contentPadding: EdgeInsets.only(top: 16.0)),
      ),
    );
  }

  aramaYok() {
    return Center(child: Text("Kullanıcı ara"));
  }

  sonuclariGetir() {
    return FutureBuilder<List<Kullanici>>(
        future: _aramaSonucu,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.length == 0) {
            return Center(child: Text("Arama sonucu bulunamadı..."));
          }

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Kullanici kullanici = snapshot.data[index];
                return kullaniciSatiri(kullanici);
              });
        });
  }

  kullaniciSatiri(Kullanici kullanici) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profil(
                      profilSahibiID: kullanici.id,
                    )));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(kullanici.fotoUrl),
        ),
        title: Text(
          kullanici.kullaniciAdi,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
