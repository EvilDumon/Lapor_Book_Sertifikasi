import 'package:flutter/material.dart';
import 'package:lapor_book_sertifikasi/components/styles.dart';
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
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.komentar.name,
            style: headerStyle(level: 3),
          ),
          Text(
            widget.komentar.komentar,
            style: headerStyle(level: 4),
          ),
        ],
      ),
    );
  }
}
