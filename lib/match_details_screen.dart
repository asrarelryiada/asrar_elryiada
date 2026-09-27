import 'package:flutter/material.dart';
import 'widgets/app_header.dart'; // الهيدر والبانر الأساسي ثابت فوق

class MatchDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> matchData;

  const MatchDetailsScreen({super.key, required this.matchData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. الهيدر والبانر الأساسي ثابت في أعلى الصفحة
              const AppHeader(),
              const SizedBox(height: 20),

              // 2. زر العودة للخلف
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_forward, color: Colors.black87),
                      tooltip: 'العودة',
                    ),
                    const Text(
                      'تفاصيل المباراة',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 3. كارت تفاصيل المباراة الكبير
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12.0 : 24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // اسم البطولة
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              matchData['league'] ?? 'بطولة رياضية',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // الفريقين والنتيجة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Text(
                                  matchData['teamA'] ?? 'الفريق الأول',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB71C1C),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${matchData['scoreA'] ?? '0'} - ${matchData['scoreB'] ?? '0'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  matchData['teamB'] ?? 'الفريق الثاني',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 15),

                          // التاريخ والحالة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoItem(Icons.calendar_today, 'التاريخ', matchData['date'] ?? 'غير محدد'),
                              _buildInfoItem(Icons.sports_soccer, 'حالة المباراة', matchData['status'] ?? 'قريباً'),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 22),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}