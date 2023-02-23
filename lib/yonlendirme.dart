// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_local_variable, missing_return, import_of_legacy_library_into_null_safe

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/anasayfa.dart';
import 'package:socialapp/sayfalar/girissayfasi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    return StreamBuilder(
        stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData) {
            Kullanici? aktifKullanici = snapshot.data as Kullanici?;
            _yetkilendirmeServisi.aktifKullaniciID = aktifKullanici!.id;
            return AnaSayfa();
          } else {
            return GirisSayfasi();
          }
        });
  }
}
