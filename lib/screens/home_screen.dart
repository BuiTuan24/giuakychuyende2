import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> danhSach = ["Paracetamol", "Vitamin C", "Kháng sinh"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trang chủ")),
      body: ListView.builder(
        itemCount: danhSach.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(danhSach[index]),
            leading: Icon(Icons.medication),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DetailScreen(tenThuoc: danhSach[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}