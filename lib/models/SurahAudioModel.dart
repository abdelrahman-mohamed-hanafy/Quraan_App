class SurahAudioResponse {
  final List<AudioFile> audioFiles;

  SurahAudioResponse({required this.audioFiles});

  factory SurahAudioResponse.fromJson(Map<String, dynamic> json) {
    return SurahAudioResponse(
      audioFiles: (json['audio_files'] as List)
          .map((e) => AudioFile.fromJson(e))
          .toList(),
    );
  }
}

class AudioFile {
  final int chapterId;
  final String audioUrl;

  AudioFile({
    required this.chapterId,
    required this.audioUrl,
  });

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      chapterId: json['chapter_id'] ?? json['chapterId'],
      audioUrl: json['audio_url'] ?? json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    "chapter_id": chapterId,
    "audio_url": audioUrl,
  };
}
