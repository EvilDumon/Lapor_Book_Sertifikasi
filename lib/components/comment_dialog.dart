import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor_book_sertifikasi/components/input_widget.dart';
import 'package:lapor_book_sertifikasi/components/styles.dart';
import 'package:lapor_book_sertifikasi/models/akun.dart';
import 'package:lapor_book_sertifikasi/models/laporan.dart';
import 'package:lapor_book_sertifikasi/page/detail_page.dart';

class CommentDialog extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;

  const CommentDialog({super.key, required this.akun, required this.laporan});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  late String komentar;
  final _firestore = FirebaseFirestore.instance;

  void addComment(Akun akun) async {
    CollectionReference transaksiCollection = _firestore.collection('laporan');
    try {
      await transaksiCollection.doc(widget.laporan.docId).update({
        'comments': FieldValue.arrayUnion([
          {'uid': akun.uid, 'name': akun.fullname, 'comment': komentar}
        ]),
      });
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.laporan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                onChanged: (String value) => setState(() {
                  komentar = value;
                }),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 8,
                decoration: customInputDecoration('Tulis Komentar Anda'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addComment(widget.akun);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Posting Komentar'),
            ),
          ],
        ),
      ),
    );
  }
}
