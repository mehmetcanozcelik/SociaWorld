// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Kullanici {
  final String id;
  final String kullaniciAdi;
  final String fotoUrl;
  final String email;
  final String hakkinda;

  Kullanici(
      {required this.id,
      required this.kullaniciAdi,
      required this.fotoUrl,
      required this.email,
      required this.hakkinda});

  factory Kullanici.firebasedenUret(FirebaseUser kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      fotoUrl: kullanici.photoUrl,
      email: kullanici.email,
      hakkinda: '',
    );
  }

  factory Kullanici.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data;
    return Kullanici(
      id: doc.documentID,
      kullaniciAdi: docData['kullaniciAdi'],
      email: docData['email'],
      fotoUrl: docData['fotoUrl'],
      hakkinda: docData['hakkinda'],
    );
  }
}
