// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/sayfalar/akis.dart';
import 'package:socialapp/sayfalar/ara.dart';
import 'package:socialapp/sayfalar/bildirimler.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/yukle.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfaNo = 0;
  late PageController sayfaKumandasi;
  @override
  void initState() {
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    sayfaKumandasi.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    String aktifKullaniciID =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciID;
    return Scaffold(
      body: PageView(
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: [
          Akis(),
          Ara(),
          Yukle(),
          Bildirimler(),
          Profil(
            profilSahibiID: aktifKullaniciID,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfaNo,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ("Akış")),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: ("Keşfet")),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload_rounded),
              label: ("Yükle ve Paylaş")),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: ("Bildirimler")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: ("Profil")),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}
