import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:rental_apartments_finder/models/store/property.dart';

class Note {
  int? _id;
  String? _title;
  String? _content;
  String? imageUrl;
  String? referencesPropertyID;
  Property? referencesProperty;
  int? cleanness;
  int? stability;
  int? affordable;

  // DateTime? _dateCreated;
  // DateTime? _dateLastEdited;
  //Color note_color;
  bool _isArchived = false;

  Note(
      {required id,
      required title,
      required content,
      required this.imageUrl,
      this.referencesPropertyID,
      this.cleanness,
      this.stability,
      this.affordable}) {
    this.id = id;
    this.title = title;
    this.content = content;
  }

  // factory Note.fromDocument(document) {
  //   return Note(
  //       id: document['id'],
  //       title: document['title'],
  //       content: document['content'],
  //       imagesUrls: document['imagesUrls'],
  //       dateCreated: document['dateCreated'],
  //       dateLastEdited: document['dateLastEdited']);
  // }

  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'],
      title: map['title'].toString(),
      content: map['content'].toString(),
      imageUrl: map['imageURL'] == null ? null : map['imageURL'].toString(),
      referencesPropertyID: map['referencesProperty'] == null
          ? null
          : map['referencesProperty'].toString(),
      cleanness: map['cleanness'] == null ? null : map['cleanness'] as int,
      stability: map['stability'] == null ? null : map['stability'] as int,
      affordable: map['affordable'] == null ? null : map['affordable'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title.toString(),
      'content': content.toString(),
      'imageURL': imageUrl == null ? null : imageUrl.toString(),
      'referencesProperty':
          referencesPropertyID == null ? null : referencesPropertyID.toString(),
      'cleanness': cleanness == null ? null : cleanness.toString(),
      'stability': stability == null ? null : stability.toString(),
      'affordable': affordable == null ? null : affordable.toString(),
    };
  }

  String get date {
    final date = DateTime.fromMicrosecondsSinceEpoch(id!);
    return DateFormat('EEE h:mm a, dd/MM/yyyy').format(date);
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

  // Map<String, dynamic> toMap(bool forUpdate) {
  //   var data = {
  //     'title': utf8.encode(title),
  //     'content': utf8.encode( content ),
  //     'date_created': epochFromDate( date_created ),
  //     'date_last_edited': epochFromDate( date_last_edited ),
  //     'note_color': note_color.value,
  //     'is_archived': is_archived  //  for later use for integrating archiving
  //   };
  //   if(forUpdate){  data["id"] = this.id;  }
  //   return data;
  // }

  void archiveThisNote() {
    isArchived = true;
  }

  String? get title => _title;

  set title(String? value) {
    _title = value;
  }

  String? get content => _content;

  bool get isArchived => _isArchived;

  set isArchived(bool value) {
    _isArchived = value;
  }

  set content(String? value) {
    _content = value;
  }

  @override
  String toString() {
    return "Note { id:$id title:$title content:$content imageUrl:$imageUrl}";
  }
}
