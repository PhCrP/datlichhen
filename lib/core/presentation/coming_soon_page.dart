import 'package:flutter/material.dart';

/// 🌟 Trang hiển thị thông báo "Chức năng đang được phát triển"
class ComingSoonPage extends StatelessWidget {
  final String? featureName; // Tên tính năng (nếu muốn truyền)

  const ComingSoonPage({super.key, this.featureName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          featureName ?? "Chức năng đang phát triển",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: ColoredBox(
            color: Color(0xFF32A852), // Thanh xanh nhỏ dưới AppBar
            child: SizedBox(height: 4),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🧩 Icon hiển thị
              const Icon(
                Icons.construction_rounded,
                size: 100,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 20),

              /// 📝 Tiêu đề lớn
              Text(
                featureName != null
                    ? "$featureName đang được phát triển"
                    : "Chức năng đang được phát triển",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              /// 📄 Nội dung mô tả nhỏ
              const Text(
                "Tính năng này hiện chưa hoàn thiện. "
                "Chúng tôi sẽ sớm cập nhật trong các phiên bản tiếp theo.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),

              const SizedBox(height: 30),

              /// 🔙 Nút quay lại
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Quay lại",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
