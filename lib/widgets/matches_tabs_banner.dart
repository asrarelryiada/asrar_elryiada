import 'package:flutter/material.dart';
import '../all_matches_screen.dart'; // استيراد صفحة كل المباريات الجديدة

class MatchesTabsBanner extends StatefulWidget {
  final Function(String) onDaySelected; // دالة لإبلاغ الشريط الأسود بتغيير اليوم

  const MatchesTabsBanner({super.key, required this.onDaySelected});

  @override
  State<MatchesTabsBanner> createState() => _MatchesTabsBannerState();
}

class _MatchesTabsBannerState extends State<MatchesTabsBanner> {
  String selectedDay = 'اليوم';

  void _handleDaySelection(String day) {
    setState(() {
      selectedDay = day;
    });
    // تحويل النص العربي إلى مفتاح يفهمه الاستعلام (yesterday, today, tomorrow)
    if (day == 'أمس') {
      widget.onDaySelected('yesterday');
    } else if (day == 'غداً') {
      widget.onDaySelected('tomorrow');
    } else {
      widget.onDaySelected('today');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      color: Colors.black54,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 20, 
        vertical: 8,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: isMobile
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AllMatchesScreen()),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.amber, size: 12),
                        label: const Text(
                          'كل المباريات',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDayTab('أمس'),
                      const SizedBox(width: 8),
                      _buildDayTab('اليوم', isSelected: selectedDay == 'اليوم'),
                      const SizedBox(width: 8),
                      _buildDayTab('غداً'),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AllMatchesScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.amber, size: 12),
                    label: const Text(
                      'كل المباريات',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  Row(
                    children: [
                      _buildDayTab('أمس'),
                      const SizedBox(width: 8),
                      _buildDayTab('اليوم', isSelected: selectedDay == 'اليوم'),
                      const SizedBox(width: 8),
                      _buildDayTab('غداً'),
                    ],
                  ),
                  const SizedBox(width: 80),
                ],
              ),
      ),
    );
  }

  Widget _buildDayTab(String day, {bool? isSelected}) {
    bool active = isSelected ?? (selectedDay == day);
    return GestureDetector(
      onTap: () => _handleDaySelection(day),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.amber : Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: active ? Colors.black87 : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}