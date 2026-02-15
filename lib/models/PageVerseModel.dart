class PageVerseModel {
  final int id;
  final int chapterId;
  final int verseNumber;
  final String text;

  PageVerseModel({
    required this.id,
    required this.chapterId,
    required this.verseNumber,
    required this.text,
  });

  factory PageVerseModel.fromJson(Map<String, dynamic> json) {
    final verseKey = json['verse_key']; // "2:17"
    final parts = verseKey.split(':');

    return PageVerseModel(
      id: json['id'],
      chapterId: int.parse(parts[0]),
      verseNumber: int.parse(parts[1]),
      text: json['text_uthmani'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'verse_number': verseNumber,
      'text_uthmani': text,
      'verse_key': '$chapterId:$verseNumber',
    };
  }
}
