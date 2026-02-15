class ChapterModel {
  final int id;
  final String revelationPlace;
  final int revelationOrder;
  final bool bismillahPre;
  final String nameSimple;
  final String nameComplex;
  final String nameArabic;
  final int versesCount;
  final List<int> pages;
  final String translatedName;

  // ✅ الحقل الجديد
  final int startPage;

  ChapterModel({
    required this.id,
    required this.revelationPlace,
    required this.revelationOrder,
    required this.bismillahPre,
    required this.nameSimple,
    required this.nameComplex,
    required this.nameArabic,
    required this.versesCount,
    required this.pages,
    required this.translatedName,
    required this.startPage,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'],
      revelationPlace: json['revelation_place'],
      revelationOrder: json['revelation_order'],
      bismillahPre: json['bismillah_pre'],
      nameSimple: json['name_simple'],
      nameComplex: json['name_complex'],
      nameArabic: json['name_arabic'],
      versesCount: json['verses_count'],
      pages: List<int>.from(json['pages']),
      translatedName: json['translated_name']['name'],

      // ✅ أول صفحة في السورة
      startPage: (json['pages'] as List).first,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'revelation_place': revelationPlace,
      'revelation_order': revelationOrder,
      'bismillah_pre': bismillahPre,
      'name_simple': nameSimple,
      'name_complex': nameComplex,
      'name_arabic': nameArabic,
      'verses_count': versesCount,
      'pages': pages,
      'translated_name': {
        'name': translatedName,
      },
      'start_page': startPage,
    };
  }
}
