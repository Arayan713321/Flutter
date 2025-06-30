class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final String date;
  final String? imagePath;
  final String? audioPath;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.imagePath,
    this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'imagePath': imagePath,
      'audioPath': audioPath,
    };
  }
}
