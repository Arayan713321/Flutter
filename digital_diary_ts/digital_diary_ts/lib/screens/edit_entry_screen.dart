import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../db/database_helper.dart';
import '../models/diary_entry.dart';

class EditEntryScreen extends StatefulWidget {
  final DiaryEntry? entry;

  const EditEntryScreen({super.key, this.entry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _imagePath;
  String? _audioPath;
  final _picker = ImagePicker();
  final _dbHelper = DatabaseHelper();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _imagePath = widget.entry!.imagePath;
      _audioPath = widget.entry!.audioPath;
    }
  }

  Future<void> _saveEntry() async {
    final entry = DiaryEntry(
      id: widget.entry?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: DateTime.now().toIso8601String(),
      imagePath: _imagePath,
      audioPath: _audioPath,
    );
    await _dbHelper.insertEntry(entry);
    Navigator.pop(context);
  }

  Future<void> _deleteEntry() async {
    if (widget.entry != null) {
      await _dbHelper.deleteEntry(widget.entry!.id!);
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  Future<void> _pickAudio() async {
    final XFile? result = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(label: 'audio', extensions: ['mp3', 'wav', 'aac', 'm4a']),
      ],
    );
    if (result != null) {
      setState(() {
        _audioPath = result.path;
      });
    }
  }

  Future<void> _playAudio() async {
    if (_audioPath != null) {
      await _audioPlayer.play(DeviceFileSource(_audioPath!));
    }
  }

  Future<void> _exportSingleNotePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Title: ${_titleController.text}',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Content:', style: pw.TextStyle(fontSize: 16)),
            pw.Text(_contentController.text),
            pw.SizedBox(height: 20),
            if (_imagePath != null)
              pw.Text('Attached Image Path: $_imagePath'),
            if (_audioPath != null)
              pw.Text('Attached Audio Path: $_audioPath'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'entry_${widget.entry?.id}',
          child: Text(
            widget.entry == null ? 'New Entry' : widget.entry!.title,
            style: const TextStyle(fontSize: 22),
          ),
        ),
        actions: [
          IconButton(onPressed: _saveEntry, icon: const Icon(Icons.save)),
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteEntry,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Attach Image'),
            ),
            if (_imagePath != null) ...[
              const SizedBox(height: 10),
              Image.file(File(_imagePath!)),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickAudio,
              icon: const Icon(Icons.audiotrack),
              label: const Text('Attach Audio'),
            ),
            if (_audioPath != null)
              ElevatedButton.icon(
                onPressed: _playAudio,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Audio'),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _exportSingleNotePdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export Note as PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
