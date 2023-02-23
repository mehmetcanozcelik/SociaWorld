// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, unused_element, prefer_final_fields, unused_field
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profiliduzenle.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:socialapp/widgetlar/gonderiKarti.dart';

class Profil extends StatefulWidget {
  const Profil({Key key, this.profilSahibiID}) : super(key: key);
  final String profilSahibiID;

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderiSayisi = 0;
  int _takipci = 0;
  int _takipEdilen = 0;
  List<Gonderi> _gonderiler = [];
  String gonderiStili = "liste";
  String _aktifKullaniciId;
  Kullanici _profilSahibi;
  bool _takipEdildi = false;

  _takipciSayisiGetir() async {
    int takipciSayisi =
        await FirestoreServisi().takipciSayisi(widget.profilSahibiID);
    if (mounted) {
      setState(() {
        _takipci = takipciSayisi;
      });
    }
  }

  _takipEdilenSayisiGetir() async {
    int takipEdilenSayisi =
        await FirestoreServisi().takipEdilenSayisi(widget.profilSahibiID);
    if (mounted) {
      setState(() {
        _takipEdilen = takipEdilenSayisi;
      });
    }
  }

  _gonderileriGetir() async {
    List<Gonderi> gonderiler =
        await FirestoreServisi().gonderileriGetir(widget.profilSahibiID);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
        _gonderiSayisi = gonderiler.length;
      });
    }
  }

  _takipKontrol() async {
    bool takipVarMi = await FirestoreServisi().takipKontrol(
        profilSahibiId: widget.profilSahibiID,
        aktifKullaniciId: _aktifKullaniciId);
    setState(() {
      _takipEdildi = takipVarMi;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
    _gonderileriGetir();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciID;
    _takipKontrol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple[400],
        actions: [
          widget.profilSahibiID == _aktifKullaniciId
              ? IconButton(
                  onPressed: _cikisYap,
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ))
              : SizedBox(
                  height: 0.0,
                )
        ],
      ),
      body: FutureBuilder<Object>(
          future: FirestoreServisi().KullaniciGetir(widget.profilSahibiID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            _profilSahibi = snapshot.data;

            return ListView(
              children: [
                _profilDetaylari(snapshot.data),
                _gonderileriGoster(snapshot.data),
              ],
            );
          }),
    );
  }

  Widget _gonderileriGoster(Kullanici profilData) {
    if (gonderiStili == "liste") {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _gonderiler.length,
          itemBuilder: (context, index) {
            return GonderiKarti(
              gonderi: _gonderiler[index],
              yayinlayan: profilData,
            );
          });
    } else {
      List<GridTile> fayanslar = [];
      _gonderiler.forEach((Gonderi) {
        fayanslar.add(_fayansOlustur(Gonderi));
      });
      return GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: 1.0,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: fayanslar);
    }
  }

  GridTile _fayansOlustur(Gonderi Gonderi) {
    return GridTile(
        child: Image.network(
      Gonderi.gonderiResmiUrl,
      fit: BoxFit.cover,
    ));
  }

  Widget _profilDetaylari(Kullanici profilData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                backgroundImage: profilData.fotoUrl.isNotEmpty
                    ? NetworkImage(profilData.fotoUrl)
                    : AssetImage("assets/images/hayalet.png"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sosyalSayac(baslik: "Gönderiler", sayi: _gonderiSayisi),
                    _sosyalSayac(baslik: "Takipçi", sayi: _takipci),
                    _sosyalSayac(baslik: "Takip Edilen", sayi: _takipEdilen),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profilData.kullaniciAdi,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(profilData.hakkinda),
          SizedBox(
            height: 25.0,
          ),
          widget.profilSahibiID == _aktifKullaniciId
              ? _profiliDuzenleButon()
              : _takipButonu(),
        ],
      ),
    );
  }

  Widget _takipButonu() {
    return _takipEdildi ? _takiptenCikButonu() : _takipEtButonu();
  }

  Widget _takipEtButonu() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: Colors.purple[400],
        onPressed: () {
          FirestoreServisi().takipEt(
              profilSahibiId: widget.profilSahibiID,
              aktifKullaniciId: _aktifKullaniciId);
          setState(() {
            _takipEdildi = true;
            _takipci = _takipci + 1;
          });
        },
        child: Text(
          "Takip Et",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _takiptenCikButonu() {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          FirestoreServisi().takiptenCik(
              profilSahibiId: widget.profilSahibiID,
              aktifKullaniciId: _aktifKullaniciId);
          setState(() {
            _takipEdildi = false;
            _takipci = _takipci - 1;
          });
        },
        child: Text(
          "Takipten Çık",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _profiliDuzenleButon() {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfiliDuzenle(
                        profil: _profilSahibi,
                      )));
        },
        child: Text(
          "Profili Düzenle",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _sosyalSayac({String baslik, int sayi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          sayi.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          baslik,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }

  void _cikisYap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}
