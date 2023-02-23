// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi {
  final String id;
  final String gonderiResmiUrl;
  final String aciklama;
  final String yayinlayanID;
  final int begeniSayisi;
  final String konum;

  Gonderi(
      {this.id,
      this.gonderiResmiUrl,
      this.aciklama,
      this.yayinlayanID,
      this.begeniSayisi,
      this.konum});

  factory Gonderi.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data;
    return Gonderi(
      id: doc.documentID,
      gonderiResmiUrl: doc['gonderiResmiUrl'],
      aciklama: doc['aciklama'],
      yayinlayanID: doc['yayinlayanID'],
      begeniSayisi: doc['begeniSayisi'],
      konum: doc['konum'],
    );
  }
}
