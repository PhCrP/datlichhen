import 'package:datlichhen/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Thông báo lịch hẹn',
        'content': 'Chúc mừng! Lịch hẹn #1234 đã được xác nhận.',
        'time': '1 ngày trước',
      },
      {
        'title': 'Hủy lịch hẹn',
        'content': 'Lịch hẹn #1228 với BS. Nguyễn Văn A đã bị hủy.',
        'time': '2 ngày trước',
      },
      {
        'title': 'Lịch hẹn sắp tới',
        'content': 'Ngày 25/09/2025 lúc 9:30, BS. Lê Thị B.',
        'time': '3 ngày trước',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(138.27),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 43.27, color: const Color(0xFF43B02A)),
            // AppBar trắng
            Container(
              height: 95,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 8,
                  right: 8,
                  bottom: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Thông báo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['content']!,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item['time']!,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
      
      );
  }

}
