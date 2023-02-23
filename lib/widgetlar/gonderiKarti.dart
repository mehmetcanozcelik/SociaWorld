// ignore_for_file: file_names, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables, unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/gonderi.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/yorumlar.dart';
import 'package:socialapp/servisler/firestoreServisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class GonderiKarti extends StatefulWidget {
  final Gonderi gonderi;
  final Kullanici yayinlayan;
  const GonderiKarti(
      {Key? key, required this.gonderi, required this.yayinlayan})
      : super(key: key);

  @override
  _GonderiKartiState createState() => _GonderiKartiState();
}

class _GonderiKartiState extends State<GonderiKarti> {
  int _begeniSayisi = 0;
  bool _begendin = false;
  late String _aktifKullaniciID;

  get gonderi => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aktifKullaniciID =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciID;
    _begeniSayisi = widget.gonderi.begeniSayisi;
    begeniVarmi();
  }

  begeniVarmi() async {
    bool begeniVarmi =
        await FirestoreServisi().begeniVarmi(widget.gonderi, _aktifKullaniciID);

    if (begeniVarmi) {
      if (mounted) {
        setState(() {
          _begendin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            _gonderiBasligi(),
            _gonderiResmi(),
            _gonderiAltKisim(),
          ],
        ));
  }

  gonderiSecenekleri() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Gönderi ile ne yapmak istiyorsunuz?"),
            children: [
              SimpleDialogOption(
                child:
                    Text("Gönderiyi Sil", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  FirestoreServisi().gonderiSil(
                      aktifKullaniciId: _aktifKullaniciID,
                      gonderi: widget.gonderi);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.grey[800]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget _gonderiBasligi() {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: NetworkImage(widget.yayinlayan.fotoUrl)),
      ),
      title: Text(
        widget.yayinlayan.kullaniciAdi,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: _aktifKullaniciID == widget.gonderi.yayinlayanID
          ? IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => gonderiSecenekleri())
          : IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => gonderiSecenekleri()),
      contentPadding: EdgeInsets.all(0.0),
    );
  }

  Widget _gonderiResmi() {
    return GestureDetector(
      onDoubleTap: _begeniDegistir,
      child: Image.network(
        widget.gonderi.gonderiResmiUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _gonderiAltKisim() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: !_begendin
                  ? Icon(
                      Icons.favorite_border,
                      size: 35.0,
                    )
                  : Icon(
                      Icons.favorite,
                      size: 35.0,
                      color: Colors.red,
                    ),
              onPressed: _begeniDegistir,
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Yorumlar(gonderi: widget.gonderi)));
                },
                icon: Icon(
                  Icons.comment_outlined,
                  size: 35.0,
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "$_begeniSayisi Beğeni",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        widget.gonderi.aciklama.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                    text: TextSpan(
                        text: widget.yayinlayan.kullaniciAdi + " ",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                      TextSpan(
                          text: widget.gonderi.aciklama,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ))
                    ])),
              )
            : SizedBox(
                height: 0.0,
              )
      ],
    );
  }

  void _begeniDegistir() {
    if (_begendin) {
      //Kullanıcı zaten gönderiyi beğenmiş.
      setState(() {
        _begendin = false;
        _begeniSayisi = _begeniSayisi - 1;
      });
      FirestoreServisi().gonderiBegeniKaldir(widget.gonderi, _aktifKullaniciID);
    } else {
      //Kullanıcı henüz gönderiyi beğenmedi.
      setState(() {
        _begendin = true;
        _begeniSayisi = _begeniSayisi + 1;
      });
      FirestoreServisi().gonderiBegen(widget.gonderi, _aktifKullaniciID);
    }
  }
}
