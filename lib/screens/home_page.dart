import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/Custom%20widget/quickItem.dart';
import 'package:quraan/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E2A1F),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Obx(
                () => RefreshIndicator(
              onRefresh: controller.refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// =======================
                    /// 👤 User Header
                    /// =======================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "أهلاً بك",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            controller.isUserLoading.value
                                ? const CircularProgressIndicator(
                                color: Colors.green)
                                : Text(
                              controller.userName.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          child:
                          Icon(Icons.person, color: Colors.white),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// =======================
                    /// 📖 Last Read Card
                    /// =======================
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff1EBE73),
                            Color(0xff0C5F3A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await Get.toNamed('/mushaf', arguments: {
                            'page': controller.lastPage.value,
                            'nameArabic':
                            controller.lastSurah.value,
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book,
                                color: Colors.white, size: 32),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "آخر قراءة",
                                  style: TextStyle(
                                      color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Obx(() {
                                  return Text(
                                    " سورة ${controller.lastSurah.value}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      children: [
                        QuickItem(
                          icon: Icons.menu_book,
                          title: "قراءة",
                          onTap: () {
                            Get.toNamed('/Surah');
                          },
                        ),
                        QuickItem(
                          icon: Icons.headphones,
                          title: "استماع",
                          onTap: () {
                            Get.toNamed('/readers');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// =======================
                    /// 🕌 Prayer Times
                    /// =======================
                    const Text(
                      "مواقيت الصلاة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 15),

                    controller.isPrayerLoading.value
                        ? const Center(
                      child: CircularProgressIndicator(
                          color: Colors.green),
                    )
                        : controller.prayerTimes.isEmpty
                        ? const Text(
                      "لا توجد بيانات",
                      style: TextStyle(
                          color: Colors.white70),
                    )
                        : Container(
                      padding:
                      const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xff123C2C),
                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),
                      child: Obx(
                            () => Column(
                          children: controller
                              .prayerTimes.entries
                              .map((e) {
                            final isNext = e.key ==
                                controller
                                    .nextPrayer.value;

                            return Container(
                              margin:
                              const EdgeInsets.symmetric(vertical: 2),
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                  horizontal:
                                  12,
                                  vertical:
                                  10),
                              decoration:
                              BoxDecoration(
                                color: isNext
                                    ? Colors.green
                                    .withOpacity(
                                    0.25)
                                    : Colors
                                    .transparent,
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .access_time,
                                    color: isNext
                                        ? Colors
                                        .amber
                                        : Colors
                                        .white70,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                      width: 8),
                                  Expanded(
                                    child: Text(
                                      e.key,
                                      style:
                                      TextStyle(
                                        color:
                                        Colors
                                            .white,
                                        fontWeight: isNext
                                            ? FontWeight
                                            .bold
                                            : FontWeight
                                            .normal,
                                        fontSize:
                                        16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    controller
                                        .formatPrayerTimeUI(
                                        e.value),
                                    style:
                                    TextStyle(
                                      color: isNext
                                          ? Colors
                                          .amber
                                          : Colors
                                          .white,
                                      fontSize:
                                      15,
                                      fontWeight:
                                      FontWeight
                                          .w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
