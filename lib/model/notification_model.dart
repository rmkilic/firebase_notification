// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    List<Sonuc>? sonuc;
    bool? basarili;
    List<Bildirimler>? bildirimler;

    NotificationModel({
        this.sonuc,
        this.basarili,
        this.bildirimler,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        sonuc: json["sonuc"] == null ? [] : List<Sonuc>.from(json["sonuc"]!.map((x) => Sonuc.fromJson(x))),
        basarili: json["basarili"],
        bildirimler: json["bildirimler"] == null ? [] : List<Bildirimler>.from(json["bildirimler"]!.map((x) => Bildirimler.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "sonuc": sonuc == null ? [] : List<dynamic>.from(sonuc!.map((x) => x.toJson())),
        "basarili": basarili,
        "bildirimler": bildirimler == null ? [] : List<dynamic>.from(bildirimler!.map((x) => x.toJson())),
    };
}

class Bildirimler {
    int? tip;
    String? mesaj;

    Bildirimler({
        this.tip,
        this.mesaj,
    });

    factory Bildirimler.fromJson(Map<String, dynamic> json) => Bildirimler(
        tip: json["tip"],
        mesaj: json["mesaj"],
    );

    Map<String, dynamic> toJson() => {
        "tip": tip,
        "mesaj": mesaj,
    };
}

class Sonuc {
    int? id;
    String? guid;
    String? kimden;
    String? kime;
    String? clienttoken;
    String? subeadi;
    String? kasakodu;
    String? mesaj;
    int? mesajtipi;
    String? durum;
    DateTime? mesajtarihi;
    String? programtipi;
    Duration? duration;
    int? geriSayimBaslangici;

    Sonuc({
        this.id,
        this.guid,
        this.kimden,
        this.kime,
        this.clienttoken,
        this.subeadi,
        this.kasakodu,
        this.mesaj,
        this.mesajtipi,
        this.durum,
        this.mesajtarihi,
        this.programtipi,
        this.duration,
        this.geriSayimBaslangici,
    });

    factory Sonuc.fromJson(Map<String, dynamic> json) => Sonuc(
        id: json["id"],
        guid: json["guid"],
        kimden: json["kimden"],
        kime: json["kime"],
        clienttoken: json["clienttoken"],
        subeadi: json["subeadi"],
        kasakodu: json["kasakodu"],
        mesaj: json["mesaj"],
        mesajtipi:int.parse(json["mesajtipi"].toString()),
        durum: json["durum"],
        mesajtarihi: json["mesajtarihi"] == null ? null : DateTime.parse(json["mesajtarihi"]),
        programtipi: json["programtipi"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "guid": guid,
        "kimden": kimden,
        "kime": kime,
        "clienttoken": clienttoken,
        "subeadi": subeadi,
        "kasakodu": kasakodu,
        "mesaj": mesaj,
        "mesajtipi": mesajtipi,
        "durum": durum,
        "mesajtarihi": mesajtarihi?.toIso8601String(),
        "programtipi": programtipi,
    };
}
