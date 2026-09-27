import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'widgets/app_header.dart';

class CategoryVideosScreen extends StatelessWidget {
  const CategoryVideosScreen({super.key});

  // دالة استخراج كود الفيديو من أي رابط يوتيوب (سواء youtu.be أو youtube.com)
  String? _extractYouTubeId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      } else if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'];
      }
    } catch (_) {}
    return null;
  }

  // دالة فتح مشغل الفيديو الداخلي في نافذة منبثقة داخل الموقع
  void _playVideoInsideModal(BuildContext context, String videoUrl, String title) {
    final videoId = _extractYouTubeId(videoUrl);

    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رابط الفيديو غير صالح أو غير مدعوم للمشغل الداخلي')),
      );
      return;
    }

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SizedBox(
            width: 700,
            height: 400,
            child: YoutubePlayer(
              controller: controller,
              aspectRatio: 16 / 9,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.close();
                Navigator.pop(context);
              },
              child: const Text('إغلاق', style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 20),

              // عنوان القسم وزر الرجوع
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'قسم الفيديوهات والصور',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_forward, color: Colors.black87),
                      tooltip: 'العودة',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // جلب الفيديوهات والصور من فايربيس وعرضها بشكل شبكي أنيق
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('videos_and_photos').orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C)));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(50),
                        alignment: Alignment.center,
                        child: const Text(
                          'لا توجد فيديوهات أو صور منشورة في هذا القسم حالياً.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : 3, // عرض 3 فيديوهات جنباً إلى جنب في الشاشات الكبيرة
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 16 / 11,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        String title = data['title'] ?? 'بدون عنوان';
                        String videoUrl = data['videoUrl'] ?? data['videoLink'] ?? '';
                        String imageUrl = data['imageUrl'] ?? '';

                        return InkWell(
                          onTap: () => _playVideoInsideModal(context, videoUrl, title),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // صورة الغلاف مع زر تشغيل تفاعلي
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                                                return Container(color: Colors.grey.shade300, child: const Icon(Icons.video_library, size: 50, color: Colors.grey));
                                              })
                                            : Container(color: Colors.grey.shade300, child: const Icon(Icons.video_library, size: 50, color: Colors.grey)),
                                      ),
                                      // زر تشغيل تفاعلي فوق الصورة
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFB71C1C).withOpacity(0.85),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                                      ),
                                    ],
                                  ),
                                ),
                                // عنوان الفيديو
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}