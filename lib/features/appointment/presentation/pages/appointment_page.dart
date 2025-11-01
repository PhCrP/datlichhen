import 'package:flutter/material.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý lịch hẹn"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.blue),
            title: Text("Nguyễn Văn A - 10:00 AM, 31/10/2025"),
            subtitle: Text("Trạng thái: Chờ xác nhận"),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 👉 mở form đặt lịch
        },
        icon: const Icon(Icons.add),
        label: const Text("Đặt lịch"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
