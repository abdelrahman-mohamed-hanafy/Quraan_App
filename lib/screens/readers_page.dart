import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/controllers/readers_controller.dart';

class ReadersPage extends GetView<RecitersController> {
  const ReadersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                radius: 1.2,
                colors: [
                  Color(0xFF0E3B2E),
                  Color(0xFF071A14),
                ],
                center: Alignment.topCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    "اختر قارئ",
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "اختر من قائمة القرّاء",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔍 البحث
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) =>
                      controller.searchQuery.value = value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "ابحث عن قارئ...",
                        hintStyle:
                        const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📜 قائمة القراء
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4AF37),
                          ),
                        );
                      }

                      final list = controller.filteredReader;

                      if (list.isEmpty) {
                        return const Center(
                          child: Text(
                            "لا يوجد نتائج",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final reader = list[index];

                          return Padding(
                            padding:
                            const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                controller.searchQuery.value = '';
                                Get.toNamed(
                                  '/surahsByReader',
                                  arguments: {
                                    'id': reader.id,
                                    'name': reader.name,
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white
                                          .withOpacity(0.06),
                                      Colors.white
                                          .withOpacity(0.02),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: const Color(
                                        0xFFD4AF37),
                                    width: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.25),
                                      blurRadius: 6,
                                      offset:
                                      const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: ListTile(
                                  leading:
                                  const CircleAvatar(
                                    backgroundColor:
                                    Color(0xFFD4AF37),
                                    child: Icon(
                                      Icons.mic,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    reader.name,
                                    style:
                                    const TextStyle(
                                      color: Color(
                                          0xFFD4AF37),
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    "تلاوة قرآنية",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons
                                        .arrow_forward_ios,
                                    color:
                                    Colors.white38,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
