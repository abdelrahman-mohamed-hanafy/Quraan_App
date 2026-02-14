class VerseModel {
  final int id;
  final int verseNumber;
  final int chapterId;
  final String arabicText;
  final String? translation;

  VerseModel({
    required this.id,
    required this.verseNumber,
    required this.chapterId,
    required this.arabicText,
    this.translation,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] ?? 0,
      verseNumber: json['verse_number'] ?? 0,
      chapterId: json['chapter_id'] ?? 0,
      arabicText: json['text_uthmani'] ?? '',
      translation: json['translations'] != null &&
          (json['translations'] as List).isNotEmpty
          ? json['translations'][0]['text']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verse_number': verseNumber,
      'chapter_id': chapterId,
      'text_uthmani': arabicText,
    };
  }
}
