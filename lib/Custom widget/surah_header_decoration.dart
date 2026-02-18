import 'package:flutter/material.dart';

class SurahHeaderDecoration extends StatelessWidget {
  final String surahName;

  const SurahHeaderDecoration({
    super.key,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          _ornament(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                  bottom: BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  "سورة $surahName",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          _ornament(),
        ],
      ),
    );
  }

  Widget _ornament() {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2,
        ),
      ),
      child: const Center(
        child: Text(
          "۞",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFD4AF37),
          ),
        ),
      ),
    );
  }
}
