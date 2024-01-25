import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book_sertifikasi/components/styles.dart';
import 'package:lapor_book_sertifikasi/components/vars.dart';
import 'package:lapor_book_sertifikasi/models/akun.dart';
import 'package:lapor_book_sertifikasi/models/laporan.dart';

class ListComment extends StatefulWidget {
  final Komentar komentar;
  const ListComment({super.key, required this.komentar});

  @override
  State<ListComment> createState() => _ListCommentState();
}

class _ListCommentState extends State<ListComment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(widget.komentar.name),
            Text(widget.komentar.komentar)
          ],
        ));
  }
}
