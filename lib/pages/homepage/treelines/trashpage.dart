import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../models/note.dart';
import 'package:http/http.dart' as http;

class TrashPage extends StatefulWidget {
  final List<Note> deletedNotes;

  const TrashPage({Key? key, required this.deletedNotes}) : super(key: key);

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Çöp Kutusu'),
      ),
      body: widget.deletedNotes.isEmpty
          ? Center(child: Text("Çöp kutusu boş."))
          : ListView.builder(
              itemCount: widget.deletedNotes.length,
              itemBuilder: (context, index) {
                return TrashItem(
                  note: widget.deletedNotes[index].noteTitle,
                  ondelete: () async {
                    // Silme İşlemi
                    if (await deleteNotePermanently(
                        widget.deletedNotes[index])) {
                      widget.deletedNotes.removeAt(index);
                      setState(() {});
                    }
                    setState(() {});
                  },
                  onrestore: () async {
                    // Geri Yükleme İşlemi

                    // Geri yüklenen notu burada işleyebilirsiniz.
                    //print("Restored Note: $restoredNote");
                    if (await updateFolderWithAPI(
                        widget.deletedNotes[index], "Kategorisiz")) {
                      widget.deletedNotes.removeAt(index);
                      setState(() {
                        // Silme İşlemi
                      });
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showClearConfirmationDialog(context);
        },
        tooltip: 'Çöp Kutusunu Temizle',
        child: Icon(Icons.delete_forever),
      ),
    );
  }

  void showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emin misiniz?'),
          content: Text('Tüm notları silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hayır'),
            ),
            TextButton(
              onPressed: () async {
                bool error = false;
                while (widget.deletedNotes.isNotEmpty && error == false) {
                  if (await deleteNotePermanently(widget.deletedNotes.last)) {
                    widget.deletedNotes.removeAt(widget.deletedNotes.length-1);
                  } else {
                    //stop loop if error occurs
                    error = true;
                  }
                }
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> updateWithAPI(Note note) async {
    String url = 'http://10.0.2.2:8085/api/notes/${note.id}';
    //10 sn time limit

    final response = await http.put(
      Uri.parse(url),
      body: json.encode(note),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateFolderWithAPI(Note note, String folderName) {
    note.folderName = folderName;
    return updateWithAPI(note);
  }

  deleteNotePermanently(Note deletedNote) async {
    String url = 'http://10.0.2.2:8085/api/notes/${deletedNote.id}';
    //10 sn time limit

    final response = await http
        .delete(
          Uri.parse(url),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class TrashItem extends StatelessWidget {
  final String note;
  final VoidCallback onrestore;
  final VoidCallback ondelete;

  TrashItem(
      {required this.note, required this.onrestore, required this.ondelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showOptionsDialog(context);
      },
      child: ListTile(
        title: Text(note),
      ),
    );
  }

  void showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seçenekler'),
          content: Text(
              'Bu notu geri yüklemek veya temelli silmek istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ondelete();
              },
              child: Text('Sil'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onrestore();
              },
              child: Text('Geri Yükle'),
            ),
          ],
        );
      },
    );
  }
}
