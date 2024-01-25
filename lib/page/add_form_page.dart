import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lapor_book_sertifikasi/components/styles.dart';
import 'package:lapor_book_sertifikasi/components/vars.dart';
import 'package:lapor_book_sertifikasi/models/akun.dart';
import '../components/validators.dart';
import '../components/input_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddFormPage extends StatefulWidget {
  const AddFormPage({super.key});

  @override
  State<StatefulWidget> createState() => AddFormState();
}

class AddFormState extends State<AddFormPage> {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  XFile? file;
  String? judul;
  String? instansi;
  String? deskripsi;
  bool _isLoading = false;
  ImagePicker picker = ImagePicker();

  Image imagePreview() {
    if (file == null) {
      return Image.asset('assets/istock-default.jpg', width: 180, height: 180);
    } else {
      return Image.file(File(file!.path), width: 180, height: 180);
    }
  }

  Future<Position> getCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference dirUpload =
          _storage.ref().child('upload/${_auth.currentUser!.uid}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  void addTransaksi(Akun akun) async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference laporanCollection = _firestore.collection('laporan');

      // Convert DateTime to Firestore Timestamp
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      String url = await uploadImage();

      String currentLocation = await getCurrentLocation().then((value) {
        return '${value.latitude},${value.longitude}';
      });

      String maps = 'https://www.google.com/maps/place/$currentLocation';
      final id = laporanCollection.doc().id;

      await laporanCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'docId': id,
        'judul': judul,
        'instansi': instansi,
        'deskripsi': deskripsi,
        'foto': url,
        'pelapor': akun.fullname,
        'status': dataStatus[0],
        'tgl_lapor': timestamp,
        'koordinat': maps,
      }).catchError((e) {
        throw e;
      });
      if (context.mounted) Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<dynamic> openCamera(BuildContext context) async {
    XFile? upload = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      file = upload;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Akun akun = arguments['akun'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            Text('Tambah Laporan', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputLayout(
                            'Judul Laporan',
                            TextFormField(
                                onChanged: (String value) => setState(() {
                                      judul = value;
                                    }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration("Judul laporan"))),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: imagePreview(),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                              onPressed: () {
                                openCamera(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_camera),
                                  Text(' Foto Pendukung',
                                      style: headerStyle(level: 3)),
                                ],
                              )),
                        ),
                        InputLayout(
                            'Instansi',
                            DropdownButtonFormField<String>(
                                decoration: customInputDecoration('Instansi'),
                                items: dataInstansi.map((e) {
                                  return DropdownMenuItem<String>(
                                      value: e, child: Text(e));
                                }).toList(),
                                onChanged: (selected) {
                                  setState(() {
                                    instansi = selected;
                                  });
                                })),
                        InputLayout(
                            "Deskripsi laporan",
                            TextFormField(
                              onChanged: (String value) => setState(() {
                                deskripsi = value;
                              }),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              decoration: customInputDecoration(
                                  'Deskripsikan semua di sini'),
                            )),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {
                                addTransaksi(akun);
                              },
                              child: Text(
                                'Kirim Laporan',
                                style: headerStyle(level: 3, dark: false),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
